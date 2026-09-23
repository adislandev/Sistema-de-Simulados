import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import BarChart from "../../../components/BarChart/BarChart";
import { listarSimuladosAtivos, type SimuladoComDisciplina } from "../../../lib/alunoApi";
import {
  apagarResultadoAluno,
  buscarRespostasTentativa,
  buscarTentativasDetalhe,
  esvaziarLixeira,
  listarDesempenhoQuestoes,
  listarLixeira,
  listarQuestoesPorSimulado,
  listarResultadosTurma,
  restaurarResultadoAluno,
  type DesempenhoQuestaoPainel,
  type LixeiraItemPainel,
  type ResultadoAlunoSimuladoPainel,
  type RespostaQuestaoPainel,
  type TentativaDetalhePainel,
} from "../../../lib/professorApi";
import { supabase } from "../../../lib/supabaseClient";
import { exportarResultadosXlsx } from "../../../lib/exportarXlsx";
import { formatarData, formatarNota, formatarPontoExtra, formatarTempo } from "../../../lib/format";
import { useSessaoProfessor } from "../useSessaoProfessor";

type Aba = "resultados" | "lixeira";

interface AlunoSelecionado {
  alunoId: string;
  alunoNome: string;
  simuladoId: string;
  simuladoTitulo: string;
}

function celulaTentativa(resultado: ResultadoAlunoSimuladoPainel, numero: number): string {
  const tentativa = resultado.tentativas.find((t) => t.numeroTentativa === numero);
  if (!tentativa) return "—";
  const tempo = tentativa.tempoSegundos !== null ? formatarTempo(tentativa.tempoSegundos) : "—";
  return `${formatarNota(tentativa.nota)} (${tempo})`;
}

function classeEmblema(percentual: number): string {
  if (percentual >= 70) return "emblema-sucesso";
  if (percentual < 40) return "emblema-erro";
  return "emblema-neutro";
}

function corPorPercentual(percentual: number): string {
  if (percentual >= 70) return "var(--cor-sucesso)";
  if (percentual < 40) return "var(--cor-erro)";
  return "var(--cor-aviso)";
}

