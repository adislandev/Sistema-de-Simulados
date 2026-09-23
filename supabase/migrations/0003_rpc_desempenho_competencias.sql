-- Migration 0003: RPC de desempenho por competência para o aluno
--
-- Lacuna identificada na Fase 3 (tela de Resultado): o PRD exige mostrar
-- competências/habilidades no resultado do aluno, mas nenhuma função
-- liberada para "anon" devolvia isso (as views vw_desempenho_questao/
-- vw_resultado_aluno_simulado são só para "authenticated", painel do
-- professor). Esta RPC devolve o desempenho por competência de UMA
-- tentativa específica, seguindo o mesmo modelo das demais RPCs do
-- aluno: SECURITY DEFINER, search_path fixo, conhecer o tentativa_id é
-- o único requisito (mesmo modelo de "posse" já usado em
-- rpc_tentativas_aluno).

create or replace function rpc_desempenho_competencias_tentativa(p_tentativa_id uuid)
returns table (
  competencia_id uuid,
  competencia_nome text,
  total_questoes int,
  acertos int,
  erros int
)
language sql
security definer
set search_path = public, pg_temp
as $$
  select
    c.id as competencia_id,
    coalesce(c.nome, 'Sem competência') as competencia_nome,
    count(r.id)::int as total_questoes,
    count(r.id) filter (where r.correta)::int as acertos,
    count(r.id) filter (where not r.correta)::int as erros
  from respostas r
  join questoes q on q.id = r.questao_id
  left join competencias c on c.id = q.competencia_id
  where r.tentativa_id = p_tentativa_id
  group by c.id, c.nome
  order by competencia_nome;
$$;

grant execute on function rpc_desempenho_competencias_tentativa(uuid) to anon, authenticated;
