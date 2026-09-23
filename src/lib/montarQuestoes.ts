import type { QuestaoMontada, QuestaoSimuladoRow } from "../types/database";
import { embaralhar } from "./shuffle";

export function montarQuestoes(linhas: QuestaoSimuladoRow[]): QuestaoMontada[] {
  const porQuestao = new Map<string, QuestaoMontada>();

  for (const linha of linhas) {
    let questao = porQuestao.get(linha.questao_id);
    if (!questao) {
      questao = {
        questao_id: linha.questao_id,
        codigo: linha.codigo,
        enunciado: linha.enunciado,
        alternativas: [],
      };
      porQuestao.set(linha.questao_id, questao);
    }
    questao.alternativas.push({ id: linha.alternativa_id, texto: linha.alternativa_texto });
  }

  const questoes = Array.from(porQuestao.values()).map((questao) => ({
    ...questao,
    alternativas: embaralhar(questao.alternativas),
  }));

  return embaralhar(questoes);
}
