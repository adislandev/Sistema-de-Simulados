"""Leitura do CSV "Grade de Notas" exportado da plataforma (atividades da N1).

Formato (separador ";", decimal com ponto): 1a linha = titulo da disciplina,
2a = grupos (n1, N2...), 3a = cabecalho ("Nome", "Codigo da pessoa", ...).
As atividades da N1 sao as colunas entre "Progresso" e a primeira coluna que
comeca com "Aval" ou "Nota". Ignora "Aval N1" (a nota da prova vem do
sistema), "Nota n1", tudo da N2 e "Nota final". Os valores sao usados
exatamente como estao no arquivo.

Modulo puro (sem rede).
"""
from __future__ import annotations

import csv
import io
from dataclasses import dataclass, field


@dataclass
class Atividades:
    nomes: list[str]
    alunos: list["AlunoAtividades"] = field(default_factory=list)
    avisos: list[str] = field(default_factory=list)


@dataclass
class AlunoAtividades:
    ra: str
    nome: str
    status: str
    notas: list[float | None]


def _numero(valor: str) -> float | None:
    texto = valor.strip().replace(",", ".")
    if texto == "":
        return None
    try:
        return float(texto)
    except ValueError:
        return None


def ra_da_matricula(matricula: str) -> str:
    """'000003_901005274' -> '901005274' (o RA vem depois do '_', com zeros a
    esquerda preservados, ex.: '000003_0002667' -> '0002667')."""
    return matricula.strip().split("_")[-1] if "_" in matricula else ""


def ler_grade(texto_csv: str) -> Atividades:
    linhas = list(csv.reader(io.StringIO(texto_csv.lstrip("﻿")), delimiter=";"))
    indice = next((i for i, l in enumerate(linhas) if l and l[0].strip() == "Nome"), None)
    if indice is None:
        raise ValueError('Cabecalho nao encontrado no CSV (esperava uma linha comecando com "Nome").')
    cab = [c.strip() for c in linhas[indice]]

    try:
        inicio = cab.index("Progresso") + 1
    except ValueError:
        inicio = cab.index("Status") + 1
    fim = next(
        (i for i in range(inicio, len(cab)) if cab[i].lower().startswith(("aval", "nota"))),
        len(cab),
    )
    col_nome = cab.index("Nome")
    col_matricula = cab.index("Código da matrícula")
    col_status = cab.index("Status")

    resultado = Atividades(nomes=cab[inicio:fim])
    for linha in linhas[indice + 1:]:
        if not linha or not linha[0].strip():
            continue
        linha = linha + [""] * (len(cab) - len(linha))
        ra = ra_da_matricula(linha[col_matricula])
        if not ra:
            resultado.avisos.append(f"{linha[col_nome]}: matricula sem RA ({linha[col_matricula]!r}) - ignorado.")
            continue
        resultado.alunos.append(
            AlunoAtividades(
                ra=ra,
                nome=linha[col_nome].strip(),
                status=linha[col_status].strip(),
                notas=[_numero(c) for c in linha[inicio:fim]],
            )
        )
    return resultado
