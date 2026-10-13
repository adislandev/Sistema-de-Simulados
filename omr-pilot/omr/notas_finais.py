"""Monta a tabela "Notas Finais" (por disciplina) a partir do Supabase.

Nota final = nota objetiva (Q1-Q8) + nota dissertativa CONFIRMADA pelo
professor no painel. Enquanto a dissertativa nao foi confirmada, a linha fica
"Pendente" e a dissertativa e a nota final ficam em branco - nunca uma nota
parcial que possa ser confundida com a definitiva.

Modulo puro (sem rede): o script `gerar_notas_finais.py` le o Supabase e
grava o resultado na planilha.
"""
from __future__ import annotations

from datetime import date

CABECALHO = [
    "RA", "Nome", "Turma", "Nota Objetiva", "Nota Dissertativa", "Nota Final", "Dissertativa", "Atualizado em",
]


def _numero(valor: object) -> float | None:
    if valor is None or str(valor).strip() == "":
        return None
    return float(valor)


def montar_tabela(linhas: list[dict], turma: str, hoje: date | None = None) -> list[list]:
    """Retorna cabecalho + uma linha por aluno, ordenada por nome."""
    data = (hoje or date.today()).isoformat()
    tabela: list[list] = [CABECALHO]
    for linha in sorted(linhas, key=lambda l: str(l["nome"]).strip().upper()):
        objetiva = _numero(linha.get("nota_objetiva"))
        dissertativa = _numero(linha.get("nota_dissertativa"))
        confirmada = dissertativa is not None and linha.get("dissertativa_revisada_em") is not None
        if confirmada:
            final = round((objetiva or 0.0) + dissertativa, 2)
            tabela.append([
                linha["ra"], linha["nome"], turma, objetiva, dissertativa, final, "Confirmada", data,
            ])
        else:
            tabela.append([linha["ra"], linha["nome"], turma, objetiva, "", "", "Pendente", data])
    return tabela
