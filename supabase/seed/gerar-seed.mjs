// Gera o seed SQL inicial (0002_seed_conteudo.sql) a partir de
// BANCO-DE-QUESTOES.md — fonte de verdade do conteúdo do MVP.
//
// Não inventa nem altera questões: só estrutura o que já está no
// markdown em INSERTs SQL, e valida o resultado contra a tabela
// "GABARITO RESUMIDO" que o próprio arquivo já traz, como checagem de
// integridade. Rodar de novo só se o banco de questões for atualizado
// pelo professor (é um script de apoio, não faz parte do app).
//
// Uso: node supabase/seed/gerar-seed.mjs

import { readFileSync, writeFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const raizProjeto = path.resolve(__dirname, "..", "..");
const md = readFileSync(path.join(raizProjeto, "BANCO-DE-QUESTOES.md"), "utf8");
const linhas = md.split(/\r?\n/);

const DISCIPLINAS = {
  "1. LÓGICA COMPUTACIONAL": { slug: "logica-computacional", nome: "Lógica Computacional" },
  "2. ERGONOMIA DE SISTEMAS COMPUTACIONAIS E IHC": {
    slug: "ergonomia-ihc",
    nome: "Ergonomia de Sistemas Computacionais e IHC",
  },
};

let disciplinaAtual = null;
let questoes = [];
let atual = null;
let modo = null; // 'competencia' | 'enunciado' | 'alternativas' | null

function novaQuestao(codigo) {
  return {
    codigo,
    disciplinaSlug: disciplinaAtual.slug,
    tipo: null,
    origem: null,
    competencia: "",
    dificuldade: null,
    enunciadoLinhas: [],
    alternativas: [], // { letra, texto }
    resposta: null,
  };
}

function finalizar() {
  if (atual) {
    atual.competencia = atual.competencia.trim().replace(/\s+/g, " ");
    // remove linha(s) em branco do fim/início do enunciado
    while (atual.enunciadoLinhas.length && atual.enunciadoLinhas[0].trim() === "") {
      atual.enunciadoLinhas.shift();
    }
    while (
      atual.enunciadoLinhas.length &&
      atual.enunciadoLinhas[atual.enunciadoLinhas.length - 1].trim() === ""
    ) {
      atual.enunciadoLinhas.pop();
    }
    atual.enunciado = atual.enunciadoLinhas.join("\n");
    questoes.push(atual);
  }
  atual = null;
  modo = null;
}

for (let i = 0; i < linhas.length; i++) {
  const linha = linhas[i];

  const headerDisciplina = linha.match(/^# (1\. LÓGICA COMPUTACIONAL|2\. ERGONOMIA.*)$/);
  if (headerDisciplina) {
    finalizar();
    disciplinaAtual = DISCIPLINAS[headerDisciplina[1]];
    continue;
  }
  if (linha.startsWith("# GABARITO")) {
    finalizar();
    break; // resto do arquivo é a tabela de gabarito, tratada à parte
  }

  const headerQuestao = linha.match(/^## ((?:LC|ERG)-\d+)/);
  if (headerQuestao) {
    finalizar();
    atual = novaQuestao(headerQuestao[1]);
    modo = "metadados";
    continue;
  }

  if (!atual) continue;

  if (modo === "metadados") {
    const mTipo = linha.match(/^-\s+tipo:\s+`([^`]+)`/);
    const mOrigem = linha.match(/^-\s+origem:\s+(.*)$/);
    const mCompetencia = linha.match(/^-\s+competência:\s+(.*)$/);
    const mDificuldade = linha.match(/^-\s+dificuldade:\s+(.*)$/);
    const mEnunciadoStart = linha.match(/^\*\*Enunciado:\*\*\\?$/);

    if (mTipo) atual.tipo = mTipo[1].trim();
    else if (mOrigem) atual.origem = mOrigem[1].trim();
    else if (mCompetencia) {
      atual.competencia = mCompetencia[1].trim();
      modo = "competencia-continuacao";
    } else if (mDificuldade) atual.dificuldade = mDificuldade[1].trim();
    else if (mEnunciadoStart) modo = "enunciado";
    continue;
  }

  if (modo === "competencia-continuacao") {
    const ehContinuacao = /^\s{2,}\S/.test(linha) && !linha.trim().startsWith("-");
    if (ehContinuacao) {
      atual.competencia += " " + linha.trim();
      continue;
    }
    // não é continuação — reprocessa esta linha como metadado normal
    modo = "metadados";
    i--;
    continue;
  }

  if (modo === "enunciado") {
    const mAlt = linha.match(/^([A-E])\)\s+(.*?)\\?$/);
    if (mAlt) {
      modo = "alternativas";
      atual.alternativas.push({ letra: mAlt[1], texto: mAlt[2].trim() });
      continue;
    }
    atual.enunciadoLinhas.push(linha.replace(/\\$/, ""));
    continue;
  }

  if (modo === "alternativas") {
    const mAlt = linha.match(/^([A-E])\)\s+(.*?)\\?$/);
    const mResposta = linha.match(/^\*\*Resposta:\*\*\s+([A-E])/);
    if (mAlt) {
      atual.alternativas.push({ letra: mAlt[1], texto: mAlt[2].trim() });
      continue;
    }
    if (mResposta) {
      atual.resposta = mResposta[1];
      modo = "fim";
      continue;
    }
    continue;
  }
}
finalizar();

// ---- validação estrutural ----
const erros = [];
for (const q of questoes) {
  if (!q.tipo) erros.push(`${q.codigo}: sem tipo`);
  if (!q.origem) erros.push(`${q.codigo}: sem origem`);
  if (!q.competencia) erros.push(`${q.codigo}: sem competência`);
  if (!q.dificuldade) erros.push(`${q.codigo}: sem dificuldade`);
  if (!q.enunciado) erros.push(`${q.codigo}: sem enunciado`);
  if (q.alternativas.length !== 5) erros.push(`${q.codigo}: tem ${q.alternativas.length} alternativas (esperado 5)`);
  if (!q.resposta) erros.push(`${q.codigo}: sem resposta`);
  else if (!q.alternativas.some((a) => a.letra === q.resposta))
    erros.push(`${q.codigo}: resposta ${q.resposta} não bate com nenhuma alternativa`);
}

// ---- validação cruzada com a tabela "GABARITO RESUMIDO" ----
const gabaritoIdx = md.indexOf("# GABARITO RESUMIDO");
const gabaritoTxt = md.slice(gabaritoIdx);
const gabaritoLinhas = gabaritoTxt
  .split(/\r?\n/)
  .map((l) => l.match(/^\s*(LC|ERG)-(\d+)\s+([A-E])\s+(\S+)/))
  .filter(Boolean);
const gabaritoMap = new Map(
  gabaritoLinhas.map((m) => [`${m[1]}-${m[2]}`, { resposta: m[3], tipo: m[4] }])
);

for (const q of questoes) {
  const g = gabaritoMap.get(q.codigo);
  if (!g) {
    erros.push(`${q.codigo}: não encontrada na tabela de gabarito resumido`);
    continue;
  }
  if (g.resposta !== q.resposta)
    erros.push(`${q.codigo}: resposta do corpo (${q.resposta}) difere do gabarito resumido (${g.resposta})`);
  if (g.tipo !== q.tipo)
    erros.push(`${q.codigo}: tipo do corpo (${q.tipo}) difere do gabarito resumido (${g.tipo})`);
}

if (questoes.length !== 40) {
  erros.push(`Total de questões parseadas = ${questoes.length} (esperado 40: 20 LC + 20 ERG)`);
}

if (erros.length) {
  console.error("Falha de validação no parser do banco de questões:\n");
  for (const e of erros) console.error(" - " + e);
  process.exit(1);
}

console.log(`OK: ${questoes.length} questões parseadas e validadas contra o gabarito resumido.`);

// ---- geração do SQL ----
function sqlEscape(str) {
  return str.replace(/'/g, "''");
}

function uuidExpr(nome) {
  return `uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, '${sqlEscape(nome)}')`;
}

const disciplinasUnicas = Object.values(DISCIPLINAS);
const competenciasUnicas = new Map(); // slug|nome -> disciplinaSlug

for (const q of questoes) {
  competenciasUnicas.set(`${q.disciplinaSlug}::${q.competencia}`, q.disciplinaSlug);
}

let out = [];
out.push("-- Seed inicial de conteúdo — gerado automaticamente por");
out.push("-- supabase/seed/gerar-seed.mjs a partir de BANCO-DE-QUESTOES.md.");
out.push("-- NÃO editar à mão: qualquer alteração de conteúdo deve ser feita");
out.push("-- no markdown fonte e este arquivo deve ser regenerado.");
out.push("-- Depende da extensão uuid-ossp, criada na migration 0001_init.sql.");
out.push("");

out.push("-- Disciplinas");
for (const d of disciplinasUnicas) {
  out.push(
    `insert into disciplinas (id, nome, slug) values (${uuidExpr("disciplina:" + d.slug)}, '${sqlEscape(
      d.nome
    )}', '${d.slug}');`
  );
}
out.push("");

