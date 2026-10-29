REGRAS DO PROJETO --- SISTEMA DE SIMULADOS

Este documento contém as regras específicas do Sistema de Simulados.

Estas regras complementam as instruções globais do agente de
desenvolvimento.

Todo agente que trabalhar neste projeto deve ler este documento antes de
executar alterações.

1. PROPÓSITO

Este documento é o manual operacional específico do projeto Sistema de
Simulados.

Ele reúne as decisões de negócio, regras pedagógicas, arquitetura,
tecnologia, experiência do aluno, painel do professor, banco de dados e
regras de desenvolvimento específicas deste projeto.

O agente não deve presumir que possui memória das sessões anteriores.

A documentação e o código atual são a fonte para reconstruir o contexto
do projeto.

2. DOCUMENTOS DE REFERÊNCIA

Documentos principais:

docs/processo/REGRAS-DO-PROJETO.md --- regras específicas deste projeto.

README.md --- visão geral e instruções rápidas.

docs/produto/PRD-Sistema-de-Simulados.md --- requisitos, regras e escopo.

docs/produto/BANCO-DE-QUESTOES.md --- questões, alternativas, respostas,
competências e origem.

PROMPT-INICIAL-CLOUD-CODE.md --- briefing inicial do projeto,
quando existente.

Antes de uma alteração relevante, o agente deve consultar os documentos
relacionados à demanda.

Não existe uma pasta docs/ obrigatória. Novos documentos devem ser
criados na raiz quando forem necessários e devem possuir nome claro e
objetivo.

3. FONTE DE VERDADE

A regra pedagógica definida pelo professor é a fonte de verdade para
decisões pedagógicas.

As regras específicas deste projeto devem ser respeitadas pelos agentes
de desenvolvimento.

Não inventar, alterar ou simplificar uma regra pedagógica por conta
própria.

Em caso de conflito ou ambiguidade que possa alterar o comportamento do
sistema:

identificar o conflito;

explicar o problema;

não decidir sozinho;

solicitar validação antes de implementar.

4. STACK

Tecnologias utilizadas:

React

Vite

Supabase

Hostinger para hospedagem do frontend

GitHub para versionamento

O Supabase é utilizado como backend e banco de dados.

A integração com Supabase pode ser realizada por CLI, MCP ou ferramentas
disponíveis ao agente, conforme permissões configuradas no ambiente.

Autenticação

Aluno:

não utiliza Supabase Auth;

não precisa criar uma conta tradicional no MVP;

utiliza o mecanismo simples de identificação definido no PRD.

Professor:

utiliza Supabase Auth;

existe uma conta administrativa/professor;

não criar sistema complexo de múltiplos perfis administrativos sem
autorização.

Não colocar credenciais ou chaves secretas no frontend.

5. OBJETIVO DO MVP

O sistema deve ser simples, rápido e focado em duas disciplinas:

Lógica Computacional

Ergonomia

O objetivo principal é permitir que o aluno realize simulados e
acompanhe seu próprio desempenho, enquanto o professor consegue
acompanhar resultados individuais e dados básicos da turma.

O sistema não deve se transformar em uma plataforma acadêmica completa.

6. FLUXO DO ALUNO

O aluno deve conseguir iniciar o simulado com o mínimo de atrito
possível.

Evitar:

cadastro complexo;

código de turma obrigatório;

autenticação desnecessária;

etapas que não agreguem valor pedagógico.

O fluxo deve ser simples e rápido.

7. TRÊS TENTATIVAS

O simulado possui três tentativas principais.

Primeira tentativa

Objetivo:

autoanálise;

diagnóstico inicial.

Ao finalizar, o aluno pode visualizar:

nota;

quantidade de acertos;

quantidade de erros;

competências/habilidades relacionadas;

tempo utilizado.

Segunda tentativa

Objetivo:

permitir que o aluno estude;

verificar evolução;

comparar o resultado com a primeira tentativa.

O sistema deve permitir observar principalmente:

nota anterior;

nota atual;

evolução de desempenho.

Terceira tentativa

Objetivo:

consolidar o treinamento;

permitir uma última tentativa dentro do ciclo principal.

Depois das três primeiras tentativas, eventuais tentativas adicionais,
caso sejam permitidas pelo sistema, devem ser tratadas como treino e não
devem alterar automaticamente as três notas principais.

8. REGRA DE NOTA

O simulado possui:

20 questões;

cada questão vale 0,5 ponto;

nota máxima = 10 pontos.

Registrar individualmente:

nota da primeira tentativa;

nota da segunda tentativa;

nota da terceira tentativa.

Calcular:

média das três notas.

Essa média será utilizada para o ponto extra definido pelo professor.

Não alterar essa regra sem validação.

9. EXPERIÊNCIA DURANTE O SIMULADO

Durante as três primeiras tentativas:

uma questão por tela;

perguntas embaralhadas;

sem barra de progresso;

cronômetro iniciado quando o aluno começa;

