# AGENT-CHECK-IN

## 1. Objetivo

Este documento define o procedimento de entrada de um novo agente de IA em um projeto.

O check-in serve para verificar se o agente consegue compreender e respeitar o ambiente operacional antes de receber tarefas de desenvolvimento.

Este documento é universal e não pertence a um produto, linguagem, IDE, modelo ou provedor específico.

O check-in é realizado uma vez por agente e ambiente. Não deve ser repetido a cada tarefa.

---

## 2. Regra fundamental

O agente deve realizar o check-in antes de executar qualquer tarefa de desenvolvimento quando estiver entrando pela primeira vez no projeto.

Durante o check-in, o agente não deve:

- alterar arquivos;
- criar arquivos;
- criar branches;
- fazer commits;
- fazer push;
- fazer merge;
- fazer deploy ou redeploy;
- corrigir problemas encontrados;
- assumir uma tarefa do sistema de gestão;
- executar mudanças destrutivas.

O objetivo é apenas diagnosticar a capacidade operacional do agente naquele ambiente.

---

## 3. Leitura inicial

O agente deve localizar e ler:

1. o protocolo operacional principal do projeto, normalmente `AGENT-WORKFLOW.md`;

2. o próprio `AGENT-CHECK-IN.md`, para compreender o procedimento de entrada e os critérios de aprovação;

3. a documentação específica indicada pelo protocolo;

4. instruções adicionais aplicáveis ao projeto;

5. informações disponíveis sobre as integrações necessárias ao trabalho.

O agente não deve assumir que nomes, branches, ferramentas, produtos ou processos são iguais aos de outro projeto.

## 4. Verificação do ambiente

O agente deve verificar, sem alterar nada:

- qual projeto está aberto;
- qual é a estrutura principal do projeto;
- qual branch está ativa;
- qual é o estado do working tree;
- se existem alterações locais;
- se existem commits locais não publicados;
- quais remotes estão configurados;
- se há outras branches relacionadas ao trabalho em andamento;
- quais ferramentas e integrações estão disponíveis;
- quais integrações exigidas pelo protocolo estão disponíveis ou ausentes.

Quando uma informação não puder ser confirmada, o agente deve registrar a ausência de informação em vez de inventá-la.

---

## 5. Verificação de integração

O agente deve identificar quais sistemas externos são necessários para operar o projeto.

Exemplos:

- sistema de gestão de tarefas;
- GitHub ou outro provedor Git;
- documentação externa;
- serviços de deploy;
- bancos de dados;
- serviços de backend;
- ferramentas de comunicação.

A ausência de uma integração não deve ser tratada como autorização para improvisar outro fluxo.

Quando uma integração obrigatória não estiver disponível, o agente deve registrar a limitação e aguardar orientação.

O check-in não exige que todas as integrações existentes no projeto estejam conectadas. Ele deve verificar somente aquelas necessárias para a operação prevista.

---

## 6. Verificação de compreensão

Sem alterar o projeto, o agente deve demonstrar, por meio do diagnóstico realizado, que compreendeu:

- qual documentação é operacional;

- qual documentação é específica do produto;

- como uma tarefa é autorizada;

- como o Git é utilizado no projeto;

- como tarefas independentes são isoladas;

- quais ações exigem autorização;

- como conflitos entre documentação e estado real devem ser tratados;

- que o histórico de uma prática anterior não constitui autorização para repeti-la;

- que não deve executar uma ação destrutiva quando houver dúvida.

O agente deve demonstrar essa compreensão de forma prática no diagnóstico, relacionando as regras encontradas ao estado real do ambiente, sem realizar alterações.

## 7. Tratamento de conflitos

Se o agente encontrar conflito entre documentação, configuração, Git, código ou integrações, ele não deve escolher uma solução com base em suposição.

Deve:

1. identificar o conflito;
2. registrar o que foi observado;
3. indicar o impacto operacional;
4. solicitar orientação quando a decisão for necessária para continuar com segurança.

---

## 8. Diagnóstico obrigatório

Ao terminar o check-in, o agente deve apresentar um diagnóstico objetivo contendo pelo menos:

### Identificação
- projeto identificado;
- protocolo operacional localizado;
- documentação principal localizada.

### Ambiente
- branch atual;
- estado do working tree;
- alterações locais encontradas;
- commits locais relevantes;
- remotes identificados.

### Integrações
- integrações necessárias identificadas;
- integrações disponíveis;
- integrações ausentes ou não verificadas.

### Segurança operacional
- capacidade de identificar trabalho existente;
- capacidade de preservar alterações de outros agentes;
- capacidade de identificar conflitos;
- capacidade de evitar alterações sem autorização.

### Resultado
O agente deve concluir com exatamente uma das classificações:

**APTO PARA EXECUTAR TAREFAS**

ou

**NÃO APTO — ORIENTAÇÃO NECESSÁRIA**

O agente não deve se declarar apto quando houver uma limitação que impeça o cumprimento seguro do protocolo.

---

## 9. Limite do check-in

O check-in não autoriza nenhuma tarefa.

Mesmo que o resultado seja `APTO PARA EXECUTAR TAREFAS`, o agente deve aguardar uma demanda autorizada e seguir o `AGENT-WORKFLOW.md` para executá-la.

O resultado do check-in não substitui:

- autorização da tarefa;
- revisão;
- validação;
- aprovação de push;
- aprovação de merge;
- autorização de deploy.

---

## 10. Continuidade após aprovação

Depois de aprovado, o agente deve utilizar o protocolo operacional normal do projeto.

Não deve repetir este check-in antes de cada tarefa.

Um novo check-in pode ser solicitado quando houver mudança relevante, como:

- entrada em um novo projeto;
- mudança significativa do protocolo operacional;
- mudança relevante das ferramentas ou integrações;
- alteração do ambiente que possa afetar a capacidade do agente de trabalhar com segurança;
- dúvida fundamentada sobre a validade da aprovação anterior.

---

## 11. Princípio final

O objetivo do check-in não é testar conhecimento técnico de programação.

O objetivo é verificar se o agente consegue operar de forma segura, rastreável e disciplinada dentro do protocolo do projeto.

O agente deve preferir:

**confirmar → preservar → identificar conflitos → pedir orientação**

em vez de:

**assumir → alterar → corrigir depois**.

## 12. Integrações obrigatórias para aprovação

O agente somente poderá ser considerado **APTO** quando possuir acesso funcional às integrações necessárias para executar tarefas no projeto.

Quando o projeto utilizar um sistema externo como fonte oficial de tarefas, o agente deve:

- identificar qual é o sistema utilizado pelo projeto;
- verificar se possui integração funcional com esse sistema;
- confirmar que consegue consultar uma tarefa real;
- confirmar que consegue obter as informações necessárias para executar uma tarefa autorizada.

No caso de o sistema de tarefas ser o Linear e a integração não estiver disponível, o agente **não deve ser considerado APTO**.

Nesse cenário, o agente deve interromper o check-in e informar claramente:

> A integração com o Linear ainda não está disponível. Você deseja configurar/conectar o Linear para que eu possa concluir o check-in e realizar um novo teste de aprovação?

O agente deve aguardar a autorização do responsável.

O agente não deve substituir o Linear por GitHub, arquivos locais, histórico de conversas ou qualquer outra fonte quando o Linear for definido como a fonte oficial de tarefas do projeto.

Somente após a integração ser configurada e o agente conseguir consultar corretamente uma tarefa real o check-in poderá prosseguir para a aprovação.

**APTO** significa que o agente está efetivamente preparado para receber e executar uma tarefa autorizada pelo fluxo de trabalho do projeto.