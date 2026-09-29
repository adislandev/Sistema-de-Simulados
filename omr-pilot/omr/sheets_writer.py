"""Escrita de resultados na planilha Google Sheets via conta de servico.

O caminho do arquivo JSON da credencial NUNCA fica hardcoded aqui: vem sempre
de uma variavel de ambiente (GOOGLE_APPLICATION_CREDENTIALS), que deve apontar
para um arquivo fora do repositorio. O conteudo da credencial nunca e lido
diretamente por este modulo alem do necessario para autenticar - nunca e
logado nem impresso.
"""
from __future__ import annotations

import os
from datetime import date

from google.oauth2 import service_account
from googleapiclient.discovery import build

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]

CABECALHO = [
    "RA", "Nome", "Turma", "Prova (Tipo)",
    "Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7", "Q8",
    "Acertos", "Nota Objetiva", "Data Correção", "Observações",
]


def _obter_credenciais() -> service_account.Credentials:
    caminho = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
    if not caminho:
        raise RuntimeError(
            "Defina a variavel de ambiente GOOGLE_APPLICATION_CREDENTIALS "
            "apontando para o arquivo JSON da conta de servico (fora do repositorio)."
        )
    return service_account.Credentials.from_service_account_file(caminho, scopes=SCOPES)


def montar_linha(
    ra: str,
    nome: str,
    turma: str,
    prova_tipo: str,
    respostas: list[str | None],
    acertos: int,
    nota_objetiva: float,
    observacoes: str = "",
) -> list:
    respostas_fmt = [r or "" for r in respostas]
    return [
        ra, nome, turma, prova_tipo,
        *respostas_fmt,
        acertos, nota_objetiva,
        date.today().isoformat(),
        observacoes,
    ]


def adicionar_linha(spreadsheet_id: str, linha: list) -> dict:
    creds = _obter_credenciais()
    servico = build("sheets", "v4", credentials=creds)
    return (
        servico.spreadsheets()
        .values()
        .append(
            spreadsheetId=spreadsheet_id,
            range="A1",
            valueInputOption="USER_ENTERED",
            insertDataOption="INSERT_ROWS",
            body={"values": [linha]},
        )
        .execute()
    )
