"""Requisicoes HTTP com retry e backoff exponencial.

Falhas transitorias (502/503/504, 429, timeout, conexao caida) de APIs
externas (Supabase, DeepSeek) nao devem descartar o trabalho ja feito. Em
falha definitiva, a excecao inclui o corpo da resposta - `raise_for_status()`
sozinho o descarta, e e ele que diz a causa real (ex.: erro do PostgREST).
"""
from __future__ import annotations

import time
from typing import Any

import requests

STATUS_TRANSITORIOS = {429, 500, 502, 503, 504}
TENTATIVAS = 4
ESPERA_BASE_SEG = 2.0


def requisitar(metodo: str, url: str, **kwargs: Any) -> requests.Response:
    ultimo_erro: Exception | None = None
    for tentativa in range(1, TENTATIVAS + 1):
        try:
            resposta = requests.request(metodo, url, **kwargs)
        except (requests.ConnectionError, requests.Timeout) as erro:
            ultimo_erro = erro
        else:
            if resposta.status_code not in STATUS_TRANSITORIOS:
                _levantar_se_erro(resposta)
                return resposta
            ultimo_erro = _erro_http(resposta)
        if tentativa < TENTATIVAS:
            espera = ESPERA_BASE_SEG * 2 ** (tentativa - 1)
            print(f"    (tentativa {tentativa}/{TENTATIVAS} falhou: {ultimo_erro}; nova tentativa em {espera:.0f}s)")
            time.sleep(espera)
    assert ultimo_erro is not None
    raise ultimo_erro


def _erro_http(resposta: requests.Response) -> requests.HTTPError:
    return requests.HTTPError(
        f"{resposta.status_code} {resposta.reason} - corpo: {resposta.text[:500]!r}", response=resposta
    )


def _levantar_se_erro(resposta: requests.Response) -> None:
    if not resposta.ok:
        raise _erro_http(resposta)
