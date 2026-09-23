import { useEffect, useState } from "react";
import { useLocation, useNavigate, useParams } from "react-router-dom";
import {
  buscarDesempenhoCompetencias,
  buscarSimulado,
  buscarTentativasAluno,
  type SimuladoComDisciplina,
} from "../../../lib/alunoApi";
import { obterAlunoSessao } from "../../../lib/alunoSession";
import { formatarNota, formatarPontoExtra, formatarTempo } from "../../../lib/format";
import type {
  DesempenhoCompetenciaTentativa,
  FinalizarTentativaResultado,
  TentativaResumo,
} from "../../../types/database";

interface EstadoNavegacao {
  tentativaId?: string;
  resultado?: FinalizarTentativaResultado;
  numeroTentativa?: number;
  tempoSegundos?: number;
}

const MENSAGEM_POR_TENTATIVA: Record<number, string> = {
  1: "Autoanálise: veja onde você já está bem e o que ainda precisa estudar.",
  2: "Verifique sua evolução comparando esta nota com a da 1ª tentativa.",
  3: "Esta é a tentativa que consolida seu treinamento.",
};
const MENSAGEM_TENTATIVA_EXTRA = "Tentativa extra de treino — não conta para a média nem para o ponto extra.";

function classeEmblema(percentual: number): string {
  if (percentual >= 70) return "emblema-sucesso";
  if (percentual < 40) return "emblema-erro";
  return "emblema-neutro";
}

