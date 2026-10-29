# Sistema de Simulados Acadêmicos

Sistema web para aplicar simulados formativos nas disciplinas de Lógica
Computacional e Ergonomia de Sistemas Computacionais e IHC. Substitui o uso
genérico de formulários por uma experiência mais controlada, com resultado
imediato para o aluno e acompanhamento da turma para o professor.

O sistema nasceu para uso real em sala de aula e evoluiu junto com as
necessidades das turmas, incluindo a correção automatizada de provas
presenciais.

## O que o sistema faz

**Aluno**
- identificação simplificada, sem criar conta (decisão de produto: manter a experiência rápida);
- simulado com questões objetivas, tempo e controle de tentativas;
- resultado com nota, acertos, erros e desempenho por competência;
- comparação entre as tentativas (diagnóstico, evolução, consolidação).

**Professor**
- login e painel protegido;
- análise da turma por simulado e por competência;
- exportação dos resultados em planilha;
- lixeira de tentativas e confirmação de notas;
- provas presenciais: correção automatizada de gabaritos e de questões dissertativas com apoio de IA, e consolidação da nota N1.

## Stack

| Camada | Tecnologia |
|---|---|
| Frontend | React 19, TypeScript, Vite, React Router |
| Backend e dados | Supabase (PostgreSQL, RLS, funções RPC, Edge Functions) |
| Correção de provas | Python (OpenCV, PyMuPDF) executado por GitHub Actions |
| Hospedagem | Hostinger |
| Versionamento e automação | GitHub e GitHub Actions |

## Como rodar localmente

```bash
npm ci
cp .env.example .env.local   # preencha com a URL e a anon key do seu projeto Supabase
npm run dev
```

Outros comandos:

```bash
npm run lint
npm run build
```

A anon key é pública por natureza (fica no bundle do frontend). A proteção dos
dados está nas policies de RLS e nas funções RPC do banco, em
`supabase/migrations/`. A service role key nunca vai para o frontend.

## Estrutura do repositório

```
src/                  frontend (features de aluno e professor, rotas, lib)
supabase/
  migrations/         esquema, policies e funções RPC versionados
  functions/          Edge Functions
  seed/               conteúdo inicial das questões
omr-pilot/            correção automatizada de provas (Python)
.github/workflows/    execução da correção e sincronizações
scripts/              utilitários de desenvolvimento
docs/
  produto/            PRD e banco de questões
  processo/           regras do projeto e protocolo de trabalho com agentes de IA
```

## Como foi construído

O sistema foi desenvolvido com apoio de IA, de forma guiada: um PRD define o
produto, e um conjunto de regras e protocolos define como o trabalho é feito
(check-in do agente, isolamento por worktree, uma tarefa por branch, revisão
por pull request). A IA executa; o escopo, as decisões e a revisão são humanos.

- [PRD](docs/produto/PRD-Sistema-de-Simulados.md): escopo, regras e decisões do produto.
- [Banco de questões](docs/produto/BANCO-DE-QUESTOES.md): fonte do conteúdo do MVP.
- [Regras do projeto](docs/processo/REGRAS-DO-PROJETO.md): manual operacional.
- [Protocolo de trabalho](docs/processo/AGENT-WORKFLOW.md), [check-in](docs/processo/AGENT-CHECK-IN.md) e [worktrees](docs/processo/AGENT-WORKTREES.md).

## Fonte das questões

O banco foi construído a partir das provas N1 e dos simulados aplicados em
aula. A regra é não inserir conteúdo fora do que foi efetivamente trabalhado
ou avaliado.
