"""Orquestra a Fase 1 (recorte) + Fase 2 (avaliacao via IA) das questoes
dissertativas para as paginas ja renderizadas de uma prova (ADI-70).

Nao grava nada - so retorna a sugestao agregada para o chamador decidir o que
fazer (hoje: gravar como sugestao no Supabase, nunca como nota definitiva).
"""
from __future__ import annotations

from dataclasses import asdict
from typing import Any

import numpy as np

from .dissertativa_detector import localizar_blocos_dissertativas
from .dissertativa_ia import ResultadoAvaliacaoIA, avaliar_dissertativa

VALOR_POR_QUESTAO_DISSERTATIVA = 1.5
NUMERO_PRIMEIRA_DISSERTATIVA = 9  # Q9 e Q10 na prova de Logica Computacional

# Plano B quando a barra de titulo nao e detectada em nenhuma pagina (foto/scan
# claro demais, com sombras): recorte por posicao, no layout padrao da prova -
# pagina 1 tem cabecalho + grade de bolhas + Q9 na metade inferior; as paginas
# seguintes tem uma dissertativa cada, logo abaixo do cabecalho.
FRACAO_INICIO_DISSERTATIVA_PAGINA_1 = 0.45
FRACAO_INICIO_DISSERTATIVA_DEMAIS_PAGINAS = 0.08
FRACAO_FIM_DISSERTATIVA = 0.92


def _recortes_por_posicao(paginas: list[np.ndarray]) -> list[np.ndarray]:
    recortes = []
    for indice, pagina in enumerate(paginas):
        altura = pagina.shape[0]
        inicio = FRACAO_INICIO_DISSERTATIVA_PAGINA_1 if indice == 0 else FRACAO_INICIO_DISSERTATIVA_DEMAIS_PAGINAS
        recortes.append(pagina[int(altura * inicio): int(altura * FRACAO_FIM_DISSERTATIVA), :].copy())
    return recortes


def _resultado_para_dict(numero_questao: int, resultado: ResultadoAvaliacaoIA) -> dict[str, Any]:
    dados = asdict(resultado)
    dados.pop("resposta_bruta", None)  # dado interno de depuracao, nao precisa persistir
    dados["questao"] = numero_questao
    return dados


def avaliar_dissertativas_da_prova(paginas: list[np.ndarray]) -> tuple[float | None, list[dict[str, Any]]]:
    """Recebe as paginas ja renderizadas da prova (em ordem) e retorna
    (nota_sugerida_total, detalhe_por_questao). nota_sugerida_total e a soma
    das notas sugeridas pela IA disponiveis - fica None se nenhuma questao
    pode ser avaliada (todas pendentes de revisao manual). Erros de avaliacao
    de uma questao especifica nao interrompem as demais - a questao fica
    marcada como pendente com a observacao do erro."""
    numero_atual = NUMERO_PRIMEIRA_DISSERTATIVA
    detalhes: list[dict[str, Any]] = []

    imagens = [bloco.imagem for pagina in paginas for bloco in localizar_blocos_dissertativas(pagina)]
    if not imagens:
        print("  AVISO: barra de titulo das dissertativas nao detectada - usando recorte por posicao.")
        imagens = _recortes_por_posicao(paginas)

    for imagem in imagens:
        try:
            resultado = avaliar_dissertativa(
                imagem,
                numero_questao=numero_atual,
                valor_questao=VALOR_POR_QUESTAO_DISSERTATIVA,
            )
            detalhes.append(_resultado_para_dict(numero_atual, resultado))
        except Exception as erro:  # nao interrompe as outras questoes/paginas
            detalhes.append(
                {
                    "questao": numero_atual,
                    "transcricao": "",
                    "pendente_revisao_manual": True,
                    "criterios": [],
                    "nota_sugerida_total": None,
                    "observacao": f"Falha ao avaliar via IA: {erro}",
                }
            )
        numero_atual += 1

    notas_disponiveis = [d["nota_sugerida_total"] for d in detalhes if d.get("nota_sugerida_total") is not None]
    nota_total = sum(notas_disponiveis) if notas_disponiveis else None
    return nota_total, detalhes
