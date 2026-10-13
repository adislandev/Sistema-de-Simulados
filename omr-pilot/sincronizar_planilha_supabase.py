"""Sincroniza as OBJETIVAS da planilha para o Supabase (planilha vence).

Para cada disciplina (omr/disciplinas.py): le a planilha de resultados, cruza
com `provas_presenciais_resultados` por RA e mostra o que difere. Por padrao
SO SIMULA (nao grava nada). Com --gravar, atualiza apenas respostas_objetivas,
acertos e nota_objetiva - nunca as dissertativas (nota_dissertativa,
dissertativa_revisada_em, sugestoes da IA), que sao do sistema.

Uso:
    GOOGLE_APPLICATION_CREDENTIALS=<json> SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... \\
        python sincronizar_planilha_supabase.py [--gravar] [--disciplina=logica|ergonomia]
"""
from __future__ import annotations

import os
import sys
from pathlib import Path

from google.oauth2 import service_account
from googleapiclient.discovery import build

sys.path.insert(0, str(Path(__file__).parent))
from omr.disciplinas import DISCIPLINAS, Disciplina  # noqa: E402
from omr.gabarito import extrair_respostas_corretas, obter_texto_documento  # noqa: E402
from omr.grade_detector import NUM_QUESTOES  # noqa: E402
from omr.sincronizacao import Relatorio, comparar, interpretar_linhas  # noqa: E402
from omr.supabase_writer import atualizar_objetivas, listar_resultados  # noqa: E402

SCOPES = ["https://www.googleapis.com/auth/spreadsheets.readonly"]


def _ler_planilha(planilha_id: str) -> list[list]:
    creds = service_account.Credentials.from_service_account_file(
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"], scopes=SCOPES
    )
    servico = build("sheets", "v4", credentials=creds)
    resposta = servico.spreadsheets().values().get(
        spreadsheetId=planilha_id, range="A:P", valueRenderOption="UNFORMATTED_VALUE"
    ).execute()
    return resposta.get("values", [])


def _imprimir(relatorio: Relatorio) -> None:
    print(f"  Iguais nas objetivas: {relatorio.iguais}")
    for p in relatorio.problemas_planilha:
        print(f"  PROBLEMA na planilha: {p}")
    for d in relatorio.divergencias:
        print(f"  DIVERGE: {d.ra_supabase} {d.nome}")
        for campo, (sb, pl) in d.campos.items():
            print(f"      {campo}: supabase={sb} -> planilha={pl}")
        for aviso in d.avisos:
            print(f"      AVISO: {aviso}")
    for s in relatorio.so_planilha:
        print(f"  So na planilha (nao existe no Supabase, nao sera criado): {s}")
    for s in relatorio.so_supabase:
        print(f"  So no Supabase (nao esta na planilha, nao sera alterado): {s}")


def sincronizar(disciplina: Disciplina, gravar: bool) -> int:
    """Retorna quantas linhas foram (ou seriam) atualizadas."""
    texto = obter_texto_documento(os.environ["GOOGLE_APPLICATION_CREDENTIALS"], disciplina.gabarito_doc_id)
    gabarito = extrair_respostas_corretas(texto, NUM_QUESTOES)
    linhas_planilha, problemas = interpretar_linhas(_ler_planilha(disciplina.planilha_id))
    relatorio = comparar(linhas_planilha, listar_resultados(disciplina.prova_tipo), gabarito)
    relatorio.problemas_planilha = problemas + relatorio.problemas_planilha
    _imprimir(relatorio)

    a_gravar = [d for d in relatorio.divergencias if d.novo is not None]
    print(f"  Linhas a atualizar: {len(a_gravar)}")
    if not gravar:
        print("  (simulacao - nada foi gravado; use --gravar para aplicar)")
        return len(a_gravar)
    for d in a_gravar:
        respostas, acertos, nota = d.novo
        atualizar_objetivas(d.ra_supabase, disciplina.prova_tipo, respostas, acertos, nota)
        print(f"  Atualizado: {d.ra_supabase} {d.nome} -> {acertos} acertos, nota {nota}")
    return len(a_gravar)


def main() -> None:
    args = sys.argv[1:]
    gravar = "--gravar" in args
    chaves = [a.split("=", 1)[1] for a in args if a.startswith("--disciplina=")]
    alvo = [d for d in DISCIPLINAS if not chaves or d.chave in chaves]
    if not alvo:
        raise SystemExit(f"Disciplina desconhecida. Opcoes: {', '.join(d.chave for d in DISCIPLINAS)}")

    print("MODO: " + ("GRAVAR" if gravar else "SIMULACAO"))
    falhas = []
    for d in alvo:
        print(f"\n##### {d.nome} - turma {d.turma} #####")
        try:
            sincronizar(d, gravar)
        except Exception as erro:
            print(f"ERRO: {type(erro).__name__}: {erro}")
            falhas.append(d.nome)
    if falhas:
        raise SystemExit(f"Falha em: {', '.join(falhas)}.")


if __name__ == "__main__":
    main()
