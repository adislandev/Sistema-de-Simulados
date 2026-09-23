-- Sistema de Simulados Acadêmicos
-- Migration 0001: schema inicial
--
-- MODELO DE SEGURANÇA (importante):
--   O aluno não se autentica (sem Supabase Auth), então a chave "anon" do
--   Supabase é pública e embutida no bundle do frontend. Qualquer pessoa
--   pode chamar a API REST diretamente, fora da aplicação. Por isso:
--
--   * A role "anon" NÃO recebe nenhuma policy de acesso direto às tabelas
--     de alunos/tentativas/respostas, e NÃO recebe select em `alternativas`
--     (que contém o gabarito). RLS habilitada + nenhuma policy = acesso
--     zero por padrão.
--   * Todo o fluxo do aluno acontece via funções RPC (SECURITY DEFINER),
--     que validam a operação e calculam a correção da resposta no
--     servidor — o cliente nunca informa se acertou, apenas qual
--     alternativa escolheu.
--   * A role "authenticated" (conta única do professor, via Supabase Auth)
--     tem leitura ampla para o painel administrativo.

create extension if not exists pgcrypto;
create extension if not exists unaccent;
create extension if not exists "uuid-ossp"; -- usada pelo seed (supabase/seed) para gerar ids determinísticos

-- ============================================================
-- ENUMS
-- ============================================================

create type tipo_questao as enum (
  'IDENTICA_PROVA',
  'ADAPTADA_PROVA',
  'NOVA_MESMO_CONTEUDO'
);

create type status_questao as enum ('ativa', 'inativa');

create type status_tentativa as enum ('em_andamento', 'finalizada');

-- ============================================================
-- TABELAS DE DOMÍNIO (catálogo — leitura pública, escrita só professor)
-- ============================================================

create table disciplinas (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  slug text not null unique,
  criado_em timestamptz not null default now()
);

create table competencias (
  id uuid primary key default gen_random_uuid(),
  disciplina_id uuid not null references disciplinas(id) on delete cascade,
  nome text not null,
  criado_em timestamptz not null default now(),
  unique (disciplina_id, nome)
);

create table simulados (
  id uuid primary key default gen_random_uuid(),
  disciplina_id uuid not null references disciplinas(id) on delete cascade,
  titulo text not null,
  qtd_questoes int not null default 20,
  ativo boolean not null default true,
  criado_em timestamptz not null default now()
);

create table questoes (
  id uuid primary key default gen_random_uuid(),
  disciplina_id uuid not null references disciplinas(id) on delete cascade,
  competencia_id uuid references competencias(id) on delete set null,
  codigo text not null unique, -- ex.: LC-001, ERG-014 (rastreabilidade com o banco original)
  enunciado text not null,
  tipo tipo_questao not null,
  dificuldade text not null,
  origem text not null,
  status status_questao not null default 'ativa',
  criado_em timestamptz not null default now()
);

create table alternativas (
  id uuid primary key default gen_random_uuid(),
  questao_id uuid not null references questoes(id) on delete cascade,
  texto text not null,
  correta boolean not null default false, -- GABARITO: nunca exposto a "anon"
  ordem int not null,
  unique (questao_id, ordem)
);

-- garante exatamente uma alternativa correta por questão
create unique index alternativas_uma_correta_por_questao
  on alternativas (questao_id)
  where correta;

create table simulado_questoes (
  id uuid primary key default gen_random_uuid(),
  simulado_id uuid not null references simulados(id) on delete cascade,
  questao_id uuid not null references questoes(id) on delete cascade,
  unique (simulado_id, questao_id)
);

-- ============================================================
-- ALUNOS E TENTATIVAS (dados de aluno — acesso direto só "authenticated";
-- aluno usa exclusivamente as funções RPC declaradas mais abaixo)
-- ============================================================

create table alunos (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  nome_normalizado text not null,
  turma text,
  criado_em timestamptz not null default now(),
  ultimo_acesso timestamptz not null default now()
);

create index alunos_nome_normalizado_idx on alunos (nome_normalizado);

create or replace function normalizar_nome(p_nome text)
returns text
language sql
immutable
as $$
  select lower(unaccent(trim(regexp_replace(p_nome, '\s+', ' ', 'g'))));
$$;

create or replace function trg_alunos_normalizar_nome()
returns trigger
language plpgsql
as $$
begin
  new.nome_normalizado := normalizar_nome(new.nome);
  return new;
end;
$$;

