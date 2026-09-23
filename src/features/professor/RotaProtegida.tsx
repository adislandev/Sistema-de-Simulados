import type { ReactNode } from "react";
import { Navigate } from "react-router-dom";
import { useSessaoProfessor } from "./useSessaoProfessor";

export default function RotaProtegida({ children }: { children: ReactNode }) {
  const { sessao, carregando } = useSessaoProfessor();

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

  if (!sessao) {
    return <Navigate to="/professor/login" replace />;
  }

  return children;
}
