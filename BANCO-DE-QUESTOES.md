# BANCO-DE-QUESTOES.md

Banco inicial do Sistema de Simulados Acadêmicos.

## Regras

-   Cada simulado possui 20 questões objetivas.
-   Cada questão vale 0,5 ponto.
-   Nota máxima: 10.
-   O banco foi construído exclusivamente a partir do conteúdo das
    provas fornecidas pelo professor e do contexto já validado.
-   Não incluir proposições/preposições ou conteúdos que não estejam na
    prova de Lógica Computacional.
-   As questões podem ser idênticas, adaptadas ou novas dentro da mesma
    habilidade.
-   `IDENTICA_PROVA` é intencional.
-   A resposta correta está indicada em cada questão.
-   As alternativas devem ser embaralhadas pelo sistema na aplicação.

------------------------------------------------------------------------

# 1. LÓGICA COMPUTACIONAL

## LC-001

-   tipo: `IDENTICA_PROVA`
-   origem: Prova N1 --- Questão 1
-   competência: rastrear execução de algoritmo com repetição e
    acumulação
-   dificuldade: fácil

**Enunciado:**\
Considere o algoritmo:

``` text
algoritmo "RepitaSomaB"
var
  n, soma, i: inteiro
inicio
  soma <- 0
  i <- 1
  repita
    leia(n)
    soma <- soma + n
    i <- i + 1
  ate i > 2
  escreva("Total: ", soma)
fimalgoritmo
```

Se o usuário digitar 6 e 4, qual será a saída?

A)  Total: 10\
B)  Total: 24\
C)  Total: 6\
D)  Total: 4\
E)  Total: 2

**Resposta:** A

## LC-002

-   tipo: `IDENTICA_PROVA`
-   origem: Prova N1 --- Questão 3
-   competência: compreender soma simples de dois valores
-   dificuldade: fácil

**Enunciado:**\
Considere:

``` text
algoritmo "SomaSimplesB"
var
  x, y, soma: inteiro
inicio
  leia(x)
  leia(y)
  soma <- x + y
  escreva(soma)
fimalgoritmo
```

Se o usuário digitar 9 e 1, qual será a saída?

A)  10\
B)  9\
C)  1\
D)  91\
E)  0

**Resposta:** A

## LC-003

-   tipo: `IDENTICA_PROVA`
-   origem: Prova N1 --- Questão 6
-   competência: interpretar condição para número positivo, negativo ou
    zero
-   dificuldade: fácil

**Enunciado:**\
Analise:

``` text
algoritmo "TesteSe"
var
  n: inteiro
inicio
  leia(n)
  se (n > 0) entao
    escreva("Positivo")
  senao
    escreva("Negativo ou zero")
  fimse
fimalgoritmo
```

Entrada: -2.

A)  Positivo\
B)  Negativo\
C)  Negativo ou zero\
D)  Zero\
E)  Erro

**Resposta:** C

## LC-004

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada nas Questões 2 e 7 da prova
-   competência: interpretar condição aplicada à soma
-   dificuldade: fácil

**Enunciado:**\
Um algoritmo lê dois números, calcula a soma e mostra "Acima" quando a
soma é maior que 14. Se forem informados 8 e 7, o resultado será:

A)  Acima\
B)  Abaixo\
C)  Igual\
D)  Erro\
E)  Nenhuma

**Resposta:** A

## LC-005

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 5 da prova
-   competência: acompanhar repetição e acumulador
-   dificuldade: fácil

**Enunciado:**\
Um algoritmo inicia `soma` em 0 e repete 3 vezes a operação
`soma <- soma + 5`. Qual será o resultado final?

A)  5\
B)  10\
C)  15\
D)  20\
E)  3

**Resposta:** C

## LC-006

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 2 da prova
-   competência: avaliar condição após operação de soma
-   dificuldade: média

**Enunciado:**\
Um algoritmo calcula `soma <- a + b` e verifica se `soma >= 12`. Para os
valores 5 e 7, qual mensagem deve ser apresentada?

