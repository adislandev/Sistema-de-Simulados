"""Deteccao deterministica (OpenCV, sem IA) da grade de bolhas A-E de uma prova objetiva.

Estrategia: em vez de tentar localizar a grade por contorno retangular (fragil na
presenca de outras caixas/tabelas na pagina, como a area de respostas discursivas),
detectamos diretamente os circulos das bolhas (Hough Circle Transform) e os agrupamos
por proximidade em X (5 colunas = A..E) e por ordem em Y dentro de cada coluna
(8 linhas = questoes 1..8). Essa abordagem e robusta a leve rotacao/perspectiva de
fotos de celular, pois nao depende de um retificacao geometrica da pagina inteira.
"""
from __future__ import annotations

from dataclasses import dataclass

import cv2
import numpy as np

NUM_QUESTOES = 8
ALTERNATIVAS = ["A", "B", "C", "D", "E"]

# Fracao minima de pixels escuros dentro da bolha para considerar "marcada".
LIMIAR_PREENCHIMENTO = 0.35
# Margem minima entre a bolha mais escura e a segunda mais escura da mesma questao,
# para evitar falso positivo em contornos impressos (anti-aliasing).
MARGEM_MINIMA = 0.12

# Valor de cinza (0-255) abaixo do qual um pixel conta como "tinta". Um limiar
# absoluto fixo e usado (em vez de Otsu por bolha) porque o patch interno de uma
# bolha preenchida e quase uniforme (pouca variancia interna) e o Otsu por-patch
# se mostrou instavel nesse regime (mesma bolha marcada ora dava fracao ~0, ora
# a fracao correta). Nas amostras reais, bolhas marcadas tem media de cinza
# ~85-120 e bolhas em branco ~155-250: ha folga ampla para um corte fixo.
LIMIAR_CINZA_TINTA = 180

# Tolerancia (em pixels) para agrupar circulos na mesma coluna.
TOLERANCIA_COLUNA_PX = 45


@dataclass
class ResultadoQuestao:
    numero: int
    alternativa: str | None  # None = em branco ou ambigua
    preenchimentos: list[float]  # um valor por alternativa (A..E)
    ambigua: bool


@dataclass
class Bolha:
    x: float
    y: float
    raio: float


def _detectar_circulos(imagem_bgr: np.ndarray) -> np.ndarray:
    cinza = cv2.cvtColor(imagem_bgr, cv2.COLOR_BGR2GRAY)
    borrado = cv2.medianBlur(cinza, 5)
    # Parametros calibrados para bolhas impressas em prova A4 renderizada a ~400dpi.
    # minRadius/maxRadius devem ser ajustados proporcionalmente se a resolucao mudar.
    altura = imagem_bgr.shape[0]
    escala = altura / 5556.0  # referencia: amostra de calibracao a 400dpi
    circulos = cv2.HoughCircles(
        borrado,
        cv2.HOUGH_GRADIENT,
        dp=1,
        minDist=int(40 * escala),
        param1=80,
        param2=30,
        minRadius=int(15 * escala),
        maxRadius=int(45 * escala),
    )
    if circulos is None:
        raise ValueError("Nenhum circulo de bolha foi detectado na imagem.")
    return circulos[0]


def _agrupar_colunas(circulos: np.ndarray, tolerancia: float) -> list[list[Bolha]]:
    """Agrupa circulos por proximidade em X. Mantem apenas grupos com pelo menos
    NUM_QUESTOES - 2 membros (uma coluna real de bolhas), descartando ruido esparso
    (ex.: circulos falsos-positivos no texto das questoes)."""
    ordenados = sorted(circulos, key=lambda c: c[0])
    grupos: list[list[Bolha]] = []
    atual: list[Bolha] = []
    for x, y, r in ordenados:
        bolha = Bolha(x=float(x), y=float(y), raio=float(r))
        if atual and abs(bolha.x - atual[-1].x) > tolerancia:
            grupos.append(atual)
            atual = []
        atual.append(bolha)
    if atual:
        grupos.append(atual)

    grupos_validos = [g for g in grupos if len(g) >= NUM_QUESTOES - 2]
    return grupos_validos


