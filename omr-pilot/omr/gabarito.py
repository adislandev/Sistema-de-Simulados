"""Busca o gabarito oficial (Google Doc) via Drive API e extrai as respostas
corretas das questoes objetivas (1..N).

O doc segue um formato fixo de tabela "Questao / Resposta" (uma letra A-E por
linha, em sequencia). O parser e deterministico (regex sobre o texto exportado),
sem IA.
"""
from __future__ import annotations

import re

from google.oauth2 import service_account
from googleapiclient.discovery import build

SCOPES = ["https://www.googleapis.com/auth/drive.readonly"]


def obter_texto_documento(caminho_credenciais: str, doc_id: str) -> str:
    creds = service_account.Credentials.from_service_account_file(caminho_credenciais, scopes=SCOPES)
    drive = build("drive", "v3", credentials=creds)
    conteudo = drive.files().export(fileId=doc_id, mimeType="text/plain").execute()
    return conteudo.decode("utf-8")


def extrair_respostas_corretas(texto_documento: str, num_questoes: int) -> list[str]:
    """Espera linhas alternando numero da questao (1, 2, 3...) e uma letra A-E,
    uma por linha (formato do gabarito atual, tabela Questao/Resposta)."""
    linhas = [l.strip() for l in texto_documento.splitlines() if l.strip()]
    respostas: dict[int, str] = {}
    numero_atual: int | None = None
    for linha in linhas:
        if re.fullmatch(r"\d+", linha):
            numero_atual = int(linha)
            continue
        if re.fullmatch(r"[A-E]", linha) and numero_atual is not None:
            respostas[numero_atual] = linha
            numero_atual = None

    faltando = [i for i in range(1, num_questoes + 1) if i not in respostas]
    if faltando:
        raise ValueError(f"Nao encontrei resposta oficial para a(s) questao(oes) {faltando} no gabarito.")
    return [respostas[i] for i in range(1, num_questoes + 1)]
