export default function CartaoResumo({
  icone,
  cor,
  corFundo,
  label,
  valor,
}: {
  icone: React.ReactNode;
  cor: string;
  corFundo: string;
  label: string;
  valor: number | string;
}) {
  return (
    <div className="cartao" style={{ padding: 16, display: "flex", alignItems: "center", gap: 14 }}>
      <span
        aria-hidden="true"
        style={{
          display: "inline-flex",
          alignItems: "center",
          justifyContent: "center",
          width: 40,
          height: 40,
          borderRadius: 10,
          background: corFundo,
          color: cor,
          flexShrink: 0,
        }}
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          {icone}
        </svg>
      </span>
      <div>
        <p className="texto-suave" style={{ margin: "0 0 2px" }}>{label}</p>
        <p style={{ margin: 0, fontSize: "1.5rem", fontWeight: 700 }}>{valor}</p>
      </div>
    </div>
  );
}
