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

LIMIAR_SIMILARIDADE = 0.6


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


def buscar_por_nome(nome_consulta: str, alunos: list[Aluno]) -> tuple[Aluno | None, float]:
    """Retorna (aluno mais provavel, score de similaridade 0-1) ou (None, 0.0)
    se nada atingir o limiar minimo."""
    alvo = _normalizar(nome_consulta)
    melhor: Aluno | None = None
    melhor_score = 0.0
    for aluno in alunos:
        score = SequenceMatcher(None, alvo, _normalizar(aluno.nome)).ratio()
        if score > melhor_score:
            melhor_score = score
            melhor = aluno
    if melhor_score < LIMIAR_SIMILARIDADE:
        return None, melhor_score
    return melhor, melhor_score
