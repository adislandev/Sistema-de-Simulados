"""Sugestao de vinculo entre o aluno do simulado (so nome/turma digitados) e o
RA (lista de chamada / plataforma), por similaridade de nome.

O aluno as vezes digita so o primeiro nome, ou sem acento, ou sem o sobrenome
final - entao o criterio e: todos os tokens do nome digitado precisam casar com
algum token do nome oficial (mesma regra de omr/roster.py). Se so UM aluno da
turma casar, vira "sugerido"; se varios, "ambiguo" (o professor escolhe); se
nenhum, "sem_correspondencia". O campo turma do simulado e texto livre do
aluno e NAO e usado. Nada aqui e definitivo: o professor confirma no sistema.

Modulo puro (sem rede).
"""
from __future__ import annotations

from dataclasses import dataclass, field

from .roster import _cobertura, _normalizar
from .sincronizacao import normalizar_ra

MAX_CANDIDATOS = 3
COBERTURA_MINIMA_DICA = 0.5  # para listar candidatos quando nada casa por completo


@dataclass
class Sugestao:
    status: str  # sugerido | ambiguo | sem_correspondencia
    ra: str | None = None
    similaridade: float | None = None
    candidatos: list[dict] = field(default_factory=list)  # [{ra, nome, similaridade}]


def _unicos(pool: list[tuple[str, str]]) -> list[tuple[str, str]]:
    vistos: dict[str, tuple[str, str]] = {}
    for ra, nome in pool:
        vistos.setdefault(normalizar_ra(ra), (ra, nome))
    return list(vistos.values())


def sugerir(nome_digitado: str, pool: list[tuple[str, str]]) -> Sugestao:
    tokens = _normalizar(nome_digitado).split()
    pontuados = []
    for ra, nome in _unicos(pool):
        cobertura, media = _cobertura(tokens, _normalizar(nome).split())
        pontuados.append((cobertura, media, ra, nome))

    completos = sorted((p for p in pontuados if p[0] >= 1.0), key=lambda p: -p[1])
    if len(completos) == 1:
        _, media, ra, _ = completos[0]
        return Sugestao("sugerido", ra, round(media, 2))
    if len(completos) > 1:
        # varios casam por similaridade, mas so um tem todos os tokens IGUAIS
        # (ex.: "Isabelli" casa exato com ISABELLI e so parecido com ISABELLY)
        perfeitos = [p for p in completos if p[1] >= 0.999]
        if len(perfeitos) == 1:
            return Sugestao("sugerido", perfeitos[0][2], 1.0)
        return Sugestao("ambiguo", None, None, [
            {"ra": ra, "nome": nome, "similaridade": round(media, 2)} for _, media, ra, nome in completos[:MAX_CANDIDATOS]
        ])

    dicas = sorted((p for p in pontuados if p[0] >= COBERTURA_MINIMA_DICA), key=lambda p: (-p[0], -p[1]))
    return Sugestao("sem_correspondencia", None, None, [
        {"ra": ra, "nome": nome, "similaridade": round(media, 2)} for _, media, ra, nome in dicas[:MAX_CANDIDATOS]
    ])
