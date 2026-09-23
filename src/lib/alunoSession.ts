const CHAVE_ALUNO_ID = "simulados:aluno_id";
const CHAVE_ALUNO_NOME = "simulados:aluno_nome";

export interface AlunoSessao {
  id: string;
  nome: string;
}

export function salvarAlunoSessao(aluno: AlunoSessao): void {
  localStorage.setItem(CHAVE_ALUNO_ID, aluno.id);
  localStorage.setItem(CHAVE_ALUNO_NOME, aluno.nome);
}

export function obterAlunoSessao(): AlunoSessao | null {
  const id = localStorage.getItem(CHAVE_ALUNO_ID);
  const nome = localStorage.getItem(CHAVE_ALUNO_NOME);
  if (!id || !nome) return null;
  return { id, nome };
}

export function limparAlunoSessao(): void {
  localStorage.removeItem(CHAVE_ALUNO_ID);
  localStorage.removeItem(CHAVE_ALUNO_NOME);
}
