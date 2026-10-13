-- ============================================================
-- Ponto do simulado: soma as tentativas de TODOS os cadastros do mesmo RA
--
-- O aluno do simulado digita o nome, e as vezes acaba com mais de um registro
-- em `alunos` (turma digitada diferente, erro de digitacao). Decisao do
-- professor: juntar as tentativas de todos os cadastros vinculados ao mesmo RA
-- e valer as 3 PRIMEIRAS (por data de finalizacao), por disciplina.
--
-- Continua valendo a regra: so ha ponto com 3 tentativas validas
-- (finalizada, nao apagada, com nota); ponto = media das 3 / 10. Dentro de cada
-- cadastro, so contam as tentativas 1 a 3 (as demais sao treino extra).
-- ============================================================

create or replace view vw_ponto_simulado_ra with (security_invoker = true) as
with validas as (
  select
    ar.ra,
    ar.aluno_id,
    ar.status as vinculo,
    s.disciplina_id,
    t.nota,
    row_number() over (
      partition by ltrim(ar.ra, '0'), s.disciplina_id
      order by t.finalizado_em, t.numero_tentativa, t.id
    ) as ordem
  from alunos_ra ar
  join tentativas t on t.aluno_id = ar.aluno_id
  join simulados s on s.id = t.simulado_id
  where ar.ra is not null
    and ar.status in ('sugerido', 'confirmado')
    and t.numero_tentativa in (1, 2, 3)
    and t.status = 'finalizada'
    and t.apagado_em is null
    and t.nota is not null
),
primeiras as (
  select * from validas where ordem <= 3
)
select
  min(p.ra) as ra,
  d.nome as prova_tipo,
  case when count(*) = 3 then round(avg(p.nota) / 10, 2) end as ponto_simulado,
  count(*)::int as tentativas_validas,                         -- 0 a 3 (so 3 gera ponto)
  count(distinct p.aluno_id)::int as registros,                -- cadastros cujas tentativas entraram na conta
  case when bool_and(p.vinculo = 'confirmado') then 'confirmado' else 'sugerido' end as vinculo_status
from primeiras p
join disciplinas d on d.id = p.disciplina_id
group by ltrim(p.ra, '0'), d.nome;

-- expoe quantos cadastros entraram na conta (para a tela explicar a soma)
create or replace view vw_nota_n1 with (security_invoker = true) as
with prova as (
  select
    ra, nome, turma, prova_tipo, nota_objetiva, nota_dissertativa,
    (nota_dissertativa is not null and dissertativa_revisada_em is not null) as dissertativa_confirmada,
    case when nota_dissertativa is not null and dissertativa_revisada_em is not null
         then coalesce(nota_objetiva, 0) + nota_dissertativa end as prova_final
  from provas_presenciais_resultados
),
base as (
  select
    coalesce(p.ra, a.ra) as ra,
    coalesce(p.nome, a.nome) as nome,
    coalesce(p.turma, a.turma) as turma,
    coalesce(p.prova_tipo, a.prova_tipo) as prova_tipo,
    a.status_plataforma, a.atividades, a.atividades_soma, a.extra_manual,
    p.nota_objetiva, p.nota_dissertativa, p.prova_final, p.dissertativa_confirmada
  from prova p
  full outer join notas_n1_atividades a
    on ltrim(a.ra, '0') = ltrim(p.ra, '0') and a.prova_tipo = p.prova_tipo
  where not (p.ra is null and coalesce(a.status_plataforma, '') ilike 'inativ%')
),
com_simulado as (
  select b.*, s.ponto_simulado, s.tentativas_validas, s.vinculo_status, s.registros as cadastros_simulado
  from base b
  left join vw_ponto_simulado_ra s
    on ltrim(s.ra, '0') = ltrim(b.ra, '0') and s.prova_tipo = b.prova_tipo
),
calculo as (
  select
    c.*,
    case when c.prova_final is null or c.atividades_soma is null then null
         else round(c.atividades_soma + c.prova_final + coalesce(c.extra_manual, 0), 2) end as total_bruto_sem_simulado
  from com_simulado c
)
select
  ra, nome, turma, prova_tipo, status_plataforma,
  coalesce(atividades, '[]'::jsonb) as atividades,
  atividades_soma, nota_objetiva, nota_dissertativa, prova_final, dissertativa_confirmada,
  extra_manual, ponto_simulado, tentativas_validas, vinculo_status,
  total_bruto_sem_simulado,
  case when total_bruto_sem_simulado is null then null else least(10, total_bruto_sem_simulado) end as nota_n1_sem_simulado,
  case when total_bruto_sem_simulado is null then null else greatest(0, round(total_bruto_sem_simulado - 10, 2)) end as excedente_sem_simulado,
  case when total_bruto_sem_simulado is null then null
       else round(total_bruto_sem_simulado + coalesce(ponto_simulado, 0), 2) end as total_bruto_com_simulado,
  case when total_bruto_sem_simulado is null then null
       else least(10, round(total_bruto_sem_simulado + coalesce(ponto_simulado, 0), 2)) end as nota_n1_com_simulado,
  case when total_bruto_sem_simulado is null then null
       else greatest(0, round(total_bruto_sem_simulado + coalesce(ponto_simulado, 0) - 10, 2)) end as excedente_com_simulado,
  case when prova_final is null then 'Sem prova'
       when atividades_soma is null then 'Sem atividades'
       else 'OK' end as situacao,
  cadastros_simulado
from calculo;
