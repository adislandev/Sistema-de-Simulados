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
        python backfill_dissertativas.py [--disciplina=logica|ergonomia] <RA1> <RA2> ...

Sem --disciplina, usa Logica Computacional.
"""
from __future__ import annotations

import sys
from pathlib import Path

from googleapiclient.discovery import build

sys.path.insert(0, str(Path(__file__).parent))
from omr.roster import buscar_por_nome  # noqa: E402
from processar_pasta import (  # noqa: E402
    SCOPES,
    _baixar_pdf,
    _carregar_alunos,
    _credenciais,
    _listar_provas,
    _renderizar_paginas,
    avaliar_e_gravar_dissertativas,
)
from omr.disciplinas import DISCIPLINAS  # noqa: E402


def main() -> None:
    args = sys.argv[1:]
    chave = "logica"
    for a in list(args):
        if a.startswith("--disciplina="):
            chave = a.split("=", 1)[1]
            args.remove(a)
    disciplina = next((d for d in DISCIPLINAS if d.chave == chave), None)
    if disciplina is None:
        raise SystemExit(f"Disciplina desconhecida: {chave}. Opcoes: {', '.join(d.chave for d in DISCIPLINAS)}")
    ras_alvo = set(args)
    if not ras_alvo:
        raise SystemExit("Informe pelo menos um RA: python backfill_dissertativas.py <RA1> <RA2> ...")

    creds = _credenciais(SCOPES)
    drive = build("drive", "v3", credentials=creds)
    alunos = _carregar_alunos(drive, disciplina)
    provas = _listar_provas(drive, disciplina)

    for arquivo in provas:
        nome_prova = Path(arquivo["name"]).stem
        aluno, score = buscar_por_nome(nome_prova, alunos)
        if aluno is None or aluno.ra not in ras_alvo:
            continue

        print(f"\n=== {aluno.nome} (RA {aluno.ra}) ===")
        pdf_bytes = _baixar_pdf(drive, arquivo["id"])
        paginas = _renderizar_paginas(pdf_bytes)

        avaliar_e_gravar_dissertativas(paginas, aluno.ra, disciplina)
        ras_alvo.discard(aluno.ra)

    if ras_alvo:
        print(f"\nAVISO: nao encontrei PDF na pasta do Drive para os RAs: {', '.join(sorted(ras_alvo))}")


if __name__ == "__main__":
    main()
