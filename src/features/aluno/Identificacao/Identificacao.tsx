import { useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import Button from "../../../components/Button/Button";
import Card from "../../../components/Card/Card";
import Field from "../../../components/Field/Field";
import PageLayout from "../../../components/PageLayout/PageLayout";
import { buscarAlunosPorNome, criarAluno, tocarAluno } from "../../../lib/alunoApi";
import { limparAlunoSessao, obterAlunoSessao, salvarAlunoSessao } from "../../../lib/alunoSession";
import type { AlunoCandidato } from "../../../types/database";

type Etapa = "formulario" | "escolha";

export default function Identificacao() {
  const navigate = useNavigate();
  const location = useLocation();
  const proximoSimuladoId = (location.state as { proximoSimuladoId?: string } | null)?.proximoSimuladoId;
  const destino = proximoSimuladoId ? `/simulados/${proximoSimuladoId}/instrucoes` : "/simulados";
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
      navigate(destino);
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
    navigate(destino);
  }

  async function handleSelecionarCandidato(candidato: AlunoCandidato) {
    setCarregando(true);
    setErro(null);
    try {
      await tocarAluno(candidato.id);
      salvarAlunoSessao({ id: candidato.id, nome: candidato.nome });
      navigate(destino);
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
      <PageLayout>
        <Card>
          <h1 className="text-2xl font-bold mb-1">Bem-vindo de volta, {sessaoExistente.nome}</h1>
          <p className="text-ink-soft mb-6 text-[0.95rem]">
            Continuar com esta identificação ou usar outro nome?
          </p>
          {erro && <p className="text-danger-500 text-sm mb-4">{erro}</p>}
          <Button fullWidth onClick={continuarComoSessaoExistente} disabled={carregando} className="mb-3">
            Continuar como {sessaoExistente.nome}
          </Button>
          <Button variant="secondary" fullWidth onClick={trocarAluno}>
            Usar outro nome
          </Button>
        </Card>
      </PageLayout>
    );
  }

  return (
    <PageLayout>
      <Card>
        <h1 className="text-2xl font-bold mb-1">Simulados Acadêmicos</h1>
        <p className="text-ink-soft mb-6 text-[0.95rem]">Informe seu nome completo para começar.</p>

        {etapa === "formulario" && (
          <form onSubmit={handleSubmitFormulario}>
            <Field
              label="Nome completo"
              id="nome"
              type="text"
              value={nome}
              onChange={(e) => setNome(e.target.value)}
              autoFocus
              autoComplete="name"
            />
            <Field
              label="Turma (opcional)"
              id="turma"
              type="text"
              value={turma}
              onChange={(e) => setTurma(e.target.value)}
              autoComplete="off"
            />
            {erro && <p className="text-danger-500 text-sm mb-4">{erro}</p>}
            <Button type="submit" fullWidth disabled={carregando}>
              {carregando ? "Verificando..." : "Continuar"}
            </Button>
          </form>
        )}

        {etapa === "escolha" && (
          <div>
            <p className="text-ink-soft mb-4 text-[0.95rem]">
              Encontramos cadastros parecidos com "{nome.trim()}". Algum deles é você?
            </p>
            {erro && <p className="text-danger-500 text-sm mb-4">{erro}</p>}
            {candidatos.map((candidato) => (
              <Button
                key={candidato.id}
                variant="option"
                fullWidth
                className="mb-2"
                onClick={() => handleSelecionarCandidato(candidato)}
                disabled={carregando}
              >
                {candidato.nome}
                {candidato.turma ? ` — ${candidato.turma}` : ""}
              </Button>
            ))}
            <Button fullWidth className="mt-4" onClick={handleContinuarComoNovo} disabled={carregando}>
              Nenhum desses, sou novo aluno
            </Button>
            <Button
              variant="secondary"
              fullWidth
              className="mt-3"
              onClick={() => setEtapa("formulario")}
              disabled={carregando}
            >
              Voltar
            </Button>
          </div>
        )}
      </Card>
    </PageLayout>
  );
}
