import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Button from "../../../components/Button/Button";
import Card from "../../../components/Card/Card";
import Field from "../../../components/Field/Field";
import PageLayout from "../../../components/PageLayout/PageLayout";
import { supabase } from "../../../lib/supabaseClient";
import { useSessaoProfessor } from "../useSessaoProfessor";

export default function Login() {
  const navigate = useNavigate();
  const { sessao, carregando } = useSessaoProfessor();
  const [email, setEmail] = useState("");
  const [senha, setSenha] = useState("");
  const [enviando, setEnviando] = useState(false);
  const [erro, setErro] = useState<string | null>(null);

  if (!carregando && sessao) {
    navigate("/professor", { replace: true });
    return null;
  }

  async function entrar(evento: React.FormEvent) {
    evento.preventDefault();
    setEnviando(true);
    setErro(null);
    const { error } = await supabase.auth.signInWithPassword({ email, password: senha });
    if (error) {
      setErro("E-mail ou senha inválidos.");
      setEnviando(false);
      return;
    }
    navigate("/professor", { replace: true });
  }

  return (
    <PageLayout>
      <Card>
        <h1 className="text-2xl font-bold mb-1">Painel do professor</h1>
        <p className="text-ink-soft mb-6 text-[0.95rem]">
          Entre com sua conta para acessar os resultados.
        </p>

        <form onSubmit={entrar}>
          <Field
            label="E-mail"
            id="email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            autoFocus
          />
          <Field
            label="Senha"
            id="senha"
            type="password"
            value={senha}
            onChange={(e) => setSenha(e.target.value)}
            required
          />

          {erro && <p className="text-danger-500 text-sm mb-4">{erro}</p>}

          <Button type="submit" fullWidth disabled={enviando}>
            {enviando ? "Entrando..." : "Entrar"}
          </Button>
        </form>
      </Card>
    </PageLayout>
  );
}
