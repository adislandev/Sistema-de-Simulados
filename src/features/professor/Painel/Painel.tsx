import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import BarChart from "../../../components/BarChart/BarChart";
import BarraProgresso from "../../../components/BarraProgresso/BarraProgresso";
import CartaoResumo from "../../../components/CartaoResumo/CartaoResumo";
import { listarSimuladosAtivos, type SimuladoComDisciplina } from "../../../lib/alunoApi";
import {
  apagarResultadoAluno,
  buscarRespostasTentativa,
  buscarTentativasDetalhe,
  confirmarNotaDissertativa,
  dispararCorrecaoProvas,
  esvaziarLixeira,
  listarDesempenhoQuestoes,
  listarLixeira,
  listarProvasPresenciais,
  listarQuestoesPorSimulado,
  listarResultadosTurma,
  restaurarResultadoAluno,
  type DesempenhoQuestaoPainel,
  type LixeiraItemPainel,
  type ResultadoAlunoSimuladoPainel,
  type RespostaQuestaoPainel,
  type TentativaDetalhePainel,
} from "../../../lib/professorApi";
import type { ProvaPresencialResultado } from "../../../types/database";
import { supabase } from "../../../lib/supabaseClient";
import { exportarResultadosXlsx } from "../../../lib/exportarXlsx";
import { formatarData, formatarNota, formatarPontoExtra, formatarTempo } from "../../../lib/format";
import { useSessaoProfessor } from "../useSessaoProfessor";
import NotaN1Aba from "./NotaN1";

const DURACAO_ANIMACAO_CORRECAO_MS = 70_000;
const DURACAO_MINIMA_SALVANDO_NOTA_MS = 1_500;
const DURACAO_MENSAGEM_NOTA_CONFIRMADA_MS = 3_000;

type Aba = "resultados" | "presenciais" | "nota-n1" | "lixeira";

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

const NOTA_MAXIMA_PROVA_PRESENCIAL = 7;

function percentualNotaPresencial(nota: number | null): number | null {
  if (nota === null) return null;
  return (nota / NOTA_MAXIMA_PROVA_PRESENCIAL) * 100;
}

