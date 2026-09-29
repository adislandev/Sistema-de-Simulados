# Rubrica de correção — questões dissertativas (provas presenciais)

> Decisão do professor registrada em [ADI-69](https://linear.app/adislan-consultoria/issue/ADI-69/definir-criterios-de-correcao-das-questoes-dissertativas-rubrica) (2026-09-28). Esta rubrica é a entrada esperada pela correção assistida por IA da [ADI-70](https://linear.app/adislan-consultoria/issue/ADI-70/correcao-automatizada-de-provas-presenciais-fase-2-dissertativas-com) (Fase 2, ainda não iniciada).

## Contexto

A prova presencial de Lógica Computacional tem 7,0 pontos:

- 8 questões objetivas, 0,5 cada = 4,0 pt (OMR, [ADI-68](https://linear.app/adislan-consultoria/issue/ADI-68/correcao-automatizada-de-provas-presenciais-fase-1-piloto-omr))
- 2 questões dissertativas de pseudocódigo, 1,5 cada = 3,0 pt (escopo desta rubrica)

## Modelo de nota por questão dissertativa (1,5 pt)

Crédito parcial por critérios — **não é tudo-ou-nada**:

| Critério | Peso sugerido | Descrição |
|---|---|---|
| Lógica/algoritmo correto | até 1,0 | A estrutura de controle e o raciocínio resolvem o problema pedido |
| Sintaxe do pseudocódigo | até 0,5 | Uso correto de `se/senão/fim-se`, `enquanto/fim-enquanto`, atribuição, etc. |

Regras de combinação:

- Pequeno erro de sintaxe com lógica correta → penalização leve (desconto parcial fixo, não zera a questão). Sugestão inicial: **-0,25 por erro leve**, nunca abaixo de 0.
- Lógica incorreta → nota baixa independentemente da sintaxe.

## Resposta em branco ou ilegível

**Não zerar automaticamente.** Sinalizar como "pendente de revisão manual" (ex.: observação "Ilegível/branco — conferir manualmente") em vez de atribuir nota, já que caligrafia ruim pode ainda conter conteúdo válido.

## Uso pela correção assistida por IA (ADI-70)

Esta rubrica é a entrada para o modelo sugerir nota + justificativa. **Nenhuma nota é definitiva sem o professor confirmar** — revisão humana obrigatória antes de finalizar.

## Em aberto (refinar durante a ADI-70, com exemplos reais de prova)

- Pontuação exata dos sub-critérios por questão específica (1,0 lógica / 0,5 sintaxe é o padrão sugerido; pode variar por questão se o professor quiser pesos diferentes).
- Valor exato do desconto por erro de sintaxe (sugestão inicial acima, a validar com casos reais).
