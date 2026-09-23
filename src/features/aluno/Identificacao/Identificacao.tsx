import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { buscarAlunosPorNome, criarAluno, tocarAluno } from "../../../lib/alunoApi";
import { limparAlunoSessao, obterAlunoSessao, salvarAlunoSessao } from "../../../lib/alunoSession";
import type { AlunoCandidato } from "../../../types/database";

type Etapa = "formulario" | "escolha";

export default function Identificacao() {
  const navigate = useNavigate();
  const [sessaoExistente, setSessaoExistente] = useState(obterAlunoSessao());
  const [nome, setNome] = useState("");
  const [turma, setTurma] = useState("");
  const [etapa, setEtapa] = useState<Etapa>("formulario");
  const [candidatos, setCandidatos] = useState<AlunoCandidato[]>([]);
  const [erro, setErro] = useState<string | null>(null);
  const [carregando, setCarregando] = useState(false);

  async function continuarComoSessaoExistente() {
    if (!sessaoExistente) return;
    setCarregando(true);
    try {
      await tocarAluno(sessaoExistente.id);
      navigate("/simulados");
    } catch {
      setErro("Não foi possível continuar. Tente novamente.");
    } finally {
      setCarregando(false);
    }
  }

  function trocarAluno() {
    limparAlunoSessao();
    setSessaoExistente(null);
  }

  async function handleSubmitFormulario(evento: React.FormEvent) {
    evento.preventDefault();
    setErro(null);

    const nomeTratado = nome.trim();
    if (nomeTratado.length < 3) {
      setErro("Informe seu nome completo.");
      return;
    }

    setCarregando(true);
    try {
      const encontrados = await buscarAlunosPorNome(nomeTratado);
      if (encontrados.length === 0) {
        await identificarComoNovo(nomeTratado);
      } else {
        setCandidatos(encontrados);
        setEtapa("escolha");
      }
    } catch {
      setErro("Não foi possível verificar seu cadastro. Tente novamente.");
    } finally {
      setCarregando(false);
    }
  }

  async function identificarComoNovo(nomeTratado: string) {
    const id = await criarAluno(nomeTratado, turma.trim() || undefined);
    salvarAlunoSessao({ id, nome: nomeTratado });
    navigate("/simulados");
  }

  async function handleSelecionarCandidato(candidato: AlunoCandidato) {
    setCarregando(true);
    setErro(null);
    try {
      await tocarAluno(candidato.id);
      salvarAlunoSessao({ id: candidato.id, nome: candidato.nome });
      navigate("/simulados");
    } catch {
      setErro("Não foi possível continuar. Tente novamente.");
    } finally {
      setCarregando(false);
    }
  }

  async function handleContinuarComoNovo() {
    setCarregando(true);
    setErro(null);
    try {
      await identificarComoNovo(nome.trim());
    } catch {
      setErro("Não foi possível concluir seu cadastro. Tente novamente.");
    } finally {
      setCarregando(false);
    }
  }

  if (sessaoExistente) {
    return (
      <div className="pagina">
        <div className="container">
          <div className="cartao">
            <h1 className="titulo-pagina">Bem-vindo de volta, {sessaoExistente.nome}</h1>
            <p className="subtitulo-pagina">Continuar com esta identificação ou usar outro nome?</p>
            {erro && <p className="mensagem-erro">{erro}</p>}
            <button
              type="button"
              className="botao botao-primario botao-bloco"
              onClick={continuarComoSessaoExistente}
              disabled={carregando}
            >
              Continuar como {sessaoExistente.nome}
            </button>
            <div style={{ marginTop: 12 }}>
              <button type="button" className="botao botao-secundario botao-bloco" onClick={trocarAluno}>
                Usar outro nome
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="pagina">
      <div className="container">
        <div className="cartao">
          <h1 className="titulo-pagina">Simulados Acadêmicos</h1>
          <p className="subtitulo-pagina">Informe seu nome completo para começar.</p>

          {etapa === "formulario" && (
            <form onSubmit={handleSubmitFormulario}>
              <div className="campo">
                <label htmlFor="nome">Nome completo</label>
                <input
                  id="nome"
                  type="text"
                  value={nome}
                  onChange={(e) => setNome(e.target.value)}
                  autoFocus
                  autoComplete="name"
                />
              </div>
              <div className="campo">
                <label htmlFor="turma">Turma (opcional)</label>
                <input
                  id="turma"
                  type="text"
                  value={turma}
                  onChange={(e) => setTurma(e.target.value)}
                  autoComplete="off"
                />
              </div>
              {erro && <p className="mensagem-erro">{erro}</p>}
              <button type="submit" className="botao botao-primario botao-bloco" disabled={carregando}>
                {carregando ? "Verificando..." : "Continuar"}
              </button>
            </form>
          )}

          {etapa === "escolha" && (
            <div>
              <p className="subtitulo-pagina">
                Encontramos cadastros parecidos com "{nome.trim()}". Algum deles é você?
              </p>
              {erro && <p className="mensagem-erro">{erro}</p>}
              {candidatos.map((candidato) => (
                <button
                  key={candidato.id}
                  type="button"
                  className="botao botao-secundario botao-bloco"
                  style={{ marginBottom: 8, justifyContent: "flex-start" }}
                  onClick={() => handleSelecionarCandidato(candidato)}
                  disabled={carregando}
                >
                  {candidato.nome}
                  {candidato.turma ? ` — ${candidato.turma}` : ""}
                </button>
              ))}
              <div style={{ marginTop: 16 }}>
                <button
                  type="button"
                  className="botao botao-primario botao-bloco"
                  onClick={handleContinuarComoNovo}
                  disabled={carregando}
                >
                  Nenhum desses, sou novo aluno
                </button>
              </div>
              <div style={{ marginTop: 12 }}>
                <button
                  type="button"
                  className="botao botao-secundario botao-bloco"
                  onClick={() => setEtapa("formulario")}
                  disabled={carregando}
                >
                  Voltar
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
