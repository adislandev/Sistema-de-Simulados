// Dispara manualmente o workflow do GitHub Actions que corrige as provas
// presenciais (omr-correcao.yml), pra o professor nao precisar entrar no
// GitHub - so clicar em "Corrigir provas" no painel.
//
// So aceita chamadas de usuario autenticado. O gateway roda com
// verify_jwt=false (supabase/config.toml) porque, com true, o preflight CORS
// (OPTIONS, que nao leva Authorization) recebe 401 sem cabecalhos CORS e o
// navegador bloqueia a chamada. A validacao do JWT e feita aqui dentro,
// apos responder ao OPTIONS. Como so o professor usa Supabase Auth neste
// projeto, isso restringe o disparo a ele.
//
// Requer o secret GH_DISPATCH_TOKEN configurado nas Edge Functions do
// Supabase: um Personal Access Token do GitHub (fine-grained, escopo
// "Actions: Read and write" *so* no repositorio Sistema-de-Simulados).
// Nunca commitar esse token - so cadastrar como secret pelo Dashboard do
// Supabase.
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const GITHUB_OWNER = "adislandev";
const GITHUB_REPO = "Sistema-de-Simulados";
const WORKFLOW_FILE = "omr-correcao.yml";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
  });
}

async function usuarioAutenticado(req: Request): Promise<boolean> {
  const authorization = req.headers.get("Authorization");
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  if (!authorization || !supabaseUrl || !anonKey) return false;
  const r = await fetch(`${supabaseUrl}/auth/v1/user`, {
    headers: { Authorization: authorization, apikey: anonKey },
  });
  return r.ok;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS_HEADERS });
  }
  if (req.method !== "POST") {
    return json({ error: "Método não permitido" }, 405);
  }
  if (!(await usuarioAutenticado(req))) {
    return json({ error: "Não autorizado" }, 401);
  }

  const token = Deno.env.get("GH_DISPATCH_TOKEN");
  if (!token) {
    return json({ error: "GH_DISPATCH_TOKEN não configurado nas Edge Functions." }, 500);
  }

  const resposta = await fetch(
    `https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/workflows/${WORKFLOW_FILE}/dispatches`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
        Accept: "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ ref: "main" }),
    },
  );

  if (!resposta.ok) {
    const detalhe = await resposta.text();
    return json({ error: "Falha ao disparar a correção no GitHub Actions.", detalhe }, 502);
  }

  return json({ ok: true }, 200);
});