A)  Soma alta\
B)  Soma baixa\
C)  Soma igual a 10\
D)  Erro\
E)  Nenhuma

**Resposta:** A

## LC-007

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada nas Questões 5 e 8 da prova
-   competência: compreender repetição com quantidade definida de
    execuções
-   dificuldade: média

**Enunciado:**\
Um algoritmo inicia `soma` em 0 e repete 4 vezes a operação
`soma <- soma + 2`. Qual será o resultado?

A)  2\
B)  4\
C)  6\
D)  8\
E)  10

**Resposta:** D

## LC-008

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 4 da prova
-   competência: interpretar condição sobre resultado de soma
-   dificuldade: fácil

**Enunciado:**\
Um algoritmo soma 10 e 3. Se a soma for maior que 8, apresenta "Maior
que 8"; caso contrário, apresenta "Menor ou igual a 8". Qual será a
saída?

A)  Maior que 8\
B)  Menor ou igual a 8\
C)  Igual a 8\
D)  Erro\
E)  Nenhuma

**Resposta:** A

## LC-009

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 8 da prova
-   competência: rastrear soma de vários valores
-   dificuldade: fácil

**Enunciado:**\
Um algoritmo lê três números: 4, 2 e 5, acumulando todos em uma variável
`soma`. Qual será o resultado?

A)  6\
B)  9\
C)  11\
D)  12\
E)  15

**Resposta:** C

## LC-010

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 5 da prova
-   competência: rastrear acumulador em repetição
-   dificuldade: fácil

**Enunciado:**\
Uma variável `soma` começa em 0. Um laço executa 4 vezes e, em cada
execução, acrescenta 2. Qual será o resultado?

A)  4\
B)  6\
C)  8\
D)  10\
E)  12

**Resposta:** C

## LC-011

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 6 da prova
-   competência: interpretar condição com valor zero
-   dificuldade: fácil

**Enunciado:**\
Um algoritmo verifica `se (n > 0)`. Caso seja verdadeiro, mostra
"Positivo"; caso contrário, mostra "Negativo ou zero". Se `n = 0`, o
resultado é:

A)  Positivo\
B)  Negativo\
C)  Zero\
D)  Negativo ou zero\
E)  Erro

**Resposta:** D

## LC-012

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 7 da prova
-   competência: avaliar comparação com soma
-   dificuldade: fácil

**Enunciado:**\
Um algoritmo soma 11 e 2 e mostra "Acima" se a soma for maior que 12.
Qual será a saída?

A)  Acima\
B)  Abaixo\
C)  Igual\
D)  Erro\
E)  Nenhuma

**Resposta:** A

## LC-013

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 8 da prova
-   competência: calcular soma acumulada em repetição
-   dificuldade: fácil

**Enunciado:**\
Um algoritmo lê três valores: 1, 3 e 2, acumulando-os em `soma`. Qual
será o resultado?

A)  4\
B)  5\
C)  6\
D)  7\
E)  8

**Resposta:** C

## LC-014

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 4 da prova
-   competência: interpretar condição de maior que
-   dificuldade: fácil

**Enunciado:**\
Um algoritmo soma dois números e testa `soma > 8`. Para os valores 4 e
4, qual mensagem corresponde ao `senao`?

A)  Maior que 8\
B)  Menor ou igual a 8\
C)  Maior ou igual a 8\
D)  Igual a 10\
E)  Erro

**Resposta:** B

## LC-015

-   tipo: `NOVA_MESMO_CONTEUDO`
-   origem: mesmo conteúdo das estruturas de repetição da prova
-   competência: acompanhar incremento em repetição
-   dificuldade: fácil

**Enunciado:**\
Uma variável `soma` começa em 0. Um laço executa 5 vezes e acrescenta 1
a cada execução. Qual será o resultado?

A)  1\
B)  4\
C)  5\
D)  6\
E)  10

**Resposta:** C

## LC-016

