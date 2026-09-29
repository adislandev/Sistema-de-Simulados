"""Reprocessamento pontual: roda a avaliacao das dissertativas via IA para
provas que ja foram corrigidas (objetivas) ANTES dessa funcionalidade
existir (ADI-70), e que por isso nunca tiveram a sugestao da IA gravada.

O pipeline automatico (`processar_pasta.py`) pula qualquer PDF cujo aluno ja
esteja na planilha - entao esses casos nunca seriam reprocessados sozinhos.
Este script busca o PDF original desses alunos na mesma pasta do Drive,
roda só a avaliação das dissertativas e grava a sugestão - nunca mexe na
nota objetiva já gravada.

Uso:
    GOOGLE_APPLICATION_CREDENTIALS=<caminho> DEEPSEEK_API_KEY=<chave> \
        python backfill_dissertativas.py <RA1> <RA2> ...
"""
from __future__ import annotations

import sys
from pathlib import Path

from googleapiclient.discovery import build

sys.path.insert(0, str(Path(__file__).parent))
from omr.dissertativa_pipeline import avaliar_dissertativas_da_prova  # noqa: E402
from omr.roster import buscar_por_nome, carregar_lista_chamada  # noqa: E402
from omr.supabase_writer import gravar_sugestao_dissertativa  # noqa: E402
from processar_pasta import (  # noqa: E402
    ARQUIVO_LISTA_CHAMADA,
    LISTA_CHAMADA_CSV,
    PASTA_ALUNOS_ID,
    PROVA_TIPO_PADRAO,
    SCOPES,
    _baixar_pdf,
    _credenciais,
    _renderizar_paginas,
)


def main() -> None:
    ras_alvo = set(sys.argv[1:])
    if not ras_alvo:
        raise SystemExit("Informe pelo menos um RA: python backfill_dissertativas.py <RA1> <RA2> ...")

    creds = _credenciais(SCOPES)
    drive = build("drive", "v3", credentials=creds)
    alunos = carregar_lista_chamada(LISTA_CHAMADA_CSV)

    resp = drive.files().list(
        q=f"'{PASTA_ALUNOS_ID}' in parents and mimeType='application/pdf'",
        fields="files(id,name)",
    ).execute()
    provas = [a for a in resp.get("files", []) if a["name"] != ARQUIVO_LISTA_CHAMADA]

    for arquivo in provas:
        nome_prova = Path(arquivo["name"]).stem
        aluno, score = buscar_por_nome(nome_prova, alunos)
        if aluno is None or aluno.ra not in ras_alvo:
            continue

        print(f"\n=== {aluno.nome} (RA {aluno.ra}) ===")
        pdf_bytes = _baixar_pdf(drive, arquivo["id"])
        paginas = _renderizar_paginas(pdf_bytes)

        nota_sugerida, dissertativas_ia = avaliar_dissertativas_da_prova(paginas)
        gravar_sugestao_dissertativa(
            ra=aluno.ra,
            prova_tipo=PROVA_TIPO_PADRAO,
            nota_sugerida_total=nota_sugerida,
            dissertativas_ia=dissertativas_ia,
        )
        print(f"  Paginas renderizadas: {len(paginas)}  Dissertativas detectadas: {len(dissertativas_ia)}")
        for d in dissertativas_ia:
            print(
                f"    Q{d['questao']}: pendente={d.get('pendente_revisao_manual')} "
                f"nota={d.get('nota_sugerida_total')} obs={d.get('observacao')!r} "
                f"transcricao={str(d.get('transcricao', ''))[:80]!r}"
            )
        print(f"  Sugestao gravada (nota sugerida: {nota_sugerida}).")
        ras_alvo.discard(aluno.ra)

    if ras_alvo:
        print(f"\nAVISO: nao encontrei PDF na pasta do Drive para os RAs: {', '.join(sorted(ras_alvo))}")


if __name__ == "__main__":
    main()
