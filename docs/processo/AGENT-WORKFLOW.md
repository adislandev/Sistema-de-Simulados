# PROTOCOLO OPERACIONAL UNIVERSAL DE AGENTES

## 1. Objetivo

Este documento define o fluxo operacional padrão para agentes de desenvolvimento, independentemente do projeto, tecnologia, IDE ou modelo de IA utilizado.

Aplica-se a qualquer agente autorizado a trabalhar no projeto.

Este documento define **como o agente deve trabalhar**.

As regras específicas de produto, arquitetura, tecnologia, identidade visual, infraestrutura, deploy e negócio permanecem nos documentos próprios de cada projeto.

---

## 2. Fontes de verdade

### 2.1 Sistema de tarefas

O sistema de gestão de tarefas definido pelo projeto é a fonte de verdade operacional.

Quando o projeto utilizar Linear, o Linear será utilizado para controlar:

- demandas;
- status;
- autorização para desenvolvimento;
- contexto;
- comentários;
- handoffs;
- validações;
- ajustes;
- conclusão.

O agente não deve depender exclusivamente do histórico da conversa.

Antes de assumir uma tarefa existente, deve consultar seu estado atual no sistema de tarefas.

### 2.2 Código e Git

O código existente e o Git são a fonte de verdade da implementação.

Antes de modificar qualquer coisa, o agente deve verificar:

```bash
git status
git branch --show-current
git log -5 --oneline

Quando necessário:

git diff
git log --all --oneline
git branch -a

O agente deve preservar alterações existentes que não pertencem à tarefa atual.

### 3. Autorização para trabalhar

O agente somente deve implementar uma tarefa quando houver autorização clara.

Uma tarefa pode ser autorizada pelo fluxo definido pelo projeto, normalmente através do sistema de tarefas.

O agente deve confirmar:

identificação da tarefa;
objetivo;
status;
escopo;
critérios de aceite;
eventuais dependências;
branch/base definida pelo projeto.

Se houver dúvida relevante sobre o escopo ou autorização, o agente deve parar e solicitar orientação.

### 4. Identificação do trabalho existente

Antes de criar ou alterar código, o agente deve verificar se já existe trabalho relacionado à tarefa.

Verificar:

branch da tarefa;
branches relacionadas;
commits recentes;
working tree;
stash;
alterações locais;
PRs existentes, quando disponíveis.

Se encontrar trabalho iniciado por outro agente, não deve sobrescrevê-lo nem descartá-lo.

Quando a tarefa já possuir uma branch de trabalho, o agente deve avaliar se deve continuar nela em vez de criar outra.

5. Branches

O nome e a estratégia de branches são definidos pelo projeto.

O agente não deve presumir que main, master, develop ou qualquer outra branch é a base correta.

Antes de iniciar o desenvolvimento, deve identificar a branch/base definida pelo projeto ou pela tarefa.

Cada tarefa deve possuir isolamento adequado quando o projeto utilizar branches por tarefa.

Exemplo:

base do projeto
      ↓
branch da tarefa
      ↓
desenvolvimento
      ↓
teste
      ↓
PR / revisão
      ↓
merge

O fluxo exato pode variar conforme o projeto.

6. Isolamento entre agentes

Múltiplos agentes podem trabalhar simultaneamente no mesmo projeto.

Cada agente deve respeitar o isolamento das tarefas.

Regra fundamental

Não alterar arquivos fora do escopo da tarefa quando isso puder afetar o trabalho de outro agente.

Antes de modificar um arquivo:

verificar se ele faz parte da tarefa;
verificar se existe trabalho relacionado de outro agente;
verificar alterações locais;
evitar alterações desnecessárias.

Se duas tarefas dependerem do mesmo arquivo, o agente deve identificar o conflito antes de continuar.

Não deve apagar, resetar, sobrescrever ou descartar trabalho de outro agente sem autorização.

7. Desenvolvimento

O agente deve:

entender o objetivo da tarefa;
consultar a documentação relevante;
analisar o código existente;
fazer a menor alteração necessária;
manter padrões existentes;
evitar refatorações não relacionadas;
não modificar configurações ou infraestrutura sem necessidade;
não inventar requisitos.

O agente não deve transformar uma tarefa simples em uma refatoração ampla sem autorização.

8. Documentação

O agente deve consultar somente os documentos relevantes para a tarefa.

A hierarquia recomendada é:

Sistema de tarefas
       ↓
Regras do projeto
       ↓
Documentação técnica/produto
       ↓
Código existente

Documentos universais de agentes definem o processo de trabalho.

Documentos específicos do projeto definem o produto.

Nunca aplicar regras de outro projeto apenas porque um arquivo ou instrução foi encontrado no ambiente.

9. Testes e validação

Após implementar a tarefa, o agente deve executar os testes apropriados ao escopo.

Quando aplicável:

lint;
typecheck;
testes automatizados;
build;
testes funcionais;
validação visual;
validação específica solicitada na tarefa.

O agente deve registrar o que foi testado e o resultado.

Testado e aprovado

"Testado e aprovado" significa que a implementação foi validada conforme os critérios disponíveis.

Isso não significa automaticamente autorização para merge ou deploy.

Merge e deploy continuam sujeitos ao fluxo definido pelo projeto.

10. Git e entrega

Após concluir e validar a implementação, o agente deve verificar:

git status
git diff

Antes de criar commit, confirmar que somente arquivos relacionados à tarefa serão incluídos.

O agente deve evitar commits contendo alterações de outras tarefas.

Quando o projeto utilizar commits por tarefa, o commit deve identificar a tarefa.

Quando o projeto utilizar Pull Request:

implementação
    ↓
testes
    ↓
commit
    ↓
push
    ↓
Pull Request
    ↓
revisão/validação
    ↓
merge autorizado

O agente não deve presumir autorização para merge.

11. Handoff

Quando a tarefa precisar continuar com outro agente, o agente atual deve deixar contexto suficiente para continuidade.

O handoff deve informar, quando aplicável:

estado da tarefa;
branch;
arquivos alterados;
alterações realizadas;
testes executados;
problemas encontrados;
pendências;
próximos passos;
commits/PRs existentes.

Outro agente deve conseguir continuar a tarefa sem depender do histórico da conversa anterior.

12. Continuidade de tarefas

Um novo agente pode assumir uma tarefa já iniciada.

Nesse caso deve:

consultar a tarefa no sistema de gestão;
verificar o estado do Git;
localizar a branch existente;
verificar commits e alterações;
ler o contexto deixado pelo agente anterior;
continuar somente depois de entender o estado atual.

Não criar uma nova implementação paralela se já existir trabalho válido para a mesma tarefa.

13. Segurança operacional

O agente não deve:

apagar trabalho existente sem autorização;
executar git reset --hard sem autorização;
executar git clean -fd sem autorização;
sobrescrever alterações de outro agente;
expor segredos;
imprimir chaves, tokens ou credenciais;
alterar produção sem autorização;
fazer deploy presumindo que a tarefa está aprovada;
modificar infraestrutura sem necessidade;
inventar configurações ausentes.

Antes de operações potencialmente destrutivas, deve solicitar confirmação.

14. Produção e deploy

Deploy não é consequência automática da conclusão de uma tarefa.

Cada projeto define:

branch de produção;
branch de staging;
mecanismo de deploy;
responsáveis;
critérios de publicação.

O agente deve seguir a política específica do projeto.

Nunca presumir que:

push = produção

ou que:

merge = produção

sem confirmação da documentação do projeto.

15. Encerramento da tarefa

Ao finalizar, o agente deve deixar registrado:

o que foi alterado;
arquivos relevantes;
testes executados;
resultado;
branch;
commit, quando houver;
PR, quando houver;
pendências;
qualquer risco identificado.

A tarefa somente deve ser marcada como concluída conforme o fluxo definido pelo projeto.

16. Regra final

Quando houver conflito entre:

instrução da conversa;
documentação;
sistema de tarefas;
código;
Git;

o agente deve identificar o conflito e não inventar uma decisão.

Deve solicitar orientação quando a decisão puder afetar:

escopo;
segurança;
dados;
produção;
trabalho de outro agente;
arquitetura;
regras de negócio.

O objetivo deste protocolo é permitir que diferentes agentes, modelos, IDEs e ferramentas trabalhem no mesmo projeto de maneira previsível, segura e auditável.

## 17. Identificação da branch base da tarefa

Antes de criar uma branch para uma tarefa, o agente deve identificar qual é a branch base apropriada para o trabalho.

O agente não deve presumir que a branch base seja `main`, `master`, `develop` ou qualquer outro nome.

Para determinar a base correta, deve:

1. verificar a configuração real do repositório;

2. consultar a documentação operacional específica do projeto;

3. identificar se existe uma branch de integração, desenvolvimento ou migração definida pelo projeto;

4. quando houver divergência entre a branch padrão do repositório e a branch operacional definida pela documentação do projeto, seguir a documentação específica do projeto;

5. registrar a base escolhida no contexto da tarefa antes de criar a branch isolada;

6. utilizar a branch base identificada somente para criar ou atualizar a branch da tarefa, sem alterar a configuração padrão do repositório;

7. nunca alterar a branch padrão do repositório apenas para adaptar o workflow a um projeto específico.

A branch padrão do repositório não constitui, por si só, autorização para utilizá-la como base da tarefa.

A branch base é uma decisão operacional específica da tarefa e do projeto, enquanto a branch padrão do repositório continua sendo uma configuração independente.

Se houver dúvida ou conflito entre a configuração do repositório e a documentação do projeto, o agente deve parar e solicitar confirmação antes de criar a branch.

## 18. Isolamento de trabalho entre agentes simultâneos

Quando houver mais de um agente trabalhando simultaneamente no mesmo repositório, cada agente deve possuir um ambiente de trabalho isolado.

Um agente não deve alterar, trocar ou fazer checkout da branch de trabalho pertencente a outro agente.

Quando o ambiente suportar Git worktree, o agente deve utilizar um worktree separado para cada tarefa ou agente simultâneo, mantendo cada worktree associado à sua própria branch.

Cada tarefa deve possuir:

- uma branch própria;
- um diretório de trabalho próprio quando houver agentes simultâneos;
- seu próprio estado de checkout;
- alterações independentes das demais tarefas.

Agentes simultâneos não devem compartilhar o mesmo diretório de trabalho quando isso puder provocar troca de branch, sobrescrita de alterações, conflitos de arquivos ou perda de contexto.

O agente deve verificar o ambiente de trabalho antes de iniciar uma tarefa e confirmar que está operando no worktree e na branch corretos.

Nenhum agente deve executar `git checkout`, `git switch` ou operação equivalente para assumir a branch de outro agente.

Se o isolamento necessário não estiver disponível, o agente deve parar e solicitar orientação antes de modificar arquivos ou branches.

Para a implementação prática do isolamento por Git worktree, consultar `docs/processo/AGENT-WORKTREES.md`.