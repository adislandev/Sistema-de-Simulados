import { Fragment, useCallback, useEffect, useMemo, useState } from "react";
import CartaoResumo from "../../../components/CartaoResumo/CartaoResumo";
import { exportarNotaN1Xlsx } from "../../../lib/exportarXlsx";
import { formatarNota } from "../../../lib/format";
import {
  confirmarVinculoAluno,
  listarNotasN1,
  listarVinculosAlunos,
  rejeitarVinculoAluno,
} from "../../../lib/professorApi";
import type { NotaN1, StatusVinculo, VinculoAluno } from "../../../types/database";

const TENTATIVAS_PARA_PONTO = 3;
const NOTA_MAXIMA_N1 = 10;

const GLOSSARIO: { termo: string; texto: string }[] = [
  {
    termo: "Atividades",
    texto: "Soma das notas das atividades entregues na plataforma (importadas da planilha, aba “Atividades N1”). É a soma exata, sem ajuste.",
  },
  {
    termo: "Prova",
    texto: "Nota da prova presencial: objetiva (Q1 a Q8) + dissertativa. Só conta depois que você confirma a dissertativa; antes disso fica em branco. Máximo 7,0.",
  },
  {
    termo: "Extra (manual)",
    texto: "Pontos extras que você lança na planilha (coluna “Extra (manual)” da aba “Nota N1”).",
  },
  {
    termo: "Total bruto",
    texto: "Atividades + Prova + Extra manual, antes do limite de 10. Não inclui o simulado.",
  },
  {
    termo: "Nota N1 (sem simulado)",
    texto: "O total bruto limitado a 10. É a nota segura caso algum vínculo do simulado esteja errado.",
  },
  {
    termo: "Simulado",
    texto: "Ponto extra do simulado da disciplina: média das 3 primeiras tentativas ÷ 10 (máximo 1,0). Só existe com as 3 tentativas finalizadas; com 1 ou 2 fica em branco. Depende do vínculo do cadastro do simulado com o RA (veja “Vínculos” abaixo).",
  },
  {
    termo: "Nota N1 (com simulado)",
    texto: "Total bruto + ponto do simulado, limitado a 10.",
  },
  {
    termo: "Excedente",
    texto: "O que passou de 10 na nota com simulado (ponto extra acima da nota máxima).",
  },
  {
    termo: "Situação",
    texto: "“OK” quando há prova confirmada e atividades. “Sem prova” (dissertativa ainda não confirmada) e “Sem atividades” deixam a N1 em branco, para não mostrar nota parcial.",
  },
];

const ROTULO_STATUS: Record<StatusVinculo, string> = {
  sugerido: "Sugerido",
  ambiguo: "Vários candidatos",
  sem_correspondencia: "Sem correspondência",
  confirmado: "Confirmado",
  rejeitado: "Rejeitado",
};

const CLASSE_STATUS: Record<StatusVinculo, string> = {
  sugerido: "emblema-aviso",
  ambiguo: "emblema-aviso",
  sem_correspondencia: "emblema-erro",
  confirmado: "emblema-sucesso",
  rejeitado: "emblema-neutro",
};

const PENDENTES: StatusVinculo[] = ["sugerido", "ambiguo", "sem_correspondencia"];

const normalizarRa = (ra: string) => ra.replace(/^0+/, "") || "0";

const semAcento = (texto: string) =>
  texto.normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase();

const chaveLinha = (n: NotaN1) => `${n.prova_tipo}|${n.ra}`;

function media(valores: (number | null)[]): string {
  const validos = valores.filter((v): v is number => v !== null);
  if (validos.length === 0) return "—";
  return formatarNota(validos.reduce((a, b) => a + b, 0) / validos.length);
}

function Legenda() {
  return (
    <details style={{ marginBottom: 20 }}>
      <summary style={{ cursor: "pointer", fontWeight: 600 }}>O que é cada coluna?</summary>
      <dl style={{ margin: "12px 0 0", display: "grid", gap: 8 }}>
        {GLOSSARIO.map((g) => (
          <div key={g.termo}>
            <dt style={{ fontWeight: 600 }}>{g.termo}</dt>
            <dd className="texto-suave" style={{ margin: 0 }}>{g.texto}</dd>
          </div>
        ))}
      </dl>
    </details>
  );
}