export default function Painel() {
  const navigate = useNavigate();
  const { sessao } = useSessaoProfessor();

  const [resultados, setResultados] = useState<ResultadoAlunoSimuladoPainel[]>([]);
  const [desempenhoQuestoes, setDesempenhoQuestoes] = useState<DesempenhoQuestaoPainel[]>([]);
  const [simulados, setSimulados] = useState<SimuladoComDisciplina[]>([]);
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState<string | null>(null);
  const [exportando, setExportando] = useState(false);

  const [aba, setAba] = useState<Aba>("resultados");
  const [simuladoId, setSimuladoId] = useState("");
  const [turma, setTurma] = useState("");
  const [questaoIdsSimulado, setQuestaoIdsSimulado] = useState<Set<string> | null>(null);

  const [lixeira, setLixeira] = useState<LixeiraItemPainel[]>([]);
  const [carregandoLixeira, setCarregandoLixeira] = useState(false);
  const [erroLixeira, setErroLixeira] = useState<string | null>(null);

  const [alunoSelecionado, setAlunoSelecionado] = useState<AlunoSelecionado | null>(null);
  const [detalheTentativas, setDetalheTentativas] = useState<TentativaDetalhePainel[]>([]);
  const [detalheRespostas, setDetalheRespostas] = useState<RespostaQuestaoPainel[]>([]);
  const [carregandoDetalhe, setCarregandoDetalhe] = useState(false);
  const [erroDetalhe, setErroDetalhe] = useState<string | null>(null);

  async function carregarPainel() {
    setCarregando(true);
    setErro(null);
    try {
      const [resultadosTurma, desempenho, simuladosAtivos] = await Promise.all([
        listarResultadosTurma(),
        listarDesempenhoQuestoes(),
        listarSimuladosAtivos(),
      ]);
      setResultados(resultadosTurma);
      setDesempenhoQuestoes(desempenho);
      setSimulados(simuladosAtivos);
    } catch {
      setErro("Não foi possível carregar os resultados.");
    } finally {
      setCarregando(false);
    }
  }

  useEffect(() => {
    carregarPainel();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    setTurma("");
    if (!simuladoId) {
      setQuestaoIdsSimulado(null);
      return;
    }
    let cancelado = false;
    listarQuestoesPorSimulado(simuladoId)
      .then((ids) => {
        if (!cancelado) setQuestaoIdsSimulado(ids);
      })
      .catch(() => {
        if (!cancelado) setQuestaoIdsSimulado(new Set());
      });
    return () => {
      cancelado = true;
    };
  }, [simuladoId]);

  async function carregarLixeira() {
    setCarregandoLixeira(true);
    setErroLixeira(null);
    try {
      setLixeira(await listarLixeira());
    } catch {
      setErroLixeira("Não foi possível carregar a lixeira.");
    } finally {
      setCarregandoLixeira(false);
    }
  }

  function abrirLixeira() {
    setAba("lixeira");
    carregarLixeira();
  }

  async function sair() {
    await supabase.auth.signOut();
    navigate("/professor/login", { replace: true });
  }

  async function exportar() {
    setExportando(true);
    try {
      await exportarResultadosXlsx(resultadosFiltrados);
    } finally {
      setExportando(false);
    }
  }

  async function handleApagar(r: ResultadoAlunoSimuladoPainel) {
    const confirmou = window.confirm(
      `Tem certeza que deseja apagar este simulado?\n\n${r.alunoNome} — ${r.disciplinaNome}: ${r.simuladoTitulo}\n\n` +
        "As tentativas dessa combinação vão para a lixeira e podem ser restauradas depois, se for engano.",
    );
    if (!confirmou) return;

    try {
      await apagarResultadoAluno(r.alunoId, r.simuladoId);
      await carregarPainel();
    } catch {
      setErro("Não foi possível apagar. Tente novamente.");
    }
  }

  async function handleRestaurar(item: LixeiraItemPainel) {
    try {
      await restaurarResultadoAluno(item.alunoId, item.simuladoId);
      await Promise.all([carregarLixeira(), carregarPainel()]);
    } catch {
      setErroLixeira("Não foi possível restaurar. Tente novamente.");
    }
  }

  async function handleEsvaziarLixeira() {
    if (lixeira.length === 0) return;
    const confirmou = window.confirm(
      "Esvaziar a lixeira apaga essas tentativas em definitivo — não é possível desfazer depois disso.\n\n" +
        "Deseja continuar?",
    );
    if (!confirmou) return;

    try {
      await esvaziarLixeira();
      await carregarLixeira();
    } catch {
      setErroLixeira("Não foi possível esvaziar a lixeira. Tente novamente.");
    }
  }

  async function abrirDetalheAluno(r: ResultadoAlunoSimuladoPainel) {
    setAlunoSelecionado({
      alunoId: r.alunoId,
      alunoNome: r.alunoNome,
      simuladoId: r.simuladoId,
      simuladoTitulo: r.simuladoTitulo,
    });
    setCarregandoDetalhe(true);
    setErroDetalhe(null);
    setDetalheRespostas([]);
    try {
      const tentativas = await buscarTentativasDetalhe(r.alunoId, r.simuladoId);
      setDetalheTentativas(tentativas);

      const ultimaFinalizada = [...tentativas].reverse().find((t) => t.status === "finalizada");
      if (ultimaFinalizada) {
        setDetalheRespostas(await buscarRespostasTentativa(ultimaFinalizada.id));
      }
    } catch {
      setErroDetalhe("Não foi possível carregar o detalhamento deste aluno.");
    } finally {
      setCarregandoDetalhe(false);
    }
  }

  function fecharDetalheAluno() {
    setAlunoSelecionado(null);
    setDetalheTentativas([]);
    setDetalheRespostas([]);
    setErroDetalhe(null);
  }

  const resultadosFiltrados = useMemo(() => {
    if (!simuladoId) return [];
    return resultados.filter((r) => r.simuladoId === simuladoId && (!turma || r.alunoTurma === turma));
  }, [resultados, simuladoId, turma]);

  const turmasDoSimulado = useMemo(() => {
    const turmas = new Set(
      resultados
        .filter((r) => r.simuladoId === simuladoId)
        .map((r) => r.alunoTurma)
        .filter((t): t is string => Boolean(t)),
    );
    return Array.from(turmas).sort();
  }, [resultados, simuladoId]);

  const desempenhoFiltrado = useMemo(() => {
    if (!questaoIdsSimulado) return [];
    return desempenhoQuestoes.filter((q) => questaoIdsSimulado.has(q.questao_id));
  }, [desempenhoQuestoes, questaoIdsSimulado]);

  if (alunoSelecionado) {
    const notasChart = detalheTentativas.map((t) => ({
      label: `Tentativa ${t.numeroTentativa}`,
      valor: t.nota ?? 0,
      maximo: 10,
      cor: t.nota !== null ? corPorPercentual((t.nota / 10) * 100) : "var(--cor-borda)",
      legenda: t.status === "finalizada" ? formatarNota(t.nota) : "em andamento",
    }));

    const respostasChart = detalheRespostas.map((r) => ({
      label: r.codigo,
      valor: r.correta ? 1 : 0,
      maximo: 1,
      cor: r.correta ? "var(--cor-sucesso)" : "var(--cor-erro)",
      legenda: r.correta ? "Acertou" : "Errou",
    }));

    return (
      <div className="pagina">
        <div className="container-largo">
          <div className="cartao">
            <button type="button" className="botao botao-secundario" onClick={fecharDetalheAluno} style={{ marginBottom: 16 }}>
              ← Voltar aos resultados
            </button>

            <h1 className="titulo-pagina">{alunoSelecionado.alunoNome}</h1>
            <p className="subtitulo-pagina" style={{ marginBottom: 24 }}>{alunoSelecionado.simuladoTitulo}</p>

            {carregandoDetalhe && <p className="texto-suave">Carregando...</p>}
            {erroDetalhe && <p className="mensagem-erro">{erroDetalhe}</p>}

            {!carregandoDetalhe && !erroDetalhe && (
              <>
                <h2 style={{ fontSize: "1rem", fontWeight: 600, margin: "0 0 12px" }}>Nota por tentativa</h2>
                {notasChart.length === 0 ? (
                  <p className="texto-suave">Nenhuma tentativa registrada.</p>
                ) : (
                  <BarChart itens={notasChart} />
                )}

                <h2 style={{ fontSize: "1rem", fontWeight: 600, margin: "28px 0 4px" }}>
                  Desempenho por questão (última tentativa finalizada)
                </h2>
                {respostasChart.length === 0 ? (
                  <p className="texto-suave">Sem tentativa finalizada para detalhar por questão.</p>
                ) : (
                  <div style={{ marginTop: 12 }}>
                    <BarChart itens={respostasChart} />
                  </div>
                )}
              </>
            )}
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="pagina">
      <div className="container-largo">
        <div className="cartao">
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", marginBottom: 24, flexWrap: "wrap", gap: 12 }}>
            <div>
              <h1 className="titulo-pagina">Painel do professor</h1>
              <p className="subtitulo-pagina" style={{ margin: 0 }}>{sessao?.user.email}</p>
            </div>
            <div style={{ display: "flex", gap: 8 }}>
              <button
                type="button"
                className={`botao ${aba === "resultados" ? "botao-primario" : "botao-secundario"}`}
                onClick={() => setAba("resultados")}
              >
                Resultados
              </button>
              <button
                type="button"
                className={`botao ${aba === "lixeira" ? "botao-primario" : "botao-secundario"}`}
                onClick={abrirLixeira}
              >
                Lixeira{lixeira.length > 0 ? ` (${lixeira.length})` : ""}
              </button>
              <button type="button" className="botao botao-secundario" onClick={sair}>
                Sair
              </button>
            </div>
          </div>

          {aba === "resultados" && (
            <>
              <div style={{ display: "flex", gap: 12, flexWrap: "wrap", marginBottom: 20 }}>
                <div className="campo" style={{ flex: "1 1 240px", marginBottom: 0 }}>
                  <label htmlFor="filtro-simulado">Simulado</label>
                  <select id="filtro-simulado" value={simuladoId} onChange={(e) => setSimuladoId(e.target.value)}>
                    <option value="">Selecione um simulado</option>
                    {simulados.map((s) => (
                      <option key={s.id} value={s.id}>
                        {s.disciplina.nome} — {s.titulo}
                      </option>
                    ))}
                  </select>
                </div>

                {simuladoId && turmasDoSimulado.length > 0 && (
                  <div className="campo" style={{ flex: "1 1 200px", marginBottom: 0 }}>
                    <label htmlFor="filtro-turma">Turma</label>
                    <select id="filtro-turma" value={turma} onChange={(e) => setTurma(e.target.value)}>
                      <option value="">Todas as turmas</option>
                      {turmasDoSimulado.map((t) => (
                        <option key={t} value={t}>{t}</option>
                      ))}
                    </select>
                  </div>
                )}

                {simuladoId && (
                  <div style={{ flex: "0 0 auto", alignSelf: "flex-end" }}>
                    <button
                      type="button"
                      className="botao botao-secundario"
                      onClick={exportar}
                      disabled={exportando || resultadosFiltrados.length === 0}
                    >
                      {exportando ? "Exportando..." : "Exportar XLSX"}
                    </button>
                  </div>
                )}
              </div>

              {carregando && <p className="texto-suave">Carregando...</p>}
              {erro && <p className="mensagem-erro">{erro}</p>}

              {!carregando && !erro && !simuladoId && (
                <p className="texto-suave">Selecione um simulado acima para ver os resultados dos alunos.</p>
              )}

              {!carregando && !erro && simuladoId && resultadosFiltrados.length === 0 && (
                <p className="texto-suave">Nenhum resultado registrado ainda para este simulado.</p>
              )}

              {!carregando && !erro && resultadosFiltrados.length > 0 && (
                <div className="tabela-wrap">
                  <table className="tabela">
                    <thead>
                      <tr>
                        <th>Aluno</th>
                        <th>Turma</th>
                        <th>Tentativa 1</th>
                        <th>Tentativa 2</th>
                        <th>Tentativa 3</th>
                        <th>Média</th>
                        <th>Ponto extra</th>
                        <th>Última tentativa</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      {resultadosFiltrados.map((r) => (
                        <tr
                          key={`${r.alunoId}:${r.simuladoId}`}
                          onClick={() => abrirDetalheAluno(r)}
                          style={{ cursor: "pointer" }}
                        >
                          <td>{r.alunoNome}</td>
                          <td>{r.alunoTurma ?? "—"}</td>
                          <td>{celulaTentativa(r, 1)}</td>
                          <td>{celulaTentativa(r, 2)}</td>
                          <td>{celulaTentativa(r, 3)}</td>
                          <td>{formatarNota(r.media)}</td>
                          <td>{formatarPontoExtra(r.pontoExtra)}</td>
                          <td>{formatarData(r.ultimaTentativaEm)}</td>
                          <td>
                            <button
                              type="button"
                              className="botao botao-secundario"
                              style={{ padding: "4px 10px", fontSize: "0.8rem" }}
                              onClick={(e) => {
                                e.stopPropagation();
                                handleApagar(r);
                              }}
                            >
                              Apagar
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}

              {!carregando && !erro && simuladoId && desempenhoFiltrado.length > 0 && (
                <>
                  <h2 style={{ fontSize: "1.1rem", fontWeight: 600, margin: "32px 0 4px" }}>Desempenho por questão</h2>
                  <p className="texto-suave" style={{ marginTop: 0, marginBottom: 16 }}>
                    Ordenado da questão com maior índice de erro para a de melhor desempenho.
                  </p>
                  <BarChart
                    itens={desempenhoFiltrado.map((q) => ({
                      label: q.codigo,
                      valor: q.percentual_acerto ?? 0,
                      maximo: 100,
                      cor: q.percentual_acerto !== null ? corPorPercentual(q.percentual_acerto) : "var(--cor-borda)",
                      legenda:
                        q.percentual_acerto !== null ? (
                          <span className={`emblema ${classeEmblema(q.percentual_acerto)}`}>{q.percentual_acerto}%</span>
                        ) : (
                          "—"
                        ),
                    }))}
                  />
                </>
              )}
            </>
          )}

          {aba === "lixeira" && (
            <>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
                <p className="texto-suave" style={{ margin: 0 }}>
                  Tentativas apagadas ficam aqui até serem restauradas ou até a lixeira ser esvaziada.
                </p>
                <button
                  type="button"
                  className="botao botao-secundario"
                  onClick={handleEsvaziarLixeira}
                  disabled={lixeira.length === 0}
                  style={{ color: "var(--cor-erro)", borderColor: "var(--cor-erro)" }}
                >
                  Esvaziar lixeira
                </button>
              </div>

              {carregandoLixeira && <p className="texto-suave">Carregando...</p>}
              {erroLixeira && <p className="mensagem-erro">{erroLixeira}</p>}

              {!carregandoLixeira && !erroLixeira && lixeira.length === 0 && (
                <p className="texto-suave">A lixeira está vazia.</p>
              )}

              {!carregandoLixeira && !erroLixeira && lixeira.length > 0 && (
                <div className="tabela-wrap">
                  <table className="tabela">
                    <thead>
                      <tr>
                        <th>Aluno</th>
                        <th>Disciplina</th>
                        <th>Simulado</th>
                        <th>Tentativas apagadas</th>
                        <th>Apagado em</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      {lixeira.map((item) => (
                        <tr key={`${item.alunoId}:${item.simuladoId}`}>
                          <td>{item.alunoNome}</td>
                          <td>{item.disciplinaNome}</td>
                          <td>{item.simuladoTitulo}</td>
                          <td>{item.qtdTentativas}</td>
                          <td>{formatarData(item.apagadoEm)}</td>
                          <td>
                            <button
                              type="button"
                              className="botao botao-secundario"
                              style={{ padding: "4px 10px", fontSize: "0.8rem" }}
                              onClick={() => handleRestaurar(item)}
                            >
                              Restaurar
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
}