aluno seleciona uma resposta;

aluno confirma;

sistema avança para a próxima questão;

não voltar para questões anteriores;

não alterar uma resposta depois de confirmada.

O objetivo é criar uma experiência de avaliação/diagnóstico sem
transformar o simulado em uma prova punitiva.

10. QUESTÕES

As questões devem seguir o conteúdo efetivamente trabalhado na prova e
nas disciplinas.

Não adicionar conteúdo apenas porque pertence genericamente à
disciplina.

O banco de questões está documentado em:

docs/produto/BANCO-DE-QUESTOES.md

Tipos de questão utilizados:

IDENTICA_PROVA

ADAPTADA_PROVA

NOVA_MESMO_CONTEUDO

Algumas questões podem ser idênticas às questões da prova. Isso é
intencional.

Questões adaptadas devem manter o mesmo conceito/conteúdo, mas podem
alterar contexto, números ou situação apresentada.

Não modificar silenciosamente questões, alternativas ou respostas.

11. PAINEL DO PROFESSOR

O painel deve permitir ao professor visualizar pelo menos:

aluno;

disciplina;

simulado;

nota da primeira tentativa;

nota da segunda tentativa;

nota da terceira tentativa;

média;

tempo das tentativas.

O professor deve poder selecionar um simulado específico antes de
analisar os dados.

Quando aplicável, deve existir filtro por turma.

O painel pode apresentar uma visão simples da turma para identificar:

questões com maior índice de erro;

desempenho geral;

pontos que podem indicar necessidade de reforço.

Essa análise é auxiliar.

Não transformar o sistema em uma plataforma de BI.

12. DESEMPENHO INDIVIDUAL

O professor deve conseguir consultar o desempenho individual de um
aluno.

Quando disponível, apresentar:

notas por tentativa;

desempenho por questão;

tempo;

informações relevantes para acompanhamento.

Gráficos simples podem ser utilizados quando ajudarem na compreensão dos
dados.

Não adicionar bibliotecas complexas sem necessidade.

13. LIXEIRA E EXCLUSÃO

A exclusão de uma tentativa deve utilizar soft-delete quando aplicável.

Apagar uma tentativa:

não apaga o simulado;

não apaga a prova;

não apaga as questões;

não deve apagar outros dados do aluno.

O painel pode disponibilizar uma lixeira para o professor.

A lixeira pode permitir:

visualizar tentativas apagadas;

restaurar uma tentativa;

esvaziar a lixeira definitivamente.

Tentativas apagadas não devem aparecer nas visões normais do aluno ou do
professor.

Operações administrativas devem permanecer protegidas.

14. EXPORTAÇÃO

O professor precisa exportar os resultados para facilitar o lançamento
das notas no sistema acadêmico.

A implementação atual utiliza exportação para XLSX.

A exportação deve considerar o contexto atualmente filtrado no painel,
principalmente o simulado selecionado.

O objetivo é facilitar o lançamento das notas no sistema acadêmico.

O arquivo pode conter:

aluno;

disciplina;

simulado;

nota da primeira tentativa;

nota da segunda tentativa;

nota da terceira tentativa;

média;

demais informações úteis para lançamento.

Não alterar o comportamento da exportação sem validação.

15. BANCO DE DADOS

Utilizar Supabase.

O banco deve representar, conforme necessário:

alunos;

disciplinas;

simulados;

questões;

alternativas;

tentativas;

respostas;

resultados.

Tentativas devem permitir exclusão lógica quando necessário.

Evitar overengineering.

Não criar estruturas complexas sem necessidade real.

16. SEGURANÇA

Regras mínimas:

nunca colocar segredos no frontend;

utilizar variáveis de ambiente;

nunca expor service role key;

proteger operações administrativas;

validar dados recebidos;

utilizar RLS/policies adequadas;

proteger operações de exclusão, restauração e exclusão definitiva.

Alterações de segurança devem ser tratadas com atenção especial.

17. UI/UX

A interface deve ser:

limpa;

moderna;

responsiva;

rápida;

adequada para estudantes;

simples de utilizar.

O objetivo é oferecer uma experiência melhor que um Google Forms
genérico.

Durante o simulado:

priorizar a questão;

reduzir distrações;

manter fluxo simples;

deixar claro quando uma resposta foi confirmada.

No painel do professor:

priorizar informações úteis;

utilizar filtros claros;

utilizar gráficos simples quando agregarem valor.

Não adicionar elementos apenas por estética.

18. PROCESSO DE DESENVOLVIMENTO

Antes de implementar uma demanda relevante:

Ler docs/processo/REGRAS-DO-PROJETO.md.

Consultar o PRD quando necessário.

Consultar documentos específicos relacionados à demanda.

Analisar o código atual.

Verificar se a funcionalidade já existe parcialmente.

Identificar dependências.

Implementar de forma incremental.

Executar validações.

Não perguntar novamente algo que já esteja claramente definido na
documentação.

Não inventar regras críticas.

