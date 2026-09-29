"""Leitura da lista de chamada (RA + nome) e casamento de nomes por similaridade.

O casamento por nome e deterministico (difflib.SequenceMatcher, sem IA/LLM):
o nome do aluno extraido do arquivo da prova (ex.: nome do arquivo no Drive) e
comparado contra cada nome da lista de chamada, normalizado (maiusculas, sem
acentos), e o mais proximo acima de um limiar minimo e escolhido.
"""
from __future__ import annotations

import csv
import unicodedata
from dataclasses import dataclass
from difflib import SequenceMatcher
from pathlib import Path

LIMIAR_SIMILARIDADE_TOKEN = 0.75
COBERTURA_MINIMA = 1.0


@dataclass
class Aluno:
    ra: str
    nome: str


def _normalizar(texto: str) -> str:
    sem_acento = unicodedata.normalize("NFKD", texto).encode("ascii", "ignore").decode("ascii")
    return sem_acento.strip().upper()


def carregar_lista_chamada(caminho_csv: str | Path) -> list[Aluno]:
    alunos = []
    with open(caminho_csv, newline="", encoding="utf-8") as f:
        for linha in csv.DictReader(f):
            alunos.append(Aluno(ra=linha["ra"].strip(), nome=linha["nome"].strip()))
    return alunos


def _cobertura(tokens_consulta: list[str], tokens_aluno: list[str]) -> tuple[float, float]:
    """Retorna (cobertura, media_dos_ratios): cobertura = fracao dos tokens da
    consulta (ex.: nome do arquivo, "Rai Douglas") que encontram um token
    correspondente no nome oficial (ex.: "RAI DOUGLAS PINHEIRO FRANCO") - assim
    um nome de arquivo parcial (so primeiro+ultimo nome) ainda casa certo com
    o nome completo da lista de chamada, sem exigir igualdade do nome inteiro."""
    if not tokens_consulta:
        return 0.0, 0.0
    ratios = []
    casados = 0
    for token in tokens_consulta:
        melhor_ratio = max(
            (SequenceMatcher(None, token, ta).ratio() for ta in tokens_aluno), default=0.0
        )
        ratios.append(melhor_ratio)
        if melhor_ratio >= LIMIAR_SIMILARIDADE_TOKEN:
            casados += 1
    return casados / len(tokens_consulta), sum(ratios) / len(ratios)


def buscar_por_nome(nome_consulta: str, alunos: list[Aluno]) -> tuple[Aluno | None, float]:
    """Retorna (aluno mais provavel, score 0-1) ou (None, score) se nenhum
    candidato cobrir todos os tokens do nome de consulta."""
    tokens_consulta = _normalizar(nome_consulta).split()
    melhor: Aluno | None = None
    melhor_chave = (0.0, 0.0)
    for aluno in alunos:
        tokens_aluno = _normalizar(aluno.nome).split()
        chave = _cobertura(tokens_consulta, tokens_aluno)
        if chave > melhor_chave:
            melhor_chave = chave
            melhor = aluno
    cobertura, media_ratio = melhor_chave
    if cobertura < COBERTURA_MINIMA:
        return None, media_ratio
    return melhor, media_ratio
