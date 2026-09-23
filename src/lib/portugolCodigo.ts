export interface BlocoCodigoPortugol {
  antes: string;
  codigo: string;
  depois: string;
  titulo: string | null;
}

export type TipoTokenPortugol = "keyword" | "comment" | "texto";

export interface TokenPortugol {
  texto: string;
  tipo: TipoTokenPortugol;
}

const PALAVRAS_RESERVADAS = new Set([
  "algoritmo",
  "var",
  "inteiro",
  "real",
  "caractere",
  "logico",
  "inicio",
  "fimalgoritmo",
  "leia",
  "escreva",
  "escreval",
  "se",
  "entao",
  "senao",
  "fimse",
  "repita",
  "ate",
  "enquanto",
  "faca",
  "fimenquanto",
  "para",
  "de",
  "fimpara",
  "funcao",
  "fimfuncao",
]);

const FENCE_RE = /```[ \t]*[A-Za-z]*[ \t]*\r?\n([\s\S]*?)\r?\n[ \t]*```/;
const TITULO_RE = /algoritmo\s+"([^"]+)"/i;

export function extrairBlocoCodigo(enunciado: string): BlocoCodigoPortugol | null {
  const match = FENCE_RE.exec(enunciado);
  if (!match) return null;

  const antes = enunciado.slice(0, match.index).trim();
  const depois = enunciado.slice(match.index + match[0].length).trim();
  const codigo = match[1].replace(/\r\n/g, "\n");

  const tituloMatch = TITULO_RE.exec(codigo);
  const titulo = tituloMatch ? `Algoritmo ${tituloMatch[1]}` : null;

  return { antes, codigo, depois, titulo };
}

const TOKEN_RE = /\/\/.*|[A-Za-zÀ-ÿ_][A-Za-zÀ-ÿ0-9_]*|\d+(?:\.\d+)?|\s+|./g;

export function tokenizarLinha(linha: string): TokenPortugol[] {
  const tokens: TokenPortugol[] = [];
  const matches = linha.match(TOKEN_RE) ?? [];

  for (const texto of matches) {
    if (texto.startsWith("//")) {
      tokens.push({ texto, tipo: "comment" });
    } else if (/^[A-Za-zÀ-ÿ_]/.test(texto) && PALAVRAS_RESERVADAS.has(texto.toLowerCase())) {
      tokens.push({ texto, tipo: "keyword" });
    } else {
      tokens.push({ texto, tipo: "texto" });
    }
  }

  return tokens;
}
