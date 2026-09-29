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
from omr.avaliacao import calcular_nota_objetiva  # noqa: E402
from omr.dissertativa_pipeline import avaliar_dissertativas_da_prova  # noqa: E402
from omr.gabarito import extrair_respostas_corretas, obter_texto_documento  # noqa: E402
from omr.grade_detector import NUM_QUESTOES, ler_respostas  # noqa: E402
from omr.roster import buscar_por_nome, carregar_lista_chamada  # noqa: E402
from omr.sheets_writer import adicionar_linha, montar_linha  # noqa: E402
from omr.supabase_writer import gravar_resultado, gravar_sugestao_dissertativa  # noqa: E402

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


def _listar_provas(drive) -> list[dict]:
    resp = drive.files().list(
        q=f"'{PASTA_ALUNOS_ID}' in parents and mimeType='application/pdf'",
        fields="files(id,name)",
    ).execute()
    return [a for a in resp.get("files", []) if a["name"] != ARQUIVO_LISTA_CHAMADA]


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


def _renderizar_paginas(pdf_bytes: bytes) -> list[np.ndarray]:
    doc = pymupdf.open(stream=pdf_bytes, filetype="pdf")
    paginas = []
    for pagina in doc:
        pixmap = pagina.get_pixmap(dpi=DPI_RENDER)
        imagem_png = pixmap.tobytes("png")
        array = np.frombuffer(imagem_png, dtype=np.uint8)
        paginas.append(cv2.imdecode(array, cv2.IMREAD_COLOR))
    return paginas


def main() -> None:
    creds = _credenciais(SCOPES)
    drive = build("drive", "v3", credentials=creds)

    ja_processados = _nomes_ja_na_planilha(SPREADSHEET_ID, creds)
    provas = _listar_provas(drive)

    if not provas:
        print("Nenhuma prova encontrada na pasta.")
        return

    alunos = carregar_lista_chamada(LISTA_CHAMADA_CSV)
    gabarito_texto = obter_texto_documento(os.environ["GOOGLE_APPLICATION_CREDENTIALS"], GABARITO_DOC_ID)
    gabarito = extrair_respostas_corretas(gabarito_texto, NUM_QUESTOES)

    houve_pendente = False
    for arquivo in provas:
        nome_prova = Path(arquivo["name"]).stem
        print(f"\n=== {arquivo['name']} ===")

        aluno, score = buscar_por_nome(nome_prova, alunos)
        if aluno is None:
            print(f"  AVISO: nao encontrei '{nome_prova}' na lista de chamada (score {score:.2f}). Pulando.")
            continue

        if aluno.nome.strip().upper() in ja_processados:
            print(f"  Ja corrigida (RA {aluno.ra}, {aluno.nome}). Pulando.")
            continue

        houve_pendente = True
        pdf_bytes = _baixar_pdf(drive, arquivo["id"])
        paginas = _renderizar_paginas(pdf_bytes)
        imagem = paginas[0]

        try:
            resultados = ler_respostas(imagem)
        except ValueError as erro:
            print(f"  ERRO ao processar OMR: {erro}. Pulando.")
            continue

        respostas = [r.alternativa for r in resultados]
        ha_ambigua = any(r.ambigua for r in resultados)
        acertos = sum(1 for r, g in zip(respostas, gabarito) if r == g)
        nota_objetiva = calcular_nota_objetiva(acertos)

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

        try:
            gravar_resultado(
                ra=aluno.ra,
                nome=aluno.nome,
                turma=TURMA_PADRAO,
                prova_tipo=PROVA_TIPO_PADRAO,
                respostas=respostas,
                acertos=acertos,
                nota_objetiva=nota_objetiva,
                observacoes="Ambigua(s) - conferir manualmente" if ha_ambigua else "",
            )
            print("  Gravado no Supabase (painel do professor).")
        except Exception as erro:  # nao interrompe o pipeline se o Supabase falhar - a planilha ja foi gravada
            print(f"  AVISO: falha ao gravar no Supabase: {erro}")

        if not os.environ.get("DEEPSEEK_API_KEY"):
            print("  DEEPSEEK_API_KEY nao definida - pulando sugestao de IA para as dissertativas.")
        else:
            try:
                nota_sugerida, dissertativas_ia = avaliar_dissertativas_da_prova(paginas)
                gravar_sugestao_dissertativa(
                    ra=aluno.ra,
                    prova_tipo=PROVA_TIPO_PADRAO,
                    nota_sugerida_total=nota_sugerida,
                    dissertativas_ia=dissertativas_ia,
                )
                print(f"  Sugestao de IA para as dissertativas gravada (nota sugerida: {nota_sugerida}).")
            except Exception as erro:  # nao interrompe o pipeline - a nota objetiva ja foi gravada
                print(f"  AVISO: falha ao avaliar/gravar sugestao das dissertativas: {erro}")

    if not houve_pendente:
        print("\nNenhuma prova nova para corrigir (todas ja estavam na planilha).")


if __name__ == "__main__":
    main()