create trigger alunos_normalizar_nome
  before insert or update of nome on alunos
  for each row execute function trg_alunos_normalizar_nome();

create table tentativas (
  id uuid primary key default gen_random_uuid(),
  aluno_id uuid not null references alunos(id) on delete cascade,
  simulado_id uuid not null references simulados(id) on delete cascade,
  numero_tentativa int not null check (numero_tentativa >= 1),
  iniciado_em timestamptz not null default now(),
  finalizado_em timestamptz,
  tempo_segundos int,
  nota numeric(4,2),
  acertos int,
  erros int,
  status status_tentativa not null default 'em_andamento',
  unique (aluno_id, simulado_id, numero_tentativa)
);

create index tentativas_aluno_simulado_idx on tentativas (aluno_id, simulado_id);

-- só pode haver 1 tentativa "em_andamento" por aluno+simulado por vez
create unique index tentativas_uma_em_andamento
  on tentativas (aluno_id, simulado_id)
  where status = 'em_andamento';

create table respostas (
  id uuid primary key default gen_random_uuid(),
  tentativa_id uuid not null references tentativas(id) on delete cascade,
  questao_id uuid not null references questoes(id) on delete cascade,
  alternativa_id uuid references alternativas(id) on delete set null,
  correta boolean not null,
  ordem_apresentacao int not null,
  tempo_resposta_segundos int,
  respondido_em timestamptz not null default now(),
  unique (tentativa_id, questao_id)
);

-- ============================================================
-- VIEWS DE RESULTADOS (uso exclusivo do painel do professor —
-- não são concedidas à role "anon"; ver seção de GRANTS)
-- ============================================================

