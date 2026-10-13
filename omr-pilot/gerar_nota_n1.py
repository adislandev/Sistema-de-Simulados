"""Gera as abas "Atividades N1" e "Nota N1" na planilha de cada disciplina.

1. Atualiza a aba "Notas Finais" (nota da prova, vinda do Supabase).
2. Le o CSV "Grade de Notas" mais recente da pasta da disciplina no Drive
   (exportado da plataforma) e escreve a aba "Atividades N1". Sem CSV, a aba
   fica so com o cabecalho (disciplina "preparada").
3. Escreve a aba "Nota N1" com formulas: atividades + prova + extra manual,
   limitada a 10 (excedente em outra coluna). A coluna "Extra (manual)" e do
   professor e e preservada por RA a cada geracao.

A aba principal da planilha nao e tocada.

Uso:
    GOOGLE_APPLICATION_CREDENTIALS=<json> SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... \\
        python gerar_nota_n1.py [--disciplina=logica|ergonomia]
"""
from __future__ import annotations

import io
import os
import sys
from pathlib import Path

from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload

sys.path.insert(0, str(Path(__file__).parent))
from gerar_notas_finais import garantir_aba, gerar as gerar_notas_finais  # noqa: E402
from omr.atividades import Atividades, ler_grade  # noqa: E402
from omr.disciplinas import DISCIPLINAS, Disciplina  # noqa: E402
from omr.nota_n1 import (  # noqa: E402
    ABA_ATIVIDADES, ABA_NOTA_N1, CABECALHO_N1, formulas_linha, letra_coluna, linhas_nota_n1, tabela_atividades,
)
from omr.sincronizacao import normalizar_ra  # noqa: E402
from omr.supabase_writer import listar_resultados  # noqa: E402

SCOPES = [
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/drive.readonly",
]


def _csv_mais_recente(drive, disciplina: Disciplina) -> str | None:
    if not disciplina.pasta_atividades_id:
        return None
    resp = drive.files().list(
        q=f"'{disciplina.pasta_atividades_id}' in parents and trashed=false and name contains '{disciplina.prefixo_atividades}'",
        fields="files(id,name,modifiedTime)",
        orderBy="modifiedTime desc",
    ).execute()
    arquivos = [f for f in resp.get("files", []) if f["name"].lower().endswith(".csv")]
    if not arquivos:
        return None
    escolhido = arquivos[0]
    print(f"  CSV de atividades: {escolhido['name']} (modificado em {escolhido['modifiedTime']})")
    buf = io.BytesIO()
    downloader = MediaIoBaseDownload(buf, drive.files().get_media(fileId=escolhido["id"]))
    pronto = False
    while not pronto:
        _, pronto = downloader.next_chunk()
    return buf.getvalue().decode("utf-8-sig")


def _extras_existentes(valores, planilha_id: str) -> dict[str, object]:
    try:
        linhas = valores.get(
            spreadsheetId=planilha_id, range=f"'{ABA_NOTA_N1}'!A:F", valueRenderOption="UNFORMATTED_VALUE"
        ).execute().get("values", [])
    except Exception:  # aba ainda nao existe
        return {}
    extras: dict[str, object] = {}
    for linha in linhas[1:]:
        if len(linha) >= 6 and str(linha[0]).strip() and linha[5] not in ("", None):
            extras[normalizar_ra(linha[0])] = linha[5]
    return extras


def _limpar_e_garantir(servico, planilha_id: str, aba: str) -> None:
    garantir_aba(servico, planilha_id, aba)
    servico.spreadsheets().values().clear(spreadsheetId=planilha_id, range=f"'{aba}'!A:Z", body={}).execute()


