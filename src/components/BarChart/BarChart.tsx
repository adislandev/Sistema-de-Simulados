import type { ReactNode } from "react";

export interface BarChartItem {
  label: string;
  valor: number;
  maximo: number;
  cor?: string;
  legenda?: ReactNode;
}

interface BarChartProps {
  itens: BarChartItem[];
}

export default function BarChart({ itens }: BarChartProps) {
  if (itens.length === 0) return null;

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
      {itens.map((item, indice) => {
        const percentual = item.maximo > 0 ? Math.min(100, Math.max(0, (item.valor / item.maximo) * 100)) : 0;
        return (
          <div key={indice}>
            <div
              style={{
                display: "flex",
                justifyContent: "space-between",
                gap: 8,
                fontSize: "0.85rem",
                marginBottom: 3,
              }}
            >
              <span>{item.label}</span>
              <span className="texto-suave">{item.legenda ?? item.valor}</span>
            </div>
            <div style={{ background: "var(--cor-fundo)", borderRadius: 6, height: 10, overflow: "hidden" }}>
              <div
                style={{
                  width: `${percentual}%`,
                  height: "100%",
                  borderRadius: 6,
                  background: item.cor ?? "var(--cor-primaria)",
                }}
              />
            </div>
          </div>
        );
      })}
    </div>
  );
}