export default function Resultado() {
  const navigate = useNavigate();
  const location = useLocation();
  const { simuladoId } = useParams<{ simuladoId: string }>();
  const [aluno] = useState(obterAlunoSessao());

  const [simulado, setSimulado] = useState<SimuladoComDisciplina | null>(null);
  const [historico, setHistorico] = useState<TentativaResumo[]>([]);
  const [numeroAtual, setNumeroAtual] = useState<number | null>(null);
  const [competencias, setCompetencias] = useState<DesempenhoCompetenciaTentativa[] | null>(null);
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState<string | null>(null);

  useEffect(() => {
    if (!aluno || !simuladoId) {
      navigate("/", { replace: true });
      return;
    }

    let cancelado = false;
    const estado = location.state as EstadoNavegacao | null;

    async function carregar() {
      try {
        const [dadosSimulado, tentativas] = await Promise.all([
          buscarSimulado(simuladoId!),
          buscarTentativasAluno(aluno!.id, simuladoId!),
        ]);
        if (cancelado) return;

        const finalizadas = tentativas.filter((t) => t.status === "finalizada");
        const numeroAlvo = estado?.numeroTentativa ?? finalizadas[finalizadas.length - 1]?.numero_tentativa;

        if (!numeroAlvo) {
          setErro("Nenhum resultado encontrado para este simulado ainda.");
          return;
        }

        setSimulado(dadosSimulado);
        setHistorico(finalizadas);
        setNumeroAtual(numeroAlvo);

        if (estado?.tentativaId && estado.numeroTentativa === numeroAlvo) {
          const linhas = await buscarDesempenhoCompetencias(estado.tentativaId);
          if (!cancelado) setCompetencias(linhas);
        } else {
          setCompetencias(null);
        }
      } catch {
        if (!cancelado) setErro("Não foi possível carregar o resultado deste simulado.");
      } finally {
        if (!cancelado) setCarregando(false);
      }
    }

    carregar();
    return () => {
      cancelado = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [aluno, simuladoId, navigate]);

  if (!aluno || !simuladoId) return null;

  if (carregando) {
    return (
      <div className="pagina">
        <div className="container">
          <div className="cartao">
            <p className="texto-suave">Carregando resultado...</p>
          </div>
        </div>
      </div>
    );
  }

  const atual = historico.find((t) => t.numero_tentativa === numeroAtual);

  if (erro || !atual) {
    return (
      <div className="pagina">
        <div className="container">
          <div className="cartao">
            <p className="mensagem-erro">{erro ?? "Resultado indisponível."}</p>
            <button type="button" className="botao botao-primario botao-bloco" onClick={() => navigate("/simulados")}>
              Ver meus simulados
            </button>
          </div>
        </div>
      </div>
    );
  }

  const mensagemTentativa = MENSAGEM_POR_TENTATIVA[atual.numero_tentativa] ?? MENSAGEM_TENTATIVA_EXTRA;
  const anterior = historico.find((t) => t.numero_tentativa === atual.numero_tentativa - 1);

  const notasTresPrimeiras = [1, 2, 3]
    .map((n) => historico.find((t) => t.numero_tentativa === n)?.nota)
    .filter((n): n is number => n !== null && n !== undefined);
  const temTresPrimeiras = notasTresPrimeiras.length === 3;
  const mediaTresPrimeiras = temTresPrimeiras
    ? notasTresPrimeiras.reduce((a, b) => a + b, 0) / 3
    : null;
  const pontoExtra = mediaTresPrimeiras !== null ? mediaTresPrimeiras / 10 : null;

  return (
    <div className="pagina">
      <div className="container">
        <div className="cartao">
          <h1 className="titulo-pagina">{simulado?.disciplina.nome ?? "Resultado"}</h1>
          <p className="subtitulo-pagina">
            Tentativa {atual.numero_tentativa}
            {atual.numero_tentativa <= 3 ? " de 3" : ""} — {mensagemTentativa}
          </p>

          <div style={{ display: "flex", gap: 12, flexWrap: "wrap", marginBottom: 24 }}>
            <div style={{ flex: "1 1 120px", textAlign: "center", padding: "16px 8px", background: "var(--cor-fundo)", borderRadius: 8 }}>
              <div style={{ fontSize: "2rem", fontWeight: 700 }}>{formatarNota(atual.nota)}</div>
              <div className="texto-suave" style={{ fontSize: "0.8rem" }}>Nota</div>
            </div>
            <div style={{ flex: "1 1 120px", textAlign: "center", padding: "16px 8px", background: "var(--cor-fundo)", borderRadius: 8 }}>
              <div style={{ fontSize: "2rem", fontWeight: 700, color: "var(--cor-sucesso)" }}>{atual.acertos}</div>
              <div className="texto-suave" style={{ fontSize: "0.8rem" }}>Acertos</div>
            </div>
            <div style={{ flex: "1 1 120px", textAlign: "center", padding: "16px 8px", background: "var(--cor-fundo)", borderRadius: 8 }}>
              <div style={{ fontSize: "2rem", fontWeight: 700, color: "var(--cor-erro)" }}>{atual.erros}</div>
              <div className="texto-suave" style={{ fontSize: "0.8rem" }}>Erros</div>
            </div>
            <div style={{ flex: "1 1 120px", textAlign: "center", padding: "16px 8px", background: "var(--cor-fundo)", borderRadius: 8 }}>
              <div style={{ fontSize: "2rem", fontWeight: 700 }}>
                {atual.tempo_segundos !== null ? formatarTempo(atual.tempo_segundos) : "—"}
              </div>
              <div className="texto-suave" style={{ fontSize: "0.8rem" }}>Tempo</div>
            </div>
          </div>

          {anterior && anterior.nota !== null && atual.nota !== null && (
            <div
              style={{
                marginBottom: 24,
                padding: "12px 16px",
                borderRadius: 8,
                background: "var(--cor-fundo)",
                display: "flex",
                alignItems: "center",
                gap: 10,
                flexWrap: "wrap",
              }}
            >
              <span
                className={`emblema ${
                  atual.nota > anterior.nota
                    ? "emblema-sucesso"
                    : atual.nota < anterior.nota
                      ? "emblema-erro"
                      : "emblema-neutro"
                }`}
              >
                {atual.nota > anterior.nota ? "Melhorou" : atual.nota < anterior.nota ? "Piorou" : "Manteve"}
              </span>
              <span className="texto-suave">
                Nota da tentativa {anterior.numero_tentativa}: {formatarNota(anterior.nota)} → tentativa{" "}
                {atual.numero_tentativa}: {formatarNota(atual.nota)}
              </span>
            </div>
          )}

          {historico.length > 1 && (
            <>
              <h2 style={{ fontSize: "1rem", fontWeight: 600, margin: "0 0 12px" }}>Histórico de tentativas</h2>
              <div className="tabela-wrap" style={{ marginBottom: 24 }}>
                <table className="tabela">
                  <thead>
                    <tr>
                      <th>Tentativa</th>
                      <th>Nota</th>
                      <th>Acertos</th>
                      <th>Erros</th>
                      <th>Tempo</th>
                    </tr>
                  </thead>
                  <tbody>
                    {historico.map((t) => (
                      <tr key={t.numero_tentativa}>
                        <td>
                          {t.numero_tentativa}
                          {t.numero_tentativa === atual.numero_tentativa ? " (atual)" : ""}
                        </td>
                        <td>{formatarNota(t.nota)}</td>
                        <td>{t.acertos ?? "—"}</td>
                        <td>{t.erros ?? "—"}</td>
                        <td>{t.tempo_segundos !== null ? formatarTempo(t.tempo_segundos) : "—"}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </>
          )}

          {pontoExtra !== null && (
            <div
              style={{
                marginBottom: 24,
                padding: "16px",
                borderRadius: 8,
                background: "var(--cor-fundo)",
                display: "flex",
                gap: 24,
                flexWrap: "wrap",
              }}
            >
              <div>
                <div style={{ fontSize: "1.5rem", fontWeight: 700 }}>{formatarNota(mediaTresPrimeiras)}</div>
                <div className="texto-suave" style={{ fontSize: "0.8rem" }}>Média das 3 primeiras notas</div>
              </div>
              <div>
                <div style={{ fontSize: "1.5rem", fontWeight: 700 }}>{formatarPontoExtra(pontoExtra)}</div>
                <div className="texto-suave" style={{ fontSize: "0.8rem" }}>Ponto extra</div>
              </div>
            </div>
          )}

          <h2 style={{ fontSize: "1rem", fontWeight: 600, margin: "0 0 12px" }}>Desempenho por competência</h2>

          {competencias === null || competencias.length === 0 ? (
            <p className="texto-suave">
              {competencias === null
                ? "Detalhamento por competência disponível apenas logo após finalizar esta tentativa."
                : "Nenhuma competência associada às questões deste simulado."}
            </p>
          ) : (
            <div className="tabela-wrap">
              <table className="tabela">
                <thead>
                  <tr>
                    <th>Competência</th>
                    <th>Acertos</th>
                    <th>Erros</th>
                    <th>% acerto</th>
                  </tr>
                </thead>
                <tbody>
                  {competencias.map((c) => {
                    const percentual = c.total_questoes > 0 ? Math.round((c.acertos / c.total_questoes) * 100) : 0;
                    return (
                      <tr key={c.competencia_id ?? c.competencia_nome}>
                        <td style={{ whiteSpace: "normal" }}>{c.competencia_nome}</td>
                        <td>{c.acertos}</td>
                        <td>{c.erros}</td>
                        <td>
                          <span className={`emblema ${classeEmblema(percentual)}`}>{percentual}%</span>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}

          <button
            type="button"
            className="botao botao-primario botao-bloco"
            style={{ marginTop: 24 }}
            onClick={() => navigate("/simulados")}
          >
            Ver meus simulados
          </button>
        </div>
      </div>
    </div>
  );
}
