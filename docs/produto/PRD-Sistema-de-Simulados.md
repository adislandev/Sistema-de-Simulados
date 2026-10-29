# PRD --- Sistema de Simulados Acadêmicos

## 1. Visão do produto

Sistema web pequeno e independente para aplicação de simulados
formativos nas disciplinas:

-   Lógica Computacional;
-   Ergonomia de Sistemas Computacionais e IHC.

O objetivo é substituir o uso genérico do Google Forms por uma
experiência mais controlada, visual e útil para autoavaliação do aluno e
acompanhamento básico do professor.

O sistema não é uma plataforma acadêmica completa.

## 2. Objetivos

### Para o aluno

-   realizar o simulado de forma simples;
-   ter uma experiência semelhante a uma avaliação;
-   receber uma nota;
-   visualizar acertos, erros, tempo e competências;
-   comparar as três primeiras tentativas;
-   perceber sua evolução.

### Para o professor

-   acompanhar individualmente as três primeiras notas;
-   calcular a média;
-   obter o ponto extra;
-   observar rapidamente questões com maior índice de erro;
-   exportar os resultados para Excel.

## 3. Escopo do MVP

### Incluído

-   duas disciplinas;
-   cadastro/importação de questões;
-   20 questões por simulado;
-   múltipla escolha;
-   identificação simples do aluno;
-   três primeiras tentativas controladas;
-   tentativas adicionais como treino;
-   cronômetro;
-   embaralhamento;
-   uma questão por tela;
-   resultado;
-   painel básico do professor;
-   exportação XLSX.

### Fora do MVP

-   aplicativo mobile nativo;
-   fórum;
-   chat;
-   gamificação complexa;
-   ranking;
-   recuperação de senha de aluno;
-   conta/e-mail de aluno;
-   autenticação complexa para aluno;
-   correção automática de questões discursivas;
-   plataforma acadêmica completa.

## 4. Stack

-   Frontend: React + Vite.
-   Backend/banco: Supabase.
-   Banco: PostgreSQL fornecido pelo Supabase.
-   Hospedagem frontend: Hostinger.
-   Versionamento: GitHub.
-   Desenvolvimento: Cloud Code.
-   Integrações: CLI/MCP disponíveis no ambiente, conforme permissões.

Não usar MySQL neste projeto.

## 5. Autenticação e identificação

### Aluno

O aluno não cria conta no MVP.

Fluxo: 1. informa nome completo; 2. o sistema tenta localizar uma
identificação já existente; 3. caso haja conflito de nomes, o sistema
deve usar o mecanismo mais simples possível para reduzir ambiguidade,
sem transformar o projeto em um sistema de login tradicional; 4. o aluno
escolhe a disciplina/simulado; 5. inicia a tentativa.

Não utilizar Supabase Auth para alunos.

### Professor

A proteção da área administrativa deve existir, mas a solução exata pode
ser definida na arquitetura. Não assumir Supabase Auth como obrigatório.

## 6. Fluxo do aluno

`Identificação → escolha do simulado → instruções → iniciar → questão → selecionar → confirmar → próxima → finalizar → resultado`

### Regras durante o simulado

-   uma questão por tela;
-   alternativas embaralhadas;
-   questões embaralhadas;
-   cronômetro;
-   sem barra de progresso;
-   não mostrar quantas questões faltam;
-   selecionar uma alternativa;
-   confirmar resposta;
-   após confirmação, não alterar;
-   nas três primeiras tentativas, não voltar;
-   ao finalizar, registrar a tentativa.

A experiência deve gerar sensação de avaliação sem transformar o sistema
em uma ferramenta punitiva.

## 7. Tentativas

### Tentativa 1 --- Diagnóstico

Objetivo: identificar o nível inicial do aluno.

Exibir: - nota; - acertos; - erros; - tempo; -
competências/habilidades; - indicação simples de pontos que precisam de
reforço.

### Tentativa 2 --- Evolução

Objetivo: permitir que o aluno estude e tente novamente.

Exibir: - nota; - acertos; - erros; - tempo; - competências; -
comparação com a tentativa 1.

### Tentativa 3 --- Consolidação

Objetivo: consolidar o aprendizado.

Exibir: - nota; - acertos; - erros; - tempo; - competências; -
comparação com as tentativas anteriores.

### Tentativas 4+

São permitidas como treino livre.

Continuam registradas para histórico, mas não alteram o ponto extra
baseado nas três primeiras.

## 8. Pontuação

Cada simulado possui:

-   20 questões;
-   0,5 ponto por questão;
-   nota máxima 10.

Fórmula:

`nota = acertos × 0,5`

Ponto extra:

`ponto_extra = média(nota_1, nota_2, nota_3) / 10`

Exemplo:

-   tentativa 1: 6,5;
-   tentativa 2: 7,5;
-   tentativa 3: 8,0;
-   média: 7,33;
-   ponto extra: 0,733.

A regra de arredondamento deve ser configurável/confirmada antes da
implementação definitiva.

## 9. Resultado do aluno

Mostrar:

-   nota;
-   quantidade de acertos;
-   quantidade de erros;
-   tempo gasto;
-   competências/habilidades;
-   comparação entre tentativas.

Não é necessário mostrar explicações detalhadas de cada questão no MVP.

## 10. Painel do professor

O professor deve conseguir visualizar:

-   disciplina;
-   simulado;
-   aluno;
-   tentativa 1;
-   tentativa 2;
-   tentativa 3;
-   média;
-   ponto extra;
-   tempo;
-   desempenho básico por questão.

