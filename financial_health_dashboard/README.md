# Financial Health Dashboard

<table>
<tr>
<td valign="top" width="62%">

O **Financial Health Dashboard** é um app mobile que transforma números financeiros brutos em uma leitura clara e imediata do seu estado financeiro. Você abre o app e vê na hora se está saudável, em atenção ou em situação crítica — sem precisar fazer nenhuma conta.

A tela principal exibe um **score de saúde financeira** calculado com base no quanto da sua renda você está comprometendo e como sua liquidez evoluiu no mês. A partir daí, você navega para telas de detalhe que mostram o breakdown de receitas ou despesas por categoria, a lista de movimentações agrupadas por data e uma ação contextual para registrar uma nova receita ou despesa diretamente na tela em que você está.

**Stack principal:** Flutter · Dart · `flutter_bloc` (Cubit) · `freezed` · `get_it` · `go_router` · `dartz`

**Sem backend:** os dados são gerados por um `FakeHttpService` que simula latência de rede, mutações e persistência em memória durante a sessão. Não há nada para configurar além de ter um emulador ou device ativo.

</td>
<td valign="top" align="center" width="38%">
<img src="../docs/assets/screenshots/dashboard_full.png" alt="Dashboard completo" width="260" />
</td>
</tr>
</table>

---

## Estrutura de pastas

### Por que essa estrutura foi escolhida

A decisão de arquitetura não partiu de preferência pessoal — ela foi simulada antes da implementação com a IA, usando o contexto real do projeto como entrada.

**Prompt de exploração arquitetural:**

```
Imagine que estamos iniciando o desenvolvimento de um novo aplicativo.
Nesse MVP temos 5 telas que se conectam a uma API REST.
A linguagem e framework adotados são Dart e Flutter.
Precisamos decidir a arquitetura do projeto.

Contexto:
- Quantos desenvolvedores? 2 front-end
- Quanto tempo? 3 meses
- Quantas funcionalidades? 5
- Tipo de projeto? Overview (Dashboard) de saúde financeira
- Conexão com API externa? Sim
- Persistência offline + Offline First? Sim
- O MVP é POC que será refatorado depois? Não
- Reutilização de funcionalidades em outro app no futuro? Não
```

A partir das respostas, foram analisadas comparativamente:

- **DDD completo vs DDD pragmático** — DDD completo traz isolamento forte mas exige camadas extras (application, value objects, aggregates) sem retorno claro para 5 features em 3 meses com 2 devs. DDD pragmático mantém entidades e políticas de negócio no domínio sem a cerimônia desnecessária.
- **Clean Architecture vs FSD vs monolítica** — Clean Architecture com separação `data/domain/presentation` por feature garante testabilidade sem o custo de micro-frontends ou feature-sliced design para esse escopo.
- **Feature-first vs camadas globais** — Feature-first (agrupar por contexto funcional) foi escolhido sobre camadas globais (agrupar por tipo: todos os repositories juntos, todos os cubits juntos). Razão: menor acoplamento entre contextos, remoção de feature sem impacto transversal, onboarding mais localizado.
- **MVVM vs MVP vs MVC** — MVVM com Cubit foi escolhido sobre MVP (mais boilerplate de interface) e MVC (acoplamento entre controller e view difícil de testar). Cubit mantém estados mutuamente exclusivos (`loading`, `success`, `error`) sem a verbosidade de BLoC puro.

**Resultado:** feature-first com separação interna `data / domain / presentation`, Cubit para estado, `get_it` para DI e `go_router` para navegação.

### Estrutura adotada