-   tipo: `NOVA_MESMO_CONTEUDO`
-   origem: mesmo conteúdo de soma da prova
-   competência: compreender leitura e soma de dois valores
-   dificuldade: fácil

**Enunciado:**\
Um algoritmo lê dois números, soma os valores e mostra o resultado. Se
forem informados 12 e 8, qual será a saída?

A)  18\
B)  20\
C)  22\
D)  96\
E)  128

**Resposta:** B

## LC-017

-   tipo: `NOVA_MESMO_CONTEUDO`
-   origem: mesmo conteúdo de condição com operador E da prova
    discursiva
-   competência: avaliar duas condições simultaneamente
-   dificuldade: média

**Enunciado:**\
Considere a condição `(n > 10) e (n > 14)`. Para `n = 15`, o resultado
da condição é:

A)  Verdadeiro\
B)  Falso\
C)  Erro\
D)  Zero\
E)  Indefinido

**Resposta:** A

## LC-018

-   tipo: `NOVA_MESMO_CONTEUDO`
-   origem: mesmo conteúdo de condição com operador E da prova
    discursiva
-   competência: avaliar duas condições simultaneamente
-   dificuldade: média

**Enunciado:**\
Considere a condição `(n > 10) e (n > 14)`. Para `n = 10`, o resultado
é:

A)  Verdadeiro\
B)  Falso\
C)  10\
D)  14\
E)  Erro

**Resposta:** B

## LC-019

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 2 da prova
-   competência: interpretar limite de comparação
-   dificuldade: média

**Enunciado:**\
Um algoritmo calcula a soma de dois valores e mostra "Soma alta" somente
quando `soma >= 15`. Para os valores 7 e 5, qual será a saída?

A)  Soma alta\
B)  Soma baixa\
C)  Soma igual\
D)  Erro\
E)  Nenhuma

**Resposta:** B

## LC-020

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 8 da prova
-   competência: acompanhar soma de três entradas
-   dificuldade: fácil

**Enunciado:**\
Um algoritmo lê três valores: 2, 3 e 4, acumulando todos em uma variável
`soma`. Qual será o resultado?

A)  7\
B)  8\
C)  9\
D)  10\
E)  12

**Resposta:** C

------------------------------------------------------------------------

# 2. ERGONOMIA DE SISTEMAS COMPUTACIONAIS E IHC

## ERG-001

-   tipo: `IDENTICA_PROVA`
-   origem: Prova N1 --- Questão 1
-   competência: identificar eficiência segundo ISO 9241-11
-   dificuldade: fácil

**Enunciado:**\
Um aluno desenvolveu um protótipo no Figma e percebeu que os usuários
conseguem concluir tarefas, mas com dificuldade e demora. Segundo a NBR
ISO 9241-11, isso indica problema em qual aspecto da usabilidade?

A)  Eficiência\
B)  Segurança\
C)  Portabilidade\
D)  Compatibilidade\
E)  Programação

**Resposta:** A

## ERG-002

-   tipo: `IDENTICA_PROVA`
-   origem: Prova N1 --- Questão 2
-   competência: identificar eficácia segundo ISO 9241-11
-   dificuldade: fácil

**Enunciado:**\
Durante um teste, os usuários conseguem completar uma tarefa
corretamente, sem erros. Segundo a ISO 9241-11, isso representa:

A)  Eficiência\
B)  Eficácia\
C)  Usabilidade técnica\
D)  Interface gráfica\
E)  Interação

**Resposta:** B

## ERG-003

-   tipo: `IDENTICA_PROVA`
-   origem: Prova N1 --- Questão 5
-   competência: reconhecer a heurística de controle e liberdade do
    usuário
-   dificuldade: fácil

**Enunciado:**\
Um sistema mobile permite que o usuário desfaça uma ação facilmente.
Isso atende qual heurística de Nielsen?

A)  Consistência e padrões\
B)  Controle e liberdade do usuário\
C)  Reconhecimento em vez de memorização\
D)  Flexibilidade e eficiência\
E)  Ajuda e documentação