Antes de criar uma solução nova, verificar se existe uma solução já
implementada que possa ser reutilizada.

19. CONTINUIDADE ENTRE AGENTES

Este projeto pode ser desenvolvido por diferentes agentes e diferentes
modelos de IA.

Nenhum agente deve presumir que possui memória das sessões anteriores.

A fonte de verdade é:

código atual;

docs/processo/REGRAS-DO-PROJETO.md;

README.md;

docs/produto/PRD-Sistema-de-Simulados.md;

docs/produto/BANCO-DE-QUESTOES.md;

demais documentos existentes;

histórico/versionamento quando necessário.

Quando assumir uma tarefa, o agente deve primeiro reconstruir o contexto
utilizando esses materiais.

Não presumir decisões que não estejam documentadas.

Se houver conflito entre a solicitação atual e a documentação:

identificar o conflito;

não alterar automaticamente;

solicitar validação.

O agente deve tratar docs/processo/REGRAS-DO-PROJETO.md como manual operacional
específico do projeto, independentemente do modelo utilizado.

20. ALTERAÇÕES DE ESCOPO

O agente não deve alterar funcionalidades fora do escopo da demanda.

Não aproveitar uma tarefa para refatorar partes não relacionadas sem
necessidade.

Se encontrar um problema fora do escopo:

registrar o problema;

informar o professor;

não corrigir automaticamente se a correção puder afetar outras
áreas.

Exceção:

Correções pequenas e claramente necessárias para manter a funcionalidade
solicitada podem ser realizadas, desde que não alterem regras de
negócio.

21. VALIDAÇÃO E TESTES

Antes de considerar uma implementação concluída:

executar TypeScript/tsc, quando aplicável;

executar lint;

executar build;

verificar migrations quando houver alteração de banco;

verificar os fluxos afetados;

verificar visualmente alterações importantes de interface.

Build, lint e TypeScript limpos não significam automaticamente que a
funcionalidade está correta.

Mudanças relevantes de UI devem ser verificadas visualmente.

22. GIT E DEPLOY

O projeto é pequeno e experimental.

Após uma implementação estar validada:

verificar o estado do projeto;

verificar alterações inesperadas;

executar validações;

criar commit descritivo;

realizar deploy conforme configuração atual.

Não fazer commit de alterações que ainda estejam em avaliação.

Não fazer deploy de alterações com erros conhecidos.

Após o deploy, verificar o funcionamento da funcionalidade afetada.

23. DOCUMENTAÇÃO

A documentação deve refletir o estado real do projeto.

Quando uma implementação alterar uma decisão anteriormente documentada:

verificar se a alteração foi intencional;

atualizar o documento correspondente;

evitar documentação conflitante com o código.

O docs/processo/REGRAS-DO-PROJETO.md deve permanecer relativamente objetivo.

Detalhes extensos devem permanecer no PRD ou em documentos específicos.

24. FORA DO ESCOPO SEM AUTORIZAÇÃO

Não adicionar:

gamificação complexa;

ranking público;

chat;

fórum;

certificados;

LMS completo;

sistema acadêmico completo;

autenticação sofisticada;

funcionalidades administrativas complexas.

Qualquer expansão relevante deve ser previamente validada.

25. PRINCÍPIO DE SIMPLICIDADE

Na dúvida entre construir mais ou menos:

preferir a menor solução que cumpra o requisito documentado.

Prioridades técnicas:

simplicidade;

manutenção;

compatibilidade com a stack existente;

menor risco de regressão;

menor complexidade operacional.

Dúvida pedagógica:

não decidir sozinho.

Dúvida técnica sem impacto pedagógico:

escolher a solução simples, sustentável e compatível com a stack
existente.

26. REGRA FINAL

O objetivo do agente não é apenas fazer o código funcionar.

O objetivo é manter a continuidade do projeto, preservar as decisões já
tomadas e evitar que diferentes agentes criem interpretações diferentes
do mesmo sistema.

Antes de implementar:

entender.

Antes de alterar:

verificar.

Antes de inventar:

perguntar.

Depois de alterar:

validar.

Depois de uma mudança relevante:

manter a documentação coerente com o código.

27. FLUXO DE AGENTES E PUBLICAÇÃO

Este projeto pode ser desenvolvido utilizando diferentes agentes de IA.

Independentemente do agente utilizado, o fluxo recomendado é:

demanda validada antes da implementação;

agente analisa a documentação e o código atual;

agente implementa somente o escopo solicitado;

agente executa as validações apropriadas;

alteração é revisada antes do commit;

somente alterações aprovadas devem ser commitadas;

deploy deve ocorrer somente após a validação da alteração.

O agente responsável pela implementação não deve realizar deploy
automaticamente sem autorização explícita.

Operações de produção devem ser realizadas pelo fluxo de publicação
previamente definido pelo responsável pelo projeto.

Não assumir que uma alteração está aprovada apenas porque build, lint ou
testes passaram.