# Financial Health Dashboard

Mini-app Flutter do desafio "Painel de Saúde Financeira".

## Visão geral

O objetivo da feature é apresentar um resumo financeiro com foco em legibilidade, estados explícitos de UI e separação de responsabilidades entre camadas.

## Stack

- Flutter + Dart
- `flutter_bloc` (Cubit)
- `get_it` (injeção de dependências)
- `go_router` (navegação)

## Estrutura de código

```txt
lib/src/
  core/
  shared/
  features/
    dashboard/
```

## Descrição visual

A tela principal mostra uma saudação, um card de score de saúde financeira, o saldo atual, cards de receitas/despesas, análise de fluxo e meta mensal. As telas de detalhe usam o mesmo padrão visual: resumo do mês, breakdown por categoria, lista de movimentações agrupadas por data e FAB contextual para adicionar receita ou despesa.

## Como executar

Pré-requisitos:

- Flutter SDK 3.38.1 stable ou compatível com Dart `^3.10.0`
- Device Android/iOS ou emulador/simulador ativo

Ambiente usado na validação:

```bash
Flutter 3.38.1
Dart 3.10.0
```

Comandos:

```bash
flutter pub get
flutter run
```

Testes:

```bash
flutter test
flutter test --coverage
```

Análise estática:

```bash
flutter analyze
```

> **Nota:** este app não requer backend. Os dados são gerados pelo `FakeHttpService` com estado persistido em memória.

## Documentação complementar

- Requisitos: [../docs/requirements/requirements.md](../docs/requirements/requirements.md)
- Arquitetura: [../docs/architecture/architecture.md](../docs/architecture/architecture.md)
- IA no processo: [../docs/ia/README.md](../docs/ia/README.md)

## Uso Crítico de IA (Caso Real)

Este projeto trata "uso crítico de IA" como critério de peso alto. A avaliação não é "usar IA", mas demonstrar capacidade de filtrar, validar, rejeitar, corrigir e justificar decisões.

### Ciclo adotado

1. A IA sugere uma hipótese técnica.
2. A hipótese é checada contra arquitetura, escopo e critérios do teste.
3. O que não faz sentido é rejeitado.
4. O que faz sentido é adaptado ao contexto do projeto.
5. A decisão final é documentada com trade-offs e evidências.

Nem toda mudança registrada abaixo foi tratada como "erro da IA". Para manter a narrativa honesta:

- **Erros reais corrigidos:** casos 1, 5 e 7.
- **Decisões evolutivas validadas:** casos 2, 3, 4, 6, 8 e 9.
- **Critério de aceite:** a classificação depende se havia violação concreta de arquitetura/testabilidade ou se era uma hipótese razoável substituída por outra melhor.

### Caso 1: texto de UI no domínio (correção real)

- Erro identificado: a IA sugeriu manter textos de exibição (`title`/`description`) dentro do domínio da meta mensal.
- Risco arquitetural: mistura de responsabilidades entre `domain` e `presentation`, com impacto em i18n e manutenção.
- Checagem aplicada: revisão de imports/dependências entre camadas para garantir direção correta (`presentation -> domain`, nunca o contrário).
- Correção aplicada: textos foram removidos da entidade e extraídos para mapper de apresentação (`MonthlyGoalTextMapper`).
- Prevenção criada: regra explícita no processo para evitar strings de UI no domínio, com preferência por mapper/presenter na camada de apresentação.

### Caso 2: score financeiro com separação estrita (decisão evolutiva)

- Hipótese da IA: manter dados calculados e textos no mesmo objeto para simplificar.
- Checagem aplicada: para teste técnico, isso aumenta risco de acoplamento entre camadas.
- Decisão: domínio ficou apenas com regra/cálculo/classificação (`FinancialHealthScorePolicy` e `FinancialHealthScoreData`), enquanto os textos foram para `FinancialHealthScoreTextMapper` na apresentação.
- Resultado: maior aderência à separação de responsabilidades, melhor caminho para i18n e testes mais focados por camada.

### Caso 3: formulário unificado de transações (decisão evolutiva)

- Decisão: os fluxos de `Adicionar Receita` e `Adicionar Despesa` usam um único bottom sheet e um único `AddTransactionCubit`.
- Por que: reduz duplicação visual e de estado sem criar dois formulários quase idênticos.
- Como foi protegido: o cubit recebe `SheetType` no construtor, mantém apenas uma categoria atual no state e é criado novamente a cada abertura da sheet.
- Trade-off: a sheet resolve um cubit via DI parametrizada (`registerFactoryParam`) para garantir consistência com o restante da arquitetura.
- Resultado: evita vazamento de estado entre modais, evita `bool isIncome` em métodos públicos e mantém ownership claro do cubit.

