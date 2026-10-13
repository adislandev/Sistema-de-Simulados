import { supabase } from "./supabaseClient";
import type {
  CandidatoVinculo,
  DesempenhoQuestao,
  NotaN1,
  ProvaPresencialResultado,
  StatusVinculo,
  VinculoAluno,
} from "../types/database";

interface TentativaBruta {
  numero_tentativa: number;
  nota: number | null;
  tempo_segundos: number | null;
  status: "em_andamento" | "finalizada";
  finalizado_em: string | null;
  aluno: { id: string; nome: string; turma: string | null } | null;
  simulado: { id: string; titulo: string; disciplina: { id: string; nome: string } | null } | null;
}

export interface TentativaResumoPainel {
  numeroTentativa: number;
  nota: number | null;
  tempoSegundos: number | null;
}

export interface ResultadoAlunoSimuladoPainel {
  alunoId: string;
  alunoNome: string;
  alunoTurma: string | null;
  disciplinaId: string;
  disciplinaNome: string;
  simuladoId: string;
  simuladoTitulo: string;
  tentativas: TentativaResumoPainel[];
  media: number | null;
  pontoExtra: number | null;
  ultimaTentativaEm: string | null;
}

export async function listarResultadosTurma(): Promise<ResultadoAlunoSimuladoPainel[]> {
  const { data, error } = await supabase
    .from("tentativas")
    .select(
      `numero_tentativa, nota, tempo_segundos, status, finalizado_em,
       aluno:alunos(id, nome, turma),
       simulado:simulados(id, titulo, disciplina:disciplinas(id, nome))`,
    )
    .eq("status", "finalizada")
    .is("apagado_em", null)
    .order("finalizado_em", { ascending: true });

  if (error) throw error;

  const linhas = (data ?? []) as unknown as TentativaBruta[];
  const porAlunoSimulado = new Map<string, ResultadoAlunoSimuladoPainel>();

  for (const linha of linhas) {
    if (!linha.aluno || !linha.simulado || !linha.simulado.disciplina) continue;
    const chave = `${linha.aluno.id}:${linha.simulado.id}`;

    let grupo = porAlunoSimulado.get(chave);
    if (!grupo) {
      grupo = {
        alunoId: linha.aluno.id,
        alunoNome: linha.aluno.nome,
        alunoTurma: linha.aluno.turma,
        disciplinaId: linha.simulado.disciplina.id,
        disciplinaNome: linha.simulado.disciplina.nome,
        simuladoId: linha.simulado.id,
        simuladoTitulo: linha.simulado.titulo,
        tentativas: [],
        media: null,
        pontoExtra: null,
        ultimaTentativaEm: null,
      };
      porAlunoSimulado.set(chave, grupo);
    }

    grupo.tentativas.push({
      numeroTentativa: linha.numero_tentativa,
      nota: linha.nota,
      tempoSegundos: linha.tempo_segundos,
    });
    if (!grupo.ultimaTentativaEm || (linha.finalizado_em ?? "") > grupo.ultimaTentativaEm) {
      grupo.ultimaTentativaEm = linha.finalizado_em;
    }
  }

  for (const grupo of porAlunoSimulado.values()) {
    grupo.tentativas.sort((a, b) => a.numeroTentativa - b.numeroTentativa);
    const notasTresPrimeiras = [1, 2, 3]
      .map((n) => grupo.tentativas.find((t) => t.numeroTentativa === n)?.nota)
      .filter((n): n is number => n !== null && n !== undefined);
    if (notasTresPrimeiras.length === 3) {
      const media = notasTresPrimeiras.reduce((a, b) => a + b, 0) / 3;
      grupo.media = Math.round(media * 100) / 100;
      grupo.pontoExtra = Math.round((media / 10) * 100) / 100;
    }
  }

  return Array.from(porAlunoSimulado.values()).sort((a, b) => a.alunoNome.localeCompare(b.alunoNome));
}

export interface DesempenhoQuestaoPainel extends DesempenhoQuestao {
  disciplinaNome: string;
}

export async function listarDesempenhoQuestoes(): Promise<DesempenhoQuestaoPainel[]> {
  const [{ data: desempenho, error: eDesempenho }, { data: disciplinas, error: eDisciplinas }] = await Promise.all([
    supabase.from("vw_desempenho_questao").select("*"),
    supabase.from("disciplinas").select("id, nome"),
  ]);
  if (eDesempenho) throw eDesempenho;
  if (eDisciplinas) throw eDisciplinas;

  const nomePorDisciplina = new Map((disciplinas ?? []).map((d) => [d.id, d.nome]));

  return ((desempenho ?? []) as DesempenhoQuestao[])
    .map((linha) => ({
      ...linha,
      disciplinaNome: nomePorDisciplina.get(linha.disciplina_id) ?? "—",
    }))
    .sort((a, b) => (a.percentual_acerto ?? 0) - (b.percentual_acerto ?? 0));
}

