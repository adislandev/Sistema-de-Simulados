import { useEffect, useState } from "react";
import "./BarraProgresso.css";

interface Props {
  /** Texto exibido acima da barra. */
  rotulo: string;
  /** Com duracaoMs, a barra sobe de 0 a 100% e mostra um contador regressivo; sem, fica indeterminada. */
  duracaoMs?: number;
}

export default function BarraProgresso({ rotulo, duracaoMs }: Props) {
  const [decorridoMs, setDecorridoMs] = useState(0);

  useEffect(() => {
    if (!duracaoMs) return;
    const inicio = Date.now();
    const id = window.setInterval(() => setDecorridoMs(Math.min(Date.now() - inicio, duracaoMs)), 200);
    return () => window.clearInterval(id);
  }, [duracaoMs]);

  const determinada = typeof duracaoMs === "number";
  const percentual = determinada ? (decorridoMs / duracaoMs) * 100 : 0;
  const restanteSeg = determinada ? Math.ceil((duracaoMs - decorridoMs) / 1000) : 0;

  return (
    <div className="barra-progresso" role="status" aria-live="polite">
      <div className="barra-progresso-rotulo">
        <span>{rotulo}</span>
        {determinada && <span>{restanteSeg}s</span>}
      </div>
      <div className="barra-progresso-trilho">
        <div
          className={determinada ? "barra-progresso-preenchimento" : "barra-progresso-indeterminada"}
          style={determinada ? { width: `${percentual}%` } : undefined}
        />
      </div>
    </div>
  );
}
