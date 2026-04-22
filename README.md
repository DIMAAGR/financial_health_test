# Financial Health Test — Conta Azul

> **Nota:** Esta documentação foi escrita com auxílio de IA (Claude Sonnet 4.6 via GitHub Copilot). Os textos, estrutura e decisões documentadas passaram por revisão manual — a IA acelerou a escrita, mas as escolhas técnicas e os julgamentos de qualidade foram feitos pelo desenvolvedor. Este disclaimer foi adicionado durante a sessão em que as docs foram construídas e revisadas iterativamente com o assistente.

Teste técnico assíncrono de Flutter composto por três desafios e um bônus. O objetivo é avaliar capacidade de arquitetura, qualidade de código, pensamento de design system e uso crítico de IA como ferramenta de desenvolvimento.

---

## Visão geral dos desafios

| # | Desafio | O que foi construído |
|---|---------|----------------------|
| 1 | Painel de Saúde Financeira | App Flutter completo com Clean Architecture, Cubit, DI e telas de detalhe |
| 2 | Refatoração de código legado | Análise de 25 problemas + modernização assistida por IA com 75 testes |
| 3 | Widget reutilizável e Design System | `FinancialSummaryCard` em package local com ThemeExtension e dark mode |
| Bônus | MCP Server | Servidor Dart que conecta assistentes de IA ao contexto do projeto |

---

## Financial Health Dashboard

<img src="./docs/assets/screenshots/dashboard_preview.png" alt="Financial Health Dashboard — Score de Saúde Financeira" width="100%" />

**Desafio 1** — App Flutter completo para visualização de saúde financeira pessoal. A tela principal exibe um score calculado em tempo real com base no comprometimento de renda e liquidez, saldo atual, receitas e despesas do mês, análise de fluxo e acompanhamento de meta mensal. A navegação leva para telas de detalhe com breakdown por categoria e lista de movimentações agrupadas por data.

Construído com Clean Architecture, `flutter_bloc` (Cubit), `get_it`, `go_router` e `freezed`. Sem dependência de backend — os dados são gerados por um `FakeHttpService` que simula latência e persistência em memória.

[Documentação completa do app →](./financial_health_dashboard/README.md)

---

## Estrutura do repositório

```
financial_health_test/
├── financial_health_dashboard/       # Desafio 1 — app Flutter principal
│   ├── lib/
│   │   └── src/
│   │       ├── core/                 # DI, router, serviços base
│   │       ├── shared/               # utilitários e componentes genéricos do app
│   │       └── features/
│   │           └── dashboard/        # feature principal
│   │               ├── data/         # repositórios, DTOs, HTTP fake
│   │               ├── domain/       # entidades, casos de uso, políticas
│   │               └── presentation/ # Cubit, states, widgets
│   ├── docs/
│   │   ├── architecture/             # arquitetura, estado, storage, IA no processo
│   │   └── design/                   # design system, processo de design
│   └── test/
│
├── transaction_refactor/             # Desafio 2 — projeto Flutter modernizado
│   ├── docs/                         # análise, prompt log e checklist de correção
│   └── lib/
│
├── packages/
│   └── financial_health_design_system/    # Desafio 3 — package de design system
│       ├── lib/src/
│       │   ├── foundations/          # tokens de espaço, radius e tipografia
│       │   ├── components/           # FinancialSummaryCard e demais widgets
│       │   └── theme/
│       └── test/
│
├── docs/                             # documentação técnica geral do repositório
│   ├── requirements/requirements.md
│   ├── architecture/architecture.md
│   └── ia/                           # regras, prompt log e learnings de IA
│
└── tools/
    └── mcp_server/                   # Bônus — servidor MCP em Dart
```

---

## Desafio 2 — Refatoração de código legado

### O que foi feito

O enunciado apresenta um trecho de código Flutter com tudo acoplado na UI — sem separação de responsabilidades, sem testabilidade, padrão comum em codebases legadas.

A tarefa foi: analisar, criticar e modernizar usando IA como ferramenta principal, documentando cada etapa com evidências.

