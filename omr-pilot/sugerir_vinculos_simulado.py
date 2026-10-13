"""Sugere o RA de cada aluno do simulado (que so digitou nome/turma), por
similaridade de nome, e grava em `alunos_ra` para o professor validar.

- Considera apenas alunos com tentativa de simulado (nao apagada).
- O pool de RAs de cada aluno vem das disciplinas em que ele fez simulado:
  alunos com prova presencial (`provas_presenciais_resultados`) e da plataforma
  (`notas_n1_atividades`).
- Nunca altera vinculos 'confirmado' ou 'rejeitado' (decisao do professor).
- Imprime o relatorio: sugeridos, ambiguos (varios candidatos) e sem correspondencia.

Uso:
    SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... python sugerir_vinculos_simulado.py [--simular]
"""
from __future__ import annotations

import sys
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from omr.supabase_writer import listar_tabela, upsert_linhas  # noqa: E402
from omr.vinculo_simulado import sugerir  # noqa: E402

DECISOES_DO_PROFESSOR = {"confirmado", "rejeitado"}


def main() -> None:
    simular = "--simular" in sys.argv[1:]

    alunos = {a["id"]: a for a in listar_tabela("alunos", {"select": "id,nome,turma"})}
    tentativas = listar_tabela(
        "tentativas",
        {"select": "aluno_id,simulado:simulados(disciplina:disciplinas(nome))", "apagado_em": "is.null"},
    )
    disciplinas_do_aluno: dict[str, set[str]] = defaultdict(set)
    for t in tentativas:
        nome_disciplina = ((t.get("simulado") or {}).get("disciplina") or {}).get("nome")
        if nome_disciplina:
            disciplinas_do_aluno[t["aluno_id"]].add(nome_disciplina)

    pools: dict[str, list[tuple[str, str]]] = defaultdict(list)
    for tabela in ("provas_presenciais_resultados", "notas_n1_atividades"):
        for l in listar_tabela(tabela, {"select": "ra,nome,prova_tipo"}):
            pools[l["prova_tipo"]].append((l["ra"], l["nome"]))

    existentes = {l["aluno_id"]: l["status"] for l in listar_tabela("alunos_ra", {"select": "aluno_id,status"})}

    agora = datetime.now(timezone.utc).isoformat()
    linhas = []
    relatorio: dict[str, list[str]] = defaultdict(list)
    for aluno_id, disciplinas in sorted(disciplinas_do_aluno.items(), key=lambda kv: alunos.get(kv[0], {}).get("nome", "")):
        aluno = alunos.get(aluno_id)
        if aluno is None or existentes.get(aluno_id) in DECISOES_DO_PROFESSOR:
            continue
        pool = [item for d in disciplinas for item in pools.get(d, [])]
        s = sugerir(aluno["nome"], pool)
        linhas.append({
            "aluno_id": aluno_id,
            "ra": s.ra,
            "status": s.status,
            "similaridade": s.similaridade,
            "candidatos": s.candidatos,
            "atualizado_em": agora,
        })
        texto = f"{aluno['nome']!r} (turma digitada: {aluno.get('turma') or '-'})"
        if s.status == "sugerido":
            nome_oficial = next((n for r, n in pool if r == s.ra), "?")
            relatorio["sugerido"].append(f"{texto} -> RA {s.ra} {nome_oficial}")
        elif s.candidatos:
            opcoes = "; ".join(f"{c['ra']} {c['nome']}" for c in s.candidatos)
            relatorio[s.status].append(f"{texto} -> candidatos: {opcoes}")
        else:
            relatorio[s.status].append(f"{texto} -> nenhum candidato")

    for status, titulo in (
        ("sugerido", "SUGERIDOS (conferir)"),
        ("ambiguo", "AMBIGUOS (escolher entre os candidatos)"),
        ("sem_correspondencia", "SEM CORRESPONDENCIA"),
    ):
        print(f"\n== {titulo}: {len(relatorio[status])}")
        for item in relatorio[status]:
            print(f"  {item}")

    if simular:
        print("\n(simulacao - nada foi gravado)")
        return
    upsert_linhas("alunos_ra", linhas, on_conflict="aluno_id")
    print(f"\n{len(linhas)} vinculo(s) gravado(s) em alunos_ra (confirmados/rejeitados foram preservados).")


if __name__ == "__main__":
    main()
