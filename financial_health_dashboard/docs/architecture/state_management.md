# Gerenciamento de Estado — Financial Health Dashboard

## O que precisava ser resolvido

Uma tela de dashboard tem três estados principais: carregando, exibindo dados com sucesso ou exibindo um erro. Parece simples — mas a forma como esses estados são modelados determina se o widget pode ter estados impossíveis, se os testes conseguem verificar transições precisas e se um novo dev consegue entender o contrato da tela sem ler o widget.

Além disso, há um caso específico neste projeto: o botão de adicionar receita/despesa dispara um bottom sheet que precisa se comunicar de volta com o cubit da dashboard — sem que a dashboard saiba dos detalhes do formulário.

Essas duas necessidades guiaram a escolha do gerenciador de estado.

---

## Alternativas analisadas

### `StatefulWidget` + `setState`

A abordagem padrão do Flutter. Estado local no widget, reconstrução chamada manualmente.

**Quando faz sentido:** componentes com estado puramente visual e efêmero — uma animação, um campo de input, um toggle local.

**Problemas para este contexto:**

```dart
// ❌ estado com flags paralelas — combinações impossíveis existem
class _DashboardState extends State<DashboardPage> {
  bool isLoading = false;
  bool hasError = false;
  DashboardData? data;
  String? errorMessage;
  // isLoading=true e data!=null é possível mas sem sentido
  // hasError=true e isLoading=true ao mesmo tempo é possível
}
```

Com flags paralelas, o widget precisa de lógica defensiva (`if (isLoading && !hasError && data != null)`) para cobrir combinações que não deveriam existir. Cada condição nova multiplica o espaço de estados possíveis.

**Trade-off evitado:** estados impossíveis atingíveis em runtime.

---

### `ValueNotifier` / `ChangeNotifier`

Reatividade baseada em notificação de mudança. O widget escuta um `ValueNotifier<T>` e reconstrói quando o valor muda.

**Quando faz sentido:** estado simples de um campo, toggle, contador — onde o modelo de dado é flat e as transições não precisam ser tipadas.

**Problemas para este contexto:**

```dart
// com ValueNotifier, você publica o estado inteiro a cada mudança
final state = ValueNotifier<DashboardState>(DashboardState.initial());

// para ir de loading para success:
state.value = state.value.copyWith(
  isLoading: false,
  data: overview,
  error: null,
); // ainda depende de flags paralelas ou de um modelo rico
```

`ValueNotifier` não impede estados impossíveis — ele apenas remove a necessidade de `setState`. A modelagem de estado continua sendo responsabilidade do dev. Se o modelo for rico (como `DashboardState` com `status` enum + dados), você reinventa parcialmente o que o Cubit já oferece.

**Por que foi usado no Desafio 2:** o código legado do desafio 2 foi modernizado com `ValueNotifier` por ser uma refatoração pragmática de código existente sem a infraestrutura de `flutter_bloc`. Para um app novo com múltiplos estados, o custo de setup do Cubit se justifica.

**Trade-off evitado:** reescrever a infraestrutura de estados explícitos do zero quando o Cubit já fornece o padrão.

---

### MobX

Reatividade baseada em observables, actions e reactions. O estado é anotado e o código-fonte é gerado.

**Quando faz sentido:** apps com muita reatividade granular e interdependências complexas entre observables (ex: filtros que afetam múltiplos estados derivados simultaneamente).

**Problemas para este contexto:**

- Geração de código adicional (`*.g.dart`) sobre a geração do `freezed` já existente.
- `@observable`, `@action`, `@computed` precisam de disciplina para não vazar para fora da store.
- Debugging de reatividade é mais difícil: uma reaction pode disparar por um observable inesperado sem uma trace clara.
- A comunidade Flutter tem migrado para soluções mais alinhadas com o modelo declarativo do framework.

**Trade-off evitado:** overhead de geração dupla e debugging de reatividade em um app onde o fluxo de estado é linear (user action → cubit → new state → widget rebuild).

---

### BLoC (flutter_bloc com Events)

O BLoC é a versão completa do padrão: estados emitidos em resposta a eventos tipados. O Cubit é uma simplificação do BLoC sem a camada de eventos.

```dart
// BLoC com eventos explícitos
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(...) : super(DashboardState.initial()) {
    on<LoadOverviewEvent>(_onLoadOverview);
    on<AddIncomeEvent>(_onAddIncome);
    on<AddExpenseEvent>(_onAddExpense);
  }
}

// vs Cubit sem eventos
class DashboardCubit extends Cubit<DashboardState> {
  Future<void> loadOverview() async { ... }
  Future<bool> addIncome(AddDashboardIncomeInput input) async { ... }
  Future<bool> addExpense(AddDashboardExpenseInput input) async { ... }
}
```

**Quando BLoC faz sentido sobre Cubit:**
- Você precisa de um histórico auditável de eventos (ex: para analytics ou undo/redo).
- Múltiplos handlers precisam reagir ao mesmo evento (fan-out).
- O evento precisa ser serializado ou persistido.

**Por que Cubit foi escolhido sobre BLoC:**

Para este projeto, os eventos são simples e diretos: "carregar overview", "adicionar receita", "adicionar despesa". Não há necessidade de persistir eventos nem de múltiplos handlers. A camada extra de `Event` adicionaria boilerplate sem comportamento novo.

**Trade-off evitado:** event classes desnecessárias que aumentam o número de arquivos sem adicionar capacidade.

---

### Riverpod

Injeção de dependências e gerenciamento de estado unificados. Providers são declarados globalmente e consumidos por qualquer widget na árvore sem necessidade de `BlocProvider`.

