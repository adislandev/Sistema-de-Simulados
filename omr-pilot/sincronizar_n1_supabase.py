"""Importa para o Supabase as atividades e o extra manual da planilha (abas
"Atividades N1" e "Nota N1"), para a tabela `notas_n1_atividades`. A planilha
manda nesses dados; esta etapa so os copia para o sistema.

Uso:
    GOOGLE_APPLICATION_CREDENTIALS=<json> SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... \\
        python sincronizar_n1_supabase.py [--disciplina=logica|ergonomia]
"""
from __future__ import annotations

import os
import sys
from datetime import datetime, timezone
from pathlib import Path

from google.oauth2 import service_account
from googleapiclient.discovery import build

sys.path.insert(0, str(Path(__file__).parent))
from omr.disciplinas import DISCIPLINAS, Disciplina  # noqa: E402
from omr.n1_planilha import linhas_atividades  # noqa: E402
from omr.nota_n1 import ABA_ATIVIDADES, ABA_NOTA_N1  # noqa: E402
from omr.supabase_writer import upsert_linhas  # noqa: E402

SCOPES = ["https://www.googleapis.com/auth/spreadsheets.readonly"]


def _ler_aba(valores, planilha_id: str, aba: str, intervalo: str) -> list[list]:
    try:
        return valores.get(
            spreadsheetId=planilha_id, range=f"'{aba}'!{intervalo}", valueRenderOption="UNFORMATTED_VALUE"
        ).execute().get("values", [])
    except Exception as erro:  # aba ausente (ainda nao gerada)
        print(f"  AVISO: nao consegui ler a aba '{aba}': {erro}")
        return []


def sincronizar(servico, disciplina: Disciplina) -> None:
    valores = servico.spreadsheets().values()
    atividades = _ler_aba(valores, disciplina.planilha_id, ABA_ATIVIDADES, "A:Z")
    nota_n1 = _ler_aba(valores, disciplina.planilha_id, ABA_NOTA_N1, "A:F")
    linhas = linhas_atividades(atividades, nota_n1, disciplina.turma, disciplina.prova_tipo)
    agora = datetime.now(timezone.utc).isoformat()
    for linha in linhas:
        linha["importado_em"] = agora  # a tela usa isso para saber quando a base foi atualizada
    upsert_linhas("notas_n1_atividades", linhas, on_conflict="ra,prova_tipo")
    com_extra = sum(1 for l in linhas if l["extra_manual"] is not None)
    print(f"  {len(linhas)} aluno(s) com atividades importados ({com_extra} com extra manual).")


def main() -> None:
    chaves = [a.split("=", 1)[1] for a in sys.argv[1:] if a.startswith("--disciplina=")]
    alvo = [d for d in DISCIPLINAS if not chaves or d.chave in chaves]
    creds = service_account.Credentials.from_service_account_file(
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"], scopes=SCOPES
    )
    servico = build("sheets", "v4", credentials=creds)

    falhas = []
    for d in alvo:
        print(f"\n##### {d.nome} - turma {d.turma} #####")
        try:
            sincronizar(servico, d)
        except Exception as erro:
            print(f"ERRO: {type(erro).__name__}: {erro}")
            falhas.append(d.nome)
    if falhas:
        raise SystemExit(f"Falha em: {', '.join(falhas)}.")


if __name__ == "__main__":
    main()
