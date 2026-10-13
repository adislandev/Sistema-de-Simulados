-- ============================================================
-- Nota N1 (atividades + prova presencial + extra + ponto do simulado)
--
-- Fonte de cada parte:
--   * atividades e extra manual: planilha do professor (abas "Atividades N1"
--     e "Nota N1"), importadas por omr-pilot/sincronizar_n1_supabase.py para
--     `notas_n1_atividades` - a planilha manda nesses dados.
--   * prova: `provas_presenciais_resultados` (objetiva + dissertativa so
--     quando confirmada pelo professor).
--   * ponto do simulado: media das 3 primeiras tentativas / 10, SO quando o
--     aluno tem as 3 tentativas finalizadas (regra do professor), ligado ao
--     RA por `alunos_ra`.
--
-- O aluno do simulado so tem nome/turma digitados (sem RA); `alunos_ra` guarda
-- a SUGESTAO de vinculo (feita por similaridade de nome) para o professor
-- confirmar. A N1 e calculada COM e SEM o simulado, para o professor
-- conseguir conferir caso um vinculo esteja errado.
--
-- Escrita: pipeline (service role) e RPCs de confirmacao abaixo. Nenhuma
-- policy de escrita para anon/authenticated.
-- ============================================================

create table notas_n1_atividades (
  id uuid primary key default gen_random_uuid(),
  ra text not null,
  nome text not null,
  turma text,
  prova_tipo text not null,                     -- mesmo valor de provas_presenciais_resultados.prova_tipo / disciplinas.nome
  status_plataforma text,                       -- Ativo / Inativo (plataforma)
  atividades jsonb not null default '[]',       -- [{nome, nota}] na ordem do CSV; nota null = sem nota
  atividades_soma numeric(5,2) not null default 0,
  extra_manual numeric(4,2),                    -- digitado pelo professor na planilha; null = sem extra
  importado_em timestamptz not null default now(),
  unique (ra, prova_tipo)
);

create index notas_n1_atividades_prova_idx on notas_n1_atividades (prova_tipo);

alter table notas_n1_atividades enable row level security;
create policy notas_n1_atividades_select_auth on notas_n1_atividades
  for select to authenticated using (true);

create table alunos_ra (
  aluno_id uuid primary key references alunos(id) on delete cascade,
  ra text,                                      -- RA vinculado (sugerido ou confirmado); null se ambiguo/sem correspondencia
  status text not null check (status in ('sugerido', 'ambiguo', 'sem_correspondencia', 'confirmado', 'rejeitado')),
  similaridade numeric(3,2),
  candidatos jsonb not null default '[]',       -- [{ra, nome, similaridade}] para o professor escolher
  atualizado_em timestamptz not null default now()
);

alter table alunos_ra enable row level security;
create policy alunos_ra_select_auth on alunos_ra
  for select to authenticated using (true);

-- Ponto do simulado por RA e disciplina. REGRA DO PROFESSOR: so existe ponto
-- quando o aluno tem as 3 primeiras tentativas finalizadas (e nao apagadas);
-- ponto = media das 3 / 10. Com 1 ou 2 tentativas fica NULL (a mesma regra do
-- painel em src/lib/professorApi.ts). NAO usa `vw_resultado_aluno_simulado.ponto_extra`,
-- que calcula a media com as tentativas que existirem.
-- Se o mesmo aluno digitou o nome de jeitos diferentes (varios registros em
-- `alunos` ligados ao mesmo RA), vale o maior ponto - as tentativas sao
-- contadas por registro, nao por pessoa.
create view vw_ponto_simulado_ra with (security_invoker = true) as
with tentativas_validas as (
  select
    t.aluno_id, t.simulado_id,
    count(*) as qtd,
    avg(t.nota) as media
  from tentativas t
  where t.numero_tentativa in (1, 2, 3)
    and t.status = 'finalizada'
    and t.apagado_em is null
    and t.nota is not null
  group by t.aluno_id, t.simulado_id
)
select
  ar.ra,
  d.nome as prova_tipo,
  max(case when tv.qtd = 3 then round(tv.media / 10, 2) end) as ponto_simulado,
  max(tv.qtd)::int as tentativas_validas,        -- 0 a 3 (so 3 gera ponto)
  count(*)::int as registros,
  case when bool_and(ar.status = 'confirmado') then 'confirmado' else 'sugerido' end as vinculo_status
from alunos_ra ar
join tentativas_validas tv on tv.aluno_id = ar.aluno_id
join simulados s on s.id = tv.simulado_id
join disciplinas d on d.id = s.disciplina_id
where ar.ra is not null and ar.status in ('sugerido', 'confirmado')
group by ar.ra, d.nome;

create view vw_nota_n1 with (security_invoker = true) as
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
  -- aluno inativo na plataforma e sem prova nao entra na lista
  where not (p.ra is null and coalesce(a.status_plataforma, '') ilike 'inativ%')
),
com_simulado as (
  select b.*, s.ponto_simulado, s.tentativas_validas, s.vinculo_status
  from base b
  left join vw_ponto_simulado_ra s
    on ltrim(s.ra, '0') = ltrim(b.ra, '0') and s.prova_tipo = b.prova_tipo
),
calculo as (
  select
    c.*,
    -- sem prova confirmada ou sem atividades importadas: fica em branco (nunca nota parcial)
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
       else 'OK' end as situacao
from calculo;

-- Confirmacao/rejeicao de vinculo pelo professor (unica escrita permitida ao
-- "authenticated" nessas tabelas).
create or replace function rpc_confirmar_vinculo_aluno_ra(p_aluno_id uuid, p_ra text)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if p_ra is null or btrim(p_ra) = '' then
    raise exception 'RA obrigatorio para confirmar o vinculo';
  end if;
  if not exists (select 1 from alunos where id = p_aluno_id) then
    raise exception 'Aluno nao encontrado: %', p_aluno_id;
  end if;
  insert into alunos_ra (aluno_id, ra, status, atualizado_em)
  values (p_aluno_id, btrim(p_ra), 'confirmado', now())
  on conflict (aluno_id) do update
    set ra = excluded.ra, status = 'confirmado', atualizado_em = now();
end;
$$;

create or replace function rpc_rejeitar_vinculo_aluno_ra(p_aluno_id uuid)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  insert into alunos_ra (aluno_id, ra, status, atualizado_em)
  values (p_aluno_id, null, 'rejeitado', now())
  on conflict (aluno_id) do update
    set ra = null, status = 'rejeitado', atualizado_em = now();
end;
$$;

revoke all on notas_n1_atividades, alunos_ra, vw_ponto_simulado_ra, vw_nota_n1 from anon, public;
grant select on notas_n1_atividades, alunos_ra, vw_ponto_simulado_ra, vw_nota_n1 to authenticated;

revoke execute on function rpc_confirmar_vinculo_aluno_ra(uuid, text), rpc_rejeitar_vinculo_aluno_ra(uuid) from public, anon;
grant execute on function rpc_confirmar_vinculo_aluno_ra(uuid, text), rpc_rejeitar_vinculo_aluno_ra(uuid) to authenticated;