out.push("-- Competências (dedupe por disciplina + nome)");
for (const [chave, disciplinaSlug] of competenciasUnicas) {
  const nomeCompetencia = chave.split("::")[1];
  out.push(
    `insert into competencias (id, disciplina_id, nome) values (${uuidExpr(
      "competencia:" + chave
    )}, ${uuidExpr("disciplina:" + disciplinaSlug)}, '${sqlEscape(nomeCompetencia)}');`
  );
}
out.push("");

out.push("-- Simulados (1 por disciplina no MVP — usa as 20 questões inteiras)");
for (const d of disciplinasUnicas) {
  out.push(
    `insert into simulados (id, disciplina_id, titulo, qtd_questoes) values (${uuidExpr(
      "simulado:" + d.slug
    )}, ${uuidExpr("disciplina:" + d.slug)}, 'Simulado — ${sqlEscape(d.nome)}', 20);`
  );
}
out.push("");

out.push("-- Questões");
for (const q of questoes) {
  out.push(
    `insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (` +
      `${uuidExpr("questao:" + q.codigo)}, ` +
      `${uuidExpr("disciplina:" + q.disciplinaSlug)}, ` +
      `${uuidExpr("competencia:" + q.disciplinaSlug + "::" + q.competencia)}, ` +
      `'${q.codigo}', ` +
      `'${sqlEscape(q.enunciado)}', ` +
      `'${q.tipo}', ` +
      `'${sqlEscape(q.dificuldade)}', ` +
      `'${sqlEscape(q.origem)}');`
  );
}
out.push("");

