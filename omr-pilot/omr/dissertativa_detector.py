"""Deteccao e recorte das questoes dissertativas (discursivas) de uma pagina
renderizada da prova presencial, para posterior avaliacao por IA com visao
(ver ADI-70).

Estrategia: o template da prova usa uma barra cinza-escura com o titulo da
questao ("QUESTAO DISCURSIVA N (X PONTO)") logo acima da caixa de resposta
pautada. Em vez de fixar coordenadas de pixel (fragil a pequenas variacoes de
digitalizacao/foto), localizamos essa barra pelo perfil de escurecimento das
linhas (row profile) e recortamos tudo entre o fim da barra e a borda inferior
da caixa de resposta (a proxima barra de titulo, ou o fim da pagina).

Calibrado sobre a amostra real (samples/lucas_gabriel_pagina_1_hd.png,
3934x5556 a 400dpi) - ver testar_recorte_dissertativas.py.
"""
from __future__ import annotations

from dataclasses import dataclass

import cv2
import numpy as np

ALTURA_REFERENCIA = 5556.0  # mesma referencia de calibracao usada no grade_detector

# Faixa de altura (em px, na resolucao de referencia) esperada para a barra
# cinza do titulo da questao dissertativa. O minimo foi reduzido de 100 para
# 40 apos observar, em digitalizacoes reais (fotocopia com contraste mais
# claro que a amostra de calibracao), barras validas medindo entre 53 e 93px
# pelo perfil de escurecimento - o limiar de 100 as descartava e perdia a
# questao inteira sem nenhum aviso. Ruido de pagina (sombras, marcas) fica
# bem abaixo disso (poucos pixels de altura), entao a margem de seguranca
# continua ampla.
ALTURA_BARRA_MIN = 40
ALTURA_BARRA_MAX = 260

# Fracao minima de colunas "escuras" dentro da faixa candidata para considerar
# uma barra de titulo (distingue de sombras de foto, que sao mais irregulares
# e nao cobrem a largura inteira da pagina).
FRACAO_COLUNAS_ESCURAS_MIN = 0.65
LIMIAR_CINZA_BARRA = 190

# Ignora as margens de topo/rodape da pagina (logo da instituicao no topo,
# marca d'agua no rodape) - nunca ha barra de titulo tao perto da borda.
MARGEM_TOPO_FRACAO = 0.08
MARGEM_RODAPE_FRACAO = 0.08

# Margem horizontal (fracao da largura) a excluir ao medir o perfil de linhas,
# para nao contar sombras nas bordas da foto.
MARGEM_LATERAL_FRACAO = 0.08


@dataclass
class BlocoDissertativa:
    imagem: np.ndarray  # recorte BGR contendo so a caixa de resposta (sem a barra de titulo)
    y0: int
    y1: int
    x0: int
    x1: int


def _perfil_linhas(cinza: np.ndarray, margem_lateral: int) -> np.ndarray:
    central = cinza[:, margem_lateral: cinza.shape[1] - margem_lateral]
    return central.mean(axis=1)


def _agrupar_faixas_escuras(perfil: np.ndarray, limiar: float, gap_max: int = 5) -> list[tuple[int, int]]:
    linhas_escuras = np.where(perfil < limiar)[0]
    grupos: list[tuple[int, int]] = []
    if len(linhas_escuras) == 0:
        return grupos
    inicio = int(linhas_escuras[0])
    anterior = int(linhas_escuras[0])
    for y in linhas_escuras[1:]:
        y = int(y)
        if y - anterior > gap_max:
            grupos.append((inicio, anterior))
            inicio = y
        anterior = y
    grupos.append((inicio, anterior))
    return grupos


def _e_barra_titulo(cinza: np.ndarray, y0: int, y1: int, margem_lateral: int) -> bool:
    faixa = cinza[y0:y1, margem_lateral: cinza.shape[1] - margem_lateral]
    fracao_escura = (faixa.mean(axis=0) < LIMIAR_CINZA_BARRA).mean()
    return fracao_escura >= FRACAO_COLUNAS_ESCURAS_MIN


def _borda_lateral_caixa(cinza: np.ndarray, barra_y0: int, barra_y1: int) -> tuple[int, int]:
    """Localiza as bordas verticais (esquerda/direita) da caixa de resposta
    pautada, a partir da extensao horizontal da PROPRIA barra de titulo
    (que e solida e escura por toda a sua altura, ao contrario da caixa de
    resposta abaixo dela, onde so as bordas fora e uma linha fina de
    separacao da numeracao de linha cruzam o limiar de escurecimento - usar
    a media de coluna sobre a altura inteira da caixa pegava essa linha fina
    em vez da borda direita real, cortando o recorte so no canto esquerdo)."""
    faixa = cinza[barra_y0:barra_y1, :]
    perfil_colunas = faixa.mean(axis=0)
    escuras = np.where(perfil_colunas < LIMIAR_CINZA_BARRA)[0]
    if len(escuras) < 2:
        return 0, cinza.shape[1]
    return int(escuras[0]), int(escuras[-1])


def localizar_blocos_dissertativas(imagem_bgr: np.ndarray) -> list[BlocoDissertativa]:
    """Localiza cada questao dissertativa na pagina (barra de titulo + caixa de
    resposta abaixo dela) e retorna o recorte apenas da caixa de resposta (sem
    a barra), um bloco por questao encontrada, em ordem de topo para baixo.
    Retorna lista vazia se a pagina nao tiver nenhuma questao dissertativa
    (ex.: pagina so com a grade de bolhas)."""
    cinza = cv2.cvtColor(imagem_bgr, cv2.COLOR_BGR2GRAY)
    altura, largura = cinza.shape
    escala = altura / ALTURA_REFERENCIA

    margem_lateral = int(largura * MARGEM_LATERAL_FRACAO)
    margem_topo = int(altura * MARGEM_TOPO_FRACAO)
    margem_rodape = int(altura * (1 - MARGEM_RODAPE_FRACAO))

    perfil = _perfil_linhas(cinza, margem_lateral)
    candidatas = _agrupar_faixas_escuras(perfil, LIMIAR_CINZA_BARRA)

    altura_min = ALTURA_BARRA_MIN * escala
    altura_max = ALTURA_BARRA_MAX * escala

    barras: list[tuple[int, int]] = []
    for y0, y1 in candidatas:
        if y0 < margem_topo or y1 > margem_rodape:
            continue
        if not (altura_min <= (y1 - y0) <= altura_max):
            continue
        if not _e_barra_titulo(cinza, y0, y1, margem_lateral):
            continue
        barras.append((y0, y1))

    if not barras:
        return []

    blocos: list[BlocoDissertativa] = []
    for indice, (barra_y0, barra_y1) in enumerate(barras):
        y_inicio = barra_y1 + 1
        y_fim = barras[indice + 1][0] - 1 if indice + 1 < len(barras) else margem_rodape
        x0, x1 = _borda_lateral_caixa(cinza, barra_y0, barra_y1)
        blocos.append(
            BlocoDissertativa(
                imagem=imagem_bgr[y_inicio:y_fim, x0:x1].copy(),
                y0=y_inicio,
                y1=y_fim,
                x0=x0,
                x1=x1,
            )
        )
    return blocos
