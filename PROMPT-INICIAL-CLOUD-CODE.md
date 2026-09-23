# PROMPT-INICIAL-CLOUD-CODE.md

Você está iniciando o projeto **Sistema de Simulados Acadêmicos**.

Antes de escrever código, leia integralmente: -
`PRD-Sistema-de-Simulados.md` - `BANCO-DE-QUESTOES.md`

O PRD é a fonte de verdade da arquitetura e das regras do produto. O
banco de questões é a fonte de verdade do conteúdo inicial.

## Regra de trabalho

NÃO comece codificando imediatamente.

Primeiro: 1. apresente seu entendimento do projeto; 2. proponha a
arquitetura; 3. proponha o modelo de dados no Supabase; 4. apresente os
relacionamentos entre as entidades; 5. apresente a estrutura de pastas
React/Vite; 6. descreva o fluxo do aluno; 7. descreva o fluxo do
professor; 8. descreva a estratégia de importação em massa de questões;
9. descreva a estratégia de exportação das notas; 10. descreva a
publicação na Hostinger; 11. aponte riscos, decisões pendentes e pontos
que precisam de validação.

Aguarde a validação do professor antes de implementar.

## Regras técnicas obrigatórias

-   Frontend: React + Vite.
-   Banco/backend: Supabase.
-   O banco do Supabase é PostgreSQL; não usar MySQL neste projeto.
-   Hospedagem do frontend: Hostinger.
-   Versionamento: GitHub.
-   Desenvolvimento: Cloud Code.
-   Usar CLI/MCP disponíveis no ambiente quando apropriado.
-   O professor poderá fornecer acesso ao Supabase/GitHub/Hostinger para
    implementação.
-   Não usar Supabase Auth para os alunos.
-   O aluno não cria conta, e-mail ou senha no MVP.
-   A identificação do aluno será simples, por nome completo, com
    mecanismos básicos para reduzir duplicidade quando possível sem
    transformar o MVP em um sistema de autenticação complexo.
-   Não expor secrets, tokens ou chaves privadas.
-   Usar variáveis de ambiente.
-   Operações administrativas devem ser protegidas.
-   Antes de alterações importantes no banco, explicar o impacto.
-   Antes de operações destrutivas em produção, pedir confirmação.
-   Não adicionar funcionalidades fora do MVP sem autorização.

## Regras pedagógicas obrigatórias

-   O sistema atende inicialmente duas disciplinas:
    -   Lógica Computacional;
    -   Ergonomia de Sistemas Computacionais e IHC.
-   Cada simulado tem 20 questões objetivas.
-   Cada questão vale 0,5 ponto.
-   Nota máxima: 10.
-   Uma questão por tela.
-   Questões e alternativas podem ser embaralhadas.
-   Não usar barra de progresso.
-   Há cronômetro desde o início.
-   O aluno seleciona uma alternativa, confirma e avança.
-   Após confirmar, a resposta não pode ser alterada.
-   Nas três primeiras tentativas, não é permitido voltar.
-   Registrar todas as tentativas.
-   Tentativa 1: diagnóstico/autoanálise.
-   Tentativa 2: evolução após estudo.
-   Tentativa 3: consolidação.
-   Tentativas 4+: treino livre; podem continuar registradas, mas não
    alteram o ponto extra.
-   Resultado do aluno: nota, acertos, erros, tempo,
    competências/habilidades e comparação entre tentativas.
-   Não é necessário mostrar explicações detalhadas por questão no MVP.
-   Ponto extra = média das três primeiras notas / 10.
-   Exemplo: média 7,17 gera 0,717 ponto extra, podendo ser
    exibido/arredondado conforme regra definida na implementação.

## Regra de conteúdo

As questões devem seguir exclusivamente a prova e os materiais
fornecidos pelo professor.

Não introduza conteúdos apenas porque são comuns à disciplina.

O banco utiliza três categorias: - `IDENTICA_PROVA`: questão
deliberadamente igual à questão da prova; - `ADAPTADA_PROVA`: mesma
habilidade/conteúdo, mas com contexto, valores ou redação alterados; -
`NOVA_MESMO_CONTEUDO`: questão nova, mas dentro do mesmo
conteúdo/habilidade cobrado na prova.

O banco inicial já contém questões e respostas. Não substitua nem
invente novas questões sem autorização do professor.

## Área do professor

O professor precisa: - visualizar cada aluno; - visualizar as três
notas; - visualizar a média das três primeiras; - visualizar o ponto
extra; - visualizar desempenho básico por questão/turma; - identificar
questões com maior índice de erro; - exportar resultados para XLSX para
lançamento posterior no sistema acadêmico.

## Importação futura

O sistema deve nascer preparado para importação em massa de questões,
preferencialmente XLSX.

A importação deve ter: 1. upload; 2. validação; 3. prévia dos registros;
4. indicação de erros; 5. confirmação; 6. gravação.

Não obrigar o professor a cadastrar questão por questão.

## Supabase e projeto gratuito

O projeto deve usar uma instância Supabase separada.

Não usar Supabase Auth para alunos.

O PRD prevê atenção ao comportamento do plano gratuito e eventual pausa
por inatividade. Não assumir que uma simples consulta periódica
necessariamente impede a pausa. Na implementação, avaliar uma estratégia
de health-check/monitoramento compatível com o plano vigente e
documentar claramente suas limitações. Não criar carga artificial
desnecessária.

## Princípio

Construir o menor sistema capaz de entregar uma boa experiência
pedagógica.

Priorizar: - simplicidade; - velocidade; - clareza; - confiabilidade dos
dados; - boa experiência do aluno; - boa leitura dos resultados pelo
professor.

Evitar transformar o projeto em uma plataforma acadêmica completa.

## Primeiro entregável

Antes de qualquer código, entregue um documento de análise contendo: -
entendimento; - arquitetura; - modelo de dados; - fluxos; - estrutura do
frontend; - estratégia de importação; - estratégia de exportação; -
segurança; - publicação; - riscos; - decisões pendentes.

Depois, aguarde validação.