### Análise da turma

Visão simples:

-   percentual de acerto por questão;
-   percentual de erro por questão;
-   identificação das questões com maior dificuldade.

O objetivo não é criar uma plataforma analítica complexa. A métrica
serve principalmente para orientar reforços de conteúdo.

## 11. Exportação

O professor deve conseguir exportar XLSX.

Colunas mínimas sugeridas:

-   aluno;
-   disciplina;
-   simulado;
-   tentativa 1;
-   tentativa 2;
-   tentativa 3;
-   média;
-   ponto extra;
-   data da última tentativa.

A exportação existe principalmente para facilitar o lançamento posterior
das notas no sistema acadêmico.

## 12. Banco de questões

O banco inicial será fornecido pelo professor.

Cada questão deve possuir:

-   id;
-   disciplina;
-   simulado;
-   enunciado;
-   alternativas;
-   resposta correta;
-   competência;
-   tipo;
-   dificuldade;
-   origem;
-   status.

### Tipos

-   `IDENTICA_PROVA`
-   `ADAPTADA_PROVA`
-   `NOVA_MESMO_CONTEUDO`

### Regra pedagógica fundamental

As questões devem seguir a prova e os materiais fornecidos pelo
professor.

Não inserir conteúdo apenas porque ele é comum à disciplina.

Pode haver: - questões deliberadamente idênticas à prova; - questões
adaptadas; - questões novas sobre a mesma habilidade.

Para o banco inicial, manter aproximadamente 3 a 5 questões
deliberadamente idênticas à prova por simulado, conforme validação do
professor.

## 13. Banco inicial

### Lógica Computacional

Conteúdos de referência da prova: - soma de números; - leitura de
valores; - estruturas condicionais `SE`; - comparação de valores; -
estruturas de repetição `REPITA`; - acumulação/soma em repetição; -
teste de número positivo/negativo/zero; - operador lógico `E` na questão
discursiva.

Não incluir proposições/preposições ou outros conteúdos que não estejam
presentes na prova/material validado.

### Ergonomia de Sistemas Computacionais e IHC

Conteúdos de referência: - NBR ISO 9241-11; - eficácia; - eficiência; -
satisfação; - heurísticas de Nielsen; - prevenção de erros; - controle e
liberdade do usuário; - reconhecimento em vez de memorização; -
consistência e padrões; - visibilidade do status do sistema; - estilos
de interface; - GUI; - CLI; - toque; - voz; - gestos; - manipulação
direta; - wizard; - menu; - formulário; - linguagem natural; -
estética/design minimalista; - flexibilidade e eficiência de uso.

## 14. Importação em massa

O sistema deve nascer preparado para futura importação de questões em
lote.

Formato preferencial: XLSX.

Fluxo:

`Upload → validação → prévia → correção de erros → confirmação → gravação`

A interface deve informar: - linha com erro; - campo com erro; -
motivo; - correção sugerida quando possível.

O professor não deve ser obrigado a cadastrar questão por questão.

## 15. Modelo conceitual

Entidades previstas:

-   `alunos`
-   `disciplinas`
-   `simulados`
-   `questoes`
-   `alternativas`
-   `competencias`
-   `simulado_questoes`
-   `tentativas`
-   `respostas`
-   `resultados`

Relacionamentos físicos devem ser validados pelo Cloud Code antes da
criação definitiva.

## 16. Segurança

-   secrets em variáveis de ambiente;
-   nunca enviar secrets ao GitHub;
-   não expor chaves privadas no frontend;
-   validar entradas;
-   proteger área administrativa;
-   aplicar políticas adequadas no Supabase;
-   confirmar operações destrutivas;
-   registrar dados necessários para auditoria básica.

## 17. Supabase

Usar um projeto Supabase separado do restante das aplicações.

Não usar Supabase Auth para alunos.

O projeto deve considerar as limitações do plano gratuito, inclusive
eventual pausa por inatividade.

### Health-check / manutenção

Não assumir que consultas artificiais impedem a pausa do projeto.

Durante a implementação, validar o comportamento vigente do plano
utilizado e, se fizer sentido, criar um mecanismo simples de
health-check/monitoramento externo.

Se for usado um cron: - ele deve fazer uma operação leve; - não deve
gerar carga desnecessária; - deve ser documentado; - deve existir um
plano alternativo caso o plano gratuito continue pausando o projeto.

## 18. Interface

Diretrizes:

-   React;
-   visual moderno e limpo;
-   responsivo;
-   rápido;
-   poucas distrações;
-   uma questão por tela;
-   foco no conteúdo;
-   boa leitura em computador e celular;
-   experiência mais profissional que um Google Forms genérico.

## 19. Hospedagem

Frontend React/Vite na Hostinger.

Supabase separado para banco/backend.

GitHub para versionamento.

Cloud Code pode utilizar MCP/CLI conforme as permissões fornecidas.

## 20. Roadmap

1.  validar PRD;
2.  validar banco de questões;
3.  validar arquitetura;
4.  modelar banco;
5.  implementar identificação do aluno;
6.  implementar fluxo do simulado;
7.  implementar resultados;
8.  implementar painel do professor;
9.  implementar exportação XLSX;
10. preparar importação em massa;
11. publicar na Hostinger;
12. testar com poucos alunos;
13. corrigir;
14. colocar em uso.

## 21. Princípio do projeto

Construir o menor sistema capaz de resolver o problema pedagógico real.

A simplicidade é uma decisão de produto, não uma limitação.
