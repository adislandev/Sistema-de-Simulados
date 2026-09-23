-- Seed inicial de conteúdo — gerado automaticamente por
-- supabase/seed/gerar-seed.mjs a partir de BANCO-DE-QUESTOES.md.
-- NÃO editar à mão: qualquer alteração de conteúdo deve ser feita
-- no markdown fonte e este arquivo deve ser regenerado.
-- Depende da extensão uuid-ossp, criada na migration 0001_init.sql.

-- Disciplinas
insert into disciplinas (id, nome, slug) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'Lógica Computacional', 'logica-computacional');
insert into disciplinas (id, nome, slug) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'Ergonomia de Sistemas Computacionais e IHC', 'ergonomia-ihc');

-- Competências (dedupe por disciplina + nome)
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::rastrear execução de algoritmo com repetição e acumulação'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'rastrear execução de algoritmo com repetição e acumulação');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::compreender soma simples de dois valores'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'compreender soma simples de dois valores');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar condição para número positivo, negativo ou zero'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'interpretar condição para número positivo, negativo ou zero');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar condição aplicada à soma'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'interpretar condição aplicada à soma');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::acompanhar repetição e acumulador'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'acompanhar repetição e acumulador');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::avaliar condição após operação de soma'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'avaliar condição após operação de soma');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::compreender repetição com quantidade definida de execuções'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'compreender repetição com quantidade definida de execuções');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar condição sobre resultado de soma'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'interpretar condição sobre resultado de soma');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::rastrear soma de vários valores'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'rastrear soma de vários valores');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::rastrear acumulador em repetição'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'rastrear acumulador em repetição');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar condição com valor zero'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'interpretar condição com valor zero');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::avaliar comparação com soma'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'avaliar comparação com soma');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::calcular soma acumulada em repetição'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'calcular soma acumulada em repetição');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar condição de maior que'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'interpretar condição de maior que');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::acompanhar incremento em repetição'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'acompanhar incremento em repetição');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::compreender leitura e soma de dois valores'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'compreender leitura e soma de dois valores');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::avaliar duas condições simultaneamente'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'avaliar duas condições simultaneamente');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar limite de comparação'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'interpretar limite de comparação');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::acompanhar soma de três entradas'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'acompanhar soma de três entradas');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar eficiência segundo ISO 9241-11'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar eficiência segundo ISO 9241-11');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar eficácia segundo ISO 9241-11'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar eficácia segundo ISO 9241-11');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer a heurística de controle e liberdade do usuário'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'reconhecer a heurística de controle e liberdade do usuário');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::diferenciar eficácia e eficiência'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'diferenciar eficácia e eficiência');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar satisfação do usuário'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar satisfação do usuário');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar heurística relacionada ao tratamento de erros'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar heurística relacionada ao tratamento de erros');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar manipulação direta'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar manipulação direta');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar wizard'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar wizard');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar interface de linha de comando'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar interface de linha de comando');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar GUI'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar GUI');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar interação por voz'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar interação por voz');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar interação por gestos'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar interação por gestos');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar menus'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar menus');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar formulários'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'identificar formulários');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer a heurística reconhecimento em vez de memorização'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'reconhecer a heurística reconhecimento em vez de memorização');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer prevenção de erros'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'reconhecer prevenção de erros');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer consistência e padrões'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'reconhecer consistência e padrões');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer visibilidade do status do sistema'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'reconhecer visibilidade do status do sistema');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer flexibilidade e eficiência de uso'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'reconhecer flexibilidade e eficiência de uso');
insert into competencias (id, disciplina_id, nome) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer estética e design minimalista'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'reconhecer estética e design minimalista');

-- Simulados (1 por disciplina no MVP — usa as 20 questões inteiras)
insert into simulados (id, disciplina_id, titulo, qtd_questoes) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), 'Simulado — Lógica Computacional', 20);
insert into simulados (id, disciplina_id, titulo, qtd_questoes) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), 'Simulado — Ergonomia de Sistemas Computacionais e IHC', 20);