**Resposta:** B

## ERG-004

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada nas Questões 1 e 2 da prova
-   competência: diferenciar eficácia e eficiência
-   dificuldade: média

**Enunciado:**\
Em um sistema, os usuários conseguem concluir uma tarefa sem erros, mas
precisam de muito tempo para realizá-la. Qual afirmação está correta?

A)  A eficácia está comprometida e a eficiência está adequada.\
B)  A eficácia está adequada, mas a eficiência precisa ser melhorada.\
C)  Eficácia e eficiência são exatamente a mesma coisa.\
D)  Apenas a estética está comprometida.\
E)  O problema é exclusivamente de segurança.

**Resposta:** B

## ERG-005

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 3 da prova
-   competência: identificar satisfação do usuário
-   dificuldade: fácil

**Enunciado:**\
Após utilizar um aplicativo, os usuários relatam que a experiência foi
agradável e confortável. Qual aspecto da ISO 9241-11 está diretamente
relacionado a esse resultado?

A)  Eficácia\
B)  Eficiência\
C)  Satisfação\
D)  Portabilidade\
E)  Compatibilidade

**Resposta:** C

## ERG-006

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 4 da prova
-   competência: identificar heurística relacionada ao tratamento de
    erros
-   dificuldade: fácil

**Enunciado:**\
Um aplicativo apresenta uma mensagem clara quando ocorre um erro e
orienta o usuário sobre como corrigi-lo. Qual heurística de Nielsen está
diretamente relacionada?

A)  Consistência e padrões\
B)  Prevenção de erros\
C)  Reconhecimento em vez de memorização\
D)  Ajuda o usuário a reconhecer, diagnosticar e corrigir erros\
E)  Controle e liberdade do usuário

**Resposta:** D

## ERG-007

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 7 da prova
-   competência: identificar manipulação direta
-   dificuldade: fácil

**Enunciado:**\
Um usuário arrasta um arquivo da área de trabalho diretamente para uma
pasta usando o mouse. Esse tipo de interação é:

A)  Menu\
B)  Formulário\
C)  Manipulação direta\
D)  Linguagem natural\
E)  Wizard

**Resposta:** C

## ERG-008

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 8 da prova
-   competência: identificar wizard
-   dificuldade: fácil

**Enunciado:**\
Um sistema apresenta várias telas sequenciais para orientar o usuário
durante a instalação de um programa. Esse estilo de interação é:

A)  CLI\
B)  Menu\
C)  Wizard\
D)  Linguagem natural\
E)  Gestos

**Resposta:** C

## ERG-009

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 6 da prova
-   competência: identificar interface de linha de comando
-   dificuldade: fácil

**Enunciado:**\
Um usuário opera um sistema digitando comandos como `cd`, `ls` e
`mkdir`. Qual estilo de interface está sendo utilizado?

A)  GUI\
B)  CLI\
C)  Voz\
D)  Toque\
E)  Gestos

**Resposta:** B

## ERG-010

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada nos estilos de interface da prova
-   competência: identificar GUI
-   dificuldade: fácil

**Enunciado:**\
Um aplicativo apresenta janelas, ícones, botões e elementos clicáveis
para interação. Qual estilo de interface é esse?

A)  CLI\
B)  GUI\
C)  Voz\
D)  Linguagem natural\
E)  Wizard

**Resposta:** B

## ERG-011

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada nos estilos de interface da prova
-   competência: identificar interação por voz
-   dificuldade: fácil

**Enunciado:**\
Um usuário solicita verbalmente a um assistente virtual que ligue as
luzes de uma sala. Qual estilo de interação está sendo utilizado?

A)  CLI\
B)  GUI\
C)  Voz\
D)  Menu\
E)  Formulário

**Resposta:** C

## ERG-012

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada nos estilos de interação da prova
-   competência: identificar interação por gestos
-   dificuldade: fácil

**Enunciado:**\
Um aplicativo permite ampliar uma imagem usando um gesto de pinça com
dois dedos. Esse tipo de interação está relacionado a:

