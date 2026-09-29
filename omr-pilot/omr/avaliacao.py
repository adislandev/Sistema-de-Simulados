"""Regra de pontuacao da prova: 7 pontos no total, sendo 8 questoes objetivas
(0,5 cada = 4,0 pts) e 2 questoes dissertativas de pseudocodigo (0,75 cada =
1,5 cada... na verdade 1,5 cada = 3,0 pts totais, fora do escopo deste piloto).

A "Nota Objetiva" gravada na planilha e so a parte das objetivas (0 a 4,0),
nao uma nota de 0 a 10 independente do peso real da prova.
"""
from __future__ import annotations

VALOR_POR_QUESTAO_OBJETIVA = 0.5


def calcular_nota_objetiva(acertos: int) -> float:
    return round(acertos * VALOR_POR_QUESTAO_OBJETIVA, 2)
