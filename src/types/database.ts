export type TipoQuestao = "IDENTICA_PROVA" | "ADAPTADA_PROVA" | "NOVA_MESMO_CONTEUDO";

export type StatusTentativa = "em_andamento" | "finalizada";

export interface Disciplina {
  id: string;
  nome: string;
  slug: string;
}

export interface Simulado {
  id: string;
  disciplina_id: string;
  titulo: string;
  qtd_questoes: number;
  ativo: boolean;
}

export interface AlunoCandidato {
  id: string;
  nome: string;
  turma: string | null;
}

export interface QuestaoSimuladoRow {
  questao_id: string;
  codigo: string;
  enunciado: string;
  alternativa_id: string;
  alternativa_texto: string;
  alternativa_ordem: number;
}

export interface QuestaoMontada {
  questao_id: string;
  codigo: string;
  enunciado: string;
  alternativas: { id: string; texto: string }[];
}

export interface IniciarTentativaResultado {
  tentativa_id: string;
  numero_tentativa: number;
  retomada: boolean;
}

export interface FinalizarTentativaResultado {
  nota: number;
  acertos: number;
  erros: number;
}

export interface TentativaResumo {
  numero_tentativa: number;
  nota: number | null;
  acertos: number | null;
  erros: number | null;
  tempo_segundos: number | null;
  status: StatusTentativa;
  finalizado_em: string | null;
}

export interface ResultadoAlunoSimulado {
  aluno_id: string;
  nome: string;
  turma: string | null;
  simulado_id: string;
  simulado_titulo: string;
  disciplina_id: string;
  disciplina_nome: string;
  nota_tentativa_1: number | null;
  nota_tentativa_2: number | null;
  nota_tentativa_3: number | null;
  media_tres_primeiras: number | null;
  ponto_extra: number | null;
  ultima_tentativa_em: string;
}

export interface DesempenhoCompetenciaTentativa {
  competencia_id: string | null;
  competencia_nome: string;
  total_questoes: number;
  acertos: number;
  erros: number;
}

export interface DesempenhoQuestao {
  questao_id: string;
  codigo: string;
  disciplina_id: string;
  competencia_id: string | null;
  total_respostas: number;
  total_acertos: number;
  total_erros: number;
  percentual_acerto: number | null;
}

export interface CriterioDissertativaIA {
  nome: string;
  nota_maxima: number;
  nota_sugerida: number;
  justificativa: string;
}

export interface DissertativaIA {
  questao: number;
  transcricao: string;
  pendente_revisao_manual: boolean;
  criterios: CriterioDissertativaIA[];
  nota_sugerida_total: number | null;
  observacao: string;
}

export interface ProvaPresencialResultado {
  id: string;
  ra: string;
  nome: string;
  turma: string | null;
  prova_tipo: string;
  respostas_objetivas: (string | null)[];
  acertos: number | null;
  nota_objetiva: number | null;
  nota_dissertativa: number | null;
  nota_total: number | null;
  data_correcao: string;
  observacoes: string;
  nota_dissertativa_sugerida: number | null;
  dissertativas_ia: DissertativaIA[] | null;
  dissertativa_revisada_em: string | null;
}

export interface AtividadeN1 {
  nome: string;
  nota: number | null;
}

export type SituacaoN1 = "OK" | "Sem prova" | "Sem atividades";

// Linha da view vw_nota_n1 (ver supabase/migrations/0009_nota_n1.sql)
export interface NotaN1 {
  ra: string;
  nome: string;
  turma: string | null;
  prova_tipo: string;
  status_plataforma: string | null;
  atividades: AtividadeN1[];
  atividades_soma: number | null;
  nota_objetiva: number | null;
  nota_dissertativa: number | null;
  prova_final: number | null;
  dissertativa_confirmada: boolean | null;
  extra_manual: number | null;
  ponto_simulado: number | null;
  tentativas_validas: number | null;
  vinculo_status: "confirmado" | "sugerido" | null;
  total_bruto_sem_simulado: number | null;
  nota_n1_sem_simulado: number | null;
  excedente_sem_simulado: number | null;
  total_bruto_com_simulado: number | null;
  nota_n1_com_simulado: number | null;
  excedente_com_simulado: number | null;
  situacao: SituacaoN1;
  cadastros_simulado: number | null; // quantos cadastros do simulado tiveram tentativas somadas
}

export type StatusVinculo = "sugerido" | "ambiguo" | "sem_correspondencia" | "confirmado" | "rejeitado";

export interface CandidatoVinculo {
  ra: string;
  nome: string;
  similaridade: number;
}

// Vinculo do aluno do simulado (so nome/turma digitados) com o RA (tabela alunos_ra)
export interface VinculoAluno {
  alunoId: string;
  alunoNome: string;
  alunoTurma: string | null;
  ra: string | null;
  status: StatusVinculo;
  similaridade: number | null;
  candidatos: CandidatoVinculo[];
}
