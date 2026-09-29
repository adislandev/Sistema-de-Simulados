"""Script de validacao da Fase 1 da ADI-70 (recorte das questoes dissertativas)
contra a amostra real do aluno Luccas Gabriel.

So faz o recorte de imagem (sem IA) - o objetivo e conferir visualmente se a
questao discursiva foi isolada corretamente antes de avancar pra Fase 2
(avaliacao via IA).

Uso:
    python testar_recorte_dissertativas.py
"""
import sys
from pathlib import Path

import cv2

sys.path.insert(0, str(Path(__file__).parent))
from omr.dissertativa_detector import localizar_blocos_dissertativas  # noqa: E402

CAMINHO_AMOSTRA = Path(__file__).parent / "samples" / "lucas_gabriel_pagina_1_hd.png"
SAIDA_DIR = Path(__file__).parent / "samples"


def main() -> None:
    imagem = cv2.imread(str(CAMINHO_AMOSTRA))
    if imagem is None:
        raise SystemExit(f"Nao foi possivel abrir a imagem: {CAMINHO_AMOSTRA}")

    blocos = localizar_blocos_dissertativas(imagem)

    if not blocos:
        print("Nenhuma questao dissertativa encontrada nesta pagina.")
        return

    print(f"{len(blocos)} questao(oes) dissertativa(s) encontrada(s):")
    for i, bloco in enumerate(blocos, start=1):
        altura, largura = bloco.imagem.shape[:2]
        print(f"  Bloco {i}: y=[{bloco.y0}:{bloco.y1}] x=[{bloco.x0}:{bloco.x1}] ({largura}x{altura}px)")
        destino = SAIDA_DIR / f"_debug_dissertativa_{i}.png"
        cv2.imwrite(str(destino), bloco.imagem)
        print(f"    Salvo em: {destino}")


if __name__ == "__main__":
    main()