// Faixas próprias para a nota de prova presencial - não reaproveita classeEmblema()
// porque aquela usa a cor de marca (--cor-primaria) como "neutro", que hoje é o
// mesmo laranja do botão de aba ativo: o badge de nota ficava com a mesma cor da
// navegação, sem comunicar se a nota é boa, mediana ou baixa.
function classeEmblemaNotaPresencial(percentual: number): string {
  if (percentual >= 70) return "emblema-sucesso";
  if (percentual < 40) return "emblema-erro";
  return "emblema-aviso";
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

  const [provasPresenciais, setProvasPresenciais] = useState<ProvaPresencialResultado[]>([]);
  const [carregandoPresenciais, setCarregandoPresenciais] = useState(false);
  const [erroPresenciais, setErroPresenciais] = useState<string | null>(null);
  const [turmaPresencial, setTurmaPresencial] = useState("");
  const [provaSelecionada, setProvaSelecionada] = useState<ProvaPresencialResultado | null>(null);
  const [notaDissertativaInput, setNotaDissertativaInput] = useState("");
  const [salvandoNotaDissertativa, setSalvandoNotaDissertativa] = useState(false);
  const [erroNotaDissertativa, setErroNotaDissertativa] = useState<string | null>(null);
  const [notaConfirmada, setNotaConfirmada] = useState(false);

  const [disparandoCorrecao, setDisparandoCorrecao] = useState(false);
  const [aguardandoCorrecao, setAguardandoCorrecao] = useState(false);
  const [mensagemDisparo, setMensagemDisparo] = useState<string | null>(null);

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

  async function carregarPresenciais() {
    setCarregandoPresenciais(true);
    setErroPresenciais(null);
    try {
      setProvasPresenciais(await listarProvasPresenciais());
    } catch {
      setErroPresenciais("Não foi possível carregar as provas presenciais.");
    } finally {
      setCarregandoPresenciais(false);
    }
  }

  function abrirPresenciais() {
    setAba("presenciais");
    setTurmaPresencial("");
    setProvaSelecionada(null);
    carregarPresenciais();
  }

  async function handleDispararCorrecao() {
    setDisparandoCorrecao(true);
    setMensagemDisparo(null);
    try {
      await dispararCorrecaoProvas();
      setAguardandoCorrecao(true);
    } catch {
      setMensagemDisparo("Não foi possível disparar a correção. Tente novamente em instantes.");
      setDisparandoCorrecao(false);
    }
  }

  useEffect(() => {
    if (!aguardandoCorrecao) return;
    const id = window.setTimeout(() => {
      setAguardandoCorrecao(false);
      setDisparandoCorrecao(false);
      setMensagemDisparo("Correção em andamento. Clique em Atualizar em instantes para ver os resultados.");
      carregarPresenciais();
    }, DURACAO_ANIMACAO_CORRECAO_MS);
    return () => window.clearTimeout(id);
  }, [aguardandoCorrecao]);

  useEffect(() => {
    if (!provaSelecionada) return;
    const notaAtual = provaSelecionada.nota_dissertativa ?? provaSelecionada.nota_dissertativa_sugerida;
    setNotaDissertativaInput(notaAtual !== null && notaAtual !== undefined ? String(notaAtual) : "");
    setErroNotaDissertativa(null);
  }, [provaSelecionada]);

  async function handleConfirmarNotaDissertativa() {
    if (!provaSelecionada) return;
    const nota = Number(notaDissertativaInput.replace(",", "."));
    if (Number.isNaN(nota) || nota < 0) {
      setErroNotaDissertativa("Informe uma nota válida (0 ou maior).");
      return;
    }

    setSalvandoNotaDissertativa(true);
    setErroNotaDissertativa(null);
    setNotaConfirmada(false);
    // Garante que a animacao seja visivel mesmo quando a gravacao e instantanea.
    const tempoMinimo = new Promise((resolve) => window.setTimeout(resolve, DURACAO_MINIMA_SALVANDO_NOTA_MS));
    try {
      await confirmarNotaDissertativa(provaSelecionada.id, nota);
      await tempoMinimo;
      setNotaConfirmada(true);
      window.setTimeout(() => setNotaConfirmada(false), DURACAO_MENSAGEM_NOTA_CONFIRMADA_MS);
      const atualizadas = await listarProvasPresenciais();
      setProvasPresenciais(atualizadas);
      const atualizada = atualizadas.find((p) => p.id === provaSelecionada.id) ?? null;
      setProvaSelecionada(atualizada);
    } catch {
      await tempoMinimo;
      setErroNotaDissertativa("Não foi possível gravar a nota. Tente novamente.");
    } finally {
      setSalvandoNotaDissertativa(false);
    }
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

  const turmasPresenciais = useMemo(() => {
    const turmas = new Set(provasPresenciais.map((p) => p.turma).filter((t): t is string => Boolean(t)));
    return Array.from(turmas).sort();
  }, [provasPresenciais]);

  const presenciaisFiltradas = useMemo(() => {
    if (!turmaPresencial) return provasPresenciais;
    return provasPresenciais.filter((p) => p.turma === turmaPresencial);
  }, [provasPresenciais, turmaPresencial]);

  const desempenhoFiltrado = useMemo(() => {
    if (!questaoIdsSimulado) return [];
    return desempenhoQuestoes.filter((q) => questaoIdsSimulado.has(q.questao_id));
  }, [desempenhoQuestoes, questaoIdsSimulado]);

  if (provaSelecionada) {
    const percentual = percentualNotaPresencial(provaSelecionada.nota_total);
    return (
      <div className="pagina">
        <div className="container-largo">
          <div className="cartao">
            <button
              type="button"
              className="botao botao-secundario"
              onClick={() => setProvaSelecionada(null)}
              style={{ marginBottom: 16 }}
            >
              ← Voltar às provas presenciais
            </button>

            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", flexWrap: "wrap", gap: 16 }}>
              <div>
                <h1 className="titulo-pagina">{provaSelecionada.nome}</h1>
                <p className="subtitulo-pagina" style={{ margin: 0 }}>
                  RA {provaSelecionada.ra}
                  {provaSelecionada.turma ? ` · Turma ${provaSelecionada.turma}` : ""}
                </p>
                <p className="texto-suave" style={{ margin: "4px 0 0" }}>{provaSelecionada.prova_tipo}</p>
              </div>

              <div style={{ textAlign: "center" }}>
                <div
                  style={{
                    fontSize: "2rem",
                    fontWeight: 700,
                    color: percentual !== null ? corPorPercentual(percentual) : "var(--cor-borda)",
                    lineHeight: 1,
                  }}
                >
                  {formatarNota(provaSelecionada.nota_total)}
                </div>
                <p className="texto-suave" style={{ margin: "4px 0 0" }}>de {NOTA_MAXIMA_PROVA_PRESENCIAL.toFixed(1)}</p>
              </div>
            </div>

            <div
              style={{
                display: "grid",
                gridTemplateColumns: "repeat(auto-fit, minmax(160px, 1fr))",
                gap: 12,
                margin: "24px 0",
              }}
            >
              <div className="cartao" style={{ padding: 16 }}>
                <p className="texto-suave" style={{ margin: "0 0 4px" }}>Objetivas</p>
                <p style={{ margin: 0, fontSize: "1.25rem", fontWeight: 600 }}>
                  {provaSelecionada.acertos ?? "—"}/8 acertos
                </p>
                <p className="texto-suave" style={{ margin: "2px 0 0" }}>{formatarNota(provaSelecionada.nota_objetiva)} pts</p>
              </div>
              <div className="cartao" style={{ padding: 16 }}>
                <p className="texto-suave" style={{ margin: "0 0 4px" }}>Dissertativas</p>
                {provaSelecionada.nota_dissertativa !== null ? (
                  <>
                    <p style={{ margin: 0, fontSize: "1.25rem", fontWeight: 600 }}>
                      {formatarNota(provaSelecionada.nota_dissertativa)} pts
                    </p>
                    <p className="texto-suave" style={{ margin: "2px 0 0", fontSize: "0.75rem" }}>
                      Confirmada pelo professor{provaSelecionada.dissertativa_revisada_em ? ` em ${formatarData(provaSelecionada.dissertativa_revisada_em)}` : ""}
                    </p>
                  </>
                ) : provaSelecionada.nota_dissertativa_sugerida !== null ? (
                  <>
                    <span className="emblema emblema-aviso">Sugestão da IA: {formatarNota(provaSelecionada.nota_dissertativa_sugerida)}</span>
                    <p className="texto-suave" style={{ margin: "4px 0 0", fontSize: "0.75rem" }}>Aguardando confirmação do professor</p>
                  </>
                ) : (
                  <span className="emblema emblema-aviso">Aguardando correção</span>
                )}
              </div>
              <div className="cartao" style={{ padding: 16 }}>
                <p className="texto-suave" style={{ margin: "0 0 4px" }}>Data da correção</p>
                <p style={{ margin: 0, fontSize: "1.25rem", fontWeight: 600 }}>{formatarData(provaSelecionada.data_correcao)}</p>
              </div>
            </div>

            <h2 style={{ fontSize: "1rem", fontWeight: 600, margin: "0 0 12px" }}>Respostas objetivas</h2>
            <div style={{ display: "flex", gap: 8, flexWrap: "wrap", marginBottom: 24 }}>
              {provaSelecionada.respostas_objetivas.map((resp, i) => (
                <div
                  key={i}
                  className="cartao"
                  style={{ padding: "10px 16px", textAlign: "center", minWidth: 56 }}
                >
                  <p className="texto-suave" style={{ margin: "0 0 4px", fontSize: "0.75rem" }}>Q{i + 1}</p>
                  <p style={{ margin: 0, fontWeight: 700 }}>{resp ?? "—"}</p>
                </div>
              ))}
            </div>

            {provaSelecionada.observacoes && (
              <p className="mensagem-erro">{provaSelecionada.observacoes}</p>
            )}

            {provaSelecionada.dissertativas_ia && provaSelecionada.dissertativas_ia.length > 0 && (
              <>
                <h2 style={{ fontSize: "1rem", fontWeight: 600, margin: "28px 0 12px" }}>
                  Revisão das dissertativas (sugestão da IA)
                </h2>

                {provaSelecionada.dissertativas_ia.map((d) => (
                  <div key={d.questao} className="cartao" style={{ padding: 16, marginBottom: 12 }}>
                    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", gap: 12, marginBottom: 8 }}>
                      <p style={{ margin: 0, fontWeight: 600 }}>Questão {d.questao}</p>
                      {d.pendente_revisao_manual ? (
                        <span className="emblema emblema-erro">Pendente de revisão manual</span>
                      ) : (
                        <span className="emblema emblema-neutro">
                          Sugestão: {d.nota_sugerida_total !== null ? formatarNota(d.nota_sugerida_total) : "—"}
                        </span>
                      )}
                    </div>

                    <p className="texto-suave" style={{ margin: "0 0 4px", fontSize: "0.8rem" }}>Transcrição literal:</p>
                    <p
                      style={{
                        margin: "0 0 12px",
                        padding: 10,
                        background: "var(--cor-fundo)",
                        borderRadius: 8,
                        whiteSpace: "pre-wrap",
                        fontFamily: "monospace",
                        fontSize: "0.85rem",
                      }}
                    >
                      {d.transcricao || "(em branco)"}
                    </p>

                    {d.criterios.length > 0 && (
                      <div style={{ display: "grid", gap: 8 }}>
                        {d.criterios.map((c, i) => (
                          <div key={i} style={{ borderLeft: "3px solid var(--cor-borda)", paddingLeft: 10 }}>
                            <p style={{ margin: 0, fontWeight: 600, fontSize: "0.85rem" }}>
                              {c.nome}: {c.nota_sugerida}/{c.nota_maxima}
                            </p>
                            <p className="texto-suave" style={{ margin: "2px 0 0", fontSize: "0.8rem" }}>{c.justificativa}</p>
                          </div>
                        ))}
                      </div>
                    )}

                    {d.observacao && (
                      <p className="texto-suave" style={{ margin: "12px 0 0", fontSize: "0.8rem", fontStyle: "italic" }}>
                        {d.observacao}
                      </p>
                    )}
                  </div>
                ))}

                <div className="cartao" style={{ padding: 16, marginTop: 4 }}>
                  <label htmlFor="nota-dissertativa-final" style={{ display: "block", fontWeight: 600, marginBottom: 8 }}>
                    Nota final das dissertativas (confirmar ou ajustar)
                  </label>
                  <div style={{ display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}>
                    <input
                      id="nota-dissertativa-final"
                      type="text"
                      inputMode="decimal"
                      value={notaDissertativaInput}
                      onChange={(e) => setNotaDissertativaInput(e.target.value)}
                      style={{ maxWidth: 120 }}
                      placeholder="0.0"
                    />
                    <button
                      type="button"
                      className="botao botao-primario"
                      onClick={handleConfirmarNotaDissertativa}
                      disabled={salvandoNotaDissertativa}
                    >
                      {salvandoNotaDissertativa ? "Salvando..." : "Confirmar nota"}
                    </button>
                  </div>
                  {salvandoNotaDissertativa && <BarraProgresso rotulo="Salvando nota..." />}
                  {notaConfirmada && (
                    <p className="emblema emblema-sucesso" role="status" style={{ marginBottom: 0 }}>
                      Nota confirmada!
                    </p>
                  )}
                  {erroNotaDissertativa && <p className="mensagem-erro" style={{ marginBottom: 0 }}>{erroNotaDissertativa}</p>}
                </div>
              </>
            )}
          </div>
        </div>
      </div>
    );
  }

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
                style={{ display: "flex", alignItems: "center", gap: 6 }}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="18"
                  height="18"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  aria-hidden="true"
                >
                  <rect width="8" height="4" x="8" y="2" rx="1" ry="1"/>
                  <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/>
                  <path d="M12 11h4"/>
                  <path d="M12 16h4"/>
                  <path d="M8 11h.01"/>
                  <path d="M8 16h.01"/>
                </svg>
                Resultados
              </button>
              <button
                type="button"
                className={`botao ${aba === "presenciais" ? "botao-primario" : "botao-secundario"}`}
                onClick={abrirPresenciais}
                style={{ display: "flex", alignItems: "center", gap: 6 }}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="18"
                  height="18"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  aria-hidden="true"
                >
                  <path d="M9 12l2 2 4-4" />
                  <path d="M21 12c0 1-4 6-9 6s-9-5-9-6 4-6 9-6 9 5 9 6z" />
                </svg>
                Provas Presenciais
              </button>
              <button
                type="button"
                className={`botao ${aba === "nota-n1" ? "botao-primario" : "botao-secundario"}`}
                onClick={() => setAba("nota-n1")}
                style={{ display: "flex", alignItems: "center", gap: 6 }}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="18"
                  height="18"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  aria-hidden="true"
                >
                  <path d="M3 3v18h18" />
                  <path d="M7 15l4-4 3 3 5-6" />
                </svg>
                Nota N1
              </button>
              <button
                type="button"
                className={`botao ${aba === "lixeira" ? "botao-primario" : "botao-secundario"}`}
                onClick={abrirLixeira}
                style={{ display: "flex", alignItems: "center", gap: 6 }}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="18"
                  height="18"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  aria-hidden="true"
                >
                  <path d="M3 6h18"/>
                  <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/>
                  <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/>
                </svg>
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
                          className="linha-clicavel"
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

          {aba === "presenciais" && (
            <>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", flexWrap: "wrap", gap: 12, marginBottom: 20 }}>
                <p className="texto-suave" style={{ margin: 0 }}>
                  Resultados de provas presenciais corrigidas automaticamente (leitura de bolhas + identificação por
                  RA). Clique em um aluno para ver o detalhamento completo.
                </p>
                <div style={{ textAlign: "right" }}>
                  <button
                    type="button"
                    className="botao botao-secundario"
                    onClick={carregarPresenciais}
                    disabled={carregandoPresenciais}
                    style={{ marginRight: 8 }}
                  >
                    Atualizar
                  </button>
                  <button
                    type="button"
                    className="botao botao-primario"
                    onClick={handleDispararCorrecao}
                    disabled={disparandoCorrecao}
                  >
                    {disparandoCorrecao ? "Disparando..." : "Corrigir provas"}
                  </button>
                  {aguardandoCorrecao && (
                    <BarraProgresso rotulo="Corrigindo provas..." duracaoMs={DURACAO_ANIMACAO_CORRECAO_MS} />
                  )}
                  {mensagemDisparo && (
                    <p className="texto-suave" style={{ margin: "6px 0 0", fontSize: "0.8rem", maxWidth: 260 }}>
                      {mensagemDisparo}
                    </p>
                  )}
                </div>
              </div>

              {!carregandoPresenciais && !erroPresenciais && provasPresenciais.length > 0 && (
                <div
                  style={{
                    display: "grid",
                    gridTemplateColumns: "repeat(auto-fit, minmax(180px, 1fr))",
                    gap: 12,
                    marginBottom: 24,
                  }}
                >
                  <CartaoResumo
                    icone={<path d="M9 12l2 2 4-4M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0z" />}
                    cor="var(--cor-sucesso)"
                    corFundo="#e6f6ec"
                    label="Alunos corrigidos"
                    valor={presenciaisFiltradas.length}
                  />
                  <CartaoResumo
                    icone={<path d="M3 3v18h18M7 15v4M11 10v9M15 6v13M19 12v7" />}
                    cor="var(--cor-primaria)"
                    corFundo="var(--color-primary-50, #fbe9ce)"
                    label="Média da nota total"
                    valor={
                      presenciaisFiltradas.length > 0
                        ? formatarNota(
                            presenciaisFiltradas.reduce((soma, p) => soma + (p.nota_total ?? 0), 0) /
                              presenciaisFiltradas.length,
                          )
                        : "—"
                    }
                  />
                  <CartaoResumo
                    icone={<><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 3" /></>}
                    cor="var(--cor-aviso)"
                    corFundo="#fff4e0"
                    label="Dissertativas pendentes"
                    valor={presenciaisFiltradas.filter((p) => p.nota_dissertativa === null).length}
                  />
                </div>
              )}

              {turmasPresenciais.length > 0 && (
                <div className="campo" style={{ maxWidth: 240, marginBottom: 20 }}>
                  <label htmlFor="filtro-turma-presencial">Turma</label>
                  <select
                    id="filtro-turma-presencial"
                    value={turmaPresencial}
                    onChange={(e) => setTurmaPresencial(e.target.value)}
                  >
                    <option value="">Todas as turmas</option>
                    {turmasPresenciais.map((t) => (
                      <option key={t} value={t}>{t}</option>
                    ))}
                  </select>
                </div>
              )}

              {carregandoPresenciais && <p className="texto-suave">Carregando...</p>}
              {erroPresenciais && <p className="mensagem-erro">{erroPresenciais}</p>}

              {!carregandoPresenciais && !erroPresenciais && presenciaisFiltradas.length === 0 && (
                <p className="texto-suave">Nenhuma prova presencial corrigida ainda.</p>
              )}

              {!carregandoPresenciais && !erroPresenciais && presenciaisFiltradas.length > 0 && (
                <div className="tabela-wrap">
                  <table className="tabela">
                    <thead>
                      <tr>
                        <th>Aluno</th>
                        <th>RA</th>
                        <th>Nota</th>
                        <th>Dissertativa</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      {presenciaisFiltradas.map((p) => {
                        const percentual = percentualNotaPresencial(p.nota_total);
                        return (
                          <tr
                            key={p.id}
                            onClick={() => setProvaSelecionada(p)}
                            className="linha-clicavel"
                            style={{ cursor: "pointer" }}
                          >
                            <td>
                              <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                                <span
                                  aria-hidden="true"
                                  style={{
                                    display: "inline-flex",
                                    alignItems: "center",
                                    justifyContent: "center",
                                    width: 28,
                                    height: 28,
                                    borderRadius: "50%",
                                    background: "var(--cor-fundo)",
                                    color: "var(--cor-texto-suave)",
                                    fontSize: "0.75rem",
                                    fontWeight: 700,
                                    flexShrink: 0,
                                  }}
                                >
                                  {p.nome.charAt(0)}
                                </span>
                                {p.nome}
                              </div>
                            </td>
                            <td>{p.ra}</td>
                            <td>
                              <span className={`emblema ${percentual !== null ? classeEmblemaNotaPresencial(percentual) : "emblema-neutro"}`}>
                                {formatarNota(p.nota_total)}
                              </span>
                            </td>
                            <td>
                              {p.nota_dissertativa !== null ? (
                                <span className="emblema emblema-sucesso">{formatarNota(p.nota_dissertativa)}</span>
                              ) : (
                                <span className="emblema emblema-aviso">Pendente</span>
                              )}
                            </td>
                            <td style={{ textAlign: "right" }}>
                              <svg
                                xmlns="http://www.w3.org/2000/svg"
                                width="16"
                                height="16"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="var(--cor-borda)"
                                strokeWidth="2"
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                aria-hidden="true"
                              >
                                <path d="m9 18 6-6-6-6" />
                              </svg>
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              )}
            </>
          )}

          {aba === "nota-n1" && <NotaN1Aba />}

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
