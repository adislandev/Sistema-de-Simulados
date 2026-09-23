import { supabase } from "./supabaseClient";
import type { DesempenhoQuestao } from "../types/database";

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
