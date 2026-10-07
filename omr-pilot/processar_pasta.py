"""Fase 3: verificacao periodica da pasta do Drive com as provas digitalizadas.

Corrige cada disciplina/turma configurada em omr/disciplinas.py (pasta do
Drive, planilha, gabarito, lista de chamada e rubrica proprios). Para cada
PDF de prova ainda nao corrigido (nome do aluno ainda nao presente
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
import tempfile
from pathlib import Path

import cv2
import numpy as np
import pymupdf
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload

sys.path.insert(0, str(Path(__file__).parent))
from omr.avaliacao import calcular_nota_objetiva  # noqa: E402
from omr.disciplinas import DISCIPLINAS, LOGICA, Disciplina  # noqa: E402
from omr.dissertativa_ia import carregar_rubrica  # noqa: E402
from omr.dissertativa_pipeline import avaliar_dissertativas_da_prova  # noqa: E402
from omr.gabarito import extrair_respostas_corretas, obter_texto_documento  # noqa: E402
from omr.grade_detector import NUM_QUESTOES, ler_respostas  # noqa: E402
from omr.roster import buscar_por_nome, carregar_lista_chamada  # noqa: E402
from omr.sheets_writer import adicionar_linha, montar_linha  # noqa: E402
from omr.supabase_writer import gravar_resultado, gravar_sugestao_dissertativa, ras_sem_sugestao  # noqa: E402

SCOPES = [
    "https://www.googleapis.com/auth/drive.readonly",
    "https://www.googleapis.com/auth/spreadsheets",
]

DPI_RENDER = 400


def _credenciais(scopes: list[str]) -> service_account.Credentials:
    caminho = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
    if not caminho:
        raise SystemExit("Defina GOOGLE_APPLICATION_CREDENTIALS.")
    return service_account.Credentials.from_service_account_file(caminho, scopes=scopes)


def _listar_provas(drive, disciplina: Disciplina) -> list[dict]:
    resp = drive.files().list(
        q=f"'{disciplina.pasta_alunos_id}' in parents and mimeType='application/pdf'",
        fields="files(id,name)",
    ).execute()
    return [a for a in resp.get("files", []) if a["name"] not in disciplina.arquivos_ignorados]


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


def _carregar_alunos(drive, disciplina: Disciplina):
    if disciplina.lista_chamada_drive_id:
        conteudo = _baixar_pdf(drive, disciplina.lista_chamada_drive_id)
        with tempfile.NamedTemporaryFile(suffix=".csv", delete=False) as arq:
            arq.write(conteudo)
            caminho = arq.name
        try:
            return carregar_lista_chamada(caminho)
        finally:
            os.unlink(caminho)
    return carregar_lista_chamada(disciplina.lista_chamada_csv)


def _renderizar_paginas(pdf_bytes: bytes) -> list[np.ndarray]:
    doc = pymupdf.open(stream=pdf_bytes, filetype="pdf")
    paginas = []
    for pagina in doc:
        pixmap = pagina.get_pixmap(dpi=DPI_RENDER)
        imagem_png = pixmap.tobytes("png")
        array = np.frombuffer(imagem_png, dtype=np.uint8)
        paginas.append(cv2.imdecode(array, cv2.IMREAD_COLOR))
    return paginas


def avaliar_e_gravar_dissertativas(paginas: list[np.ndarray], ra: str, disciplina: Disciplina = LOGICA) -> bool:
    """Avalia as dissertativas via IA e grava a sugestao no Supabase. Nunca
    levanta excecao (a nota objetiva ja foi gravada); retorna se deu certo."""
    if not os.environ.get("DEEPSEEK_API_KEY"):
        print("  DEEPSEEK_API_KEY nao definida - pulando sugestao de IA para as dissertativas.")
        return False
    try:
        nota_sugerida, dissertativas_ia = avaliar_dissertativas_da_prova(
            paginas,
            rubrica_texto=carregar_rubrica(disciplina.rubrica),
            disciplina=disciplina.nome,
        )
        print(f"  Dissertativas detectadas: {len(dissertativas_ia)} (paginas: {len(paginas)})")
        for d in dissertativas_ia:
            print(f"    Q{d['questao']}: pendente={d.get('pendente_revisao_manual')} nota={d.get('nota_sugerida_total')} obs={d.get('observacao')!r}")
        gravar_sugestao_dissertativa(
            ra=ra,
            prova_tipo=disciplina.prova_tipo,
            nota_sugerida_total=nota_sugerida,
            dissertativas_ia=dissertativas_ia,
        )
        print(f"  Sugestao de IA para as dissertativas gravada (nota sugerida: {nota_sugerida}).")
        return True
    except Exception as erro:  # nao interrompe o pipeline - a nota objetiva ja foi gravada
        print(f"  AVISO: falha ao avaliar/gravar sugestao das dissertativas: {erro}")
        return False


def processar_disciplina(creds, drive, disciplina: Disciplina) -> None:
    ja_processados = _nomes_ja_na_planilha(disciplina.planilha_id, creds)
    provas = _listar_provas(drive, disciplina)

    if not provas:
        print("Nenhuma prova encontrada na pasta.")
        return

    alunos = _carregar_alunos(drive, disciplina)
    gabarito_texto = obter_texto_documento(os.environ["GOOGLE_APPLICATION_CREDENTIALS"], disciplina.gabarito_doc_id)
    gabarito = extrair_respostas_corretas(gabarito_texto, NUM_QUESTOES)

    try:
        pendentes_sugestao = ras_sem_sugestao(disciplina.prova_tipo)
    except Exception as erro:
        print(f"AVISO: nao consegui consultar RAs sem sugestao das dissertativas: {erro}")
        pendentes_sugestao = set()
    sem_sugestao_falhou: list[str] = []

    houve_pendente = False
    for arquivo in provas:
        nome_prova = Path(arquivo["name"]).stem
        print(f"\n=== {arquivo['name']} ===")

        aluno, score = buscar_por_nome(nome_prova, alunos)
        if aluno is None:
            print(f"  AVISO: nao encontrei '{nome_prova}' na lista de chamada (score {score:.2f}). Pulando.")
            continue

        if aluno.nome.strip().upper() in ja_processados:
            if aluno.ra in pendentes_sugestao:
                print(f"  Ja corrigida (RA {aluno.ra}), mas sem sugestao das dissertativas - tentando de novo so essa etapa.")
                paginas = _renderizar_paginas(_baixar_pdf(drive, arquivo["id"]))
                if not avaliar_e_gravar_dissertativas(paginas, aluno.ra, disciplina):
                    sem_sugestao_falhou.append(aluno.ra)
            else:
                print(f"  Ja corrigida (RA {aluno.ra}, {aluno.nome}). Pulando.")
            continue

        houve_pendente = True
        pdf_bytes = _baixar_pdf(drive, arquivo["id"])
        paginas = _renderizar_paginas(pdf_bytes)
        imagem = paginas[0]

        try:
            resultados = ler_respostas(imagem)
        except Exception as erro:  # uma prova problematica nao pode derrubar as demais
            print(f"  ERRO ao processar OMR: {type(erro).__name__}: {erro}. Pulando.")
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
            turma=disciplina.turma,
            prova_tipo=disciplina.prova_tipo,
            respostas=respostas,
            acertos=acertos,
            nota_objetiva=nota_objetiva,
            observacoes="Ambigua(s) - conferir manualmente" if ha_ambigua else "",
        )
        adicionar_linha(disciplina.planilha_id, linha)
        print("  Gravado na planilha.")

        try:
            gravar_resultado(
                ra=aluno.ra,
                nome=aluno.nome,
                turma=disciplina.turma,
                prova_tipo=disciplina.prova_tipo,
                respostas=respostas,
                acertos=acertos,
                nota_objetiva=nota_objetiva,
                observacoes="Ambigua(s) - conferir manualmente" if ha_ambigua else "",
            )
            print("  Gravado no Supabase (painel do professor).")
        except Exception as erro:  # nao interrompe o pipeline se o Supabase falhar - a planilha ja foi gravada
            print(f"  AVISO: falha ao gravar no Supabase: {erro} - pulando dissertativas (a linha nao existe no painel).")
            sem_sugestao_falhou.append(aluno.ra)
            continue

        if not avaliar_e_gravar_dissertativas(paginas, aluno.ra, disciplina):
            sem_sugestao_falhou.append(aluno.ra)

    if not houve_pendente:
        print("\nNenhuma prova nova para corrigir (todas ja estavam na planilha).")
    if sem_sugestao_falhou:
        print(f"\nAVISO: {len(sem_sugestao_falhou)} aluno(s) ainda sem sugestao das dissertativas (RAs: {', '.join(sem_sugestao_falhou)}). Clique em Corrigir provas de novo para tentar outra vez.")



def main() -> None:
    creds = _credenciais(SCOPES)
    drive = build("drive", "v3", credentials=creds)

    falhas: list[str] = []
    for disciplina in DISCIPLINAS:
        print(f"\n##### {disciplina.nome} - turma {disciplina.turma} #####")
        try:
            processar_disciplina(creds, drive, disciplina)
        except Exception as erro:  # uma disciplina com problema (ex.: pasta nao compartilhada) nao derruba as demais
            print(f"ERRO ao processar {disciplina.nome}: {type(erro).__name__}: {erro}")
            falhas.append(disciplina.nome)

    if falhas:
        raise SystemExit(f"Falha em: {', '.join(falhas)}.")


if __name__ == "__main__":
    main()
