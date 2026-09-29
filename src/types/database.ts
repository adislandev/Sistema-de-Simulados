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