```
lib/
└── src/
    ├── core/                         # infraestrutura compartilhada por todo o app
    │   ├── app/                      # MaterialApp, configuração de tema
    │   ├── dependencies/             # setup do get_it (injeção de dependências)
    │   ├── failures/                 # AppFailure sealed class — erros tipados
    │   ├── router/                   # configuração do go_router
    │   └── services/
    │       ├── clock/                # abstração de tempo (evita DateTime.now() espalhado)
    │       ├── http/                 # HttpService + FakeHttpService
    │       ├── network/              # verificação de conectividade
    │       └── storage/              # key-value storage (persistência da sessão)
    │
    ├── shared/                       # código de negócio compartilhado entre features
    │   ├── data/                     # modelos e parsers neutros (ex: TransactionModel)
    │   ├── domain/                   # entidades e enums sem dono de feature
    │   │   └── enum/                 # IncomeCategory, ExpenseCategory
    │   └── presentation/             # (vazio nesta versão — componentes migraram para o design system)
    │
    └── features/
        ├── dashboard/                # tela principal
        │   ├── dashboard_init.dart   # registro de DI desta feature
        │   ├── data/
        │   │   ├── datasources/      # chamadas HTTP
        │   │   ├── mappers/          # JSON → modelo
        │   │   ├── models/           # DTOs de rede
        │   │   └── repositories/     # implementações concretas
        │   ├── domain/
        │   │   ├── entities/         # DashboardOverviewData, FinancialHealthScoreData,
        │   │   │                     # FlowAnalysisData, MonthlyGoalData
        │   │   ├── enum/             # FinancialHealthStatus, MonthlyGoalStatus
        │   │   ├── policies/         # FinancialHealthScorePolicy, MonthlyGoalStatusPolicy
        │   │   ├── repositories/     # contratos (interfaces)
        │   │   └── use_cases/        # casos de uso
        │   └── presentation/
        │       ├── mappers/          # entidade → texto de UI (sem strings no domínio)
        │       ├── models/           # AddTransactionSheetResult e inputs de UI
        │       ├── view/             # DashboardView, FinancialSummaryShowcaseView
        │       ├── view_model/       # DashboardCubit, AddTransactionCubit
        │       └── widgets/          # widgets específicos desta feature
        │
        ├── expenses/                 # tela de detalhe de despesas (estrutura espelhada)
        ├── incomes/                  # tela de detalhe de receitas (estrutura espelhada)
        └── transactions/             # lista completa de transações (estrutura espelhada)
```

**Cada feature tem um `*_init.dart`** que centraliza o registro de DI. Isso mantém o `dependencies/` do core limpo e permite que uma feature seja removida sem deixar referências soltas.

**`shared/` não é um depósito** — só entra o que é genuinamente compartilhado e semanticamente neutro. Código específico de uma feature que "reaproveita" outra feature é sinal de acoplamento, não de reuso.

---

## Arquitetura e decisões técnicas

### DDD pragmático

DDD foi aplicado sem cerimônia — entidades com regras reais, sem value objects e aggregates artificiais para escopo pequeno.

**O que ficou no domínio:**
- `FinancialHealthScorePolicy` — calcula score com base em comprometimento de renda e variação de liquidez.
- `MonthlyGoalStatusPolicy` — classifica status da meta com base em `% atingido` e ritmo do mês.
- Entidades (`FinancialHealthScoreData`, `MonthlyGoalData`, `FlowAnalysisData`) encapsulam dados do negócio sem depender de UI.

**O que ficou fora do domínio:**
- Textos de exibição (`"Você está gastando X% da sua renda"`, labels de status) ficam em mappers de apresentação (`FinancialHealthScoreTextMapper`, `MonthlyGoalTextMapper`). Isso mantém o domínio agnóstico de i18n e de qualquer detalhe de copy.
- Cores e estados visuais são resolvidos na presentation a partir dos enums do domínio.

### Cubit e estados explícitos

A UI modela o estado com classes seladas mutuamente exclusivas:

```dart
sealed class DashboardState {
  const DashboardState();
}

class DashboardLoading extends DashboardState { ... }
class DashboardSuccess extends DashboardState { ... }
class DashboardError extends DashboardState { ... }
```

Isso elimina condições impossíveis como `isLoading: true` + `data: non-null` simultaneamente. O widget reconstrói com base no tipo — sem flags paralelas, sem `if (isLoading && !hasError && data != null)`.

### `get_it` e cubits parametrizados

O `AddTransactionCubit` é criado a cada abertura do bottom sheet via `registerFactoryParam`. Isso garante que o estado do formulário começa limpo toda vez e não vaza entre sessões do modal.

