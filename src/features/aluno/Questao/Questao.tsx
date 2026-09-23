import { useEffect, useRef, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import PortugolCodeBlock from "../../../components/PortugolCodeBlock/PortugolCodeBlock";
import {
  buscarQuestoesSimulado,
  finalizarTentativa,
  iniciarTentativa,
  responderQuestao,
} from "../../../lib/alunoApi";
import { obterAlunoSessao } from "../../../lib/alunoSession";
import { formatarTempo } from "../../../lib/format";
import { montarQuestoes } from "../../../lib/montarQuestoes";
import { extrairBlocoCodigo } from "../../../lib/portugolCodigo";
import type { IniciarTentativaResultado, QuestaoMontada } from "../../../types/database";

export default function Questao() {
  const navigate = useNavigate();
  const { simuladoId } = useParams<{ simuladoId: string }>();
  const [aluno] = useState(obterAlunoSessao());

  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState<string | null>(null);
  const [enviando, setEnviando] = useState(false);

  const [tentativa, setTentativa] = useState<IniciarTentativaResultado | null>(null);
  const [questoes, setQuestoes] = useState<QuestaoMontada[]>([]);
  const [indice, setIndice] = useState(0);
  const [selecionada, setSelecionada] = useState<string | null>(null);
  const [segundosDecorridos, setSegundosDecorridos] = useState(0);

  const inicioSimuladoRef = useRef(0);
  const inicioQuestaoRef = useRef(0);

  useEffect(() => {
    if (!aluno || !simuladoId) {
      navigate("/", { replace: true, state: { proximoSimuladoId: simuladoId } });
      return;
    }

    let cancelado = false;

    async function carregar() {
      try {
        const [tentativaResultado, linhas] = await Promise.all([
          iniciarTentativa(aluno!.id, simuladoId!),
          buscarQuestoesSimulado(simuladoId!),
        ]);
        if (cancelado) return;
        inicioSimuladoRef.current = Date.now();
        inicioQuestaoRef.current = Date.now();
        setTentativa(tentativaResultado);
        setQuestoes(montarQuestoes(linhas));
      } catch {
        if (!cancelado) setErro("Não foi possível iniciar o simulado. Tente novamente.");
      } finally {
        if (!cancelado) setCarregando(false);
      }
    }

    carregar();
    return () => {
      cancelado = true;
    };
  }, [aluno, simuladoId, navigate]);

  useEffect(() => {
    if (carregando) return;
    const intervalo = setInterval(() => {
      setSegundosDecorridos(Math.floor((Date.now() - inicioSimuladoRef.current) / 1000));
    }, 1000);
    return () => clearInterval(intervalo);
  }, [carregando]);

  useEffect(() => {
    inicioQuestaoRef.current = Date.now();
  }, [indice]);

  if (!aluno || !simuladoId) return null;

  async function confirmar() {
    if (!selecionada || !tentativa || enviando) return;

    const questaoAtual = questoes[indice];
    const ultima = indice === questoes.length - 1;
    const tempoResposta = Math.round((Date.now() - inicioQuestaoRef.current) / 1000);

    setEnviando(true);
    setErro(null);
    try {
      await responderQuestao({
        tentativaId: tentativa.tentativa_id,
        questaoId: questaoAtual.questao_id,
        alternativaId: selecionada,
        ordemApresentacao: indice + 1,
        tempoRespostaSegundos: tempoResposta,
      });
      await avancar(ultima);
    } catch (e) {
      const jaRespondida = e instanceof Error && e.message.includes("já foi respondida");
      const jaFinalizada = e instanceof Error && e.message.includes("já finalizada");
      if (jaRespondida) {
        await avancar(ultima);
      } else if (jaFinalizada) {
        // Tentativa já foi finalizada em outra aba/navegação (ex.: usuário
        // voltou pelo botão do navegador depois de já ter terminado). Não há
        // mais o que responder aqui — manda para o resultado já registrado.
        navigate(`/simulados/${simuladoId}/resultado`, { replace: true });
      } else {
        setErro("Não foi possível registrar sua resposta. Tente novamente.");
        setEnviando(false);
      }
    }
  }

  async function avancar(ultima: boolean) {
    if (!ultima) {
      setIndice((i) => i + 1);
      setSelecionada(null);
      setEnviando(false);
      return;
    }

    try {
      const tempoTotal = Math.round((Date.now() - inicioSimuladoRef.current) / 1000);
      const resultado = await finalizarTentativa(tentativa!.tentativa_id, tempoTotal);
      navigate(`/simulados/${simuladoId}/resultado`, {
        replace: true,
        state: {
          tentativaId: tentativa!.tentativa_id,
          resultado,
          numeroTentativa: tentativa!.numero_tentativa,
          tempoSegundos: tempoTotal,
        },
      });
    } catch {
      setErro("Não foi possível finalizar o simulado. Tente novamente.");
      setEnviando(false);
    }
  }

  if (carregando) {
    return (
      <div className="pagina">
        <div className="container">
          <div className="cartao">
            <p className="texto-suave">Carregando...</p>
          </div>
        </div>
      </div>
    );
  }

  if (erro && questoes.length === 0) {
    return (
      <div className="pagina">
        <div className="container">
          <div className="cartao">
            <p className="mensagem-erro">{erro}</p>
          </div>
        </div>
      </div>
    );
  }

  const questaoAtual = questoes[indice];
  const blocoCodigo = extrairBlocoCodigo(questaoAtual.enunciado);

  return (
    <div className="pagina">
      <div className="container">
        <div className="cartao">
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", marginBottom: 16 }}>
            <span className="texto-suave">
              Questão {indice + 1} de {questoes.length}
            </span>
            <span className="texto-suave">{formatarTempo(segundosDecorridos)}</span>
          </div>

          {blocoCodigo ? (
            <>
              {blocoCodigo.antes && (
                <p className="titulo-pagina" style={{ fontSize: "1.15rem", fontWeight: 600, marginBottom: 0 }}>
                  {blocoCodigo.antes}
                </p>
              )}
              <PortugolCodeBlock codigo={blocoCodigo.codigo} titulo={blocoCodigo.titulo} />
              {blocoCodigo.depois && (
                <p className="titulo-pagina" style={{ fontSize: "1.15rem", fontWeight: 600, marginTop: 0 }}>
                  {blocoCodigo.depois}
                </p>
              )}
            </>
          ) : (
            <h1 className="titulo-pagina" style={{ fontSize: "1.15rem", fontWeight: 600 }}>
              {questaoAtual.enunciado}
            </h1>
          )}

          <div style={{ marginTop: 20 }}>
            {questaoAtual.alternativas.map((alternativa) => (
              <button
                key={alternativa.id}
                type="button"
                className={`botao botao-bloco ${selecionada === alternativa.id ? "botao-primario" : "botao-secundario"}`}
                style={{ marginBottom: 8, justifyContent: "flex-start", textAlign: "left" }}
                onClick={() => setSelecionada(alternativa.id)}
                disabled={enviando}
              >
                {alternativa.texto}
              </button>
            ))}
          </div>

          {erro && <p className="mensagem-erro">{erro}</p>}

          <button
            type="button"
            className="botao botao-primario botao-bloco"
            style={{ marginTop: 8 }}
            onClick={confirmar}
            disabled={!selecionada || enviando}
          >
            {enviando ? "Enviando..." : "Confirmar e avançar"}
          </button>
        </div>
      </div>
    </div>
  );
}