-- Questões
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-001'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::rastrear execução de algoritmo com repetição e acumulação'), 'LC-001', 'Considere o algoritmo:

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

Se o usuário digitar 6 e 4, qual será a saída?', 'IDENTICA_PROVA', 'fácil', 'Prova N1 --- Questão 1');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-002'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::compreender soma simples de dois valores'), 'LC-002', 'Considere:

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

Se o usuário digitar 9 e 1, qual será a saída?', 'IDENTICA_PROVA', 'fácil', 'Prova N1 --- Questão 3');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-003'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar condição para número positivo, negativo ou zero'), 'LC-003', 'Analise:

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

Entrada: -2.', 'IDENTICA_PROVA', 'fácil', 'Prova N1 --- Questão 6');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-004'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar condição aplicada à soma'), 'LC-004', 'Considere o algoritmo:

``` text
algoritmo "SomaAcima"
var
  a, b, soma: inteiro
inicio
  leia(a)
  leia(b)
  soma <- a + b
  se soma > 14 entao
    escreva("Acima")
  senao
    escreva("Abaixo")
  fimse
fimalgoritmo
```

Se forem informados 8 e 7, qual será o resultado?', 'ADAPTADA_PROVA', 'fácil', 'baseada nas Questões 2 e 7 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-005'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::acompanhar repetição e acumulador'), 'LC-005', 'Observe o algoritmo:

``` text
algoritmo "RepeteSoma5"
var
  soma, i: inteiro
inicio
  soma <- 0
  para i de 1 ate 3 faca
    soma <- soma + 5
  fimpara
  escreva(soma)
fimalgoritmo
```

Qual será o resultado final?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 5 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-006'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::avaliar condição após operação de soma'), 'LC-006', 'Considere:

``` text
algoritmo "VerificaSoma12"
var
  a, b, soma: inteiro
inicio
  leia(a)
  leia(b)
  soma <- a + b
  se soma >= 12 entao
    escreva("Soma alta")
  senao
    escreva("Soma baixa")
  fimse
fimalgoritmo
```

Para os valores 5 e 7, qual mensagem deve ser apresentada?', 'ADAPTADA_PROVA', 'média', 'baseada na Questão 2 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-007'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::compreender repetição com quantidade definida de execuções'), 'LC-007', 'Analise o algoritmo a seguir:

``` text
algoritmo "RepeteSoma2"
var
  soma, i: inteiro
inicio
  soma <- 0
  para i de 1 ate 4 faca
    soma <- soma + 2
  fimpara
  escreva(soma)
fimalgoritmo
```

Qual será o resultado?', 'ADAPTADA_PROVA', 'média', 'baseada nas Questões 5 e 8 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-008'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar condição sobre resultado de soma'), 'LC-008', 'Considere o algoritmo:

``` text
algoritmo "TesteSoma8"
var
  soma: inteiro
inicio
  soma <- 10 + 3
  se soma > 8 entao
    escreva("Maior que 8")
  senao
    escreva("Menor ou igual a 8")
  fimse
fimalgoritmo
```

Qual será a saída?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 4 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-009'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::rastrear soma de vários valores'), 'LC-009', 'Observe o algoritmo:

``` text
algoritmo "SomaTresValores"
var
  n, soma, i: inteiro
inicio
  soma <- 0
  para i de 1 ate 3 faca
    leia(n)
    soma <- soma + n
  fimpara
  escreva(soma)
fimalgoritmo
```

Se forem informados 4, 2 e 5, qual será o resultado?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 8 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-010'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::rastrear acumulador em repetição'), 'LC-010', 'Considere o algoritmo:

``` text
algoritmo "LacoAcrescenta2"
var
  soma, i: inteiro
inicio
  soma <- 0
  i <- 1
  enquanto i <= 4 faca
    soma <- soma + 2
    i <- i + 1
  fimenquanto
  escreva(soma)
fimalgoritmo
```

Qual será o resultado?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 5 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-011'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar condição com valor zero'), 'LC-011', 'Analise o algoritmo a seguir:

``` text
algoritmo "VerificaPositivo"
var
  n: inteiro
inicio
  leia(n)
  se n > 0 entao
    escreva("Positivo")
  senao
    escreva("Negativo ou zero")
  fimse
fimalgoritmo
```

