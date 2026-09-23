-- ============================================================
-- Lixeira de tentativas (painel do professor)
--
-- O professor não tem tela de criação de simulados (o conteúdo vem
-- do banco de questões versionado). O que ele precisa apagar são
-- tentativas de teste que ele mesmo gera ao navegar pelo fluxo do
-- aluno para validar o sistema. Isso é feito por soft-delete
-- (apagado_em) para permitir restaurar em caso de engano; só
-- "esvaziar lixeira" apaga em definitivo.
-- ============================================================

alter table tentativas add column apagado_em timestamptz;

-- As views de painel passam a ignorar tentativas/respostas apagadas.

create or replace view vw_resultado_aluno_simulado as
with tres_primeiras as (
  select t.aluno_id, t.simulado_id, t.numero_tentativa, t.nota
  from tentativas t
  where t.numero_tentativa in (1, 2, 3) and t.status = 'finalizada' and t.apagado_em is null
)
select
  a.id as aluno_id,
  a.nome,
  a.turma,
  s.id as simulado_id,
  s.titulo as simulado_titulo,
  d.id as disciplina_id,
  d.nome as disciplina_nome,
  max(case when tp.numero_tentativa = 1 then tp.nota end) as nota_tentativa_1,
  max(case when tp.numero_tentativa = 2 then tp.nota end) as nota_tentativa_2,
  max(case when tp.numero_tentativa = 3 then tp.nota end) as nota_tentativa_3,
  round(avg(tp.nota) filter (where tp.numero_tentativa in (1, 2, 3)), 2) as media_tres_primeiras,
  round((avg(tp.nota) filter (where tp.numero_tentativa in (1, 2, 3))) / 10, 2) as ponto_extra,
  max(t_ultima.finalizado_em) as ultima_tentativa_em
from alunos a
join tentativas t_ultima on t_ultima.aluno_id = a.id and t_ultima.apagado_em is null
join simulados s on s.id = t_ultima.simulado_id
join disciplinas d on d.id = s.disciplina_id
left join tres_primeiras tp
  on tp.aluno_id = a.id and tp.simulado_id = t_ultima.simulado_id
group by a.id, a.nome, a.turma, s.id, s.titulo, d.id, d.nome;

create or replace view vw_desempenho_questao as
select
  q.id as questao_id,
  q.codigo,
  q.disciplina_id,
  q.competencia_id,
  count(r.id) filter (where t.apagado_em is null) as total_respostas,
  count(r.id) filter (where t.apagado_em is null and r.correta) as total_acertos,
  count(r.id) filter (where t.apagado_em is null and not r.correta) as total_erros,
  round(
    (count(r.id) filter (where t.apagado_em is null and r.correta))::numeric
      / nullif(count(r.id) filter (where t.apagado_em is null), 0) * 100,
    1
  ) as percentual_acerto
from questoes q
left join respostas r on r.questao_id = q.id
left join tentativas t on t.id = r.tentativa_id
group by q.id, q.codigo, q.disciplina_id, q.competencia_id;

-- Lixeira: um grupo por aluno+simulado com tentativas apagadas.
create view vw_lixeira as
select
  a.id as aluno_id,
  a.nome,
  a.turma,
  s.id as simulado_id,
  s.titulo as simulado_titulo,
  d.id as disciplina_id,
  d.nome as disciplina_nome,
  count(t.id) as qtd_tentativas,
  max(t.apagado_em) as apagado_em
from tentativas t
join alunos a on a.id = t.aluno_id
join simulados s on s.id = t.simulado_id
join disciplinas d on d.id = s.disciplina_id
where t.apagado_em is not null
group by a.id, a.nome, a.turma, s.id, s.titulo, d.id, d.nome;

grant select on vw_lixeira to authenticated;

-- ============================================================
-- RPCs administrativas do professor (apagar / restaurar / esvaziar)
-- ============================================================

create or replace function rpc_professor_apagar_tentativas(p_aluno_id uuid, p_simulado_id uuid)
returns void
language sql
security definer
set search_path = public, pg_temp
as $$
  update tentativas
  set apagado_em = now()
  where aluno_id = p_aluno_id and simulado_id = p_simulado_id and apagado_em is null;
$$;

create or replace function rpc_professor_restaurar_tentativas(p_aluno_id uuid, p_simulado_id uuid)
returns void
language sql
security definer
set search_path = public, pg_temp
as $$
  update tentativas
  set apagado_em = null
  where aluno_id = p_aluno_id and simulado_id = p_simulado_id and apagado_em is not null;
$$;

create or replace function rpc_professor_esvaziar_lixeira()
returns void
language sql
security definer
set search_path = public, pg_temp
as $$
  delete from tentativas where apagado_em is not null;
$$;

-- Só o professor autenticado pode apagar/restaurar/esvaziar — nunca "anon".
grant execute on function
  rpc_professor_apagar_tentativas(uuid, uuid),
  rpc_professor_restaurar_tentativas(uuid, uuid),
  rpc_professor_esvaziar_lixeira()
to authenticated;

-- Views devem rodar com o privilégio de quem consulta (o professor
-- autenticado), não do dono da view — evita o lint "Security Definer View".
alter view vw_resultado_aluno_simulado set (security_invoker = true);
alter view vw_desempenho_questao set (security_invoker = true);
alter view vw_lixeira set (security_invoker = true);