def _linhas_esperadas(grupos: list[list[Bolha]], num_questoes: int) -> list[float]:
    """Estima o Y de cada linha (questao) a partir das colunas que tem exatamente
    `num_questoes` bolhas (colunas "limpas", sem ruido). Colunas com bolhas extras
    (ex.: um circulo espurio capturado no cabecalho/texto acima da grade) sao
    ignoradas nesta estimativa, mas ainda terao suas linhas corrigidas depois via
    correspondencia por proximidade."""
    referencia = [g for g in grupos if len(g) == num_questoes]
    fonte = referencia if referencia else grupos
    linhas_y = []
    n_linhas = min(len(g) for g in fonte)
    for i in range(n_linhas):
        linhas_y.append(float(np.median([g[i].y for g in fonte])))
    return linhas_y


def _selecionar_por_referencia(
    coluna: list[Bolha], linhas_y: list[float], tolerancia: float
) -> list[Bolha | None]:
    """Para cada Y de linha esperado, escolhe a bolha da coluna mais proxima
    (descartando bolhas espurias que nao correspondem a nenhuma linha real).
    Se nenhuma bolha da coluna estiver perto o suficiente, a linha fica None
    (bolha ausente / nao detectada)."""
    disponiveis = list(coluna)
    selecionadas: list[Bolha | None] = []
    for y_esperado in linhas_y:
        if not disponiveis:
            selecionadas.append(None)
            continue
        melhor = min(disponiveis, key=lambda b: abs(b.y - y_esperado))
        if abs(melhor.y - y_esperado) <= tolerancia:
            selecionadas.append(melhor)
            disponiveis.remove(melhor)
        else:
            selecionadas.append(None)
    return selecionadas


def localizar_bolhas(
    imagem_bgr: np.ndarray, num_questoes: int = NUM_QUESTOES
) -> list[list[Bolha | None]]:
    """Retorna uma lista de colunas (A..E, ordenadas da esquerda para a direita),
    cada uma contendo suas bolhas ordenadas de cima para baixo (questao 1..N).
    Uma posicao pode ser None se a bolha correspondente nao foi detectada."""
    circulos = _detectar_circulos(imagem_bgr)
    altura = imagem_bgr.shape[0]
    escala = altura / 5556.0
    grupos = _agrupar_colunas(circulos, tolerancia=TOLERANCIA_COLUNA_PX * escala)

    if len(grupos) < len(ALTERNATIVAS):
        raise ValueError(
            f"Esperava {len(ALTERNATIVAS)} colunas de bolhas, encontrei {len(grupos)}. "
            "Verifique a qualidade/resolucao da imagem."
        )

    # As 5 maiores colunas (mais membros) sao as colunas reais A..E.
    grupos = sorted(grupos, key=len, reverse=True)[: len(ALTERNATIVAS)]
    # Reordena da esquerda para a direita (A..E) pela posicao X media.
    grupos = sorted(grupos, key=lambda g: sum(b.x for b in g) / len(g))
    grupos = [sorted(g, key=lambda b: b.y) for g in grupos]

    linhas_y = _linhas_esperadas(grupos, num_questoes)
    if len(linhas_y) < num_questoes:
        raise ValueError(
            f"Esperava {num_questoes} linhas (questoes), mas so foi possivel "
            f"estimar {len(linhas_y)} a partir das colunas detectadas."
        )

    gaps = [b - a for a, b in zip(linhas_y, linhas_y[1:])]
    tolerancia_linha = (float(np.median(gaps)) if gaps else 40.0) * 0.6

    colunas = [_selecionar_por_referencia(g, linhas_y, tolerancia_linha) for g in grupos]
    return _preencher_bolhas_ausentes(colunas, grupos, linhas_y)


def _preencher_bolhas_ausentes(
    colunas: list[list[Bolha | None]], grupos: list[list[Bolha]], linhas_y: list[float]
) -> list[list[Bolha | None]]:
    """O Hough as vezes nao detecta uma bolha (foto com sombra, bolha muito
    preenchida). A posicao dela e previsivel pela grade (X mediano da coluna,
    Y da linha), entao estimamos a bolha ausente em vez de abortar a prova
    inteira - a leitura de preenchimento e feita nessa posicao estimada."""
    raio = float(np.median([b.raio for g in grupos for b in g]))
    preenchidas: list[list[Bolha | None]] = []
    for coluna, grupo in zip(colunas, grupos):
        x_coluna = float(np.median([b.x for b in grupo]))
        preenchidas.append(
            [b if b is not None else Bolha(x=x_coluna, y=linhas_y[i], raio=raio) for i, b in enumerate(coluna)]
        )
    return preenchidas