create view vw_resultado_aluno_simulado as
with tres_primeiras as (
  select t.aluno_id, t.simulado_id, t.numero_tentativa, t.nota
  from tentativas t
  where t.numero_tentativa in (1, 2, 3) and t.status = 'finalizada'
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
join tentativas t_ultima on t_ultima.aluno_id = a.id
join simulados s on s.id = t_ultima.simulado_id
join disciplinas d on d.id = s.disciplina_id
left join tres_primeiras tp
  on tp.aluno_id = a.id and tp.simulado_id = t_ultima.simulado_id
group by a.id, a.nome, a.turma, s.id, s.titulo, d.id, d.nome;

create view vw_desempenho_questao as
select
  q.id as questao_id,
  q.codigo,
  q.disciplina_id,
  q.competencia_id,
  count(r.id) as total_respostas,
  count(r.id) filter (where r.correta) as total_acertos,
  count(r.id) filter (where not r.correta) as total_erros,
  round((count(r.id) filter (where r.correta))::numeric / nullif(count(r.id), 0) * 100, 1) as percentual_acerto
from questoes q
left join respostas r on r.questao_id = q.id
group by q.id, q.codigo, q.disciplina_id, q.competencia_id;

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

alter table disciplinas enable row level security;
alter table competencias enable row level security;
alter table simulados enable row level security;
alter table questoes enable row level security;
alter table alternativas enable row level security;
alter table simulado_questoes enable row level security;
alter table alunos enable row level security;
alter table tentativas enable row level security;
alter table respostas enable row level security;

-- Catálogo: leitura pública (anon + authenticated). Sem dado sensível aqui
-- (o gabarito mora em `alternativas`, que é tratado à parte abaixo).
create policy disciplinas_select on disciplinas for select to anon, authenticated using (true);
create policy competencias_select on competencias for select to anon, authenticated using (true);
create policy simulados_select on simulados for select to anon, authenticated using (true);
create policy simulado_questoes_select on simulado_questoes for select to anon, authenticated using (true);
create policy questoes_select on questoes for select to anon, authenticated using (status = 'ativa');

-- Catálogo: escrita só professor autenticado.
create policy disciplinas_write on disciplinas for all to authenticated using (true) with check (true);
create policy competencias_write on competencias for all to authenticated using (true) with check (true);
create policy simulados_write on simulados for all to authenticated using (true) with check (true);
create policy simulado_questoes_write on simulado_questoes for all to authenticated using (true) with check (true);
create policy questoes_write on questoes for all to authenticated using (true) with check (true);

-- Alternativas: contém o gabarito (`correta`). Só "authenticated" lê a
-- tabela diretamente. O aluno recebe as alternativas (sem o campo
-- `correta`) exclusivamente via a função rpc_questoes_simulado().
create policy alternativas_select_auth on alternativas for select to authenticated using (true);
create policy alternativas_write on alternativas for all to authenticated using (true) with check (true);

-- Alunos / tentativas / respostas: só "authenticated" tem policy — ou
-- seja, "anon" tem acesso ZERO à tabela crua (nenhuma policy = nenhuma
-- linha visível/gravável). O fluxo do aluno usa só as funções RPC.
create policy alunos_select_auth on alunos for select to authenticated using (true);
create policy tentativas_select_auth on tentativas for select to authenticated using (true);
create policy respostas_select_auth on respostas for select to authenticated using (true);

-- ============================================================
-- FUNÇÕES RPC — único caminho de escrita/leitura para o aluno (anon)
-- Todas SECURITY DEFINER com search_path fixo (evita search_path
-- hijacking) e validam a operação internamente antes de tocar nas
-- tabelas, já que rodam com privilégio de dono (bypassa RLS).
-- ============================================================

-- Busca alunos existentes por nome (para reduzir duplicidade). Retorna
-- só id/nome/turma — nunca dados de nota.
create or replace function rpc_aluno_buscar(p_nome text)
returns table (id uuid, nome text, turma text)
language sql
security definer
set search_path = public, pg_temp
as $$
  select a.id, a.nome, a.turma
  from alunos a
  where a.nome_normalizado = normalizar_nome(p_nome)
     or a.nome_normalizado ilike '%' || normalizar_nome(p_nome) || '%'
  order by a.ultimo_acesso desc
  limit 5;
$$;

-- Cria um novo aluno e devolve o id (guardado no localStorage do browser).
create or replace function rpc_aluno_criar(p_nome text, p_turma text default null)
returns uuid
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_id uuid;
begin
  if length(trim(p_nome)) < 3 then
    raise exception 'Nome muito curto';
  end if;

  insert into alunos (nome, turma)
  values (trim(p_nome), nullif(trim(p_turma), ''))
  returning id into v_id;

  return v_id;
end;
$$;

-- Atualiza "último acesso" (reconhecimento do aluno pelo token salvo no
-- localStorage, sem validar identidade de fato — risco aceito no MVP).
create or replace function rpc_aluno_tocar(p_aluno_id uuid)
returns void
language sql
security definer
set search_path = public, pg_temp
as $$
  update alunos set ultimo_acesso = now() where id = p_aluno_id;
$$;

-- Lista as questões (com alternativas, SEM o campo `correta`) de um
-- simulado, para a aplicação montar a prova. O embaralhamento de
-- questões/alternativas é feito no cliente.
create or replace function rpc_questoes_simulado(p_simulado_id uuid)
returns table (
  questao_id uuid,
  codigo text,
  enunciado text,
  alternativa_id uuid,
  alternativa_texto text,
  alternativa_ordem int
)
language sql
security definer
set search_path = public, pg_temp
as $$
  select q.id, q.codigo, q.enunciado, alt.id, alt.texto, alt.ordem
  from simulado_questoes sq
  join questoes q on q.id = sq.questao_id and q.status = 'ativa'
  join alternativas alt on alt.questao_id = q.id
  where sq.simulado_id = p_simulado_id
  order by q.id, alt.ordem;
$$;

-- Inicia uma tentativa (ou retoma uma já em andamento). numero_tentativa
-- é calculado no servidor — o cliente nunca escolhe esse valor.
create or replace function rpc_iniciar_tentativa(p_aluno_id uuid, p_simulado_id uuid)
returns table (tentativa_id uuid, numero_tentativa int, retomada boolean)
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_existente record;
  v_proximo_numero int;
  v_nova_id uuid;
begin
  select t.id, t.numero_tentativa into v_existente
  from tentativas t
  where t.aluno_id = p_aluno_id
    and t.simulado_id = p_simulado_id
    and t.status = 'em_andamento';

  if found then
    return query select v_existente.id, v_existente.numero_tentativa, true;
    return;
  end if;

  select coalesce(max(t.numero_tentativa), 0) + 1 into v_proximo_numero
  from tentativas t
  where t.aluno_id = p_aluno_id and t.simulado_id = p_simulado_id;

  insert into tentativas (aluno_id, simulado_id, numero_tentativa)
  values (p_aluno_id, p_simulado_id, v_proximo_numero)
  returning id into v_nova_id;

  return query select v_nova_id, v_proximo_numero, false;
end;
$$;

-- Registra a resposta de UMA questão. A correção é calculada aqui,
-- nunca é enviada pelo cliente. Nas 3 primeiras tentativas, o índice
-- único (tentativa_id, questao_id) impede responder a mesma questão
-- duas vezes (equivalente a "não permitir voltar e alterar").
create or replace function rpc_responder_questao(
  p_tentativa_id uuid,
  p_questao_id uuid,
  p_alternativa_id uuid,
  p_ordem_apresentacao int,
  p_tempo_resposta_segundos int default null
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_status status_tentativa;
  v_simulado_id uuid;
  v_correta boolean;
begin
  select t.status, t.simulado_id into v_status, v_simulado_id
  from tentativas t where t.id = p_tentativa_id;

  if not found then
    raise exception 'Tentativa não encontrada';
  end if;
  if v_status <> 'em_andamento' then
    raise exception 'Tentativa já finalizada';
  end if;

  if not exists (
    select 1 from simulado_questoes sq
    where sq.simulado_id = v_simulado_id and sq.questao_id = p_questao_id
  ) then
    raise exception 'Questão não pertence a este simulado';
  end if;

  select alt.correta into v_correta
  from alternativas alt
  where alt.id = p_alternativa_id and alt.questao_id = p_questao_id;

  if not found then
    raise exception 'Alternativa inválida para esta questão';
  end if;

  insert into respostas (
    tentativa_id, questao_id, alternativa_id, correta,
    ordem_apresentacao, tempo_resposta_segundos
  ) values (
    p_tentativa_id, p_questao_id, p_alternativa_id, v_correta,
    p_ordem_apresentacao, p_tempo_resposta_segundos
  );
exception
  when unique_violation then
    raise exception 'Esta questão já foi respondida nesta tentativa';
end;
$$;

-- Finaliza a tentativa: calcula nota/acertos/erros a partir das
-- respostas já gravadas (nunca a partir de valores enviados pelo
-- cliente) e devolve o resumo para a tela de resultado.
create or replace function rpc_finalizar_tentativa(p_tentativa_id uuid, p_tempo_segundos int)
returns table (nota numeric, acertos int, erros int)
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_status status_tentativa;
  v_acertos int;
  v_erros int;
  v_nota numeric;
begin
  select t.status into v_status from tentativas t where t.id = p_tentativa_id;

  if not found then
    raise exception 'Tentativa não encontrada';
  end if;
  if v_status <> 'em_andamento' then
    raise exception 'Tentativa já finalizada';
  end if;

  select count(*) filter (where r.correta), count(*) filter (where not r.correta)
    into v_acertos, v_erros
  from respostas r where r.tentativa_id = p_tentativa_id;

  v_nota := v_acertos * 0.5;

  update tentativas t
  set status = 'finalizada',
      finalizado_em = now(),
      tempo_segundos = p_tempo_segundos,
      nota = v_nota,
      acertos = v_acertos,
      erros = v_erros
  where t.id = p_tentativa_id;

  return query select v_nota, v_acertos, v_erros;
end;
$$;

-- Histórico de tentativas do próprio aluno (tela de resultado /
-- comparação). Escopo só ao aluno_id + simulado_id informados —
-- o cliente não consegue listar tentativas de outra pessoa sem
-- conhecer o aluno_id dela (não há endpoint de listagem geral).
create or replace function rpc_tentativas_aluno(p_aluno_id uuid, p_simulado_id uuid)
returns table (
  numero_tentativa int, nota numeric, acertos int, erros int,
  tempo_segundos int, status status_tentativa, finalizado_em timestamptz
)
language sql
security definer
set search_path = public, pg_temp
as $$
  select t.numero_tentativa, t.nota, t.acertos, t.erros,
         t.tempo_segundos, t.status, t.finalizado_em
  from tentativas t
  where t.aluno_id = p_aluno_id and t.simulado_id = p_simulado_id
  order by t.numero_tentativa;
$$;

-- ============================================================
-- GRANTS
-- ============================================================

revoke execute on all functions in schema public from public;

grant execute on function
  rpc_aluno_buscar(text),
  rpc_aluno_criar(text, text),
  rpc_aluno_tocar(uuid),
  rpc_questoes_simulado(uuid),
  rpc_iniciar_tentativa(uuid, uuid),
  rpc_responder_questao(uuid, uuid, uuid, int, int),
  rpc_finalizar_tentativa(uuid, int),
  rpc_tentativas_aluno(uuid, uuid)
to anon, authenticated;

-- Views de resultado: só o painel do professor consulta.
grant select on vw_resultado_aluno_simulado to authenticated;
grant select on vw_desempenho_questao to authenticated;
