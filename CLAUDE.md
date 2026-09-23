# CLAUDE.md — Sistema de Simulados

## 1. Propósito
Guia operacional do agente de desenvolvimento deste projeto. Use este arquivo como índice de regras; os detalhes ficam nos documentos da raiz do projeto.

## 2. Documentos de referência
- `README.md` — visão geral e instruções rápidas.
- `PRD-Sistema-de-Simulados.md` — requisitos, regras e escopo.
- `BANCO-DE-QUESTOES.md` — questões, alternativas, respostas, competências e origem.
- `PROMPT-INICIAL-CLOUD-CODE.md` — prompt/briefing inicial do projeto.

Não existe pasta `docs/` nem arquivo `REGRAS-PEDAGOGICAS.md` neste projeto — regra pedagógica adicional, quando surgir, deve ser adicionada a um destes documentos ou criada como novo arquivo na raiz, nunca presumida.

## 3. Fonte de verdade
A regra pedagógica definida pelo professor é a fonte de verdade.
Não inventar, alterar ou simplificar uma regra pedagógica por conta própria. Em caso de conflito ou ambiguidade que altere o escopo, sinalizar e pedir validação antes de implementar.

## 4. Stack
- React
- Vite
- Supabase para backend/banco
- Hostinger para hospedagem do frontend
- GitHub para versionamento

**Aluno nunca usa Supabase Auth** (identificação simples, conforme PRD). **O professor usa Supabase Auth**, com conta única (e-mail/senha) — decisão já validada e já implementada nas policies de `supabase/migrations/0001_init.sql` (role `authenticated`). Não criar autenticação sofisticada ou multiusuário para o professor além dessa conta única.
A integração com Supabase pode ser feita via CLI/MCP conforme as permissões disponíveis.

## 5. Estratégia de escolha do modelo
A escolha do modelo deve considerar complexidade, velocidade e custo.

- **Tarefas simples/repetitivas:** usar um modelo rápido/Haiku, quando disponível.
- **Desenvolvimento e implementação geral:** usar Sonnet como padrão.
- **Arquitetura, debugging complexo e decisões técnicas críticas:** usar Opus quando disponível e justificável.

A escolha do modelo não altera os requisitos do projeto. Todos os modelos devem seguir este `CLAUDE.md`, o PRD e os demais documentos de referência.

Não usar um modelo mais pesado apenas por padrão quando a tarefa puder ser resolvida adequadamente por um modelo mais rápido.

Os nomes e versões exatos dos modelos podem mudar conforme a versão do Claude Code e a conta utilizada. Portanto, não fixar uma versão específica neste arquivo sem necessidade.

## 6. Escopo inicial
Disciplinas:
- Lógica Computacional
- Ergonomia

O MVP deve ser simples, rápido e focado na experiência do aluno e na análise básica do professor. Não transformar o projeto em uma plataforma acadêmica completa.

## 7. Fluxo do aluno
O aluno não precisa criar uma conta tradicional no MVP.
A identificação deve usar apenas os dados mínimos definidos no PRD.
Evitar código de turma ou processos desnecessários.

## 8. Três tentativas
### Primeira
Autoanálise. Mostrar nota, acertos, erros, competências/habilidades e tempo.

### Segunda
Verificar evolução após estudo. Comparar principalmente nota anterior x atual e desempenho.

### Terceira
Consolidar o treinamento. Registrar o resultado individual.

Tentativas extras, se permitidas, devem ser tratadas como treino e não confundidas com as três notas principais.

## 9. Nota
- 20 questões.
- Cada questão vale 0,5 ponto.
- Nota máxima = 10.
- Registrar as três notas individualmente.
- Calcular a média das três para o ponto extra, conforme o PRD.

Não alterar essa regra sem validação.

## 10. Experiência do simulado
Nas três primeiras tentativas:
- uma questão por tela;
- questões embaralhadas;
- sem barra de progresso;
- cronômetro iniciado ao começar;
- selecionar e confirmar;
- avançar para a próxima;
- não voltar;
- não alterar resposta após confirmação.

O objetivo é diagnóstico e treinamento, não punição.

## 11. Banco de questões
Fonte: `BANCO-DE-QUESTOES.md`.

As questões devem seguir o conteúdo efetivamente trabalhado na prova. Não adicionar conteúdos apenas porque pertencem genericamente à disciplina.

Tipos:
- `IDENTICA_PROVA`
- `ADAPTADA_PROVA`
- `NOVA_MESMO_CONTEUDO`

Algumas questões idênticas à prova são intencionais.
Não modificar silenciosamente o banco.

## 12. Painel do professor
No mínimo:
- aluno;
- disciplina;
- nota da 1ª, 2ª e 3ª tentativa;
- média;
- tempo das tentativas.

Também deve existir visão simples da turma para identificar questões com maior índice de erro. Essa análise é auxiliar, não um BI complexo.

## 13. Exportação
O professor precisa exportar resultados para planilha, prioritariamente CSV compatível com Excel, contendo aluno, três notas, média e dados necessários para lançamento posterior no sistema acadêmico.

## 14. Banco de dados
Usar Supabase. Modelar de forma simples os conceitos necessários para:
- alunos;
- disciplinas;
- simulados;
- questões;
- alternativas;
- tentativas;
- respostas;
- resultados.

Evitar overengineering.

## 15. Supabase
Usar um projeto Supabase separado.
Aluno nunca usa Supabase Auth. Professor usa Supabase Auth com conta única (ver seção 4) — já implementado no schema aplicado.
CLI/MCP pode ser utilizado para configuração conforme permissões.
Como o plano gratuito pode pausar projetos por inatividade, a solução de health check/manutenção deve seguir o PRD e ser documentada antes de implementação.

## 16. Segurança
- Nunca colocar segredos no frontend.
- Usar variáveis de ambiente.
- Nunca expor service role key.
- Proteger operações administrativas.
- Validar dados recebidos.
- Usar RLS/políticas adequadas quando necessário.

## 17. UI/UX
Interface limpa, moderna, responsiva, rápida e adequada a estudantes.
O objetivo é oferecer experiência melhor que um Google Forms genérico.
Durante o simulado, priorizar foco na questão e evitar elementos que distraiam.

## 18. Processo de desenvolvimento
Antes de uma implementação grande:
1. Ler este arquivo.
2. Consultar o PRD.
3. Consultar os documentos específicos.
4. Identificar dependências.
5. Implementar incrementalmente.

Não perguntar novamente algo que já esteja definido na documentação.
Não inventar regras críticas que não estejam definidas.

## 19. Deploy
Projeto pequeno e experimental. Após validação, pode ser publicado diretamente na Hostinger conforme o README. Não criar infraestrutura de staging complexa sem necessidade.

## 20. Fora do escopo sem autorização
Não adicionar:
- gamificação complexa;
- ranking público;
- chat;
- fórum;
- certificados;
- LMS completo;
- sistema acadêmico completo;
- autenticação sofisticada.

## 21. Regra final
Na dúvida entre construir mais ou menos, preferir a menor solução que cumpra o requisito documentado.

Dúvida pedagógica: não decidir sozinho.
Dúvida técnica sem impacto pedagógico: preferir solução simples, sustentável e compatível com a stack.