A)  CLI\
B)  Voz\
C)  Toque\
D)  Gestos\
E)  Menu

**Resposta:** D

## ERG-013

-   tipo: `NOVA_MESMO_CONTEUDO`
-   origem: mesmo conteúdo de estilos de interação da prova
-   competência: identificar menus
-   dificuldade: fácil

**Enunciado:**\
Um sistema organiza comandos em opções como "Arquivo", "Editar",
"Exibir" e "Ajuda", permitindo que o usuário escolha uma delas. Qual
estilo de interação está representado?

A)  Menu\
B)  Formulário\
C)  Manipulação direta\
D)  Wizard\
E)  CLI

**Resposta:** A

## ERG-014

-   tipo: `NOVA_MESMO_CONTEUDO`
-   origem: mesmo conteúdo de estilos de interação da prova
-   competência: identificar formulários
-   dificuldade: fácil

**Enunciado:**\
Uma página solicita nome, e-mail e senha por meio de campos estruturados
para preenchimento. Qual estilo de interação está sendo utilizado?

A)  Menu\
B)  Linguagem natural\
C)  Formulário\
D)  Wizard\
E)  CLI

**Resposta:** C

## ERG-015

-   tipo: `ADAPTADA_PROVA`
-   origem: baseada na Questão 5 e nas heurísticas de Nielsen
    trabalhadas na prova
-   competência: reconhecer a heurística reconhecimento em vez de
    memorização
-   dificuldade: média

**Enunciado:**\
Um sistema mostra opções e comandos visíveis na tela para que o usuário
não precise memorizar códigos. Qual heurística de Nielsen está sendo
favorecida?

A)  Estética e design minimalista\
B)  Controle e liberdade do usuário\
C)  Reconhecimento em vez de memorização\
D)  Consistência e padrões\
E)  Prevenção de erros

**Resposta:** C

## ERG-016

-   tipo: `ADAPTADA_PROVA`
-   origem: conteúdo de heurísticas de Nielsen da prova
-   competência: reconhecer prevenção de erros
-   dificuldade: fácil

**Enunciado:**\
Um botão de confirmação permanece desabilitado enquanto os dados
obrigatórios de um formulário não forem preenchidos. Qual heurística
está sendo aplicada?

A)  Flexibilidade e eficiência de uso\
B)  Prevenção de erros\
C)  Estética e design minimalista\
D)  Controle e liberdade do usuário\
E)  Consistência e padrões

**Resposta:** B

## ERG-017

-   tipo: `ADAPTADA_PROVA`
-   origem: conteúdo de heurísticas de Nielsen da prova
-   competência: reconhecer consistência e padrões
-   dificuldade: fácil

**Enunciado:**\
Um aplicativo usa a mesma aparência, posição e comportamento para botões
equivalentes em todas as telas. Qual heurística está sendo aplicada?

A)  Consistência e padrões\
B)  Prevenção de erros\
C)  Controle e liberdade do usuário\
D)  Flexibilidade e eficiência\
E)  Ajuda e documentação

**Resposta:** A

## ERG-018

-   tipo: `ADAPTADA_PROVA`
-   origem: conteúdo de heurísticas de Nielsen da prova
-   competência: reconhecer visibilidade do status do sistema
-   dificuldade: fácil

**Enunciado:**\
Após o usuário clicar em "Salvar", o sistema mostra imediatamente uma
mensagem informando que o arquivo foi salvo. Qual heurística está sendo
atendida?

A)  Visibilidade do status do sistema\
B)  Consistência e padrões\
C)  Estética e design minimalista\
D)  Reconhecimento em vez de memorização\
E)  Controle e liberdade do usuário

**Resposta:** A

## ERG-019

-   tipo: `ADAPTADA_PROVA`
-   origem: conteúdo de heurísticas de Nielsen da prova
-   competência: reconhecer flexibilidade e eficiência de uso
-   dificuldade: média