**Resultado:**
- 25 problemas identificados e categorizados por causa raiz em 6 grupos de correção.
- Código modernizado com Clean Architecture, MVVM com `ValueNotifier` e `get_it`.
- **75 testes unitários — 0 falhas.**
- Prompt completo, questionamentos pós-geração e correções iterativas registradas.

**IAs utilizadas:** Claude Sonnet 4.6 (GitHub Copilot) e GPT 5.4.

Para a análise completa: [transaction_refactor/README.md](./transaction_refactor/README.md)

---

## Desafio 3 — Widget reutilizável e Design System Thinking

### O que é

O `FinancialSummaryCard` é um componente de design system que exibe título, valor, variação percentual, ícone e suporte a callback de toque. Ele foi implementado em um **package local** (`packages/financial_health_design_system`), separado do app.

### Por que virou package

Os componentes compartilhados inicialmente viviam dentro do app em `shared/presentation/design`. O Desafio 3 foi o gatilho para extrair: o `FinancialSummaryCard` precisava ser avaliado como componente de design system com contrato público explícito, sem dependências implícitas de produto.

A extração também formalizou a fronteira entre "o que é do produto" (regras, features) e "o que é do sistema visual" (tokens, componentes, temas).

### Decisões do componente

- **`value` é `String`**: o card não formata moeda nem conhece regra de negócio. Quem chama decide o formato.
- **Cor de variação automática**: positivo ou negativo é resolvido internamente a partir do sinal de `variationPercent`.
- **`ThemeExtension`** com variantes para light e dark mode — sem cores hardcoded no widget.
- **`themePalette`** permite família de cores customizada sem acoplar o widget a nenhuma feature específica.
- Estrutura `Foundations + Components` em vez de Atomic Design — decisão pragmática para o escopo de um componente financeiro reutilizável.

Para detalhes, decisões e testes: [packages/financial_health_design_system/README.md](./packages/financial_health_design_system/README.md)

---

## Bônus — MCP Server

O diretório `tools/mcp_server/` contém um **servidor MCP (Model Context Protocol)** escrito em Dart que conecta assistentes de IA (VS Code Copilot, Claude) diretamente ao contexto do projeto.

### Problema que resolve

Em times Flutter usando IA no dia a dia, três problemas são recorrentes:

1. **Perda de contexto entre sessões** — cada conversa começa do zero; a IA não sabe as decisões já tomadas, os erros já cometidos nem os padrões do time.
2. **Inconsistência no uso** — sem padronização, cada dev interage com a IA de forma diferente.
3. **Scaffolding repetitivo** — criar uma feature nova exige montar 14+ diretórios e 5+ arquivos de boilerplate.

### Ferramentas disponíveis

| Ferramenta | Tipo | O que faz |
|------------|------|-----------|
| `get_project_context` | Leitura | Retorna arquitetura e convenções do projeto |
| `get_rules` | Leitura | Retorna regras de governança e guardrails |
| `get_learnings` | Leitura | Retorna erros documentados com causa raiz e prevenção |
| `search_prompt_log` | Leitura | Busca no histórico de interações por termo |
| `log_interaction` | Escrita | Registra nova interação no `prompt_log.md` |
| `add_learning` | Escrita | Registra novo aprendizado no `learnings.md` |
| `generate_feature_structure` | Geração | Cria hierarquia completa de pastas e arquivos de uma feature |
| `generate_cubit_test` | Geração | Analisa o source de um Cubit e gera scaffold de teste AAA |

Documentação completa: [tools/mcp_server/README.md](./tools/mcp_server/README.md)

---

## Gitflow adotado no projeto

O repositório usou um fluxo de branches simples, adequado para um projeto individual mas que reflete as práticas que seriam usadas em time.

**Branches principais:**
- `main` — estado estável, só recebe via PR
- `feature/*` — desenvolvimento de features (ex: `feature/financial-summary-card`)
- `docs/*` — documentação (ex: `docs/general-documentation`)
- `chore/*` — infra, setup, refatorações sem feature (ex: `chore/extract-design-system-package`)