out.push("-- Alternativas");
const ORDEM = { A: 1, B: 2, C: 3, D: 4, E: 5 };
for (const q of questoes) {
  for (const alt of q.alternativas) {
    out.push(
      `insert into alternativas (id, questao_id, texto, correta, ordem) values (` +
        `${uuidExpr("alternativa:" + q.codigo + ":" + alt.letra)}, ` +
        `${uuidExpr("questao:" + q.codigo)}, ` +
        `'${sqlEscape(alt.texto)}', ` +
        `${alt.letra === q.resposta ? "true" : "false"}, ` +
        `${ORDEM[alt.letra]});`
    );
  }
}
out.push("");

out.push("-- Vínculo questão <-> simulado (todas as 20 de cada disciplina)");
for (const q of questoes) {
  out.push(
    `insert into simulado_questoes (id, simulado_id, questao_id) values (` +
      `${uuidExpr("simulado_questao:" + q.codigo)}, ` +
      `${uuidExpr("simulado:" + q.disciplinaSlug)}, ` +
      `${uuidExpr("questao:" + q.codigo)});`
  );
}
out.push("");

const caminhoSaida = path.join(__dirname, "0002_seed_conteudo.sql");
writeFileSync(caminhoSaida, out.join("\n"), "utf8");
console.log(`Gravado: ${caminhoSaida} (${out.length} linhas)`);

// dump de apoio para revisão humana (não usado pelo app)
writeFileSync(
  path.join(__dirname, "questoes-parseadas.json"),
  JSON.stringify(questoes, null, 2),
  "utf8"
);
