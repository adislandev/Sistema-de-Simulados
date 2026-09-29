-- ============================================================
-- Confirmação da nota dissertativa pelo professor (ADI-73)
--
-- A tabela `provas_presenciais_resultados` não tem policy de update para
-- "authenticated" (só o pipeline, via service role, escreve nela - ver
-- 0006). Esta RPC abre uma exceção mínima e controlada: o professor
-- autenticado só pode gravar `nota_dissertativa` (a nota definitiva) e
-- `dissertativa_revisada_em` (timestamp da revisão) - nunca as colunas de
-- sugestão da IA (`nota_dissertativa_sugerida`, `dissertativas_ia`), que
-- continuam sendo só o registro histórico do que a IA sugeriu.
-- ============================================================

create or replace function rpc_confirmar_nota_dissertativa(p_id uuid, p_nota numeric)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if p_nota is null or p_nota < 0 or p_nota > 3 then
    raise exception 'Nota da dissertativa fora da faixa válida (0 a 3): %', p_nota;
  end if;

  update provas_presenciais_resultados
  set nota_dissertativa = p_nota,
      dissertativa_revisada_em = now()
  where id = p_id;

  if not found then
    raise exception 'Prova presencial não encontrada: %', p_id;
  end if;
end;
$$;

grant execute on function rpc_confirmar_nota_dissertativa(uuid, numeric) to authenticated;
