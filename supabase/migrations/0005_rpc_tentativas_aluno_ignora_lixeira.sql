-- Tentativas apagadas pelo professor (lixeira) não devem aparecer nem
-- para o próprio aluno na tela de resultado/histórico.
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
  where t.aluno_id = p_aluno_id and t.simulado_id = p_simulado_id and t.apagado_em is null
  order by t.numero_tentativa;
$$;

-- Mesmo cuidado ao verificar se já existe uma tentativa "em_andamento"
-- para retomar: uma tentativa apagada não deve ser retomada.
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
    and t.status = 'em_andamento'
    and t.apagado_em is null;

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