**Por que gitflow importa aqui mesmo sendo projeto solo:**

O Desafio 3 envolveu extrair o design system de `shared/presentation` para um package local. Em um time, isso seria um risco alto: dois devs com branches abertas usando o caminho antigo teriam conflito de imports ao tentar mergear após a extração.

A disciplina de criar a extração em uma branch isolada, não misturar com feature work, e mergear em um único PR atômico é a mesma que funcionaria em produção — e foi adotada aqui por essa razão. Ver detalhes em [docs/design/design_system.md](./financial_health_dashboard/docs/design/design_system.md#migração-para-package-em-produção--riscos-e-gitflow).

---

## Uso de IA no projeto

A IA foi usada como ferramenta de aceleração — não como substituto de decisão técnica.

O ciclo adotado em todas as entregas:

1. A IA gera uma hipótese (código, estrutura, análise).
2. A hipótese é checada contra arquitetura, escopo e critérios do teste.
3. O que não faz sentido é rejeitado com justificativa.
4. O que faz sentido é adaptado ao contexto.
5. A decisão final é documentada com trade-offs e evidências.

Toda sugestão arquitetural relevante passou por validação manual. Erros identificados foram corrigidos e registrados como learnings — não escondidos.

### Problemas causados pela IA que exigiram correção manual

**Nomes de features incorretos:** em um momento de geração de scaffolding, a IA criou diretórios e arquivos com nomes que não seguiam a convenção `snake_case` do projeto (ex: `AddTransaction` em vez de `add_transaction`). Os imports gerados apontavam para os caminhos errados. A correção foi manual — renomear arquivos, atualizar imports e adicionar a regra de nomenclatura explicitamente no MCP para evitar recorrência.

**Impacto do MCP neste problema:** antes do servidor MCP ser configurado, essa regra não estava documentada de forma acessível para o assistente. Após ser registrada via `add_learning`, a IA passou a respeitar a convenção. O MCP não corrigi o passado, mas evitou repetição.

Outros erros documentados com causa raiz e código real: [docs/architecture/ia_in_process.md](./financial_health_dashboard/docs/architecture/ia_in_process.md)

### MCP Server — contexto persistente para IA

O servidor MCP (`tools/mcp_server/`) foi conectado ao VS Code Copilot durante o desenvolvimento. Ele resolve o problema de "perda de contexto entre sessões": as regras do projeto, os erros já cometidos e a estrutura esperada de uma feature estavam disponíveis para o assistente desde o primeiro prompt de cada sessão.

O histórico completo está em:

- Regras e guardrails: [docs/ia/rules.md](./docs/ia/rules.md)
- Log de prompts e decisões: [docs/ia/prompt_log.md](./docs/ia/prompt_log.md)
- Aprendizados acumulados: [docs/ia/learnings.md](./docs/ia/learnings.md)
- Vantagens e limitações do MCP neste projeto: [financial_health_dashboard/README.md](./financial_health_dashboard/README.md#mcp-server-no-processo-de-desenvolvimento)

---

## Mapa de documentação

| Arquivo | Conteúdo |
|---------|----------|
| [financial_health_dashboard/README.md](./financial_health_dashboard/README.md) | App Flutter — estrutura, arquitetura, decisões e problemas encontrados |
| [transaction_refactor/README.md](./transaction_refactor/README.md) | Refatoração — problemas, modernização, histórico de prompts |
| [packages/financial_health_design_system/README.md](./packages/financial_health_design_system/README.md) | Package local — organização, conteúdo e motivação da extração |
| [docs/requirements/requirements.md](./docs/requirements/requirements.md) | Requisitos funcionais e não funcionais |
| [docs/architecture/architecture.md](./docs/architecture/architecture.md) | Arquitetura, camadas e trade-offs técnicos |
| [docs/ia/README.md](./docs/ia/README.md) | IA no processo — visão geral |
| [tools/mcp_server/README.md](./tools/mcp_server/README.md) | MCP Server — instalação, ferramentas e fluxo de uso |