**Quando faz sentido:**
- Apps com estado derivado complexo (um provider que depende de outro).
- Times que preferem remover a dependência explícita de `BuildContext` no acesso ao estado.
- Projetos onde `get_it` e `flutter_bloc` seriam duas dependências e o Riverpod resolve as duas.

**Problemas para este contexto:**

- O projeto já usa `get_it` para DI com `registerFactoryParam` — funcionalidade que Riverpod suporta via `family`, mas com sintaxe menos explícita para quem está lendo o código pela primeira vez.
- Providers globais exigem disciplina de naming e organização para não virar um arquivo com 30 providers sem estrutura clara.
- A migração de `flutter_bloc` para Riverpod no meio de um projeto com prazo curto tem custo sem retorno imediato.
- O modelo mental de `ref.watch` / `ref.read` / `ref.listen` é diferente do `BlocBuilder` / `BlocListener` — uma curva de entrada adicional para novos devs vindos do ecossistema `flutter_bloc`.

**Trade-off evitado:** trocar uma ferramenta conhecida por uma com curva de entrada diferente sem ganho técnico claro para este escopo.

---

## Por que Cubit foi escolhido

O Cubit resolve os problemas do projeto com o menor custo de infraestrutura:

| Requisito | Como o Cubit resolve |
|-----------|----------------------|
| Estados mutuamente exclusivos | `DashboardViewStatus` enum — `initial`, `loading`, `success`, `error` |
| Imutabilidade do state | `freezed` com `copyWith` gerado |
| Testabilidade por transição | `bloc_test` com `expect: [...]` por estado emitido |
| Comunicação bidirecional com bottom sheet | `Future<bool>` no callback — sem acoplamento de widget |
| DI parametrizada por sheet type | `registerFactoryParam` do `get_it` |
| Eventos efêmeros (abrir sheet) | `DashboardEffect` com `effectVersion` — sem canal separado |

---

## Como o estado está modelado

### `DashboardState` — estado unificado

```dart
@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    required String userName,
    required double balance,
    required double income,
    required double expense,
    required FinancialHealthScoreData financialHealthScore,
    required FlowAnalysisData flowAnalysis,
    required MonthlyGoalData monthlyGoal,
    required DashboardViewStatus status,
    String? errorMessage,
    @Default(false) bool canRetry,
    DashboardEffect? effect,
    required int effectVersion,
  }) = _DashboardState;
}

enum DashboardViewStatus { initial, loading, success, error }
```

O `status` enum garante exclusividade: você não pode ter `loading` e `data != null` ao mesmo tempo porque o state é gerado por `DashboardState.fromOverview(...)` que só é chamado quando os dados chegam com sucesso.

### `AddTransactionState` — estado do formulário

```dart
@freezed
abstract class AddTransactionState with _$AddTransactionState {
  const factory AddTransactionState({
    required int amountCents,
    required String description,
    required TransactionCategory category,
    @Default(false) bool isSubmitting,
  }) = _AddTransactionState;

  bool get canSubmit =>
      !isSubmitting && amountCents > 0 && description.trim().isNotEmpty;
}
```

`canSubmit` é uma propriedade derivada do estado — não um flag separado. O botão de submit do widget só lê `state.canSubmit`. Não há lógica de validação no widget.

---

## Separação de responsabilidades entre Cubit e View

O `DashboardCubit` nunca conhece detalhes da UI:

```dart
// O cubit expõe intenções, não ações de UI
void onAddIncomePressed() =>
    _showBottomSheet(DashboardEffect.showAddIncomeSheet);

void onAddExpensePressed() =>
    _showBottomSheet(DashboardEffect.showAddExpenseSheet);
```

O widget (`DashboardView`) escuta o effect e decide como abrir o sheet:

```dart
// O widget traduz o effect em ação de UI
Future<void> _onDashboardEffect(BuildContext context, DashboardState state) async {
  switch (state.effect) {
    case DashboardEffect.showAddIncomeSheet:
      await _handleIncomeSheet(context, dashCubit);
    case DashboardEffect.showAddExpenseSheet:
      await _handleExpenseSheet(context, dashCubit);
    case null:
      return;
  }
}
```

O cubit não sabe o que é um `BottomSheet`. O widget não sabe se o income foi adicionado com sucesso. Cada um faz o que é seu.

---

## Testabilidade

Com esta modelagem, cada camada é testável de forma isolada:

```dart
// Teste do Cubit — sem widget, sem HTTP, sem context
blocTest<DashboardCubit, DashboardState>(
  'emite loading depois success ao carregar overview',
  build: () => DashboardCubit(
    MockAddExpenseUseCase(),
    MockAddIncomeUseCase(),
    FakeGetOverviewUseCase(result: Right(fakeDashboardData)),
  ),
  act: (cubit) => cubit.loadOverview(),
  expect: () => [
    isA<DashboardState>().having((s) => s.status, 'status', DashboardViewStatus.loading),
    isA<DashboardState>().having((s) => s.status, 'status', DashboardViewStatus.success),
  ],
);
```

```dart
// Teste da Policy — sem cubit, sem widget, sem qualquer dependência
test('score abaixo de 45 é crítico', () {
  final policy = FinancialHealthScorePolicy();
  final result = policy.compute(income: 1000, expense: 900, ...);
  expect(result.status, FinancialHealthStatus.critical);
});
```

---

## Referências

- [Arquitetura e estrutura de pastas →](./architecture.md)
- [Eventos efêmeros e desacoplamento →](./ephemeral_events.md)