def _fracao_escura(imagem_cinza: np.ndarray, bolha: Bolha) -> float:
    raio_interno = int(bolha.raio * 0.55)
    x0, y0 = int(bolha.x - raio_interno), int(bolha.y - raio_interno)
    x1, y1 = int(bolha.x + raio_interno), int(bolha.y + raio_interno)
    altura, largura = imagem_cinza.shape
    x0, y0 = max(x0, 0), max(y0, 0)
    x1, y1 = min(x1, largura), min(y1, altura)
    patch = imagem_cinza[y0:y1, x0:x1]
    if patch.size == 0:
        return 0.0

    mascara = np.zeros_like(patch, dtype=np.uint8)
    cv2.circle(
        mascara,
        (patch.shape[1] // 2, patch.shape[0] // 2),
        raio_interno,
        255,
        -1,
    )
    escuros = np.where(patch < LIMIAR_CINZA_TINTA, np.uint8(255), np.uint8(0))
    pixels_bolha = cv2.bitwise_and(escuros, mascara)
    total = cv2.countNonZero(mascara)
    if total == 0:
        return 0.0
    return cv2.countNonZero(pixels_bolha) / total


def ler_respostas(imagem_bgr: np.ndarray, num_questoes: int = NUM_QUESTOES) -> list[ResultadoQuestao]:
    colunas = localizar_bolhas_por_reticulado(imagem_bgr, num_questoes)
    if colunas is None:  # grade nao encontrada: tenta o metodo antigo (agrupamento por coluna)
        colunas = localizar_bolhas(imagem_bgr, num_questoes)
    cinza = cv2.cvtColor(imagem_bgr, cv2.COLOR_BGR2GRAY)

    num_linhas = min(len(coluna) for coluna in colunas)
    if num_linhas < num_questoes:
        raise ValueError(
            f"Esperava {num_questoes} linhas (questoes), mas ao menos uma coluna "
            f"so tem {num_linhas} bolhas detectadas."
        )

    resultados: list[ResultadoQuestao] = []
    for linha in range(num_questoes):
        preenchimentos = [_fracao_escura(cinza, coluna[linha]) for coluna in colunas]

        ordenado = sorted(preenchimentos, reverse=True)
        maior = ordenado[0]
        segundo = ordenado[1] if len(ordenado) > 1 else 0.0
        marcada = None
        ambigua = False
        if maior >= LIMIAR_PREENCHIMENTO:
            if maior - segundo >= MARGEM_MINIMA:
                marcada = ALTERNATIVAS[preenchimentos.index(maior)]
            else:
                ambigua = True

        resultados.append(
            ResultadoQuestao(
                numero=linha + 1,
                alternativa=marcada,
                preenchimentos=preenchimentos,
                ambigua=ambigua,
            )
        )
    return resultados


# --- Ajuste de reticulado (grade regular) ---------------------------------
# Passo aproximado entre bolhas na resolucao de referencia (altura 5556px,
# A4 a 400dpi): ~195px entre alternativas (colunas) e ~105px entre questoes.
PASSO_COLUNA_REF = 195.0
PASSO_LINHA_REF = 105.0
TOLERANCIA_PASSO = 0.25  # fracao do passo aceita ao procurar vetores da grade
TOLERANCIA_ENCAIXE = 0.3  # distancia maxima (em passos) de um circulo ao ponto da grade


def _estimar_vetores_grade(pontos: np.ndarray, escala: float) -> tuple[np.ndarray, np.ndarray] | None:
    """Estima os vetores u (proxima alternativa) e v (proxima questao) pela
    mediana das diferencas entre pares de circulos proximos do passo esperado.
    Robusto a rotacao leve da foto."""
    esperado_u = np.array([PASSO_COLUNA_REF * escala, 0.0])
    esperado_v = np.array([0.0, PASSO_LINHA_REF * escala])
    diffs = pontos[None, :, :] - pontos[:, None, :]
    diffs = diffs.reshape(-1, 2)
    achados = []
    for esperado in (esperado_u, esperado_v):
        tol = TOLERANCIA_PASSO * np.linalg.norm(esperado)
        proximos = diffs[np.linalg.norm(diffs - esperado, axis=1) < tol]
        if len(proximos) < 6:
            return None
        achados.append(np.median(proximos, axis=0))
    return achados[0], achados[1]


def _ajustar_reticulado(
    pontos: np.ndarray, u: np.ndarray, v: np.ndarray, num_linhas: int
) -> tuple[np.ndarray, np.ndarray, np.ndarray] | None:
    """Escolhe a origem (bolha A da questao 1) que maximiza os circulos que caem
    numa grade de 5 x num_linhas, e refina origem/u/v por minimos quadrados."""
    base = np.column_stack([u, v])
    inversa = np.linalg.inv(base)
    n_col = len(ALTERNATIVAS)
    melhor = None
    for p0 in pontos:
        coords = (pontos - p0) @ inversa.T
        arredondado = np.round(coords)
        encaixa = np.linalg.norm(coords - arredondado, axis=1) < TOLERANCIA_ENCAIXE
        if encaixa.sum() < 8:
            continue
        indices = arredondado[encaixa].astype(int)
        for a0 in range(int(indices[:, 0].min()), int(indices[:, 0].max()) + 1):
            for b0 in range(int(indices[:, 1].min()), int(indices[:, 1].max()) + 1):
                dentro = (
                    (indices[:, 0] >= a0) & (indices[:, 0] < a0 + n_col)
                    & (indices[:, 1] >= b0) & (indices[:, 1] < b0 + num_linhas)
                )
                if melhor is None or dentro.sum() > melhor[0]:
                    melhor = (int(dentro.sum()), p0, a0, b0)
    if melhor is None or melhor[0] < 12:
        return None

    _, p0, a0, b0 = melhor
    coords = (pontos - p0) @ inversa.T
    arredondado = np.round(coords).astype(int)
    encaixa = (
        (np.linalg.norm(coords - arredondado, axis=1) < TOLERANCIA_ENCAIXE)
        & (arredondado[:, 0] >= a0) & (arredondado[:, 0] < a0 + n_col)
        & (arredondado[:, 1] >= b0) & (arredondado[:, 1] < b0 + num_linhas)
    )
    a = arredondado[encaixa, 0] - a0
    b = arredondado[encaixa, 1] - b0
    matriz = np.column_stack([np.ones(len(a)), a, b])
    coef, *_ = np.linalg.lstsq(matriz, pontos[encaixa], rcond=None)
    return coef[0], coef[1], coef[2]  # origem, u, v


def localizar_bolhas_por_reticulado(
    imagem_bgr: np.ndarray, num_questoes: int = NUM_QUESTOES
) -> list[list[Bolha | None]] | None:
    """Alternativa robusta a `localizar_bolhas`: ajusta uma grade regular
    (5 alternativas x num_questoes) aos circulos detectados e devolve as 40
    posicoes previstas pela grade - inclusive as bolhas que o Hough nao
    detectou (ex.: bolhas preenchidas) e ignorando circulos falsos (texto
    'Questao', numeros das linhas). Retorna None se nao achar a grade."""
    try:
        circulos = _detectar_circulos(imagem_bgr)
    except ValueError:
        return None
    escala = imagem_bgr.shape[0] / 5556.0
    pontos = circulos[:, :2].astype(float)
    if len(pontos) < 12:
        return None

    vetores = _estimar_vetores_grade(pontos, escala)
    if vetores is None:
        return None
    ajuste = _ajustar_reticulado(pontos, vetores[0], vetores[1], num_questoes)
    if ajuste is None:
        return None
    origem, u, v = ajuste
    raio = float(np.median(circulos[:, 2]))

    return [
        [
            Bolha(x=float(origem[0] + a * u[0] + b * v[0]), y=float(origem[1] + a * u[1] + b * v[1]), raio=raio)
            for b in range(num_questoes)
        ]
        for a in range(len(ALTERNATIVAS))
    ]