function CelulaSimulado({ linha }: { linha: NotaN1 }) {
  if (linha.ponto_simulado !== null) {
    return (
      <>
        +{formatarNota(linha.ponto_simulado)}
        {linha.vinculo_status === "sugerido" && (
          <>
            {" "}
            <span className="emblema emblema-aviso" title="O vínculo deste aluno com o cadastro do simulado ainda não foi confirmado por você.">
              a validar
            </span>
          </>
        )}
      </>
    );
  }
  if (linha.tentativas_validas !== null && linha.tentativas_validas < TENTATIVAS_PARA_PONTO) {
    return (
      <span className="texto-suave" title="O ponto do simulado só existe com as 3 primeiras tentativas finalizadas.">
        — ({linha.tentativas_validas}/{TENTATIVAS_PARA_PONTO})
      </span>
    );
  }
  return <>—</>;
}

function Detalhe({ linha }: { linha: NotaN1 }) {
  const f = formatarNota;
  const pontoSimulado = linha.ponto_simulado ?? 0;
  return (
    <div
      style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))",
        gap: 20,
        padding: "8px 4px 12px",
        // acompanha a largura visivel mesmo quando a tabela rola na horizontal
        position: "sticky",
        left: 0,
        maxWidth: "min(1100px, calc(100vw - 96px))",
      }}
    >
      <div>
        <p style={{ margin: "0 0 6px", fontWeight: 600 }}>Atividades (plataforma)</p>
        {linha.atividades.length === 0 ? (
          <p className="texto-suave" style={{ margin: 0 }}>Nenhuma atividade importada.</p>
        ) : (
          <ul style={{ margin: 0, paddingLeft: 18 }}>
            {linha.atividades.map((a) => (
              <li key={a.nome}>
                {a.nome}: <strong>{f(a.nota)}</strong>
              </li>
            ))}
          </ul>
        )}
        <p style={{ margin: "6px 0 0" }}>Soma: <strong>{f(linha.atividades_soma)}</strong></p>
      </div>

      <div>
        <p style={{ margin: "0 0 6px", fontWeight: 600 }}>Prova presencial</p>
        <p style={{ margin: 0 }}>Objetiva (Q1–Q8): <strong>{f(linha.nota_objetiva)}</strong></p>
        <p style={{ margin: 0 }}>
          Dissertativa:{" "}
          {linha.dissertativa_confirmada ? <strong>{f(linha.nota_dissertativa)}</strong> : <span className="texto-suave">pendente de confirmação</span>}
        </p>
        <p style={{ margin: "6px 0 0" }}>Prova: <strong>{f(linha.prova_final)}</strong></p>
      </div>

      <div>
        <p style={{ margin: "0 0 6px", fontWeight: 600 }}>Cálculo</p>
        {linha.total_bruto_sem_simulado === null ? (
          <p className="texto-suave" style={{ margin: 0 }}>
            {linha.situacao === "Sem prova"
              ? "Aguardando a confirmação da dissertativa."
              : "Aguardando a importação das atividades."}
          </p>
        ) : (
          <>
            <p style={{ margin: 0 }}>
              {f(linha.atividades_soma)} (atividades) + {f(linha.prova_final)} (prova) + {f(linha.extra_manual ?? 0)} (extra) ={" "}
              <strong>{f(linha.total_bruto_sem_simulado)}</strong>
            </p>
            <p style={{ margin: "4px 0 0" }}>
              Sem simulado: <strong>{f(linha.nota_n1_sem_simulado)}</strong>
              {(linha.excedente_sem_simulado ?? 0) > 0 && <> (excedente {f(linha.excedente_sem_simulado)})</>}
            </p>
            <p style={{ margin: "4px 0 0" }}>
              Com simulado: {f(linha.total_bruto_sem_simulado)} + {f(pontoSimulado)} = {f(linha.total_bruto_com_simulado)} →{" "}
              <strong>{f(linha.nota_n1_com_simulado)}</strong>
              {(linha.excedente_com_simulado ?? 0) > 0 && <> (excedente {f(linha.excedente_com_simulado)})</>}
            </p>
          </>
        )}
      </div>
    </div>
  );
}