Se n = 0, qual será o resultado?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 6 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-012'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::avaliar comparação com soma'), 'LC-012', 'Considere:

``` text
algoritmo "TesteSoma12"
var
  soma: inteiro
inicio
  soma <- 11 + 2
  se soma > 12 entao
    escreva("Acima")
  senao
    escreva("Abaixo")
  fimse
fimalgoritmo
```

Qual será a saída?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 7 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-013'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::calcular soma acumulada em repetição'), 'LC-013', 'Observe o algoritmo:

``` text
algoritmo "SomaTresValoresB"
var
  n, soma, i: inteiro
inicio
  soma <- 0
  para i de 1 ate 3 faca
    leia(n)
    soma <- soma + n
  fimpara
  escreva(soma)
fimalgoritmo
```

Se forem informados 1, 3 e 2, qual será o resultado?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 8 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-014'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar condição de maior que'), 'LC-014', 'Considere o algoritmo:

``` text
algoritmo "TesteSomaSenao"
var
  a, b, soma: inteiro
inicio
  leia(a)
  leia(b)
  soma <- a + b
  se soma > 8 entao
    escreva("Maior que 8")
  senao
    escreva("Menor ou igual a 8")
  fimse
fimalgoritmo
```

Para os valores 4 e 4, qual mensagem corresponde ao `senao`?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 4 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-015'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::acompanhar incremento em repetição'), 'LC-015', 'Analise o algoritmo a seguir:

``` text
algoritmo "LacoAcrescenta1"
var
  soma, i: inteiro
inicio
  soma <- 0
  i <- 0
  repita
    soma <- soma + 1
    i <- i + 1
  ate i = 5
  escreva(soma)
fimalgoritmo
```

Qual será o resultado?', 'NOVA_MESMO_CONTEUDO', 'fácil', 'mesmo conteúdo das estruturas de repetição da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-016'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::compreender leitura e soma de dois valores'), 'LC-016', 'Considere:

``` text
algoritmo "SomaDoisValores"
var
  a, b, soma: inteiro
inicio
  leia(a)
  leia(b)
  soma <- a + b
  escreva(soma)
fimalgoritmo
```

Se forem informados 12 e 8, qual será a saída?', 'NOVA_MESMO_CONTEUDO', 'fácil', 'mesmo conteúdo de soma da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-017'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::avaliar duas condições simultaneamente'), 'LC-017', 'Considere o algoritmo:

``` text
algoritmo "CondicaoComposta"
var
  n: inteiro
  resultado: logico
inicio
  leia(n)
  resultado <- (n > 10) e (n > 14)
  escreva(resultado)
fimalgoritmo
```

Para n = 15, qual é o resultado da condição?', 'NOVA_MESMO_CONTEUDO', 'média', 'mesmo conteúdo de condição com operador E da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-018'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::avaliar duas condições simultaneamente'), 'LC-018', 'Observe o algoritmo:

``` text
algoritmo "CondicaoCompostaB"
var
  n: inteiro
  resultado: logico
inicio
  leia(n)
  resultado <- (n > 10) e (n > 14)
  escreva(resultado)
fimalgoritmo
```

Para n = 10, qual é o resultado da condição?', 'NOVA_MESMO_CONTEUDO', 'média', 'mesmo conteúdo de condição com operador E da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-019'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::interpretar limite de comparação'), 'LC-019', 'Considere o algoritmo:

``` text
algoritmo "SomaAltaOuBaixa"
var
  a, b, soma: inteiro
inicio
  leia(a)
  leia(b)
  soma <- a + b
  se soma >= 15 entao
    escreva("Soma alta")
  senao
    escreva("Soma baixa")
  fimse
fimalgoritmo
```

Para os valores 7 e 5, qual será a saída?', 'ADAPTADA_PROVA', 'média', 'baseada na Questão 2 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-020'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:logica-computacional::acompanhar soma de três entradas'), 'LC-020', 'Analise o algoritmo a seguir:

``` text
algoritmo "SomaTresValoresC"
var
  n, soma, i: inteiro
inicio
  soma <- 0
  para i de 1 ate 3 faca
    leia(n)
    soma <- soma + n
  fimpara
  escreva(soma)
fimalgoritmo
```

