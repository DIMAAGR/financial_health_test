# Processo de design — Financial Health Dashboard

## Visão geral

O design das telas não foi feito diretamente em código. O fluxo foi: exploração visual → refinamento no Figma → geração acelerada de widgets com `figma.to.code` → refinamento e integração no app.

Cada etapa teve um papel específico, e a IA entrou em pontos concretos — acelerando onde fazia sentido e sendo descartada onde o output não se encaixava na arquitetura.

---

## Google Stitch — exploração e seleção de componentes

O [Google Stitch](https://stitch.withgoogle.com) foi usado na fase de exploração visual antes de qualquer linha de código de UI.

O processo foi iterativo: foram geradas diversas variações de telas completas a partir de descrições do produto — cards de score financeiro, gráficos de fluxo, cards de meta mensal, listas de transação. O objetivo não era chegar a um resultado final, mas explorar o espaço de possibilidades rápido:

- Qual hierarquia visual funciona melhor para o score?
- O gráfico de entradas vs despesas deve ser de barras ou de linha?
- Como representar status crítico/atenção/saudável sem depender apenas de cor?
- Onde colocar o saldo para não competir com o score?

A cada iteração, os melhores componentes de telas diferentes foram combinados — um header de uma variação, um card de outra, um layout de lista de uma terceira. O Stitch funcionou como uma ferramenta de curadoria rápida, não de geração final.

**O que foi levado ao Figma:** a composição escolhida das telas, as decisões de hierarquia, o sistema de cores e a paleta de status (crítico = vermelho escuro, atenção = verde escuro, saudável = verde claro).

---

## Figma — refinamento e handoff

Com a composição escolhida, as telas foram refinadas no Figma para:

1. Ajustar espaçamentos e proporções para a grade de 8pt
2. Definir os tokens de cor que depois virariam `ThemeExtension` — os nomes semânticos (`backgroundPrimary`, `metricCardBackground`, `headerTitle`) foram definidos aqui antes de existir uma linha de Dart
3. Validar os estados visuais: loading skeleton, score crítico, score saudável, meta atingida, meta em risco
4. Preparar o dark mode como variante paralela de cada tela

O Figma não foi usado como fonte única de verdade — foi usado como ferramenta de alinhamento. As decisões de componente continuaram sendo feitas em código, com as constraints reais do Flutter.

**MCP do Figma não foi usado** — a integração direta Figma → IDE não estava no fluxo por escolha consciente. O handoff foi manual via `figma.to.code`.

---

## figma.to.code — geração acelerada de widgets

O `figma.to.code` (plugin do Figma) foi usado para gerar o código Flutter inicial dos widgets visuais a partir dos frames do Figma.

O output gerado nunca foi usado diretamente. O que ele entregou:

- Estrutura de `Column`/`Row`/`Stack` inicial correta
- Tamanhos, padding e fontes com os valores do Figma
- Uma base para identificar quais partes eram estáticas e quais precisavam de estado

O que exigiu reescrita completa:

- **Cores hardcoded** — o código gerado usava `Color(0xFF1D5C4A)` inline. Todo widget foi refatorado para consumir as cores via `ThemeExtension`, eliminando qualquer valor de cor fora do tema.
- **Widgets sem estado** — o output era puramente visual, sem conexão com `DashboardState`, `FinancialHealthScoreData` ou qualquer entidade de domínio.
- **Layout fixo** — a geração não considerava variações de tamanho de tela, overflow ou estados de loading.

O `figma.to.code` economizou tempo na estrutura inicial dos widgets complexos (como o card de score e o gráfico de barras de fluxo), mas nenhum arquivo foi commitado sem passar por revisão de arquitetura, extração de cores para o tema e integração com o estado.

---

## Referências

- [Design System e ThemeExtensions →](./design_system.md)
- [Arquitetura do app →](../architecture/architecture.md)
