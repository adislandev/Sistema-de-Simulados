import { tokenizarLinha, type TipoTokenPortugol } from "../../lib/portugolCodigo";

interface PortugolCodeBlockProps {
  codigo: string;
  titulo?: string | null;
}

const CLASSES_TOKEN: Record<TipoTokenPortugol, string> = {
  keyword: "text-primary-600 font-semibold underline decoration-primary-400",
  comment: "text-ink-soft italic",
  texto: "text-ink",
};

function limparLinhasExtremas(codigo: string): string[] {
  const linhas = codigo.split("\n");
  while (linhas.length && linhas[0].trim() === "") linhas.shift();
  while (linhas.length && linhas[linhas.length - 1].trim() === "") linhas.pop();
  return linhas;
}

export default function PortugolCodeBlock({ codigo, titulo }: PortugolCodeBlockProps) {
  const linhas = limparLinhasExtremas(codigo);

  return (
    <figure className="my-4">
      <div className="rounded-md border border-primary-100 bg-surface shadow-card overflow-x-auto">
        <pre className="m-0 p-0 font-mono text-sm leading-relaxed">
          {linhas.map((linha, indice) => (
            <div key={indice} className="flex">
              <span className="select-none shrink-0 w-9 sm:w-10 text-right pr-2 sm:pr-3 py-0.5 text-ink-soft/70 border-r border-primary-100 bg-bg">
                {indice + 1}
              </span>
              <span className="whitespace-pre pl-3 pr-4 py-0.5">
                {tokenizarLinha(linha).map((token, i) => (
                  <span key={i} className={CLASSES_TOKEN[token.tipo]}>
                    {token.texto}
                  </span>
                ))}
                {linha.length === 0 && " "}
              </span>
            </div>
          ))}
        </pre>
      </div>
      {titulo && <figcaption className="text-center text-ink-soft text-xs sm:text-sm mt-2 italic">{titulo}</figcaption>}
    </figure>
  );
}
