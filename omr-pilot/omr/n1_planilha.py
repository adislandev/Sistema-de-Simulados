"""Leitura das abas "Atividades N1" e "Nota N1" da planilha (dados que a
planilha manda: atividades e extra manual) e conversao em linhas para a tabela
`notas_n1_atividades` do Supabase.

Modulo puro (sem rede).
"""
from __future__ import annotations

from .sincronizacao import normalizar_ra

COLUNA_SOMA = "Soma das atividades"


def _numero(valor: object) -> float | None:
    if valor is None or str(valor).strip() == "":
        return None
    try:
        return float(str(valor).strip().replace(",", "."))
    except ValueError:
        return None


def extras_por_ra(valores_nota_n1: list[list]) -> dict[str, float]:
    """Coluna F ("Extra (manual)") da aba Nota N1, por RA normalizado."""
    extras: dict[str, float] = {}
    for linha in valores_nota_n1[1:]:
        if len(linha) >= 6 and str(linha[0]).strip():
            extra = _numero(linha[5])
            if extra is not None:
                extras[normalizar_ra(linha[0])] = extra
    return extras


def linhas_atividades(
    valores_atividades: list[list],
    valores_nota_n1: list[list],
    turma: str,
    prova_tipo: str,
) -> list[dict]:
    if not valores_atividades:
        return []
    cab = [str(c).strip() for c in valores_atividades[0]]
    if COLUNA_SOMA not in cab:
        raise ValueError(f"Aba 'Atividades N1' sem a coluna '{COLUNA_SOMA}'.")
    fim = cab.index(COLUNA_SOMA)
    nomes = cab[3:fim]
    extras = extras_por_ra(valores_nota_n1)

    linhas: list[dict] = []
    for bruto in valores_atividades[1:]:
        celulas = list(bruto) + [""] * (fim + 1 - len(bruto))
        if not str(celulas[0]).strip():
            continue
        notas = [_numero(c) for c in celulas[3:fim]]
        linhas.append({
            "ra": str(celulas[0]).strip(),
            "nome": str(celulas[1]).strip(),
            "turma": turma,
            "prova_tipo": prova_tipo,
            "status_plataforma": str(celulas[2]).strip() or None,
            "atividades": [{"nome": n, "nota": v} for n, v in zip(nomes, notas)],
            "atividades_soma": round(sum(v for v in notas if v is not None), 2),
            "extra_manual": extras.get(normalizar_ra(celulas[0])),
        })
    return linhas
