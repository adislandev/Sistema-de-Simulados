"""Grava a aba "Notas Finais" na planilha de cada disciplina, a partir do
Supabase (objetiva + dissertativa confirmada no painel).

A aba e sempre reescrita por inteiro - nao e para editar a mao. A aba
principal da planilha (onde o pipeline grava e voce corrige as objetivas) nao
e tocada.

Uso:
    GOOGLE_APPLICATION_CREDENTIALS=<json> SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... \\
        python gerar_notas_finais.py [--disciplina=logica|ergonomia]
"""
from __future__ import annotations

import os
import sys
from pathlib import Path

from google.oauth2 import service_account
from googleapiclient.discovery import build

sys.path.insert(0, str(Path(__file__).parent))
from omr.disciplinas import DISCIPLINAS, Disciplina  # noqa: E402
from omr.notas_finais import montar_tabela  # noqa: E402
from omr.supabase_writer import listar_resultados  # noqa: E402

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]
NOME_ABA = "Notas Finais"


def garantir_aba(servico, planilha_id: str, nome: str = NOME_ABA) -> None:
    meta = servico.spreadsheets().get(
        spreadsheetId=planilha_id, fields="sheets.properties.title"
    ).execute()
    if any(s["properties"]["title"] == nome for s in meta["sheets"]):
        return
    servico.spreadsheets().batchUpdate(
        spreadsheetId=planilha_id,
        body={"requests": [{"addSheet": {"properties": {"title": nome}}}]},  # entra no fim: a aba principal continua a primeira
    ).execute()
    print(f"  Aba '{nome}' criada.")


def gerar(servico, disciplina: Disciplina) -> None:
    tabela = montar_tabela(listar_resultados(disciplina.prova_tipo), disciplina.turma)
    garantir_aba(servico, disciplina.planilha_id)
    valores = servico.spreadsheets().values()
    valores.clear(spreadsheetId=disciplina.planilha_id, range=f"'{NOME_ABA}'!A:Z", body={}).execute()
    # RAW: numeros ficam numericos sem depender da configuracao regional (virgula/ponto) da planilha
    valores.update(
        spreadsheetId=disciplina.planilha_id,
        range=f"'{NOME_ABA}'!A1",
        valueInputOption="RAW",
        body={"values": tabela},
    ).execute()
    confirmadas = sum(1 for linha in tabela[1:] if linha[6] == "Confirmada")
    print(f"  {len(tabela) - 1} aluno(s): {confirmadas} com dissertativa confirmada, {len(tabela) - 1 - confirmadas} pendente(s).")


def main() -> None:
    chaves = [a.split("=", 1)[1] for a in sys.argv[1:] if a.startswith("--disciplina=")]
    alvo = [d for d in DISCIPLINAS if not chaves or d.chave in chaves]
    if not alvo:
        raise SystemExit(f"Disciplina desconhecida. Opcoes: {', '.join(d.chave for d in DISCIPLINAS)}")

    creds = service_account.Credentials.from_service_account_file(
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"], scopes=SCOPES
    )
    servico = build("sheets", "v4", credentials=creds)

    falhas = []
    for d in alvo:
        print(f"\n##### {d.nome} - turma {d.turma} #####")
        try:
            gerar(servico, d)
        except Exception as erro:
            print(f"ERRO: {type(erro).__name__}: {erro}")
            falhas.append(d.nome)
    if falhas:
        raise SystemExit(f"Falha em: {', '.join(falhas)}.")


if __name__ == "__main__":
    main()
