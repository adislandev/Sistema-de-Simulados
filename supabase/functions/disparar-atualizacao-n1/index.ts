// Dispara o workflow do GitHub Actions que leva a Nota N1 da planilha para o
// sistema (omr-n1-sistema.yml): importa atividades + extra manual e atualiza as
// sugestoes de vinculo do simulado. Opcionalmente (regerar_planilha) antes
// relê o CSV "Grade de Notas" do Drive e regera as abas da planilha.
//
// Mesmo modelo de seguranca de disparar-correcao-provas: so aceita usuario
// autenticado (o professor). O gateway roda com verify_jwt=false
// (supabase/config.toml) porque o preflight CORS nao leva Authorization; o JWT
// e validado aqui dentro, apos responder ao OPTIONS.
//
// Usa o mesmo secret GH_DISPATCH_TOKEN (PAT fine-grained, "Actions: Read and
// write" so neste repositorio) ja cadastrado nas Edge Functions.
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const GITHUB_OWNER = "adislandev";
const GITHUB_REPO = "Sistema-de-Simulados";
const WORKFLOW_FILE = "omr-n1-sistema.yml";

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

  let regerarPlanilha = false;
  try {
    const corpo = await req.json();
    regerarPlanilha = corpo?.regerar_planilha === true;
  } catch {
    // corpo vazio/invalido: segue com o padrao (so importar da planilha)
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
      body: JSON.stringify({
        ref: "main",
        inputs: {
          simular_vinculos: "false",
          regerar_planilha: regerarPlanilha ? "true" : "false",
        },
      }),
    },
  );

  if (!resposta.ok) {
    const detalhe = await resposta.text();
    return json({ error: "Falha ao disparar a atualização no GitHub Actions.", detalhe }, 502);
  }

  return json({ ok: true }, 200);
});