export async function listarQuestoesPorSimulado(simuladoId: string): Promise<Set<string>> {
  const { data, error } = await supabase
    .from("simulado_questoes")
    .select("questao_id")
    .eq("simulado_id", simuladoId);
  if (error) throw error;
  return new Set((data ?? []).map((linha) => linha.questao_id as string));
}

export interface LixeiraItemPainel {
  alunoId: string;
  alunoNome: string;
  alunoTurma: string | null;
  disciplinaId: string;
  disciplinaNome: string;
  simuladoId: string;
  simuladoTitulo: string;
  qtdTentativas: number;
  apagadoEm: string;
}

interface LixeiraLinhaBruta {
  aluno_id: string;
  nome: string;
  turma: string | null;
  disciplina_id: string;
  disciplina_nome: string;
  simulado_id: string;
  simulado_titulo: string;
  qtd_tentativas: number;
  apagado_em: string;
}

export async function listarLixeira(): Promise<LixeiraItemPainel[]> {
  const { data, error } = await supabase.from("vw_lixeira").select("*");
  if (error) throw error;

  return ((data ?? []) as unknown as LixeiraLinhaBruta[])
    .map((linha) => ({
      alunoId: linha.aluno_id,
      alunoNome: linha.nome,
      alunoTurma: linha.turma,
      disciplinaId: linha.disciplina_id,
      disciplinaNome: linha.disciplina_nome,
      simuladoId: linha.simulado_id,
      simuladoTitulo: linha.simulado_titulo,
      qtdTentativas: linha.qtd_tentativas,
      apagadoEm: linha.apagado_em,
    }))
    .sort((a, b) => a.alunoNome.localeCompare(b.alunoNome));
}

export async function apagarResultadoAluno(alunoId: string, simuladoId: string): Promise<void> {
  const { error } = await supabase.rpc("rpc_professor_apagar_tentativas", {
    p_aluno_id: alunoId,
    p_simulado_id: simuladoId,
  });
  if (error) throw error;
}

export async function restaurarResultadoAluno(alunoId: string, simuladoId: string): Promise<void> {
  const { error } = await supabase.rpc("rpc_professor_restaurar_tentativas", {
    p_aluno_id: alunoId,
    p_simulado_id: simuladoId,
  });
  if (error) throw error;
}

export async function esvaziarLixeira(): Promise<void> {
  const { error } = await supabase.rpc("rpc_professor_esvaziar_lixeira");
  if (error) throw error;
}

export interface TentativaDetalhePainel {
  id: string;
  numeroTentativa: number;
  nota: number | null;
  acertos: number | null;
  erros: number | null;
  tempoSegundos: number | null;
  status: "em_andamento" | "finalizada";
  finalizadoEm: string | null;
}

export async function buscarTentativasDetalhe(alunoId: string, simuladoId: string): Promise<TentativaDetalhePainel[]> {
  const { data, error } = await supabase
    .from("tentativas")
    .select("id, numero_tentativa, nota, acertos, erros, tempo_segundos, status, finalizado_em")
    .eq("aluno_id", alunoId)
    .eq("simulado_id", simuladoId)
    .is("apagado_em", null)
    .order("numero_tentativa", { ascending: true });
  if (error) throw error;

  return (data ?? []).map((t) => ({
    id: t.id,
    numeroTentativa: t.numero_tentativa,
    nota: t.nota,
    acertos: t.acertos,
    erros: t.erros,
    tempoSegundos: t.tempo_segundos,
    status: t.status,
    finalizadoEm: t.finalizado_em,
  }));
}

export interface RespostaQuestaoPainel {
  questaoId: string;
  codigo: string;
  correta: boolean;
}

interface RespostaLinhaBruta {
  questao_id: string;
  correta: boolean;
  questoes: { codigo: string } | null;
}

export async function listarProvasPresenciais(): Promise<ProvaPresencialResultado[]> {
  const { data, error } = await supabase
    .from("provas_presenciais_resultados")
    .select("*")
    .order("nome", { ascending: true });
  if (error) throw error;
  return (data ?? []) as ProvaPresencialResultado[];
}

export async function confirmarNotaDissertativa(id: string, nota: number): Promise<void> {
  const { error } = await supabase.rpc("rpc_confirmar_nota_dissertativa", { p_id: id, p_nota: nota });
  if (error) throw error;
}

