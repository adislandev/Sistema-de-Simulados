"""Fase 2: corrige uma prova (imagem/PDF ja renderizado), identifica o aluno
pelo RA (cruzando o nome do arquivo com a lista de chamada) e grava o
resultado na planilha real do Google Sheets.

Uso:
    python corrigir_prova.py <imagem_da_prova> <nome_do_aluno> [--turma T] [--gravar]

Sem --gravar, so mostra o resultado (dry-run). Com --gravar, escreve de fato
uma linha na planilha (exige GOOGLE_APPLICATION_CREDENTIALS configurada).
"""
from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

import cv2

sys.path.insert(0, str(Path(__file__).parent))
from omr.avaliacao import calcular_nota_objetiva  # noqa: E402
from omr.gabarito import extrair_respostas_corretas, obter_texto_documento  # noqa: E402
from omr.grade_detector import NUM_QUESTOES, ler_respostas  # noqa: E402
from omr.roster import buscar_por_nome, carregar_lista_chamada  # noqa: E402
from omr.sheets_writer import adicionar_linha, montar_linha  # noqa: E402

SPREADSHEET_ID = "1obdaU2JMsOJBUhdO238mIGHnWk7umoLxFFatj8QWPOY"
GABARITO_DOC_ID = "1UfJLJusRVFMkzWmE3lCL9fZ-548LqmyzXhM4oUb2RWM"
LISTA_CHAMADA_CSV = Path(__file__).parent / "dados" / "lista_chamada.csv"
TURMA_PADRAO = "01SI-NOTA"
PROVA_TIPO_PADRAO = "Lógica Computacional"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("imagem", help="Caminho da imagem da prova (PNG/JPG)")
    parser.add_argument("nome_aluno", help="Nome do aluno (ex.: extraido do arquivo do Drive)")
    parser.add_argument("--turma", default=TURMA_PADRAO)
    parser.add_argument("--gravar", action="store_true", help="Grava de fato na planilha")
    args = parser.parse_args()

    imagem = cv2.imread(args.imagem)
    if imagem is None:
        raise SystemExit(f"Nao foi possivel abrir a imagem: {args.imagem}")

    alunos = carregar_lista_chamada(LISTA_CHAMADA_CSV)
    aluno, score = buscar_por_nome(args.nome_aluno, alunos)
    if aluno is None:
        raise SystemExit(
            f"Nao encontrei '{args.nome_aluno}' na lista de chamada "
            f"(melhor similaridade: {score:.2f}). Verifique o nome/arquivo."
        )

    resultados = ler_respostas(imagem)
    respostas = [r.alternativa for r in resultados]
    ha_ambigua = any(r.ambigua for r in resultados)

    credenciais = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
    if not credenciais:
        raise SystemExit(
            "Defina GOOGLE_APPLICATION_CREDENTIALS apontando para o JSON da conta de servico."
        )
    gabarito_texto = obter_texto_documento(credenciais, GABARITO_DOC_ID)
    gabarito = extrair_respostas_corretas(gabarito_texto, NUM_QUESTOES)

    acertos = sum(1 for r, g in zip(respostas, gabarito) if r == g)
    nota_objetiva = calcular_nota_objetiva(acertos)

    print(f"Aluno identificado: {aluno.nome} (RA {aluno.ra}, similaridade {score:.2f})")
    print(f"{'Q':<3}{'Marcada':<10}{'Gabarito':<10}Preenchimentos (A-E)")
    for r, g in zip(resultados, gabarito):
        marcada = r.alternativa or ("AMBIGUA" if r.ambigua else "BRANCO")
        preench_fmt = ", ".join(f"{v:.2f}" for v in r.preenchimentos)
        print(f"{r.numero:<3}{marcada:<10}{g:<10}[{preench_fmt}]")

    print(f"\nAcertos: {acertos}/{NUM_QUESTOES}  Nota objetiva: {nota_objetiva}")
    if ha_ambigua:
        print("ATENCAO: ha questao(oes) ambigua(s) - confira manualmente antes de gravar.")

    if args.gravar:
        observacoes = "Ambigua(s) - conferir manualmente" if ha_ambigua else ""
        linha = montar_linha(
            ra=aluno.ra,
            nome=aluno.nome,
            turma=args.turma,
            prova_tipo=PROVA_TIPO_PADRAO,
            respostas=respostas,
            acertos=acertos,
            nota_objetiva=nota_objetiva,
            observacoes=observacoes,
        )
        resultado = adicionar_linha(SPREADSHEET_ID, linha)
        intervalo = resultado.get("updates", {}).get("updatedRange", "?")
        print(f"\nGravado na planilha em: {intervalo}")
    else:
        print("\n(dry-run: nada foi gravado na planilha; use --gravar para escrever de fato)")


if __name__ == "__main__":
    main()
