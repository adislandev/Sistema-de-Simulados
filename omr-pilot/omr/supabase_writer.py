"""Grava o resultado da correção na tabela `provas_presenciais_resultados`
do Supabase (Sistema de Simulados), para o professor visualizar dentro do
próprio painel, além da planilha (ver ADI-71).

Usa a REST API do PostgREST direto (sem SDK extra) com a service role key,
que bypassa RLS - por isso nunca é a chave "anon" usada pelo app. A URL e a
chave vêm sempre de variáveis de ambiente (SUPABASE_URL,
SUPABASE_SERVICE_ROLE_KEY), nunca hardcoded nem logadas.

Grava via upsert (on_conflict=ra,prova_tipo) para o pipeline poder rodar de
novo sem duplicar linha - a unicidade é garantida pela constraint da tabela.
"""
from __future__ import annotations

import os
from datetime import date
from typing import Any

from .http_retry import requisitar

TABELA = "provas_presenciais_resultados"


def _config() -> tuple[str, str]:
    url = os.environ.get("SUPABASE_URL")
    chave = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")
    if not url or not chave:
        raise RuntimeError(
            "Defina SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY para gravar no Supabase."
        )
    return url, chave


def gravar_resultado(
    ra: str,
    nome: str,
    turma: str,
    prova_tipo: str,
    respostas: list[str | None],
    acertos: int,
    nota_objetiva: float,
    observacoes: str = "",
) -> None:
    url, chave = _config()

    linha = {
        "ra": ra,
        "nome": nome,
        "turma": turma,
        "prova_tipo": prova_tipo,
        "respostas_objetivas": [r or None for r in respostas],
        "acertos": acertos,
        "nota_objetiva": nota_objetiva,
        "data_correcao": date.today().isoformat(),
        "observacoes": observacoes,
    }

    requisitar(
        "POST",
        f"{url}/rest/v1/{TABELA}",
        headers={
            "apikey": chave,
            "Authorization": f"Bearer {chave}",
            "Content-Type": "application/json",
            "Prefer": "resolution=merge-duplicates,return=minimal",
        },
        params={"on_conflict": "ra,prova_tipo"},
        json=linha,
        timeout=30,
    )


def gravar_sugestao_dissertativa(
    ra: str,
    prova_tipo: str,
    nota_sugerida_total: float | None,
    dissertativas_ia: list[dict[str, Any]],
) -> None:
    """Grava a SUGESTAO da IA para as dissertativas (ADI-70) na linha ja
    existente (criada por `gravar_resultado`). So atualiza as colunas de
    sugestao - nunca toca em `nota_dissertativa` (a nota definitiva, que so
    o professor grava ao revisar/confirmar).

    Requer que a linha (ra, prova_tipo) ja exista - roda depois de
    `gravar_resultado` no mesmo pipeline.

    Usa PATCH (nao upsert via POST): um upsert por POST monta a linha
    candidata para o INSERT antes de checar o conflito, e as colunas nao
    enviadas (nome, turma etc.) violariam as constraints NOT NULL mesmo
    quando a linha ja existe."""
    url, chave = _config()

    linha = {
        "nota_dissertativa_sugerida": nota_sugerida_total,
        "dissertativas_ia": dissertativas_ia,
    }

    requisitar(
        "PATCH",
        f"{url}/rest/v1/{TABELA}",
        headers={
            "apikey": chave,
            "Authorization": f"Bearer {chave}",
            "Content-Type": "application/json",
            "Prefer": "return=minimal",
        },
        params={"ra": f"eq.{ra}", "prova_tipo": f"eq.{prova_tipo}"},
        json=linha,
        timeout=30,
    )


def ras_sem_sugestao(prova_tipo: str) -> set[str]:
    """RAs com a prova ja gravada mas sem a sugestao da IA para as
    dissertativas (`dissertativas_ia` nulo) - ex.: a gravacao falhou numa
    rodada anterior. Usado para tentar de novo so essa etapa."""
    url, chave = _config()
    resposta = requisitar(
        "GET",
        f"{url}/rest/v1/{TABELA}",
        headers={"apikey": chave, "Authorization": f"Bearer {chave}"},
        params={"select": "ra", "prova_tipo": f"eq.{prova_tipo}", "dissertativas_ia": "is.null"},
        timeout=30,
    )
    return {linha["ra"] for linha in resposta.json()}


def listar_resultados(prova_tipo: str) -> list[dict[str, Any]]:
    """Todas as linhas da prova, com as colunas necessarias para comparar com
    a planilha (inclui as de dissertativa so para relatorio - nunca sao
    alteradas pela sincronizacao)."""
    url, chave = _config()
    resposta = requisitar(
        "GET",
        f"{url}/rest/v1/{TABELA}",
        headers={"apikey": chave, "Authorization": f"Bearer {chave}"},
        params={
            "select": "ra,nome,respostas_objetivas,acertos,nota_objetiva,nota_dissertativa,dissertativa_revisada_em",
            "prova_tipo": f"eq.{prova_tipo}",
        },
        timeout=30,
    )
    return resposta.json()


def atualizar_objetivas(
    ra: str,
    prova_tipo: str,
    respostas: list[str | None],
    acertos: int,
    nota_objetiva: float,
) -> None:
    """Atualiza SO as colunas das objetivas de uma linha existente (PATCH).
    Nunca envia nota_dissertativa, dissertativa_revisada_em nem as sugestoes
    da IA - essas pertencem ao sistema (confirmadas pelo professor)."""
    url, chave = _config()
    requisitar(
        "PATCH",
        f"{url}/rest/v1/{TABELA}",
        headers={
            "apikey": chave,
            "Authorization": f"Bearer {chave}",
            "Content-Type": "application/json",
            "Prefer": "return=minimal",
        },
        params={"ra": f"eq.{ra}", "prova_tipo": f"eq.{prova_tipo}"},
        json={
            "respostas_objetivas": [r or None for r in respostas],
            "acertos": acertos,
            "nota_objetiva": nota_objetiva,
        },
        timeout=30,
    )


def listar_tabela(tabela: str, params: dict[str, str]) -> list[dict[str, Any]]:
    """GET paginado (o PostgREST limita 1000 linhas por resposta)."""
    url, chave = _config()
    linhas: list[dict[str, Any]] = []
    tamanho = 1000
    while True:
        resposta = requisitar(
            "GET",
            f"{url}/rest/v1/{tabela}",
            headers={"apikey": chave, "Authorization": f"Bearer {chave}"},
            params={**params, "limit": str(tamanho), "offset": str(len(linhas))},
            timeout=30,
        )
        bloco = resposta.json()
        linhas.extend(bloco)
        if len(bloco) < tamanho:
            return linhas


def upsert_linhas(tabela: str, linhas: list[dict[str, Any]], on_conflict: str) -> None:
    """Upsert em lote (todas as linhas precisam ter as mesmas chaves)."""
    if not linhas:
        return
    url, chave = _config()
    requisitar(
        "POST",
        f"{url}/rest/v1/{tabela}",
        headers={
            "apikey": chave,
            "Authorization": f"Bearer {chave}",
            "Content-Type": "application/json",
            "Prefer": "resolution=merge-duplicates,return=minimal",
        },
        params={"on_conflict": on_conflict},
        json=linhas,
        timeout=60,
    )
