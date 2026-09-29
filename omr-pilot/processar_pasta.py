"""Fase 3: verificacao periodica da pasta do Drive com as provas digitalizadas.

Para cada PDF de prova ainda nao corrigido (nome do aluno ainda nao presente
na planilha), baixa o arquivo, renderiza a primeira pagina (grade de bolhas),
roda o OMR, identifica o aluno por RA, calcula acertos contra o gabarito
oficial e grava uma linha na planilha real.

Pensado para rodar via GitHub Actions (cron) ou manualmente:
    GOOGLE_APPLICATION_CREDENTIALS=<caminho> python processar_pasta.py

A credencial da conta de servico e sempre lida de GOOGLE_APPLICATION_CREDENTIALS
(no CI, o workflow grava o secret nesse caminho antes de chamar este script) -
nunca fica hardcoded ou commitada.
"""
from __future__ import annotations

import io
import os
import sys
from pathlib import Path

import cv2
import numpy as np
import pymupdf
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload

sys.path.insert(0, str(Path(__file__).parent))
from omr.gabarito import extrair_respostas_corretas, obter_texto_documento  # noqa: E402
from omr.grade_detector import NUM_QUESTOES, ler_respostas  # noqa: E402
from omr.roster import buscar_por_nome, carregar_lista_chamada  # noqa: E402
from omr.sheets_writer import adicionar_linha, montar_linha  # noqa: E402

SCOPES = [
    "https://www.googleapis.com/auth/drive.readonly",
    "https://www.googleapis.com/auth/spreadsheets",
]

PASTA_ALUNOS_ID = "1nsLuzXqzTCvLiUOQZqL0gEBvPi3sIcwW"
SPREADSHEET_ID = "1obdaU2JMsOJBUhdO238mIGHnWk7umoLxFFatj8QWPOY"
GABARITO_DOC_ID = "1UfJLJusRVFMkzWmE3lCL9fZ-548LqmyzXhM4oUb2RWM"
LISTA_CHAMADA_CSV = Path(__file__).parent / "dados" / "lista_chamada.csv"
ARQUIVO_LISTA_CHAMADA = "Lista de Presença.pdf"
TURMA_PADRAO = "01SI-NOTA"
PROVA_TIPO_PADRAO = "Lógica Computacional"
DPI_RENDER = 400


def _credenciais(scopes: list[str]) -> service_account.Credentials:
    caminho = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
    if not caminho:
        raise SystemExit("Defina GOOGLE_APPLICATION_CREDENTIALS.")
    return service_account.Credentials.from_service_account_file(caminho, scopes=scopes)


def _listar_provas_pendentes(drive, ja_processados: set[str]) -> list[dict]:
    resp = drive.files().list(
        q=f"'{PASTA_ALUNOS_ID}' in parents and mimeType='application/pdf'",
        fields="files(id,name)",
    ).execute()
    pendentes = []
    for arquivo in resp.get("files", []):
        nome_arquivo = arquivo["name"]
        if nome_arquivo == ARQUIVO_LISTA_CHAMADA:
            continue
        nome_base = Path(nome_arquivo).stem
        if nome_base.strip().upper() in ja_processados:
            continue
        pendentes.append(arquivo)
    return pendentes


def _nomes_ja_na_planilha(spreadsheet_id: str, creds) -> set[str]:
    servico = build("sheets", "v4", credentials=creds)
    resultado = servico.spreadsheets().values().get(
        spreadsheetId=spreadsheet_id, range="B:B"
    ).execute()
    valores = resultado.get("values", [])[1:]  # pula cabecalho
    return {linha[0].strip().upper() for linha in valores if linha}


def _baixar_pdf(drive, file_id: str) -> bytes:
    request = drive.files().get_media(fileId=file_id)
    buf = io.BytesIO()
    downloader = MediaIoBaseDownload(buf, request)
    done = False
    while not done:
        _, done = downloader.next_chunk()
    return buf.getvalue()


def _renderizar_primeira_pagina(pdf_bytes: bytes) -> np.ndarray:
    doc = pymupdf.open(stream=pdf_bytes, filetype="pdf")
    pixmap = doc[0].get_pixmap(dpi=DPI_RENDER)
    imagem_png = pixmap.tobytes("png")
    array = np.frombuffer(imagem_png, dtype=np.uint8)
    return cv2.imdecode(array, cv2.IMREAD_COLOR)


def main() -> None:
    creds = _credenciais(SCOPES)
    drive = build("drive", "v3", credentials=creds)

    ja_processados = _nomes_ja_na_planilha(SPREADSHEET_ID, creds)
    pendentes = _listar_provas_pendentes(drive, ja_processados)

    if not pendentes:
        print("Nenhuma prova nova para corrigir.")
        return

    alunos = carregar_lista_chamada(LISTA_CHAMADA_CSV)
    gabarito_texto = obter_texto_documento(os.environ["GOOGLE_APPLICATION_CREDENTIALS"], GABARITO_DOC_ID)
    gabarito = extrair_respostas_corretas(gabarito_texto, NUM_QUESTOES)

    for arquivo in pendentes:
        nome_prova = Path(arquivo["name"]).stem
        print(f"\n=== Processando: {arquivo['name']} ===")

        aluno, score = buscar_por_nome(nome_prova, alunos)
        if aluno is None:
            print(f"  AVISO: nao encontrei '{nome_prova}' na lista de chamada (score {score:.2f}). Pulando.")
            continue

        pdf_bytes = _baixar_pdf(drive, arquivo["id"])
        imagem = _renderizar_primeira_pagina(pdf_bytes)

        try:
            resultados = ler_respostas(imagem)
        except ValueError as erro:
            print(f"  ERRO ao processar OMR: {erro}. Pulando.")
            continue

        respostas = [r.alternativa for r in resultados]
        ha_ambigua = any(r.ambigua for r in resultados)
        acertos = sum(1 for r, g in zip(respostas, gabarito) if r == g)
        nota_objetiva = round(acertos / NUM_QUESTOES * 10, 2)

        print(f"  Aluno: {aluno.nome} (RA {aluno.ra}, similaridade {score:.2f})")
        print(f"  Acertos: {acertos}/{NUM_QUESTOES}  Nota objetiva: {nota_objetiva}")
        if ha_ambigua:
            print("  ATENCAO: questao(oes) ambigua(s) - conferir manualmente.")

        linha = montar_linha(
            ra=aluno.ra,
            nome=aluno.nome,
            turma=TURMA_PADRAO,
            prova_tipo=PROVA_TIPO_PADRAO,
            respostas=respostas,
            acertos=acertos,
            nota_objetiva=nota_objetiva,
            observacoes="Ambigua(s) - conferir manualmente" if ha_ambigua else "",
        )
        adicionar_linha(SPREADSHEET_ID, linha)
        print("  Gravado na planilha.")


if __name__ == "__main__":
    main()
