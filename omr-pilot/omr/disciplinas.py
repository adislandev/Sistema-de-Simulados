"""Configuracao das disciplinas/turmas corrigidas pelo pipeline.

Cada disciplina tem a sua pasta de provas digitalizadas, planilha de
resultados, gabarito, lista de chamada e rubrica das dissertativas. Os IDs
sao identificadores do Drive (nao sao segredos - o acesso e controlado pelo
compartilhamento com a conta de servico).

A lista de chamada fica em um destes lugares:
- `lista_chamada_csv`: arquivo local, gravado pelo workflow a partir de um
  Secret (caso de Logica Computacional);
- `lista_chamada_drive_id`: arquivo CSV (colunas `ra,nome`) no proprio Drive,
  baixado em tempo de execucao - assim os dados dos alunos nao entram no
  repositorio nem exigem um novo Secret.
"""
from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent  # omr-pilot/
DOCS = RAIZ.parent / "docs"


@dataclass(frozen=True)
class Disciplina:
    chave: str
    nome: str  # usado no prompt da IA
    prova_tipo: str  # valor gravado em provas_presenciais_resultados.prova_tipo
    turma: str
    pasta_alunos_id: str
    planilha_id: str
    gabarito_doc_id: str
    rubrica: Path
    lista_chamada_csv: Path | None = None
    lista_chamada_drive_id: str | None = None
    # arquivos da pasta que nao sao provas (ex.: a propria lista de presenca escaneada)
    arquivos_ignorados: tuple[str, ...] = ()


LOGICA = Disciplina(
    chave="logica",
    nome="Lógica Computacional",
    prova_tipo="Lógica Computacional",
    turma="01SI-NOTA",
    pasta_alunos_id="1nsLuzXqzTCvLiUOQZqL0gEBvPi3sIcwW",
    planilha_id="1obdaU2JMsOJBUhdO238mIGHnWk7umoLxFFatj8QWPOY",
    gabarito_doc_id="1UfJLJusRVFMkzWmE3lCL9fZ-548LqmyzXhM4oUb2RWM",
    rubrica=DOCS / "rubrica-dissertativas-provas-presenciais.md",
    lista_chamada_csv=RAIZ / "dados" / "lista_chamada.csv",
    arquivos_ignorados=("Lista de Presença.pdf",),
)

ERGONOMIA = Disciplina(
    chave="ergonomia",
    nome="Ergonomia de Sistemas Computacionais e IHC",
    prova_tipo="Ergonomia de Sistemas Computacionais e IHC",
    turma="03SI-NOTA",
    pasta_alunos_id="1vVlU7ZhTjxxoU2hU0yuXx-p5FBosEW1e",
    planilha_id="1gNT_IDQuVejt6nw5BdLCWUm3e_XUiKAFOG8TJHufrBY",
    gabarito_doc_id="1ZON5qAN-mcv00xh2_vhDaSpZCkekmrmzD1KuFnRL49w",
    rubrica=DOCS / "rubrica-dissertativas-ergonomia.md",
    lista_chamada_drive_id="176YvwwsTQ4vqPXSNazxE4EwFOhNihtf5",
)

# Ordem de processamento: Logica primeiro, para uma falha em outra disciplina
# nunca impedir a correcao ja existente.
DISCIPLINAS = [LOGICA, ERGONOMIA]
