import { useState } from "react";
import { useNavigate } from "react-router-dom";
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
    <div className="pagina">
      <div className="container">
        <div className="cartao">
          <h1 className="titulo-pagina">Painel do professor</h1>
          <p className="subtitulo-pagina">Entre com sua conta para acessar os resultados.</p>

          <form onSubmit={entrar}>
            <div className="campo">
              <label htmlFor="email">E-mail</label>
              <input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                autoFocus
              />
            </div>
            <div className="campo">
              <label htmlFor="senha">Senha</label>
              <input
                id="senha"
                type="password"
                value={senha}
                onChange={(e) => setSenha(e.target.value)}
                required
              />
            </div>

            {erro && <p className="mensagem-erro">{erro}</p>}

            <button type="submit" className="botao botao-primario botao-bloco" disabled={enviando}>
              {enviando ? "Entrando..." : "Entrar"}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
