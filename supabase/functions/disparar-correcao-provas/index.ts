// Dispara manualmente o workflow do GitHub Actions que corrige as provas
// presenciais (omr-correcao.yml), pra o professor nao precisar entrar no
// GitHub - so clicar em "Corrigir provas" no painel.
//
// So aceita chamadas de usuario autenticado (verify_jwt=true na config de
// deploy) - como so o professor usa Supabase Auth neste projeto, isso ja
// restringe o disparo a ele.
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

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Método não permitido" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  const token = Deno.env.get("GH_DISPATCH_TOKEN");
  if (!token) {
    return new Response(JSON.stringify({ error: "GH_DISPATCH_TOKEN não configurado nas Edge Functions." }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
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
    return new Response(JSON.stringify({ error: "Falha ao disparar a correção no GitHub Actions.", detalhe }), {
      status: 502,
      headers: { "Content-Type": "application/json" },
    });
  }

  return new Response(JSON.stringify({ ok: true }), {
    status: 200,
    headers: { "Content-Type": "application/json" },
  });
});
