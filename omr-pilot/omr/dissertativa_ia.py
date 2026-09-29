"""Avaliacao das questoes dissertativas via IA com visao (DeepSeek), a partir
do recorte gerado pelo dissertativa_detector (Fase 1 da ADI-70).

Regras anti-alucinacao (definidas com o professor - ver comentario na issue
ADI-70 do Linear):

1. Transcricao literal do que esta escrito - o modelo NAO pode supor o que o
   aluno "quis dizer". Trechos ilegiveis viram o marcador "[ilegivel]" na
   transcricao, nunca um palpite.
2. Resposta em branco ou totalmente ilegivel NAO recebe nota automaticamente -
   fica marcada como pendente de revisao manual (mesma regra da rubrica,
   ADI-69) e cabe ao professor decidir.
3. A nota de cada criterio so pode se basear no que esta na transcricao, e a
   justificativa precisa citar um trecho exato dela - nunca uma nota "solta"
   sem evidencia no texto.
4. temperature=0 (deterministico) e saida em JSON estruturado - nunca texto
   livre que possa "elaborar" alem do pedido.
5. O resultado e SEMPRE uma sugestao para o professor confirmar/ajustar -
   este modulo nunca grava nota definitiva em lugar nenhum.
"""
from __future__ import annotations

import base64
import json
import os
from dataclasses import dataclass, field
from pathlib import Path

import cv2
import numpy as np
import requests

DEEPSEEK_URL = "https://api.deepseek.com/chat/completions"
DEEPSEEK_MODEL = "deepseek-flash"

CAMINHO_RUBRICA = Path(__file__).resolve().parent.parent.parent / "docs" / "rubrica-dissertativas-provas-presenciais.md"

PROMPT_SISTEMA = """Você é um assistente de correção de provas de Lógica Computacional. Sua única tarefa é TRANSCREVER literalmente o que está escrito na imagem e avaliar a transcrição contra uma rubrica, para um professor revisar depois.

REGRAS OBRIGATÓRIAS (violar qualquer uma invalida a resposta):

1. Transcreva exatamente o que está escrito na imagem, caractere por caractere, incluindo erros de português/sintaxe do aluno. NUNCA corrija, complete ou "melhore" o que foi escrito. NUNCA suponha o que o aluno "quis dizer" além do que está literalmente visível.
2. Se um trecho estiver ilegível ou você tiver qualquer dúvida sobre o que está escrito, marque esse trecho como "[ilegível]" na transcrição — nunca adivinhe uma palavra ou símbolo que você não consegue ler com certeza.
3. Se a resposta estiver em branco ou totalmente ilegível, defina "pendente_revisao_manual": true, deixe "criterios" como lista vazia e "nota_sugerida_total" como null. NÃO atribua nota zero automaticamente.
4. Cada nota sugerida em "criterios" deve ter uma "justificativa" que cite um trecho EXATO da sua própria transcrição (entre aspas) como evidência. Se você não conseguir citar um trecho real que sustente a nota, não a atribua.
5. Nunca use conhecimento externo sobre "como normalmente se resolve esse problema" para preencher lacunas do que foi escrito — avalie só o que está de fato na imagem.
6. Sua resposta é sempre uma SUGESTÃO para revisão humana, nunca uma nota definitiva.

Responda APENAS com um JSON no formato exato abaixo, sem texto antes ou depois, sem markdown:

{
  "transcricao": string,
  "pendente_revisao_manual": boolean,
  "criterios": [
    {"nome": string, "nota_maxima": number, "nota_sugerida": number, "justificativa": string}
  ],
  "nota_sugerida_total": number ou null,
  "observacao": string
}
"""


@dataclass
class CriterioAvaliado:
    nome: str
    nota_maxima: float
    nota_sugerida: float
    justificativa: str


@dataclass
class ResultadoAvaliacaoIA:
    transcricao: str
    pendente_revisao_manual: bool
    criterios: list[CriterioAvaliado]
    nota_sugerida_total: float | None
    observacao: str
    resposta_bruta: str = field(repr=False)


