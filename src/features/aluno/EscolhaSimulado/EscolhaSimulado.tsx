import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { listarSimuladosAtivos, type SimuladoComDisciplina } from "../../../lib/alunoApi";
import { obterAlunoSessao } from "../../../lib/alunoSession";

export default function EscolhaSimulado() {
  const navigate = useNavigate();
  const [aluno] = useState(obterAlunoSessao());
  const [simulados, setSimulados] = useState<SimuladoComDisciplina[]>([]);
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState<string | null>(null);

  useEffect(() => {
    if (!aluno) {
      navigate("/", { replace: true });
      return;
    }

    listarSimuladosAtivos()
      .then(setSimulados)
      .catch(() => setErro("Não foi possível carregar os simulados disponíveis."))
      .finally(() => setCarregando(false));
  }, [aluno, navigate]);

  if (!aluno) return null;

  return (
    <div className="pagina">
      <div className="container">
        <div className="cartao">
          <h1 className="titulo-pagina">Olá, {aluno.nome}</h1>
          <p className="subtitulo-pagina">Escolha o simulado que deseja fazer.</p>

          {carregando && <p className="texto-suave">Carregando...</p>}
          {erro && <p className="mensagem-erro">{erro}</p>}

          {!carregando && !erro && simulados.length === 0 && (
            <p className="texto-suave">Nenhum simulado disponível no momento.</p>
          )}

          {simulados.map((simulado) => (
            <button
              key={simulado.id}
              type="button"
              className="botao botao-secundario botao-bloco"
              style={{ marginBottom: 8, justifyContent: "flex-start", flexDirection: "column", alignItems: "flex-start", padding: "16px 20px" }}
              onClick={() => navigate(`/simulados/${simulado.id}/instrucoes`)}
            >
              <strong>{simulado.disciplina.nome}</strong>
              <span className="texto-suave">{simulado.titulo} — {simulado.qtd_questoes} questões</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
