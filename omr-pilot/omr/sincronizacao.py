"""Cruzamento planilha x Supabase das provas objetivas.

Regra definida pelo professor: em conflito nas objetivas, a PLANILHA vence.
As dissertativas pertencem ao sistema (notas confirmadas no painel) e nunca
sao tocadas por esta sincronizacao.

Este modulo e puro (sem rede): recebe as linhas ja lidas e devolve o que
difere. O script `sincronizar_planilha_supabase.py` faz a leitura/gravacao.
"""
from __future__ import annotations

from dataclasses import dataclass, field

from .avaliacao import calcular_nota_objetiva

NUM_QUESTOES = 8
LETRAS_VALIDAS = set("ABCDE")


def normalizar_ra(ra: object) -> str:
    """O Sheets converte RA em numero e perde zeros a esquerda ('0002667' ->
    2667); compara-se sem zeros a esquerda."""
    texto = str(ra).strip()
    if texto.endswith(".0"):
        texto = texto[:-2]
    return texto.lstrip("0") or "0"


def _numero(valor: object) -> float | None:
    if valor is None or str(valor).strip() == "":
        return None
    try:
        return float(str(valor).strip().replace(",", "."))
    except ValueError:
        return None


@dataclass
class LinhaPlanilha:
    ra: str
    nome: str
    respostas: list[str | None]
    acertos: int | None
    nota_objetiva: float | None
    linha: int  # numero da linha na planilha (para mensagens)


@dataclass
class Divergencia:
    ra_supabase: str
    nome: str
    campos: dict[str, tuple[object, object]]  # campo -> (supabase, planilha)
    avisos: list[str] = field(default_factory=list)
    novo: tuple[list[str | None], int, float] | None = None  # (respostas, acertos, nota) a gravar


@dataclass
class Relatorio:
    divergencias: list[Divergencia] = field(default_factory=list)
    iguais: int = 0
    so_planilha: list[str] = field(default_factory=list)
    so_supabase: list[str] = field(default_factory=list)
    problemas_planilha: list[str] = field(default_factory=list)


def interpretar_linhas(valores: list[list]) -> tuple[list[LinhaPlanilha], list[str]]:
    """valores = linhas da planilha (cabecalho incluso): RA, Nome, Turma, Prova,
    Q1..Q8, Acertos, Nota Objetiva, ..."""
    linhas: list[LinhaPlanilha] = []
    problemas: list[str] = []
    for numero, bruto in enumerate(valores[1:], start=2):
        celulas = list(bruto) + [""] * (14 - len(bruto))
        if not str(celulas[0]).strip():
            continue
        respostas: list[str | None] = []
        for q, c in enumerate(celulas[4:4 + NUM_QUESTOES], start=1):
            letra = str(c).strip().upper()
            if letra == "":
                respostas.append(None)
            elif letra in LETRAS_VALIDAS:
                respostas.append(letra)
            else:
                problemas.append(f"linha {numero} (RA {celulas[0]}): Q{q} com valor invalido {c!r} - tratado como em branco.")
                respostas.append(None)
        acertos = _numero(celulas[12])
        linhas.append(
            LinhaPlanilha(
                ra=str(celulas[0]).strip(),
                nome=str(celulas[1]).strip(),
                respostas=respostas,
                acertos=int(acertos) if acertos is not None else None,
                nota_objetiva=_numero(celulas[13]),
                linha=numero,
            )
        )
    return linhas, problemas


def comparar(
    linhas_planilha: list[LinhaPlanilha],
    linhas_supabase: list[dict],
    gabarito: list[str],
) -> Relatorio:
    relatorio = Relatorio()
    por_ra: dict[str, LinhaPlanilha] = {}
    for lp in linhas_planilha:
        chave = normalizar_ra(lp.ra)
        if chave in por_ra:
            relatorio.problemas_planilha.append(
                f"RA {lp.ra} repetido na planilha (linhas {por_ra[chave].linha} e {lp.linha}) - usando a ultima."
            )
        por_ra[chave] = lp

    vistos: set[str] = set()
    for sb in linhas_supabase:
        chave = normalizar_ra(sb["ra"])
        lp = por_ra.get(chave)
        if lp is None:
            relatorio.so_supabase.append(f"{sb['ra']} {sb['nome']}")
            continue
        vistos.add(chave)

        acertos_recalculados = sum(1 for r, g in zip(lp.respostas, gabarito) if r == g)
        avisos: list[str] = []
        acertos = lp.acertos if lp.acertos is not None else acertos_recalculados
        nota = lp.nota_objetiva if lp.nota_objetiva is not None else calcular_nota_objetiva(acertos)
        if lp.acertos is not None and lp.acertos != acertos_recalculados:
            avisos.append(
                f"planilha diz {lp.acertos} acerto(s) mas as respostas contra o gabarito dao {acertos_recalculados} (planilha vence; confira)."
            )
        if lp.nota_objetiva is not None and abs(lp.nota_objetiva - calcular_nota_objetiva(acertos)) > 1e-9:
            avisos.append(
                f"nota objetiva da planilha ({lp.nota_objetiva}) nao e acertos x 0,5 ({calcular_nota_objetiva(acertos)}) (planilha vence; confira)."
            )

        sb_respostas = [r or None for r in (sb.get("respostas_objetivas") or [])]
        sb_respostas += [None] * (NUM_QUESTOES - len(sb_respostas))
        campos: dict[str, tuple[object, object]] = {}
        if sb_respostas != lp.respostas:
            campos["respostas"] = (sb_respostas, lp.respostas)
        if sb.get("acertos") != acertos:
            campos["acertos"] = (sb.get("acertos"), acertos)
        sb_nota = _numero(sb.get("nota_objetiva"))
        if sb_nota is None or abs(sb_nota - nota) > 1e-9:
            campos["nota_objetiva"] = (sb.get("nota_objetiva"), nota)

        if campos or avisos:
            relatorio.divergencias.append(
                Divergencia(
                    ra_supabase=sb["ra"],
                    nome=sb["nome"],
                    campos=campos,
                    avisos=avisos,
                    novo=(lp.respostas, acertos, round(nota, 2)) if campos else None,
                )
            )
        else:
            relatorio.iguais += 1

    for chave, lp in por_ra.items():
        if chave not in vistos:
            relatorio.so_planilha.append(f"{lp.ra} {lp.nome}")
    return relatorio