def carregar_rubrica(caminho: Path = CAMINHO_RUBRICA) -> str:
    if not caminho.exists():
        raise FileNotFoundError(
            f"Rubrica nao encontrada em {caminho}. Verifique se docs/rubrica-dissertativas-provas-presenciais.md existe."
        )
    return caminho.read_text(encoding="utf-8")


def _chave_api() -> str:
    chave = os.environ.get("DEEPSEEK_API_KEY")
    if not chave:
        raise RuntimeError("Defina DEEPSEEK_API_KEY para avaliar dissertativas via IA.")
    return chave


def _imagem_para_data_url(imagem_bgr: np.ndarray) -> str:
    ok, buffer = cv2.imencode(".png", imagem_bgr)
    if not ok:
        raise ValueError("Falha ao codificar a imagem do recorte para envio a IA.")
    b64 = base64.b64encode(buffer).decode("ascii")
    return f"data:image/png;base64,{b64}"


def _montar_prompt_usuario(rubrica_texto: str, numero_questao: int, valor_questao: float) -> str:
    return (
        f"Questão dissertativa {numero_questao} (valor: {valor_questao} pontos).\n\n"
        f"Rubrica de correção:\n{rubrica_texto}\n\n"
        "Transcreva o que está escrito na imagem anexada e avalie contra a rubrica, "
        "seguindo estritamente as regras do sistema."
    )


def _parsear_resposta(conteudo: str) -> ResultadoAvaliacaoIA:
    try:
        payload = json.loads(conteudo)
    except json.JSONDecodeError as erro:
        raise ValueError(f"IA nao retornou JSON valido: {erro}\nConteudo recebido: {conteudo}") from erro

    criterios = [
        CriterioAvaliado(
            nome=c["nome"],
            nota_maxima=float(c["nota_maxima"]),
            nota_sugerida=float(c["nota_sugerida"]),
            justificativa=c["justificativa"],
        )
        for c in payload.get("criterios", [])
    ]

    return ResultadoAvaliacaoIA(
        transcricao=payload.get("transcricao", ""),
        pendente_revisao_manual=bool(payload.get("pendente_revisao_manual", False)),
        criterios=criterios,
        nota_sugerida_total=payload.get("nota_sugerida_total"),
        observacao=payload.get("observacao", ""),
        resposta_bruta=conteudo,
    )


def avaliar_dissertativa(
    imagem_bgr: np.ndarray,
    numero_questao: int,
    valor_questao: float = 1.5,
    rubrica_texto: str | None = None,
) -> ResultadoAvaliacaoIA:
    """Envia o recorte da questao dissertativa (ver dissertativa_detector.py)
    para avaliacao via IA com visao. Sempre retorna uma SUGESTAO - a gravacao
    de nota definitiva e responsabilidade do fluxo de revisao do professor
    (Fase 3, ainda nao implementada)."""
    chave = _chave_api()
    rubrica = rubrica_texto if rubrica_texto is not None else carregar_rubrica()
    data_url = _imagem_para_data_url(imagem_bgr)

    corpo = {
        "model": DEEPSEEK_MODEL,
        "temperature": 0,
        "response_format": {"type": "json_object"},
        "messages": [
            {"role": "system", "content": PROMPT_SISTEMA},
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": _montar_prompt_usuario(rubrica, numero_questao, valor_questao),
                    },
                    {"type": "image_url", "image_url": {"url": data_url}},
                ],
            },
        ],
    }

    resposta = requests.post(
        DEEPSEEK_URL,
        headers={
            "Authorization": f"Bearer {chave}",
            "Content-Type": "application/json",
        },
        json=corpo,
        timeout=60,
    )
    resposta.raise_for_status()
    conteudo = resposta.json()["choices"][0]["message"]["content"]
    return _parsear_resposta(conteudo)