def gerar(servico, drive, disciplina: Disciplina) -> None:
    pid = disciplina.planilha_id
    valores = servico.spreadsheets().values()

    gerar_notas_finais(servico, disciplina)

    texto = _csv_mais_recente(drive, disciplina)
    atividades = ler_grade(texto) if texto else None
    if atividades is None:
        print("  Nenhum CSV 'Grade de Notas' na pasta - aba 'Atividades N1' fica so com o cabecalho (disciplina preparada).")
    for aviso in (atividades.avisos if atividades else []):
        print(f"  AVISO: {aviso}")

    base = atividades or Atividades(nomes=[])
    tabela = tabela_atividades(base)
    col_soma = letra_coluna(3 + len(base.nomes))
    _limpar_e_garantir(servico, pid, ABA_ATIVIDADES)
    ultima_dado = letra_coluna(2 + len(base.nomes))
    n = len(tabela)
    corpo = [linha[:-1] for linha in tabela]  # sem a coluna de soma (formula)
    valores.update(
        spreadsheetId=pid, range=f"'{ABA_ATIVIDADES}'!A1:{ultima_dado}{n}",
        valueInputOption="RAW", body={"values": corpo},
    ).execute()
    if n > 1:
        valores.update(
            spreadsheetId=pid, range=f"'{ABA_ATIVIDADES}'!{col_soma}1:{col_soma}{n}",
            valueInputOption="USER_ENTERED", body={"values": [[tabela[0][-1]]] + [[l[-1]] for l in tabela[1:]]},
        ).execute()
    else:
        valores.update(
            spreadsheetId=pid, range=f"'{ABA_ATIVIDADES}'!{col_soma}1",
            valueInputOption="RAW", body={"values": [[tabela[0][-1]]]},
        ).execute()

    extras = _extras_existentes(valores, pid)
    linhas = linhas_nota_n1(listar_resultados(disciplina.prova_tipo), atividades, disciplina.turma, extras)
    _limpar_e_garantir(servico, pid, ABA_NOTA_N1)
    ultimo = len(linhas) + 1
    formulas = [formulas_linha(i, col_soma) for i in range(2, ultimo + 1)]
    ab = f"'{ABA_NOTA_N1}'"
    servico.spreadsheets().values().batchUpdate(spreadsheetId=pid, body={
        "valueInputOption": "RAW",
        "data": [
            {"range": f"{ab}!A1:J1", "values": [CABECALHO_N1]},
            {"range": f"{ab}!A2:C{ultimo}", "values": [l[:3] for l in linhas]},
            {"range": f"{ab}!F2:F{ultimo}", "values": [[l[3]] for l in linhas]},
        ],
    }).execute()
    if linhas:
        servico.spreadsheets().values().batchUpdate(spreadsheetId=pid, body={
            "valueInputOption": "USER_ENTERED",
            "data": [
                {"range": f"{ab}!D2:E{ultimo}", "values": [[f["D"], f["E"]] for f in formulas]},
                {"range": f"{ab}!G2:J{ultimo}", "values": [[f["G"], f["H"], f["I"], f["J"]] for f in formulas]},
            ],
        }).execute()
    print(f"  Aba '{ABA_NOTA_N1}': {len(linhas)} aluno(s); extras preservados: {len(extras)}.")


def main() -> None:
    chaves = [a.split("=", 1)[1] for a in sys.argv[1:] if a.startswith("--disciplina=")]
    alvo = [d for d in DISCIPLINAS if not chaves or d.chave in chaves]
    if not alvo:
        raise SystemExit(f"Disciplina desconhecida. Opcoes: {', '.join(d.chave for d in DISCIPLINAS)}")

    creds = service_account.Credentials.from_service_account_file(
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"], scopes=SCOPES
    )
    servico = build("sheets", "v4", credentials=creds)
    drive = build("drive", "v3", credentials=creds)

    falhas = []
    for d in alvo:
        print(f"\n##### {d.nome} - turma {d.turma} #####")
        try:
            gerar(servico, drive, d)
        except Exception as erro:
            print(f"ERRO: {type(erro).__name__}: {erro}")
            falhas.append(d.nome)
    if falhas:
        raise SystemExit(f"Falha em: {', '.join(falhas)}.")


if __name__ == "__main__":
    main()