**Enunciado:**\
Um sistema oferece atalhos de teclado para usuários experientes,
mantendo também os comandos tradicionais para iniciantes. Qual
heurística está relacionada?

A)  Estética e design minimalista\
B)  Flexibilidade e eficiência de uso\
C)  Consistência e padrões\
D)  Controle e liberdade do usuário\
E)  Prevenção de erros

**Resposta:** B

## ERG-020

-   tipo: `ADAPTADA_PROVA`
-   origem: conteúdo de heurísticas de Nielsen da prova
-   competência: reconhecer estética e design minimalista
-   dificuldade: fácil

**Enunciado:**\
Uma interface remove informações e elementos visuais desnecessários,
mantendo apenas o que ajuda o usuário a realizar a tarefa. Qual
heurística está sendo aplicada?

A)  Consistência e padrões\
B)  Estética e design minimalista\
C)  Prevenção de erros\
D)  Feedback\
E)  Controle e liberdade do usuário

**Resposta:** B

------------------------------------------------------------------------

# GABARITO RESUMIDO

## Lógica Computacional

  ID       Resposta   Tipo
  -------- ---------- ---------------------
  LC-001   A          IDENTICA_PROVA
  LC-002   A          IDENTICA_PROVA
  LC-003   C          IDENTICA_PROVA
  LC-004   A          ADAPTADA_PROVA
  LC-005   C          ADAPTADA_PROVA
  LC-006   A          ADAPTADA_PROVA
  LC-007   D          ADAPTADA_PROVA
  LC-008   A          ADAPTADA_PROVA
  LC-009   C          ADAPTADA_PROVA
  LC-010   C          ADAPTADA_PROVA
  LC-011   D          ADAPTADA_PROVA
  LC-012   A          ADAPTADA_PROVA
  LC-013   C          ADAPTADA_PROVA
  LC-014   B          ADAPTADA_PROVA
  LC-015   C          NOVA_MESMO_CONTEUDO
  LC-016   B          NOVA_MESMO_CONTEUDO
  LC-017   A          NOVA_MESMO_CONTEUDO
  LC-018   B          NOVA_MESMO_CONTEUDO
  LC-019   B          ADAPTADA_PROVA
  LC-020   C          ADAPTADA_PROVA

## Ergonomia de Sistemas Computacionais e IHC

  ID        Resposta   Tipo
  --------- ---------- ---------------------
  ERG-001   A          IDENTICA_PROVA
  ERG-002   B          IDENTICA_PROVA
  ERG-003   B          IDENTICA_PROVA
  ERG-004   B          ADAPTADA_PROVA
  ERG-005   C          ADAPTADA_PROVA
  ERG-006   D          ADAPTADA_PROVA
  ERG-007   C          ADAPTADA_PROVA
  ERG-008   C          ADAPTADA_PROVA
  ERG-009   B          ADAPTADA_PROVA
  ERG-010   B          ADAPTADA_PROVA
  ERG-011   C          ADAPTADA_PROVA
  ERG-012   D          ADAPTADA_PROVA
  ERG-013   A          NOVA_MESMO_CONTEUDO
  ERG-014   C          NOVA_MESMO_CONTEUDO
  ERG-015   C          ADAPTADA_PROVA
  ERG-016   B          ADAPTADA_PROVA
  ERG-017   A          ADAPTADA_PROVA
  ERG-018   A          ADAPTADA_PROVA
  ERG-019   B          ADAPTADA_PROVA
  ERG-020   B          ADAPTADA_PROVA

## Observação pedagógica

As questões discursivas 9 e 10 das provas não foram transformadas em
questões objetivas neste banco inicial. O MVP do sistema foi definido
para múltipla escolha, portanto essas habilidades ficam registradas como
referência pedagógica e podem gerar novas questões objetivas do mesmo
conteúdo, desde que validadas pelo professor.

As questões idênticas foram mantidas deliberadamente para cumprir a
estratégia definida pelo professor: o aluno deve encontrar parte da
prova no simulado, mas também enfrentar variações de contexto, valores e
redação.