```dart
getIt.registerFactoryParam<AddTransactionCubit, SheetType, void>(
  (type, _) => AddTransactionCubit(type: type, ...),
);
```

### Separação entre resultado de UI e input de domínio

O bottom sheet retorna um `AddTransactionSheetResult` (objeto de apresentação). A conversão para o input do caso de uso fica em `AddTransactionInputMapper`. A UI não conhece o contrato do domínio — só coleta dados e devolve o resultado.

---

## Stack

| Dependência | Por que foi escolhida |
|-------------|----------------------|
| `flutter_bloc` (Cubit) | Estados mutuamente exclusivos sem ambiguidade de flags |
| `freezed` | Imutabilidade real, `copyWith` e igualdade estrutural nos states |
| `get_it` | DI com suporte a `registerFactoryParam` para cubits parametrizados |
| `go_router` | Roteamento declarativo, deep link, guards de navegação |
| `dartz` | `Either` para tratamento funcional de erros no domínio |
| `intl` | Formatação de moeda e datas |
| `connectivity_plus` | Verificação de conectividade para estado de erro de rede |
| `financial_health_design_system` | Package local com componentes visuais e tokens |

---

## Problemas encontrados e resolvidos

Problemas reais identificados durante o desenvolvimento, com causa raiz e como foram resolvidos.

### 1. Ambiguidade de estado na UI

**Erro:** modelagem inicial com múltiplas flags booleanas (`isLoading`, `error`, `data`) permitia estados impossíveis.

**Causa:** simplificação excessiva sem garantir exclusividade — padrão que a IA sugere com frequência para reduzir código.

**Correção:** migração para estados explícitos e mutuamente exclusivos via Cubit com classes seladas.

**Prevenção:** evitar flags paralelas para o fluxo principal de tela.

---

### 2. Textos de UI vazando para o domínio

**Erro:** a IA sugeriu manter `title` e `description` de exibição dentro das entidades de domínio.

**Causa:** simplificação que mistura responsabilidades — a entidade fica fácil de usar na UI, mas carrega um acoplamento implícito com apresentação, i18n e copy.

**Correção:** textos foram removidos das entidades e movidos para mappers de apresentação (`MonthlyGoalTextMapper`, `FinancialHealthScoreTextMapper`).

**Prevenção:** regra criada no processo — strings de UI nunca entram em entidades de domínio.

---

### 3. Label de apresentação serializado no domínio

**Erro:** categorias de transação foram unificadas em `TransactionCategory` com `label` em português. A serialização persistia o `label` visual, não um `code` estável.

**Causa:** refatoração que reduziu duplicação entre receita e despesa levou um artefato visual para o núcleo de negócio.

**Correção:** `IncomeCategory` e `ExpenseCategory` separados no domínio. `TransactionCategory` movido para presentation. Storage passou a usar `category.code`.

**Prevenção:** mapper explícito entre UI e domínio sempre que a UI agrupa conceitos que o domínio precisa manter separados.

---

### 4. Parâmetro público sem efeito real

**Erro:** `MetricCardSize` existia no widget mas não alterava layout — o parâmetro era aceito e ignorado.

**Causa:** boilerplate gerado pela IA sem validação de comportamento observável.

**Correção:** tamanho passou a afetar padding, tipografia e ícone de forma mensurável.

**Prevenção:** todo parâmetro público deve ter efeito visível ou ser removido.

---

### 5. Bottom sheet fechava antes de confirmar sucesso

**Erro:** o sheet fazia `pop` imediatamente após `submit()` e só depois disparava o cubit da dashboard. Se o submit falhasse, o usuário não via o erro.

**Causa:** fluxo tratava o sheet como formulário puro (coletar → devolver), sem considerar que operações com latência precisam de feedback antes do fechamento.

**Correção:** `onSubmit` recebe um callback `Future<bool>`. O sheet só fecha se o resultado for `true`. Em `false`, reseta `isSubmitting` para que o usuário possa tentar novamente.

**Prevenção:** modais que disparam side-effect com latência devem aguardar confirmação antes de fechar.

