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

import requests

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

    resposta = requests.post(
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
    resposta.raise_for_status()


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
    `gravar_resultado` no mesmo pipeline."""
    url, chave = _config()

    linha = {
        "ra": ra,
        "prova_tipo": prova_tipo,
        "nota_dissertativa_sugerida": nota_sugerida_total,
        "dissertativas_ia": dissertativas_ia,
    }

    resposta = requests.post(
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
    resposta.raise_for_status()
