# AGENT-WORKTREES — implementação prática da Regra 18

> **Relação com o AGENT-WORKFLOW.md**
>
> Este documento é um guia operacional complementar ao `AGENT-WORKFLOW.md`.
> A regra normativa é a Regra 18 do `AGENT-WORKFLOW.md`.
> Este arquivo apenas descreve a implementação prática do isolamento por Git worktree.
>
> Em caso de divergência, o `AGENT-WORKFLOW.md` prevalece.

Este documento operacionaliza a **Regra 18** do `AGENT-WORKFLOW.md`
("Isolamento de trabalho entre agentes simultâneos"). Ele descreve como usar
o script `scripts/agent-worktree.sh` para que cada agente/tarefa tenha sua
própria branch, seu próprio diretório de trabalho (worktree) e seu próprio
estado de checkout — sem depender de nenhuma suposição específica deste
projeto.

Este script é genérico: não assume nome de branch base, nome de repositório
ou sistema de gestão de tarefas. Funciona em qualquer repositório Git com
suporte a `git worktree` (Git ≥ 2.5).

---

## 1. Pré-requisito: identificar a branch base

Antes de criar um worktree, a branch base da tarefa deve ser identificada
seguindo a **Regra 17** do `AGENT-WORKFLOW.md` (nunca presumir `main`,
`master`, `develop` ou qualquer outro nome) e a documentação específica do
projeto (quando existir uma seção equivalente à "Branch operacional e base
de integração").

O script nunca adivinha essa branch. Ela pode ser informada de duas formas:

1. **Por parâmetro, a cada uso:**
   ```bash
   scripts/agent-worktree.sh start <task-id> --base <branch-base>
   ```

2. **Configurada uma vez, localmente**, criando um arquivo
   `.agent-workflow.local` na raiz do repositório (arquivo **não
   versionado** — já está no `.gitignore`) com o conteúdo:
   ```
   BASE_BRANCH=<branch-base-identificada>
   ```
   A partir daí, `--base` pode ser omitido nos usos seguintes.

Se nenhuma das duas formas for usada, o script recusa continuar e aponta de
volta para a Regra 17.

---

## 2. Criar um worktree isolado para uma tarefa

```bash
scripts/agent-worktree.sh start <task-id> --base <branch-base>
```

Isso:
- cria uma branch nova chamada `<task-id>` a partir de `<branch-base>`;
- cria um diretório de trabalho isolado como pasta **irmã** do repositório
  (`../<nome-do-repo>-worktrees/<task-id>`), fora da árvore versionada;
- imprime o caminho criado.

O agente deve then trabalhar exclusivamente dentro desse diretório (abrir
uma nova janela do editor/terminal apontando para ele). **Não** deve rodar
`git checkout`/`git switch` no worktree principal para "entrar" nessa
branch — isso violaria o isolamento.

### Continuar uma tarefa já iniciada

Se a branch da tarefa já existe (outro agente começou e encerrou o worktree
dele) e nenhum worktree ativo a está usando:

```bash
scripts/agent-worktree.sh start <task-id> --from <branch-existente>
```

Se a branch **ainda** estiver em uso por outro worktree, o script recusa —
isso é a proteção contra dois agentes disputando o mesmo checkout.

---

## 3. Ver os worktrees ativos

```bash
scripts/agent-worktree.sh list
```

Mostra caminho e branch de cada worktree ativo (equivalente legível a
`git worktree list`).

---

## 4. Encerrar/remover o worktree de uma tarefa

```bash
scripts/agent-worktree.sh finish <task-id>
```

- Recusa remover se houver alterações não commitadas (proteção nativa do
  Git — o script não força isso por padrão).
- Não apaga a branch por padrão (ela continua disponível para PR/revisão).
- Para apagar a branch local também (somente se já estiver mesclada):
  ```bash
  scripts/agent-worktree.sh finish <task-id> --delete-branch
  ```

O script recusa "finalizar" o worktree principal do repositório — ele nunca
opera sobre o checkout de onde outro agente esteja trabalhando.

---

## 5. Limpeza administrativa

```bash
scripts/agent-worktree.sh prune
```

Remove apenas metadados de worktrees cujo diretório já foi apagado
manualmente (operação somente administrativa, não apaga nada em disco).

---

## 6. Garantias de isolamento

- O script nunca executa `git checkout`, `git switch`, `git reset --hard`,
  `git clean`, `merge`, `push` ou deploy.
- Toda operação usa `git worktree add|remove|list|prune` ancorada no
  worktree principal (`git -C <caminho-principal>`), nunca alterando o
  diretório/checkout de quem chamou o script.
- O próprio Git recusa nativamente criar um worktree para uma branch já
  usada por outro worktree — essa é a proteção estrutural contra dois
  agentes assumirem o mesmo checkout, e o script apenas propaga esse erro
  em vez de contorná-lo.
- Nenhum subcomando apaga trabalho de outro agente sem que o próprio
  agente dono peça explicitamente (`finish` do seu próprio worktree).

Se o ambiente não suportar `git worktree` (versão antiga do Git ou
restrição do ambiente), o agente deve parar e solicitar orientação antes de
compartilhar um único diretório de trabalho entre tarefas simultâneas —
conforme a Regra 18.