---

### 6. Features de detalhe consumindo endpoint da dashboard

**Erro:** as telas de receitas, despesas e transações consumiam `/dashboard/overview` — a mesma rota da tela principal.

**Causa:** acoplamento por conveniência durante o desenvolvimento inicial.

**Correção:** `FakeHttpService` passou a expor bordas por contexto: `/incomes/overview`, `/expenses/overview`, `/transactions/overview`, `/transactions`. Cada feature usa seu próprio contrato.

**Prevenção:** features de detalhe não devem depender do agregado de outra feature.

---

### 7. Loops abertos — código declarado sem consumo

**Erro:** `CommitmentStatus` enum declarado mas nunca renderizado. Rotas criadas vazias. `Future.delayed` artificial dentro do Cubit simulando IO.

**Causa:** geração incremental com IA priorizou "preparar para depois" sem validar se o "depois" existia no escopo do MVP.

**Correção:** tudo que não era consumido em nenhum widget, teste ou rota foi removido. O delay foi movido para a camada de dados, onde faz sentido arquitetural.

**Prevenção:** antes de commitar, verificar se todo artefato declarado é consumido em pelo menos um lugar real.

---

### 8. Cores hardcoded fora do tema

**Erro:** resolver de estilo do card principal usava cores literais em vez de tokens de tema.

**Causa:** código vindo de geração visual sem alinhamento com o design system.

**Correção:** paleta movida para `ThemeExtension`, consumida via `Theme.of(context)`.

**Prevenção:** toda cor nova nasce no tema/tokens.

---

## Dívida técnica conhecida

Itens identificados que não foram resolvidos nesta entrega por decisão de escopo — não por descuido.

| Item | Status | Descrição |
|------|--------|-----------|
| Valores monetários como `double` | Pendente | Risco de erro de arredondamento. Solução: `Money` com centavos em `int`. |
| `DateTime.now()` espalhado | Pendente | Deveria usar `Clock` injetado em todos os pontos temporais. |
| `AppFailure.message` com texto de UI | Pendente | Mensagens exibíveis ainda vivem no failure — deveriam ser mapeadas na presentation. |
| Inputs de comando com aparência de entidade | Pendente | `AddDashboardInput` parece entidade de domínio. Separar command/input de regra central. |
| Widget tests da tela principal | Parcial | Cobre estados, mas falta cobertura de interação completa (loading → success → tap). |
| `FakeHttpService` com muitas responsabilidades | Parcial | Store, seed, mutação e serialização estão na mesma classe. Separar em outra branch. |

---

## Como executar

**Pré-requisitos:**
- Flutter 3.38.1 stable / Dart ^3.10.0
- Emulador ou device Android/iOS ativo

```bash
cd financial_health_dashboard
flutter pub get
flutter run
```

**Testes:**

```bash
flutter test
flutter test --coverage
```

**Análise estática:**

```bash
flutter analyze
```

> O app não requer backend nem variáveis de ambiente. Basta ter um device ativo.

---

## Documentação complementar

### Arquitetura (este projeto)

| Arquivo | Conteúdo |
|---------|----------|
| [docs/architecture/architecture.md](./docs/architecture/architecture.md) | Por que essa arquitetura, alternativas descartadas, SOLID aplicado, curva de complexidade |
| [docs/architecture/state_management.md](./docs/architecture/state_management.md) | Por que Cubit e não ValueNotifier, MobX, BLoC ou Riverpod — com trade-offs de cada um |
| [docs/architecture/ephemeral_events.md](./docs/architecture/ephemeral_events.md) | Eventos efêmeros com `effectVersion`, desacoplamento entre dashboard e bottom sheet |

### Documentação geral do repositório

| Arquivo | Conteúdo |
|---------|----------|
| [../docs/requirements/requirements.md](../docs/requirements/requirements.md) | Requisitos funcionais e não funcionais |
| [../docs/architecture/architecture.md](../docs/architecture/architecture.md) | Visão geral arquitetural do repositório |
| [../docs/ia/README.md](../docs/ia/README.md) | IA no processo — regras, log e learnings |