Se forem informados 2, 3 e 4, qual será o resultado?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 8 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-001'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar eficiência segundo ISO 9241-11'), 'ERG-001', 'Um aluno desenvolveu um protótipo no Figma e percebeu que os usuários
conseguem concluir tarefas, mas com dificuldade e demora. Segundo a NBR
ISO 9241-11, isso indica problema em qual aspecto da usabilidade?', 'IDENTICA_PROVA', 'fácil', 'Prova N1 --- Questão 1');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-002'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar eficácia segundo ISO 9241-11'), 'ERG-002', 'Durante um teste, os usuários conseguem completar uma tarefa
corretamente, sem erros. Segundo a ISO 9241-11, isso representa:', 'IDENTICA_PROVA', 'fácil', 'Prova N1 --- Questão 2');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-003'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer a heurística de controle e liberdade do usuário'), 'ERG-003', 'Um sistema mobile permite que o usuário desfaça uma ação facilmente.
Isso atende qual heurística de Nielsen?', 'IDENTICA_PROVA', 'fácil', 'Prova N1 --- Questão 5');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-004'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::diferenciar eficácia e eficiência'), 'ERG-004', 'Em um sistema, os usuários conseguem concluir uma tarefa sem erros, mas
precisam de muito tempo para realizá-la. Qual afirmação está correta?', 'ADAPTADA_PROVA', 'média', 'baseada nas Questões 1 e 2 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-005'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar satisfação do usuário'), 'ERG-005', 'Após utilizar um aplicativo, os usuários relatam que a experiência foi
agradável e confortável. Qual aspecto da ISO 9241-11 está diretamente
relacionado a esse resultado?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 3 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-006'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar heurística relacionada ao tratamento de erros'), 'ERG-006', 'Um aplicativo apresenta uma mensagem clara quando ocorre um erro e
orienta o usuário sobre como corrigi-lo. Qual heurística de Nielsen está
diretamente relacionada?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 4 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-007'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar manipulação direta'), 'ERG-007', 'Um usuário arrasta um arquivo da área de trabalho diretamente para uma
pasta usando o mouse. Esse tipo de interação é:', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 7 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-008'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar wizard'), 'ERG-008', 'Um sistema apresenta várias telas sequenciais para orientar o usuário
durante a instalação de um programa. Esse estilo de interação é:', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 8 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-009'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar interface de linha de comando'), 'ERG-009', 'Um usuário opera um sistema digitando comandos como `cd`, `ls` e
`mkdir`. Qual estilo de interface está sendo utilizado?', 'ADAPTADA_PROVA', 'fácil', 'baseada na Questão 6 da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-010'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar GUI'), 'ERG-010', 'Um aplicativo apresenta janelas, ícones, botões e elementos clicáveis
para interação. Qual estilo de interface é esse?', 'ADAPTADA_PROVA', 'fácil', 'baseada nos estilos de interface da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-011'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar interação por voz'), 'ERG-011', 'Um usuário solicita verbalmente a um assistente virtual que ligue as
luzes de uma sala. Qual estilo de interação está sendo utilizado?', 'ADAPTADA_PROVA', 'fácil', 'baseada nos estilos de interface da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-012'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar interação por gestos'), 'ERG-012', 'Um aplicativo permite ampliar uma imagem usando um gesto de pinça com
dois dedos. Esse tipo de interação está relacionado a:', 'ADAPTADA_PROVA', 'fácil', 'baseada nos estilos de interação da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-013'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar menus'), 'ERG-013', 'Um sistema organiza comandos em opções como "Arquivo", "Editar",
"Exibir" e "Ajuda", permitindo que o usuário escolha uma delas. Qual
estilo de interação está representado?', 'NOVA_MESMO_CONTEUDO', 'fácil', 'mesmo conteúdo de estilos de interação da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-014'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::identificar formulários'), 'ERG-014', 'Uma página solicita nome, e-mail e senha por meio de campos estruturados
para preenchimento. Qual estilo de interação está sendo utilizado?', 'NOVA_MESMO_CONTEUDO', 'fácil', 'mesmo conteúdo de estilos de interação da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-015'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer a heurística reconhecimento em vez de memorização'), 'ERG-015', 'Um sistema mostra opções e comandos visíveis na tela para que o usuário
não precise memorizar códigos. Qual heurística de Nielsen está sendo
favorecida?', 'ADAPTADA_PROVA', 'média', 'baseada na Questão 5 e nas heurísticas de Nielsen');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-016'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer prevenção de erros'), 'ERG-016', 'Um botão de confirmação permanece desabilitado enquanto os dados
obrigatórios de um formulário não forem preenchidos. Qual heurística
está sendo aplicada?', 'ADAPTADA_PROVA', 'fácil', 'conteúdo de heurísticas de Nielsen da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-017'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer consistência e padrões'), 'ERG-017', 'Um aplicativo usa a mesma aparência, posição e comportamento para botões
equivalentes em todas as telas. Qual heurística está sendo aplicada?', 'ADAPTADA_PROVA', 'fácil', 'conteúdo de heurísticas de Nielsen da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-018'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer visibilidade do status do sistema'), 'ERG-018', 'Após o usuário clicar em "Salvar", o sistema mostra imediatamente uma
mensagem informando que o arquivo foi salvo. Qual heurística está sendo
atendida?', 'ADAPTADA_PROVA', 'fácil', 'conteúdo de heurísticas de Nielsen da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-019'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer flexibilidade e eficiência de uso'), 'ERG-019', 'Um sistema oferece atalhos de teclado para usuários experientes,
mantendo também os comandos tradicionais para iniciantes. Qual
heurística está relacionada?', 'ADAPTADA_PROVA', 'média', 'conteúdo de heurísticas de Nielsen da prova');
insert into questoes (id, disciplina_id, competencia_id, codigo, enunciado, tipo, dificuldade, origem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-020'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'disciplina:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'competencia:ergonomia-ihc::reconhecer estética e design minimalista'), 'ERG-020', 'Uma interface remove informações e elementos visuais desnecessários,
mantendo apenas o que ajuda o usuário a realizar a tarefa. Qual
heurística está sendo aplicada?', 'ADAPTADA_PROVA', 'fácil', 'conteúdo de heurísticas de Nielsen da prova');

