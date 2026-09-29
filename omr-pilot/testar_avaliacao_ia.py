"""Script de validacao da Fase 2 da ADI-70 (avaliacao via IA) contra a
amostra real do aluno Luccas Gabriel.

Usa o recorte da Fase 1 (dissertativa_detector) + envia pro DeepSeek com as
regras anti-alucinacao definidas com o professor. NUNCA grava nada - so
imprime o resultado para conferencia manual antes de integrar ao pipeline.

Uso:
    DEEPSEEK_API_KEY=<sua_chave> python testar_avaliacao_ia.py

A chave nunca deve ser commitada nem colada em nenhum arquivo do repositorio -
so como variavel de ambiente na sua maquina (ou GitHub Secret, quando formos
integrar ao pipeline agendado).
"""
import sys
from pathlib import Path

import cv2

sys.path.insert(0, str(Path(__file__).parent))
from omr.dissertativa_detector import localizar_blocos_dissertativas  # noqa: E402
from omr.dissertativa_ia import avaliar_dissertativa  # noqa: E402

CAMINHO_AMOSTRA = Path(__file__).parent / "samples" / "lucas_gabriel_pagina_1_hd.png"
VALOR_QUESTAO = 1.5


def main() -> None:
    imagem = cv2.imread(str(CAMINHO_AMOSTRA))
    if imagem is None:
        raise SystemExit(
            f"Nao foi possivel abrir a imagem: {CAMINHO_AMOSTRA}\n"
            "Copie a amostra (samples/, fora do controle de versao) antes de rodar."
        )

    blocos = localizar_blocos_dissertativas(imagem)
    if not blocos:
        raise SystemExit("Nenhuma questao dissertativa encontrada na imagem.")

    for numero, bloco in enumerate(blocos, start=9):  # Q9 e a primeira dissertativa da prova
        print(f"\n=== Questao {numero} ===")
        resultado = avaliar_dissertativa(bloco.imagem, numero_questao=numero, valor_questao=VALOR_QUESTAO)

        print(f"Transcricao:\n{resultado.transcricao}\n")
        print(f"Pendente de revisao manual: {resultado.pendente_revisao_manual}")
        for criterio in resultado.criterios:
            print(
                f"  - {criterio.nome}: {criterio.nota_sugerida}/{criterio.nota_maxima} "
                f"-- {criterio.justificativa}"
            )
        print(f"Nota sugerida total: {resultado.nota_sugerida_total}")
        if resultado.observacao:
            print(f"Observacao: {resultado.observacao}")


if __name__ == "__main__":
    main()
