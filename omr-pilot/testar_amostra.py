"""Script de validacao da Fase 1 (piloto OMR) contra a amostra real do aluno Luccas Gabriel.

Uso:
    python testar_amostra.py
"""
import sys
from pathlib import Path

import cv2

sys.path.insert(0, str(Path(__file__).parent))
from omr.grade_detector import ler_respostas, localizar_bolhas  # noqa: E402

GABARITO = ["A", "B", "A", "B", "C", "C", "B", "A"]
CAMINHO_AMOSTRA = Path(__file__).parent / "samples" / "lucas_gabriel_pagina_1_hd.png"


def main() -> None:
    imagem = cv2.imread(str(CAMINHO_AMOSTRA))
    if imagem is None:
        raise SystemExit(f"Nao foi possivel abrir a imagem: {CAMINHO_AMOSTRA}")

    debug = imagem.copy()
    for coluna in localizar_bolhas(imagem):
        for bolha in coluna:
            cv2.circle(debug, (int(bolha.x), int(bolha.y)), int(bolha.raio), (0, 0, 255), 3)
    cv2.imwrite(str(Path(__file__).parent / "samples" / "_debug_bolhas.png"), debug)

    resultados = ler_respostas(imagem)

    acertos = 0
    print(f"{'Q':<3}{'Marcada':<10}{'Gabarito':<10}{'Status':<10}Preenchimentos (A-E)")
    for resultado, esperado in zip(resultados, GABARITO):
        status = "OK" if resultado.alternativa == esperado else "ERRO"
        if resultado.alternativa == esperado:
            acertos += 1
        preenchimentos_fmt = ", ".join(f"{v:.2f}" for v in resultado.preenchimentos)
        marcada = resultado.alternativa or ("AMBIGUA" if resultado.ambigua else "BRANCO")
        print(f"{resultado.numero:<3}{marcada:<10}{esperado:<10}{status:<10}[{preenchimentos_fmt}]")

    nota = round(acertos / len(GABARITO) * 10, 2)
    print(f"\nAcertos: {acertos}/{len(GABARITO)}  Nota objetiva: {nota}")
    print("Esperado (validacao manual): 7/8 acertos, erro na Q4 (marcou D em vez de B), nota 3.5*")
    print("* nota manual calculada sobre 10 questoes totais (8 objetivas); aqui a nota e apenas sobre as objetivas.")


if __name__ == "__main__":
    main()
