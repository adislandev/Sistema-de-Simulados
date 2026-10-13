"""Montagem das abas "Atividades N1" e "Nota N1" (por disciplina).

Nota N1 = soma das atividades (como vieram da plataforma) + nota da prova
(Nota Final da aba "Notas Finais", so quando a dissertativa foi confirmada) +
extra manual. O total e limitado a 10; o que passar de 10 vai para
"Excedente". Sem prova (ou sem atividades importadas) a linha fica em branco -
nunca uma nota parcial.

As abas usam formulas para recalcular sozinhas quando a planilha de atividades
ou a "Notas Finais" mudam. A coluna "Extra (manual)" e do professor: ao
regerar, os valores digitados sao preservados por RA.

Modulo puro (sem rede).
"""
from __future__ import annotations

from .atividades import Atividades
from .sincronizacao import normalizar_ra

ABA_ATIVIDADES = "Atividades N1"
ABA_NOTA_N1 = "Nota N1"
ABA_NOTAS_FINAIS = "Notas Finais"
LIMITE_N1 = 10

CABECALHO_N1 = [
    "RA", "Nome", "Turma", "Atividades", "Prova", "Extra (manual)",
    "Total bruto", "Nota N1", "Excedente (acima de 10)", "Situação",
]


def letra_coluna(indice: int) -> str:
    """0 -> A, 25 -> Z, 26 -> AA."""
    texto = ""
    n = indice + 1
    while n:
        n, resto = divmod(n - 1, 26)
        texto = chr(65 + resto) + texto
    return texto


def tabela_atividades(atividades: Atividades) -> list[list]:
    """RA, Nome, Status, <atividades...>, Soma (a Soma e preenchida com formula
    pelo script; aqui vai como texto da formula)."""
    cabecalho = ["RA", "Nome", "Status", *atividades.nomes, "Soma das atividades"]
    primeira, ultima = letra_coluna(3), letra_coluna(2 + len(atividades.nomes))
    tabela = [cabecalho]
    for i, aluno in enumerate(sorted(atividades.alunos, key=lambda a: a.nome.upper()), start=2):
        formula = f"=ROUND(SUM({primeira}{i}:{ultima}{i}),2)" if atividades.nomes else 0
        tabela.append([aluno.ra, aluno.nome, aluno.status, *["" if n is None else n for n in aluno.notas], formula])
    return tabela


def linhas_nota_n1(
    resultados: list[dict],
    atividades: Atividades | None,
    turma: str,
    extras_existentes: dict[str, object],
) -> list[list]:
    """Linhas (sem cabecalho) com RA, Nome, Turma e Extra preservado; as demais
    colunas sao formulas montadas por `formulas_linha`."""
    por_ra: dict[str, dict] = {}
    for r in resultados:
        por_ra[normalizar_ra(r["ra"])] = {"ra": r["ra"], "nome": r["nome"]}
    if atividades:
        for a in atividades.alunos:
            chave = normalizar_ra(a.ra)
            if chave in por_ra:
                continue
            if a.status.lower().startswith("inativ"):
                continue  # inativo sem prova nao entra na lista
            por_ra[chave] = {"ra": a.ra, "nome": a.nome}

    linhas = []
    for chave, dados in sorted(por_ra.items(), key=lambda kv: str(kv[1]["nome"]).upper()):
        linhas.append([dados["ra"], dados["nome"], turma, extras_existentes.get(chave, "")])
    return linhas


def formulas_linha(n: int, col_soma_atividades: str) -> dict[str, str]:
    """Formulas (sintaxe da API: ingles, virgula) da linha `n` da aba Nota N1."""
    atividades = (
        f"=IFERROR(INDEX('{ABA_ATIVIDADES}'!${col_soma_atividades}:${col_soma_atividades},"
        f"MATCH($A{n},'{ABA_ATIVIDADES}'!$A:$A,0)),\"\")"
    )
    prova = (
        f"=IFERROR(IF(INDEX('{ABA_NOTAS_FINAIS}'!$F:$F,MATCH($A{n},'{ABA_NOTAS_FINAIS}'!$A:$A,0))=\"\","
        f"\"\",INDEX('{ABA_NOTAS_FINAIS}'!$F:$F,MATCH($A{n},'{ABA_NOTAS_FINAIS}'!$A:$A,0))),\"\")"
    )
    return {
        "D": atividades,
        "E": prova,
        "G": f'=IF(OR(D{n}="",E{n}=""),"",ROUND(D{n}+E{n}+N(F{n}),2))',
        "H": f'=IF(G{n}="","",MIN({LIMITE_N1},G{n}))',
        "I": f'=IF(G{n}="","",MAX(0,ROUND(G{n}-{LIMITE_N1},2)))',
        "J": f'=IF(E{n}="","Sem prova",IF(D{n}="","Sem atividades",IF(G{n}>{LIMITE_N1},"Acima de 10","OK")))',
    }