-- Alternativas
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-001:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-001'), 'Total: 10', true, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-001:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-001'), 'Total: 24', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-001:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-001'), 'Total: 6', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-001:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-001'), 'Total: 4', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-001:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-001'), 'Total: 2', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-002:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-002'), '10', true, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-002:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-002'), '9', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-002:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-002'), '1', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-002:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-002'), '91', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-002:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-002'), '0', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-003:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-003'), 'Positivo', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-003:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-003'), 'Negativo', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-003:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-003'), 'Negativo ou zero', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-003:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-003'), 'Zero', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-003:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-003'), 'Erro', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-004:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-004'), 'Acima', true, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-004:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-004'), 'Abaixo', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-004:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-004'), 'Igual', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-004:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-004'), 'Erro', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-004:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-004'), 'Nenhuma', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-005:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-005'), '5', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-005:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-005'), '10', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-005:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-005'), '15', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-005:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-005'), '20', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-005:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-005'), '3', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-006:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-006'), 'Soma alta', true, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-006:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-006'), 'Soma baixa', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-006:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-006'), 'Soma igual a 10', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-006:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-006'), 'Erro', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-006:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-006'), 'Nenhuma', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-007:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-007'), '2', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-007:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-007'), '4', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-007:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-007'), '6', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-007:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-007'), '8', true, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-007:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-007'), '10', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-008:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-008'), 'Maior que 8', true, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-008:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-008'), 'Menor ou igual a 8', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-008:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-008'), 'Igual a 8', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-008:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-008'), 'Erro', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-008:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-008'), 'Nenhuma', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-009:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-009'), '6', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-009:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-009'), '9', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-009:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-009'), '11', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-009:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-009'), '12', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-009:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-009'), '15', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-010:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-010'), '4', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-010:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-010'), '6', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-010:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-010'), '8', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-010:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-010'), '10', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-010:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-010'), '12', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-011:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-011'), 'Positivo', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-011:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-011'), 'Negativo', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-011:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-011'), 'Zero', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-011:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-011'), 'Negativo ou zero', true, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-011:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-011'), 'Erro', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-012:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-012'), 'Acima', true, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-012:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-012'), 'Abaixo', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-012:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-012'), 'Igual', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-012:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-012'), 'Erro', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-012:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-012'), 'Nenhuma', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-013:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-013'), '4', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-013:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-013'), '5', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-013:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-013'), '6', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-013:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-013'), '7', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-013:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-013'), '8', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-014:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-014'), 'Maior que 8', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-014:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-014'), 'Menor ou igual a 8', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-014:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-014'), 'Maior ou igual a 8', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-014:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-014'), 'Igual a 10', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-014:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-014'), 'Erro', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-015:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-015'), '1', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-015:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-015'), '4', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-015:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-015'), '5', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-015:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-015'), '6', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-015:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-015'), '10', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-016:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-016'), '18', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-016:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-016'), '20', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-016:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-016'), '22', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-016:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-016'), '96', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-016:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-016'), '128', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-017:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-017'), 'Verdadeiro', true, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-017:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-017'), 'Falso', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-017:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-017'), 'Erro', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-017:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-017'), 'Zero', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-017:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-017'), 'Indefinido', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-018:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-018'), 'Verdadeiro', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-018:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-018'), 'Falso', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-018:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-018'), '10', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-018:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-018'), '14', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-018:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-018'), 'Erro', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-019:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-019'), 'Soma alta', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-019:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-019'), 'Soma baixa', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-019:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-019'), 'Soma igual', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-019:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-019'), 'Erro', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-019:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-019'), 'Nenhuma', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-020:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-020'), '7', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-020:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-020'), '8', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-020:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-020'), '9', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-020:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-020'), '10', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:LC-020:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-020'), '12', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-001:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-001'), 'Eficiência', true, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-001:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-001'), 'Segurança', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-001:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-001'), 'Portabilidade', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-001:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-001'), 'Compatibilidade', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-001:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-001'), 'Programação', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-002:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-002'), 'Eficiência', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-002:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-002'), 'Eficácia', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-002:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-002'), 'Usabilidade técnica', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-002:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-002'), 'Interface gráfica', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-002:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-002'), 'Interação', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-003:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-003'), 'Consistência e padrões', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-003:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-003'), 'Controle e liberdade do usuário', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-003:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-003'), 'Reconhecimento em vez de memorização', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-003:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-003'), 'Flexibilidade e eficiência', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-003:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-003'), 'Ajuda e documentação', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-004:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-004'), 'A eficácia está comprometida e a eficiência está adequada.', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-004:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-004'), 'A eficácia está adequada, mas a eficiência precisa ser melhorada.', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-004:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-004'), 'Eficácia e eficiência são exatamente a mesma coisa.', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-004:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-004'), 'Apenas a estética está comprometida.', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-004:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-004'), 'O problema é exclusivamente de segurança.', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-005:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-005'), 'Eficácia', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-005:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-005'), 'Eficiência', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-005:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-005'), 'Satisfação', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-005:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-005'), 'Portabilidade', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-005:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-005'), 'Compatibilidade', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-006:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-006'), 'Consistência e padrões', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-006:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-006'), 'Prevenção de erros', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-006:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-006'), 'Reconhecimento em vez de memorização', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-006:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-006'), 'Ajuda o usuário a reconhecer, diagnosticar e corrigir erros', true, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-006:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-006'), 'Controle e liberdade do usuário', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-007:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-007'), 'Menu', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-007:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-007'), 'Formulário', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-007:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-007'), 'Manipulação direta', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-007:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-007'), 'Linguagem natural', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-007:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-007'), 'Wizard', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-008:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-008'), 'CLI', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-008:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-008'), 'Menu', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-008:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-008'), 'Wizard', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-008:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-008'), 'Linguagem natural', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-008:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-008'), 'Gestos', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-009:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-009'), 'GUI', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-009:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-009'), 'CLI', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-009:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-009'), 'Voz', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-009:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-009'), 'Toque', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-009:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-009'), 'Gestos', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-010:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-010'), 'CLI', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-010:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-010'), 'GUI', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-010:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-010'), 'Voz', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-010:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-010'), 'Linguagem natural', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-010:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-010'), 'Wizard', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-011:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-011'), 'CLI', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-011:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-011'), 'GUI', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-011:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-011'), 'Voz', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-011:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-011'), 'Menu', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-011:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-011'), 'Formulário', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-012:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-012'), 'CLI', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-012:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-012'), 'Voz', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-012:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-012'), 'Toque', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-012:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-012'), 'Gestos', true, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-012:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-012'), 'Menu', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-013:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-013'), 'Menu', true, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-013:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-013'), 'Formulário', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-013:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-013'), 'Manipulação direta', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-013:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-013'), 'Wizard', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-013:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-013'), 'CLI', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-014:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-014'), 'Menu', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-014:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-014'), 'Linguagem natural', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-014:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-014'), 'Formulário', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-014:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-014'), 'Wizard', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-014:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-014'), 'CLI', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-015:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-015'), 'Estética e design minimalista', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-015:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-015'), 'Controle e liberdade do usuário', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-015:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-015'), 'Reconhecimento em vez de memorização', true, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-015:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-015'), 'Consistência e padrões', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-015:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-015'), 'Prevenção de erros', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-016:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-016'), 'Flexibilidade e eficiência de uso', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-016:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-016'), 'Prevenção de erros', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-016:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-016'), 'Estética e design minimalista', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-016:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-016'), 'Controle e liberdade do usuário', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-016:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-016'), 'Consistência e padrões', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-017:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-017'), 'Consistência e padrões', true, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-017:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-017'), 'Prevenção de erros', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-017:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-017'), 'Controle e liberdade do usuário', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-017:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-017'), 'Flexibilidade e eficiência', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-017:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-017'), 'Ajuda e documentação', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-018:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-018'), 'Visibilidade do status do sistema', true, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-018:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-018'), 'Consistência e padrões', false, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-018:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-018'), 'Estética e design minimalista', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-018:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-018'), 'Reconhecimento em vez de memorização', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-018:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-018'), 'Controle e liberdade do usuário', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-019:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-019'), 'Estética e design minimalista', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-019:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-019'), 'Flexibilidade e eficiência de uso', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-019:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-019'), 'Consistência e padrões', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-019:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-019'), 'Controle e liberdade do usuário', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-019:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-019'), 'Prevenção de erros', false, 5);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-020:A'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-020'), 'Consistência e padrões', false, 1);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-020:B'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-020'), 'Estética e design minimalista', true, 2);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-020:C'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-020'), 'Prevenção de erros', false, 3);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-020:D'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-020'), 'Feedback', false, 4);
insert into alternativas (id, questao_id, texto, correta, ordem) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'alternativa:ERG-020:E'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-020'), 'Controle e liberdade do usuário', false, 5);

-- Vínculo questão <-> simulado (todas as 20 de cada disciplina)
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-001'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-001'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-002'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-002'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-003'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-003'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-004'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-004'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-005'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-005'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-006'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-006'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-007'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-007'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-008'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-008'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-009'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-009'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-010'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-010'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-011'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-011'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-012'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-012'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-013'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-013'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-014'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-014'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-015'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-015'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-016'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-016'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-017'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-017'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-018'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-018'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-019'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-019'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:LC-020'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:logica-computacional'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:LC-020'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-001'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-001'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-002'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-002'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-003'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-003'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-004'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-004'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-005'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-005'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-006'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-006'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-007'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-007'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-008'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-008'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-009'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-009'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-010'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-010'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-011'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-011'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-012'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-012'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-013'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-013'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-014'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-014'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-015'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-015'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-016'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-016'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-017'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-017'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-018'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-018'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-019'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-019'));
insert into simulado_questoes (id, simulado_id, questao_id) values (uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado_questao:ERG-020'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'simulado:ergonomia-ihc'), uuid_generate_v5('c53a3f0a-2b1e-4c2e-9d0e-9a2f6b5a2d10'::uuid, 'questao:ERG-020'));