### Caso 4: mapper entre apresentação e domínio (decisão evolutiva)

- Decisão: `AddTransactionSheetResult` não conhece mais os inputs de domínio.
- Por que: o resultado do bottom sheet é um objeto de apresentação; a conversão para caso de uso fica em `AddTransactionInputMapper`.
- Resultado: a UI continua simples, mas sem acoplar o modelo visual diretamente ao contrato de domínio.

### Caso 5: loading local no submit (correção real)

- Erro identificado: a versão anterior mantinha um `Future.delayed(2s)` artificial dentro do `AddTransactionCubit.submit()`.
- Risco: delay artificial no cubit mascara a latência real da camada de dados e torna os testes frágeis (dependentes de `pump(Duration)`).
- Correção aplicada: o delay foi removido do cubit. A latência agora vem exclusivamente do `FakeHttpService._latency`, que simula tempo de rede na camada de dados — onde faz sentido.
- Resultado: testes mais rápidos e determinísticos; a apresentação não simula IO.

### Caso 6: Dashboard como snapshot consolidado (decisão evolutiva)

- Decisão: `DashboardState` armazena `financialHealthScore`, `flowAnalysis` e `monthlyGoal` vindos do `DashboardOverviewData`.
- Por que: o overview representa um snapshot consolidado da tela. Recalcular score/flow no state criaria duas possíveis fontes de verdade.
- Resultado: a apresentação lê dados prontos do snapshot e evita divergência entre payload do backend/mock e estado renderizado.

### Caso 7: categorias fortes no domínio, categoria unificada só na UI (correção real)

- Erro identificado: a primeira versão unificou `salary/gift/investment/food/transport/shopping` no domínio e enviou `label` em português para data/API.
- Risco arquitetural: o domínio aceitava estados inválidos, como despesa com categoria `salary`, e o payload dependia de texto de apresentação.
- Correção aplicada: `TransactionCategory` ficou na presentation para simplificar o bottom sheet, enquanto o domínio passou a usar `IncomeCategory` e `ExpenseCategory`.
- Fronteira criada: `AddTransactionInputMapper` converte o resultado visual da sheet em inputs de domínio tipados.
- Contrato de data: o repository recebe categorias fortes e serializa `category.code` para o datasource, mantendo `label` restrito à UI.
- Resultado: a refatoração anterior da sheet continua válida, mas agora com domínio mais seguro e sem mistura de copy/payload.

### Caso 8: tempo como dependência explícita (decisão evolutiva)

- Erro potencial: usar `DateTime.now()` dentro da entidade ou conversão para entidade deixaria a regra da meta mensal dependente de relógio implícito.
- Risco arquitetural: a mesma regra poderia mudar de resultado sem mudança nos dados, especialmente em dashboards abertos durante virada de dia.
- Correção aplicada: `Clock` ficou em `core/services/clock`, registrado via DI, e `MonthlyGoalData` passou a receber `referenceDate` obrigatório.
- Fronteira criada: `DashboardRepositoryImpl` lê `clock.now()`, normaliza para ano/mês/dia e passa a data para `DashboardOverviewModel.toEntity(referenceDate:)`.
- Resultado: domínio determinístico, testes mais confiáveis e infraestrutura de tempo isolada fora da entidade.

### Caso 9: overview e transactions separados no fake backend (decisão evolutiva)

- Decisão: o mock local passou a persistir transações em `financial_transactions_v1`, separado do snapshot `financial_overview_v1`.
- Por que: as telas de detalhe precisam de fontes próprias sem depender do agregado da dashboard.
- Endpoints preparados: `GET /transactions`, `GET /transactions/overview`, `GET /incomes/overview` e `GET /expenses/overview`.
- Trade-off: a versão atual ainda mantém `overview` como snapshot/cache para evitar reescrita grande do fake DB; uma evolução futura poderia separar store, seed, mutação e projeções.
- Resultado: a dashboard atual segue estável e a base de dados fake fica mais próxima de uma API real.

Evidências:

- Regras atualizadas: [../docs/ia/rules.md](../docs/ia/rules.md)
- Log de decisão e correção: [../docs/ia/prompt_log.md](../docs/ia/prompt_log.md)

## Observações

Este README descreve apenas a aplicação Flutter.
As justificativas de arquitetura, trade-offs e uso crítico de IA estão centralizadas em `docs/` para evitar duplicação.