interface OpcaoAluno {
  ra: string;
  nome: string;
}

function LinhaVinculo({
  vinculo,
  todos,
  ocupado,
  onConfirmar,
  onRejeitar,
}: {
  vinculo: VinculoAluno;
  todos: OpcaoAluno[];
  ocupado: boolean;
  onConfirmar: (alunoId: string, ra: string) => void;
  onRejeitar: (alunoId: string) => void;
}) {
  const padrao = vinculo.status === "sugerido" || vinculo.status === "confirmado" ? (vinculo.ra ?? "") : "";
  const [escolha, setEscolha] = useState(padrao);

  const nomeDoRa = (ra: string | null) =>
    ra ? todos.find((o) => normalizarRa(o.ra) === normalizarRa(ra))?.nome : undefined;
  const sugestoes = vinculo.candidatos.length > 0
    ? vinculo.candidatos.map((c) => ({ ra: c.ra, nome: c.nome }))
    : vinculo.ra
      ? [{ ra: vinculo.ra, nome: nomeDoRa(vinculo.ra) ?? vinculo.ra }]
      : [];

  return (
    <div
      className="cartao"
      style={{ padding: 12, display: "flex", justifyContent: "space-between", alignItems: "center", gap: 12, flexWrap: "wrap" }}
    >
      <div style={{ minWidth: 220 }}>
        <p style={{ margin: 0 }}>
          <strong>{vinculo.alunoNome}</strong>{" "}
          <span className={`emblema ${CLASSE_STATUS[vinculo.status]}`}>{ROTULO_STATUS[vinculo.status]}</span>
        </p>
        <p className="texto-suave" style={{ margin: "2px 0 0", fontSize: "0.8rem" }}>
          Turma digitada: {vinculo.alunoTurma ?? "—"}
          {vinculo.ra && ` · RA ${vinculo.ra}`}
          {vinculo.ra && nomeDoRa(vinculo.ra) && ` · ${nomeDoRa(vinculo.ra)}`}
        </p>
      </div>
      <div style={{ display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}>
        <select
          aria-label={`Aluno correspondente a ${vinculo.alunoNome}`}
          value={escolha}
          onChange={(e) => setEscolha(e.target.value)}
          disabled={ocupado}
          style={{ maxWidth: 320 }}
        >
          <option value="">Escolha o aluno…</option>
          {sugestoes.length > 0 && (
            <optgroup label="Sugestões">
              {sugestoes.map((s) => (
                <option key={`s-${s.ra}`} value={s.ra}>{s.nome} ({s.ra})</option>
              ))}
            </optgroup>
          )}
          <optgroup label="Todos os alunos">
            {todos.map((o) => (
              <option key={`t-${o.ra}`} value={o.ra}>{o.nome} ({o.ra})</option>
            ))}
          </optgroup>
        </select>
        <button type="button" className="botao botao-primario" disabled={ocupado || !escolha} onClick={() => onConfirmar(vinculo.alunoId, escolha)}>
          Confirmar
        </button>
        <button type="button" className="botao botao-secundario" disabled={ocupado} onClick={() => onRejeitar(vinculo.alunoId)}>
          Não é nenhum
        </button>
      </div>
    </div>
  );
}

export default function NotaN1Aba() {
  const [notas, setNotas] = useState<NotaN1[]>([]);
  const [vinculos, setVinculos] = useState<VinculoAluno[]>([]);
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState<string | null>(null);
  const [erroVinculo, setErroVinculo] = useState<string | null>(null);
  const [disciplina, setDisciplina] = useState("");
  const [busca, setBusca] = useState("");
  const [abertos, setAbertos] = useState<Set<string>>(new Set());
  const [mostrarResolvidos, setMostrarResolvidos] = useState(false);
  const [ocupadoId, setOcupadoId] = useState<string | null>(null);
  const [exportando, setExportando] = useState(false);

  const buscarDados = useCallback(() => Promise.all([listarNotasN1(), listarVinculosAlunos()]), []);

  // recarga disparada por botoes/acoes do professor
  const recarregar = useCallback(async () => {
    setCarregando(true);
    setErro(null);
    try {
      const [n, v] = await buscarDados();
      setNotas(n);
      setVinculos(v);
      setDisciplina((atual) => atual || n[0]?.prova_tipo || "");
    } catch (e) {
      setErro(e instanceof Error ? e.message : "Não foi possível carregar a Nota N1.");
    } finally {
      setCarregando(false);
    }
  }, [buscarDados]);

  // carga inicial (o estado inicial ja e "carregando")
  useEffect(() => {
    let ativo = true;
    buscarDados()
      .then(([n, v]) => {
        if (!ativo) return;
        setNotas(n);
        setVinculos(v);
        setDisciplina((atual) => atual || n[0]?.prova_tipo || "");
      })
      .catch((e: unknown) => {
        if (ativo) setErro(e instanceof Error ? e.message : "Não foi possível carregar a Nota N1.");
      })
      .finally(() => {
        if (ativo) setCarregando(false);
      });
    return () => {
      ativo = false;
    };
  }, [buscarDados]);

  const disciplinas = useMemo(() => Array.from(new Set(notas.map((n) => n.prova_tipo))).sort(), [notas]);

  const linhas = useMemo(() => {
    const termo = semAcento(busca.trim());
    return notas.filter((n) => n.prova_tipo === disciplina && (!termo || semAcento(n.nome).includes(termo) || n.ra.includes(termo)));
  }, [notas, disciplina, busca]);

  const todosAlunos = useMemo<OpcaoAluno[]>(() => {
    const porRa = new Map<string, OpcaoAluno>();
    for (const n of notas) {
      if (!porRa.has(normalizarRa(n.ra))) porRa.set(normalizarRa(n.ra), { ra: n.ra, nome: n.nome });
    }
    return Array.from(porRa.values()).sort((a, b) => a.nome.localeCompare(b.nome));
  }, [notas]);

  const pendentes = useMemo(() => vinculos.filter((v) => PENDENTES.includes(v.status)), [vinculos]);
  const resolvidos = useMemo(() => vinculos.filter((v) => !PENDENTES.includes(v.status)), [vinculos]);
  const vinculosVisiveis = mostrarResolvidos ? vinculos : pendentes;

  function alternar(chave: string) {
    setAbertos((atual) => {
      const novo = new Set(atual);
      if (novo.has(chave)) novo.delete(chave);
      else novo.add(chave);
      return novo;
    });
  }

  async function executarVinculo(alunoId: string, acao: () => Promise<void>) {
    setOcupadoId(alunoId);
    setErroVinculo(null);
    try {
      await acao();
      await recarregar();
    } catch (e) {
      setErroVinculo(e instanceof Error ? e.message : "Não foi possível salvar o vínculo.");
    } finally {
      setOcupadoId(null);
    }
  }

  async function exportar() {
    setExportando(true);
    try {
      await exportarNotaN1Xlsx(linhas, disciplina);
    } finally {
      setExportando(false);
    }
  }

  return (
    <>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", flexWrap: "wrap", gap: 12, marginBottom: 16 }}>
        <p className="texto-suave" style={{ margin: 0, maxWidth: 640 }}>
          Nota N1 = atividades + prova + extra manual (+ ponto do simulado), limitada a 10. As atividades e o extra manual
          vêm da planilha; a prova e o simulado vêm do sistema. A N1 é mostrada <strong>com e sem</strong> o simulado.
        </p>
        <div style={{ display: "flex", gap: 8 }}>
          <button type="button" className="botao botao-secundario" onClick={() => void recarregar()} disabled={carregando}>
            Atualizar
          </button>
          <button type="button" className="botao botao-secundario" onClick={() => void exportar()} disabled={exportando || linhas.length === 0}>
            {exportando ? "Exportando..." : "Exportar XLSX"}
          </button>
        </div>
      </div>

      <Legenda />

      {carregando && notas.length === 0 && <p className="texto-suave">Carregando...</p>}
      {erro && <p className="mensagem-erro">{erro}</p>}

      {!erro && notas.length > 0 && (
        <>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(180px, 1fr))", gap: 12, marginBottom: 24 }}>
            <CartaoResumo
              icone={<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />}
              cor="var(--cor-primaria)"
              corFundo="var(--color-primary-50, #fbe9ce)"
              label="Alunos"
              valor={linhas.length}
            />
            <CartaoResumo
              icone={<path d="M3 3v18h18M7 15v4M11 10v9M15 6v13M19 12v7" />}
              cor="var(--cor-sucesso)"
              corFundo="#e6f6ec"
              label="Média N1 (sem simulado)"
              valor={media(linhas.map((l) => l.nota_n1_sem_simulado))}
            />
            <CartaoResumo
              icone={<path d="M3 3v18h18M7 15v4M11 10v9M15 6v13M19 12v7" />}
              cor="var(--cor-sucesso)"
              corFundo="#e6f6ec"
              label="Média N1 (com simulado)"
              valor={media(linhas.map((l) => l.nota_n1_com_simulado))}
            />
            <CartaoResumo
              icone={<path d="M12 2l3 7h7l-5.5 4.5L18.5 21 12 16.5 5.5 21l2-7.5L2 9h7z" />}
              cor="var(--cor-aviso)"
              corFundo="#fff4e0"
              label={`Acima de ${NOTA_MAXIMA_N1}`}
              valor={linhas.filter((l) => (l.excedente_com_simulado ?? 0) > 0).length}
            />
            <CartaoResumo
              icone={<><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 3" /></>}
              cor="var(--cor-aviso)"
              corFundo="#fff4e0"
              label="Sem nota ainda"
              valor={linhas.filter((l) => l.situacao !== "OK").length}
            />
          </div>

          <div style={{ display: "flex", gap: 12, flexWrap: "wrap", marginBottom: 20 }}>
            <div className="campo" style={{ flex: "1 1 200px", minWidth: 0, marginBottom: 0 }}>
              <label htmlFor="filtro-disciplina-n1">Disciplina</label>
              <select id="filtro-disciplina-n1" value={disciplina} onChange={(e) => setDisciplina(e.target.value)}>
                {disciplinas.map((d) => (
                  <option key={d} value={d}>{d}</option>
                ))}
              </select>
            </div>
            <div className="campo" style={{ flex: "1 1 180px", minWidth: 0, marginBottom: 0 }}>
              <label htmlFor="busca-n1">Buscar aluno</label>
              <input id="busca-n1" type="search" placeholder="Nome ou RA" value={busca} onChange={(e) => setBusca(e.target.value)} />
            </div>
          </div>

          <div className="tabela-wrap">
            <table className="tabela tabela-compacta">
              <thead>
                <tr>
                  <th>Aluno</th>
                  <th title="Soma das atividades entregues na plataforma">Atividades</th>
                  <th title="Objetiva + dissertativa confirmada (máx. 7,0)">Prova</th>
                  <th title="Pontos extras lançados na planilha">Extra</th>
                  <th title="Atividades + prova + extra, antes do limite de 10">Total bruto</th>
                  <th title="Total bruto limitado a 10, sem o simulado">N1 sem simulado</th>
                  <th title="Média das 3 primeiras tentativas ÷ 10; só com as 3 tentativas">Simulado</th>
                  <th title="Total bruto + simulado, limitado a 10">N1 com simulado</th>
                  <th title="O que passou de 10 na nota com simulado">Excedente</th>
                  <th>Situação</th>
                </tr>
              </thead>
              <tbody>
                {linhas.map((l) => {
                  const chave = chaveLinha(l);
                  const aberto = abertos.has(chave);
                  return (
                    <Fragment key={chave}>
                      <tr className="linha-clicavel" onClick={() => alternar(chave)} style={{ cursor: "pointer" }}>
                        <td className="coluna-aluno">
                          <strong>{l.nome}</strong>
                          <br />
                          <span className="texto-suave" style={{ fontSize: "0.75rem" }}>RA {l.ra}</span>
                        </td>
                        <td>{formatarNota(l.atividades_soma)}</td>
                        <td>
                          {formatarNota(l.prova_final)}
                          {l.prova_final === null && (
                            <>
                              <br />
                              <span className="texto-suave" style={{ fontSize: "0.75rem" }}>dissertativa pendente</span>
                            </>
                          )}
                        </td>
                        <td>{formatarNota(l.extra_manual)}</td>
                        <td>{formatarNota(l.total_bruto_sem_simulado)}</td>
                        <td><strong>{formatarNota(l.nota_n1_sem_simulado)}</strong></td>
                        <td><CelulaSimulado linha={l} /></td>
                        <td><strong>{formatarNota(l.nota_n1_com_simulado)}</strong></td>
                        <td>
                          {(l.excedente_com_simulado ?? 0) > 0 ? (
                            <span className="emblema emblema-aviso">+{formatarNota(l.excedente_com_simulado)}</span>
                          ) : (
                            "—"
                          )}
                        </td>
                        <td>
                          <span className={`emblema ${l.situacao === "OK" ? "emblema-sucesso" : "emblema-aviso"}`}>{l.situacao}</span>
                        </td>
                      </tr>
                      {aberto && (
                        <tr>
                          <td colSpan={10} style={{ whiteSpace: "normal", background: "var(--cor-fundo)" }}>
                            <Detalhe linha={l} />
                          </td>
                        </tr>
                      )}
                    </Fragment>
                  );
                })}
              </tbody>
            </table>
          </div>
          {linhas.length === 0 && <p className="texto-suave">Nenhum aluno encontrado.</p>}
          <p className="texto-suave" style={{ fontSize: "0.8rem" }}>Clique em um aluno para ver o detalhamento.</p>
        </>
      )}

      {!erro && vinculos.length > 0 && (
        <section style={{ marginTop: 32 }}>
          <h2 style={{ fontSize: "1.1rem", margin: "0 0 4px" }}>
            Vínculos do simulado com o RA{pendentes.length > 0 ? ` (${pendentes.length} a validar)` : ""}
          </h2>
          <p className="texto-suave" style={{ margin: "0 0 12px" }}>
            O aluno digita só o nome no simulado, sem RA. O sistema sugere de quem é cada cadastro pelo nome; o ponto do
            simulado só entra na N1 com vínculo. Confirme, escolha outro aluno ou marque “Não é nenhum” (ex.: cadastros de teste).
          </p>
          {erroVinculo && <p className="mensagem-erro">{erroVinculo}</p>}
          {pendentes.length === 0 && <p className="texto-suave">Todos os vínculos já foram validados.</p>}
          <div style={{ display: "grid", gap: 8 }}>
            {vinculosVisiveis.map((v) => (
              <LinhaVinculo
                key={`${v.alunoId}-${v.status}-${v.ra ?? ""}`}
                vinculo={v}
                todos={todosAlunos}
                ocupado={ocupadoId === v.alunoId}
                onConfirmar={(alunoId, ra) => void executarVinculo(alunoId, () => confirmarVinculoAluno(alunoId, ra))}
                onRejeitar={(alunoId) => void executarVinculo(alunoId, () => rejeitarVinculoAluno(alunoId))}
              />
            ))}
          </div>
          {resolvidos.length > 0 && (
            <label style={{ display: "inline-flex", alignItems: "center", gap: 6, marginTop: 12 }}>
              <input type="checkbox" checked={mostrarResolvidos} onChange={(e) => setMostrarResolvidos(e.target.checked)} />
              Mostrar também os já resolvidos ({resolvidos.length})
            </label>
          )}
        </section>
      )}
    </>
  );
}
