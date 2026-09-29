-- ============================================================
-- Provas presenciais (correção automatizada via OMR — piloto ADI-68)
--
-- Guarda o mesmo resultado que hoje só vai para a planilha do Google
-- Sheets, para o professor visualizar dentro do painel. Tabela
-- independente de `alunos`: o aluno de prova presencial é identificado
-- por RA (lista de chamada), não pelo fluxo de nome usado no simulado
-- online, e o aluno NUNCA visualiza essa nota — é leitura exclusiva do
-- professor. Por isso não há policy nenhuma para "anon".
--
-- Escrita: feita fora da aplicação, pelo pipeline Python (GitHub
-- Actions, ver omr-pilot/), usando a service role key do Supabase —
-- que bypassa RLS por padrão. Não há policy de insert/update para
-- nenhuma role: nem "anon" nem "authenticated" gravam aqui diretamente.
-- ============================================================

create table provas_presenciais_resultados (
  id uuid primary key default gen_random_uuid(),
  ra text not null,
  nome text not null,
  turma text,
  prova_tipo text not null,
  respostas_objetivas text[] not null default '{}', -- ex.: {A,B,A,B,C,C,B,A}, item null = em branco/ambígua
  acertos int,
  nota_objetiva numeric(3,2),
  nota_dissertativa numeric(3,2), -- preenchida depois (ADI-70); null = ainda não corrigida
  nota_total numeric(4,2) generated always as (coalesce(nota_objetiva, 0) + coalesce(nota_dissertativa, 0)) stored,
  data_correcao date not null default current_date,
  observacoes text not null default '',
  criado_em timestamptz not null default now(),
  unique (ra, prova_tipo)
);

create index provas_presenciais_turma_idx on provas_presenciais_resultados (turma, prova_tipo);

alter table provas_presenciais_resultados enable row level security;

-- Só o professor autenticado lê. Nenhuma policy de escrita: gravação é
-- feita pelo pipeline com a service role key (bypassa RLS), nunca pelo
-- app com a chave anon.
create policy provas_presenciais_select_auth on provas_presenciais_resultados
  for select to authenticated using (true);