export async function dispararCorrecaoProvas(): Promise<void> {
  const { data, error } = await supabase.functions.invoke("disparar-correcao-provas", { method: "POST" });
  if (error) throw error;
  if (data?.error) throw new Error(data.error);
}

export async function buscarRespostasTentativa(tentativaId: string): Promise<RespostaQuestaoPainel[]> {
  const { data, error } = await supabase
    .from("respostas")
    .select("questao_id, correta, questoes(codigo)")
    .eq("tentativa_id", tentativaId);
  if (error) throw error;

  return ((data ?? []) as unknown as RespostaLinhaBruta[])
    .filter((linha) => linha.questoes)
    .map((linha) => ({ questaoId: linha.questao_id, codigo: linha.questoes!.codigo, correta: linha.correta }))
    .sort((a, b) => a.codigo.localeCompare(b.codigo));
}

const numeroOuNulo = (valor: unknown): number | null =>
  valor === null || valor === undefined ? null : Number(valor);

export async function listarNotasN1(): Promise<NotaN1[]> {
  const { data, error } = await supabase.from("vw_nota_n1").select("*").order("nome", { ascending: true });
  if (error) throw error;
  return (data ?? []).map((l) => ({
    ...l,
    atividades_soma: numeroOuNulo(l.atividades_soma),
    nota_objetiva: numeroOuNulo(l.nota_objetiva),
    nota_dissertativa: numeroOuNulo(l.nota_dissertativa),
    prova_final: numeroOuNulo(l.prova_final),
    extra_manual: numeroOuNulo(l.extra_manual),
    ponto_simulado: numeroOuNulo(l.ponto_simulado),
    tentativas_validas: numeroOuNulo(l.tentativas_validas),
    cadastros_simulado: numeroOuNulo(l.cadastros_simulado),
    total_bruto_sem_simulado: numeroOuNulo(l.total_bruto_sem_simulado),
    nota_n1_sem_simulado: numeroOuNulo(l.nota_n1_sem_simulado),
    excedente_sem_simulado: numeroOuNulo(l.excedente_sem_simulado),
    total_bruto_com_simulado: numeroOuNulo(l.total_bruto_com_simulado),
    nota_n1_com_simulado: numeroOuNulo(l.nota_n1_com_simulado),
    excedente_com_simulado: numeroOuNulo(l.excedente_com_simulado),
  })) as NotaN1[];
}

interface VinculoBruto {
  aluno_id: string;
  ra: string | null;
  status: StatusVinculo;
  similaridade: number | null;
  candidatos: CandidatoVinculo[] | null;
  aluno: { nome: string; turma: string | null } | null;
}

export async function listarVinculosAlunos(): Promise<VinculoAluno[]> {
  const { data, error } = await supabase
    .from("alunos_ra")
    .select("aluno_id, ra, status, similaridade, candidatos, aluno:alunos(nome, turma)");
  if (error) throw error;
  return ((data ?? []) as unknown as VinculoBruto[])
    .filter((l) => l.aluno)
    .map((l) => ({
      alunoId: l.aluno_id,
      alunoNome: l.aluno!.nome,
      alunoTurma: l.aluno!.turma,
      ra: l.ra,
      status: l.status,
      similaridade: numeroOuNulo(l.similaridade),
      candidatos: l.candidatos ?? [],
    }))
    .sort((a, b) => a.alunoNome.localeCompare(b.alunoNome));
}

export async function confirmarVinculoAluno(alunoId: string, ra: string): Promise<void> {
  const { error } = await supabase.rpc("rpc_confirmar_vinculo_aluno_ra", { p_aluno_id: alunoId, p_ra: ra });
  if (error) throw error;
}

export async function rejeitarVinculoAluno(alunoId: string): Promise<void> {
  const { error } = await supabase.rpc("rpc_rejeitar_vinculo_aluno_ra", { p_aluno_id: alunoId });
  if (error) throw error;
}

export async function dispararAtualizacaoN1(regerarPlanilha: boolean): Promise<void> {
  const { data, error } = await supabase.functions.invoke("disparar-atualizacao-n1", {
    method: "POST",
    body: { regerar_planilha: regerarPlanilha },
  });
  if (error) throw error;
  if (data?.error) throw new Error(data.error);
}

// Quando a base da N1 foi atualizada pela ultima vez (a importacao regrava importado_em
// de todas as linhas). A tela usa para saber quando a atualizacao disparada terminou.
export async function ultimaImportacaoN1(): Promise<string | null> {
  const { data, error } = await supabase
    .from("notas_n1_atividades")
    .select("importado_em")
    .order("importado_em", { ascending: false })
    .limit(1);
  if (error) throw error;
  return (data?.[0]?.importado_em as string | undefined) ?? null;
}
