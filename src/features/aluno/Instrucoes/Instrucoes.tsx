import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { buscarSimulado, type SimuladoComDisciplina } from "../../../lib/alunoApi";
import { obterAlunoSessao } from "../../../lib/alunoSession";

export default function Instrucoes() {
  const navigate = useNavigate();
  const { simuladoId } = useParams<{ simuladoId: string }>();
  const [aluno] = useState(obterAlunoSessao());
  const [simulado, setSimulado] = useState<SimuladoComDisciplina | null>(null);
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState<string | null>(null);

  useEffect(() => {
    if (!aluno || !simuladoId) {
      navigate("/", { replace: true });
      return;
    }

    buscarSimulado(simuladoId)
      .then(setSimulado)
      .catch(() => setErro("Não foi possível carregar as instruções deste simulado."))
      .finally(() => setCarregando(false));
  }, [aluno, simuladoId, navigate]);

  if (!aluno || !simuladoId) return null;

  return (
    <div className="pagina">
      <div className="container">
        <div className="cartao">
          {carregando && <p className="texto-suave">Carregando...</p>}
          {erro && <p className="mensagem-erro">{erro}</p>}

          {simulado && (
            <>
              <h1 className="titulo-pagina">{simulado.disciplina.nome}</h1>
              <p className="subtitulo-pagina">
                {simulado.titulo} — {simulado.qtd_questoes} questões
              </p>

              <ul style={{ margin: "0 0 24px", paddingLeft: 20, color: "var(--cor-texto-suave)", lineHeight: 1.7 }}>
                <li>Uma questão por tela.</li>
                <li>Questões e alternativas embaralhadas.</li>
                <li>O cronômetro começa a contar assim que você iniciar.</li>
                <li>Selecione uma alternativa e confirme para avançar.</li>
                <li>Depois de confirmada, a resposta não pode ser alterada.</li>
                <li>Não é possível voltar para uma questão anterior.</li>
              </ul>

              <button
                type="button"
                className="botao botao-primario botao-bloco"
                onClick={() => navigate(`/simulados/${simuladoId}/questao`)}
              >
                Iniciar simulado
              </button>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
