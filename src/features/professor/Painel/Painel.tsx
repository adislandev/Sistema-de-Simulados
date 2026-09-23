import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  listarDesempenhoQuestoes,
  listarResultadosTurma,
  type DesempenhoQuestaoPainel,
  type ResultadoAlunoSimuladoPainel,
} from "../../../lib/professorApi";
import { supabase } from "../../../lib/supabaseClient";
import { exportarResultadosXlsx } from "../../../lib/exportarXlsx";
import { formatarData, formatarNota, formatarPontoExtra, formatarTempo } from "../../../lib/format";
import { useSessaoProfessor } from "../useSessaoProfessor";

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

export default function Painel() {
  const navigate = useNavigate();
  const { sessao } = useSessaoProfessor();
  const [resultados, setResultados] = useState<ResultadoAlunoSimuladoPainel[]>([]);
  const [desempenhoQuestoes, setDesempenhoQuestoes] = useState<DesempenhoQuestaoPainel[]>([]);
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState<string | null>(null);
  const [exportando, setExportando] = useState(false);

  useEffect(() => {
    Promise.all([listarResultadosTurma(), listarDesempenhoQuestoes()])
      .then(([resultadosTurma, desempenho]) => {
        setResultados(resultadosTurma);
        setDesempenhoQuestoes(desempenho);
      })
      .catch(() => setErro("Não foi possível carregar os resultados."))
      .finally(() => setCarregando(false));
  }, []);

  async function sair() {
    await supabase.auth.signOut();
    navigate("/professor/login", { replace: true });
  }

  async function exportar() {
    setExportando(true);
    try {
      await exportarResultadosXlsx(resultados);
    } finally {
      setExportando(false);
    }
  }

  return (
    <div className="pagina">
      <div className="container-largo">
        <div className="cartao">
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", marginBottom: 24 }}>
            <div>
              <h1 className="titulo-pagina">Painel do professor</h1>
              <p className="subtitulo-pagina" style={{ margin: 0 }}>{sessao?.user.email}</p>
            </div>
            <div style={{ display: "flex", gap: 8 }}>
              <button
                type="button"
                className="botao botao-secundario"
                onClick={exportar}
                disabled={exportando || resultados.length === 0}
              >
                {exportando ? "Exportando..." : "Exportar XLSX"}
              </button>
              <button type="button" className="botao botao-secundario" onClick={sair}>
                Sair
              </button>
            </div>
          </div>

          {carregando && <p className="texto-suave">Carregando...</p>}
          {erro && <p className="mensagem-erro">{erro}</p>}

          {!carregando && !erro && resultados.length === 0 && (
            <p className="texto-suave">Nenhum resultado registrado ainda.</p>
          )}

          {!carregando && !erro && resultados.length > 0 && (
            <div className="tabela-wrap">
              <table className="tabela">
                <thead>
                  <tr>
                    <th>Aluno</th>
                    <th>Disciplina</th>
                    <th>Simulado</th>
                    <th>Tentativa 1</th>
                    <th>Tentativa 2</th>
                    <th>Tentativa 3</th>
                    <th>Média</th>
                    <th>Ponto extra</th>
                    <th>Última tentativa</th>
                  </tr>
                </thead>
                <tbody>
                  {resultados.map((r) => (
                    <tr key={`${r.alunoId}:${r.simuladoId}`}>
                      <td>{r.alunoNome}</td>
                      <td>{r.disciplinaNome}</td>
                      <td>{r.simuladoTitulo}</td>
                      <td>{celulaTentativa(r, 1)}</td>
                      <td>{celulaTentativa(r, 2)}</td>
                      <td>{celulaTentativa(r, 3)}</td>
                      <td>{formatarNota(r.media)}</td>
                      <td>{formatarPontoExtra(r.pontoExtra)}</td>
                      <td>{formatarData(r.ultimaTentativaEm)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}

          {!carregando && !erro && desempenhoQuestoes.length > 0 && (
            <>
              <h2 style={{ fontSize: "1.1rem", fontWeight: 600, margin: "32px 0 4px" }}>Desempenho por questão</h2>
              <p className="texto-suave" style={{ marginTop: 0 }}>
                Ordenado da questão com maior índice de erro para a de melhor desempenho.
              </p>
              <div className="tabela-wrap">
                <table className="tabela">
                  <thead>
                    <tr>
                      <th>Código</th>
                      <th>Disciplina</th>
                      <th>Respostas</th>
                      <th>Acertos</th>
                      <th>Erros</th>
                      <th>% acerto</th>
                    </tr>
                  </thead>
                  <tbody>
                    {desempenhoQuestoes.map((q) => (
                      <tr key={q.questao_id}>
                        <td>{q.codigo}</td>
                        <td>{q.disciplinaNome}</td>
                        <td>{q.total_respostas}</td>
                        <td>{q.total_acertos}</td>
                        <td>{q.total_erros}</td>
                        <td>
                          {q.percentual_acerto !== null ? (
                            <span className={`emblema ${classeEmblema(q.percentual_acerto)}`}>
                              {q.percentual_acerto}%
                            </span>
                          ) : (
                            "—"
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
