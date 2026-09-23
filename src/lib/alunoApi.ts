import { supabase } from "./supabaseClient";
import type {
  AlunoCandidato,
  DesempenhoCompetenciaTentativa,
  Disciplina,
  FinalizarTentativaResultado,
  IniciarTentativaResultado,
  QuestaoSimuladoRow,
  Simulado,
  TentativaResumo,
} from "../types/database";

export async function buscarAlunosPorNome(nome: string): Promise<AlunoCandidato[]> {
  const { data, error } = await supabase.rpc("rpc_aluno_buscar", { p_nome: nome });
  if (error) throw error;
  return data ?? [];
}

export async function criarAluno(nome: string, turma?: string): Promise<string> {
  const { data, error } = await supabase.rpc("rpc_aluno_criar", {
    p_nome: nome,
    p_turma: turma ?? null,
  });
  if (error) throw error;
  return data as string;
}

export async function tocarAluno(alunoId: string): Promise<void> {
  const { error } = await supabase.rpc("rpc_aluno_tocar", { p_aluno_id: alunoId });
  if (error) throw error;
}

export interface SimuladoComDisciplina extends Simulado {
  disciplina: Pick<Disciplina, "id" | "nome" | "slug">;
}

export async function listarSimuladosAtivos(): Promise<SimuladoComDisciplina[]> {
  const { data, error } = await supabase
    .from("simulados")
    .select("id, disciplina_id, titulo, qtd_questoes, ativo, disciplina:disciplinas(id, nome, slug)")
    .eq("ativo", true);
  if (error) throw error;
  return (data ?? []) as unknown as SimuladoComDisciplina[];
}

export async function buscarSimulado(simuladoId: string): Promise<SimuladoComDisciplina> {
  const { data, error } = await supabase
    .from("simulados")
    .select("id, disciplina_id, titulo, qtd_questoes, ativo, disciplina:disciplinas(id, nome, slug)")
    .eq("id", simuladoId)
    .single();
  if (error) throw error;
  return data as unknown as SimuladoComDisciplina;
}

export async function buscarQuestoesSimulado(simuladoId: string): Promise<QuestaoSimuladoRow[]> {
  const { data, error } = await supabase.rpc("rpc_questoes_simulado", { p_simulado_id: simuladoId });
  if (error) throw error;
  return data ?? [];
}

export async function iniciarTentativa(
  alunoId: string,
  simuladoId: string,
): Promise<IniciarTentativaResultado> {
  const { data, error } = await supabase.rpc("rpc_iniciar_tentativa", {
    p_aluno_id: alunoId,
    p_simulado_id: simuladoId,
  });
  if (error) throw error;
  return (data as IniciarTentativaResultado[])[0];
}

export async function responderQuestao(params: {
  tentativaId: string;
  questaoId: string;
  alternativaId: string;
  ordemApresentacao: number;
  tempoRespostaSegundos?: number;
}): Promise<void> {
  const { error } = await supabase.rpc("rpc_responder_questao", {
    p_tentativa_id: params.tentativaId,
    p_questao_id: params.questaoId,
    p_alternativa_id: params.alternativaId,
    p_ordem_apresentacao: params.ordemApresentacao,
    p_tempo_resposta_segundos: params.tempoRespostaSegundos ?? null,
  });
  if (error) throw error;
}

export async function finalizarTentativa(
  tentativaId: string,
  tempoSegundos: number,
): Promise<FinalizarTentativaResultado> {
  const { data, error } = await supabase.rpc("rpc_finalizar_tentativa", {
    p_tentativa_id: tentativaId,
    p_tempo_segundos: tempoSegundos,
  });
  if (error) throw error;
  return (data as FinalizarTentativaResultado[])[0];
}

export async function buscarDesempenhoCompetencias(
  tentativaId: string,
): Promise<DesempenhoCompetenciaTentativa[]> {
  const { data, error } = await supabase.rpc("rpc_desempenho_competencias_tentativa", {
    p_tentativa_id: tentativaId,
  });
  if (error) throw error;
  return data ?? [];
}

export async function buscarTentativasAluno(
  alunoId: string,
  simuladoId: string,
): Promise<TentativaResumo[]> {
  const { data, error } = await supabase.rpc("rpc_tentativas_aluno", {
    p_aluno_id: alunoId,
    p_simulado_id: simuladoId,
  });
  if (error) throw error;
  return data ?? [];
}
