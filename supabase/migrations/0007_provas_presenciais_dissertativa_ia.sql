-- ============================================================
-- Sugestao de nota das dissertativas via IA (ADI-70)
--
-- `nota_dissertativa` (ja existente, migration 0006) continua sendo a nota
-- DEFINITIVA, so preenchida quando o professor confirma/ajusta - nunca
-- escrita automaticamente pelo pipeline. Estas colunas novas guardam a
-- SUGESTAO da IA (transcricao + notas por criterio + justificativas) para
-- o professor revisar antes de confirmar.
-- ============================================================

alter table provas_presenciais_resultados
  add column nota_dissertativa_sugerida numeric(3,2), -- soma sugerida pela IA; nunca gravada como nota_dissertativa automaticamente
  add column dissertativas_ia jsonb,                   -- detalhe por questao: [{questao, transcricao, pendente_revisao_manual, criterios:[{nome,nota_maxima,nota_sugerida,justificativa}], observacao}]
  add column dissertativa_revisada_em timestamptz;      -- quando o professor confirmou/ajustou nota_dissertativa (null = ainda nao revisado)

comment on column provas_presenciais_resultados.nota_dissertativa_sugerida is
  'Soma das notas sugeridas pela IA (DeepSeek) para as questoes dissertativas. Sempre sugestao - nunca definitiva.';
comment on column provas_presenciais_resultados.dissertativas_ia is
  'Detalhe da avaliacao da IA por questao dissertativa (transcricao literal, criterios, justificativas). Ver omr-pilot/omr/dissertativa_ia.py.';
comment on column provas_presenciais_resultados.dissertativa_revisada_em is
  'Timestamp da confirmacao/ajuste do professor. nota_dissertativa so deve ser considerada definitiva quando este campo nao e null.';
