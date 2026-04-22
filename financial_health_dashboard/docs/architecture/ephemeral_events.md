# Eventos Efêmeros e Desacoplamento — Financial Health Dashboard

## O problema

A tela de dashboard tem um botão que abre um bottom sheet. Quando o usuário termina de preencher o formulário e confirma, o sheet fecha e o dashboard atualiza com os novos dados.

Parece simples. Mas há uma tensão real aqui:

1. **Quem decide abrir o sheet?** O widget diretamente? O cubit?
2. **Como o sheet comunica o resultado de volta** para o cubit da dashboard sem que os dois se conheçam diretamente?
3. **Como garantir que a lógica de quando abrir o sheet** não vaza para o widget (que não deveria tomar essa decisão)?
4. **O que acontece se o sheet for aberto duas vezes** em sequência — o segundo evento é tratado mesmo que o estado de `effect` não tenha mudado?

---

## Contexto: o que é um evento efêmero

Um **evento efêmero** é algo que acontece uma vez e não precisa ser persistido no estado — mas precisa ser propagado para a UI de forma controlada.

Exemplos comuns:
- Abrir um modal ou bottom sheet
- Exibir um snackbar
- Navegar para outra tela
- Reproduzir uma animação pontual

O problema é que o estado gerenciado pelo Cubit é persistente e reativo: qualquer widget que escuta o estado reconstrói com o último valor emitido. Se você coloca `showAddIncomeSheet: true` no estado e o widget processa esse valor, o estado continua em `true` até você emiti-lo como `false`. E quando um widget entra na árvore tarde (por exemplo, depois de uma reconstrução), ele lê o estado atual — que ainda tem o effect — e pode disparar a ação novamente.

---

## Como não resolver

### Opção 1: widget decide diretamente

```dart
// ❌ o widget toma a decisão de quando abrir o sheet
ElevatedButton(
  onPressed: () {
    showModalBottomSheet(context, builder: (_) => AddIncomeSheet());
  },
)
```

O widget assumiu a responsabilidade de quando o sheet deve ser exibido. Se a regra mudar (ex: só abrir o sheet se o usuário estiver com limite disponível), essa lógica estará no widget — sem teste unitário possível.

### Opção 2: flag booleana no estado

```dart
// ❌ flag no estado — persiste além do necessário
class DashboardState {
  final bool showAddIncomeSheet;
}

// No BlocListener:
if (state.showAddIncomeSheet) {
  showModalBottomSheet(...);
  cubit.clearSheet(); // precisa de uma ação de limpeza manual
}
```

Se o widget for reconstruído (por qualquer motivo) enquanto `showAddIncomeSheet: true`, ele vai tentar abrir o sheet de novo. O desenvolvedor precisa lembrar de chamar `clearSheet()` explicitamente depois de processar o efeito.

---

## A solução: `DashboardEffect` + `effectVersion`

O projeto usa dois campos no estado para resolver isso:

```dart
DashboardEffect? effect;     // qual efeito está pendente (ou null)
int effectVersion;           // contador que muda a cada novo efeito
```

E o `BlocListener` no widget escuta apenas quando `effectVersion` muda:

```dart
BlocListener<DashboardCubit, DashboardState>(
  listenWhen: (previous, current) =>
      previous.effectVersion != current.effectVersion,
  listener: _onDashboardEffect,
  child: ...,
)
```

### Como funciona na prática

1. Usuário toca no FAB de "adicionar receita".
2. O widget chama `cubit.onAddIncomePressed()`.
3. O cubit emite:

```dart
void _showBottomSheet(DashboardEffect effect) {
  emit(
    state.copyWith(
      effect: effect,
      effectVersion: state.effectVersion + 1, // muda o gatilho
    ),
  );
}
```

4. O `BlocListener` detecta a mudança em `effectVersion` e chama `_onDashboardEffect`.
5. O widget abre o sheet e aguarda o resultado.
6. Ao terminar (sucesso ou cancelamento), chama `cubit.clearEffect()`.

```dart
void clearEffect() => emit(state.copyWith(effect: null));
```

### Por que `effectVersion` e não só `effect`?

Imagine que o usuário:
- Abre o sheet de receita → cancela sem adicionar.
- Toca no FAB de receita novamente imediatamente.

Sem o `effectVersion`, o estado teria `effect: showAddIncomeSheet` antes e depois. O `listenWhen` compararia dois estados iguais e **não dispararia o listener da segunda vez**.

Com o `effectVersion`, o segundo toque emite `effectVersion: 2` — diferente de `1` — garantindo que o listener dispara mesmo que `effect` seja o mesmo enum.

---

## Desacoplamento entre dashboard e formulário

O segundo problema é: como o bottom sheet comunica o resultado de volta para o cubit da dashboard sem criar acoplamento direto?

### Abordagem: callback `Future<bool>`

O sheet recebe um callback `onSubmit` que retorna `Future<bool>`. Ele não sabe quem é o cubit nem o que acontece após a confirmação.

```dart
// No widget da dashboard
Future<void> _handleIncomeSheet(
  BuildContext context,
  DashboardCubit dashCubit,
) async {
  await showTransactionBottomSheet(
    context,
    sheetType: SheetType.income,
    onSubmit: (result) async {
      if (result is! AddIncomeSheetResult) return false;
      return dashCubit.addIncome(
        AddTransactionInputMapper.toIncomeInput(result), // mapper de apresentação
      );
    },
  );
  dashCubit.clearEffect();
}
```

O sheet processa o formulário, chama `onSubmit(result)` e aguarda o `bool`:
- `true` → fecha o sheet.
- `false` → reseta `isSubmitting` e permite nova tentativa.

```dart
// Dentro do AddTransactionBottomSheet
Future<void> _onConfirm(
  BuildContext context,
  AddTransactionCubit cubit,
) async {
  final result = await cubit.submit();
  if (result == null) return;

  final success = await widget.onSubmit(result); // chama o callback
  if (success) {
    if (context.mounted) Navigator.of(context).pop();
  } else {
    cubit.resetSubmitting(); // permite nova tentativa
  }
}
```

### Por que isso é desacoplamento real

O `AddTransactionBottomSheet` não importa `DashboardCubit`. Ele não sabe o que `addIncome` faz. Ele só sabe que `onSubmit` retorna um `bool` que indica se deve fechar ou não.

Isso significa que o mesmo sheet pode ser reutilizado em qualquer contexto que forneça um callback compatível — sem mudar uma linha do sheet.

---

## Separação entre objeto de UI e input de domínio

Outro ponto de desacoplamento: o resultado que o sheet devolve é um **objeto de apresentação** — não um input de domínio.

```dart
// O sheet devolve isso (objeto de apresentação)
class AddIncomeSheetResult extends AddTransactionSheetResult {
  final double amount;
  final TransactionCategory category; // enum de UI
  final String description;
}

// O mapper converte para input de domínio
static AddDashboardIncomeInput toIncomeInput(AddIncomeSheetResult result) {
  return AddDashboardIncomeInput(
    amount: result.amount,
    title: result.description,
    category: _toIncomeCategory(result.category), // converte para enum de domínio
  );
}
```

O sheet não conhece `AddDashboardIncomeInput`. O domínio não conhece `AddIncomeSheetResult`. O mapper (`AddTransactionInputMapper`) é o único ponto onde os dois mundos se encontram — e ele vive na camada de apresentação.

---

## `AddTransactionCubit` como cubit parametrizado

O formulário de receita e o de despesa usam o mesmo `AddTransactionCubit`. A diferença é o `SheetType` passado no construtor:

```dart
class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit(this.type) : super(AddTransactionState.initial(type));
  final SheetType type;
}
```

O `get_it` registra com `registerFactoryParam`:

```dart
getIt.registerFactoryParam<AddTransactionCubit, SheetType, void>(
  (type, _) => AddTransactionCubit(type),
);
```

Cada vez que o sheet abre, uma nova instância do cubit é criada — estado limpo, sem vazamento de dados do formulário anterior. Quando o sheet fecha, a instância é descartada.

Sem `registerFactoryParam`, a alternativa seria um cubit singleton com um método `reset()` chamado manualmente ao abrir cada sheet. Isso introduz estado persistente entre sessões do modal e exige que o chamador lembre de limpar o estado.

---

## Diagrama do fluxo completo

```
[Usuário toca no FAB]
        │
        ▼
[Widget chama cubit.onAddIncomePressed()]
        │
        ▼
[DashboardCubit emite effect=showAddIncomeSheet, effectVersion++]
        │
        ▼
[BlocListener detecta mudança em effectVersion]
        │
        ▼
[Widget abre AddTransactionBottomSheet com onSubmit callback]
        │
        ▼ (usuário preenche e confirma)
[AddTransactionCubit.submit() → devolve AddIncomeSheetResult]
        │
        ▼
[widget.onSubmit(result) é chamado]
        │
        ▼
[AddTransactionInputMapper.toIncomeInput(result)]
        │
        ▼
[DashboardCubit.addIncome(input) → retorna Future<bool>]
        │
     ┌──┴──┐
   true   false
     │      │
     ▼      ▼
[sheet fecha] [cubit.resetSubmitting() — usuário tenta de novo]
     │
     ▼
[DashboardCubit emite novo DashboardState com dados atualizados]
     │
     ▼
[DashboardView reconstrói com novos valores]
     │
     ▼
[cubit.clearEffect() — effect volta a null]
```

---

## Referências

- [Arquitetura e estrutura de pastas →](./architecture.md)
- [Gerenciamento de estado →](./state_management.md)

### Leitura externa

- **[BLoC — Side Effects](https://bloclibrary.dev/architecture/#bloc-side-effects)** — documentação oficial da biblioteca `flutter_bloc` explicando o problema de eventos efêmeros (side effects) e as abordagens para tratá-los. O `effectVersion` usado aqui é uma variante do padrão `Event Transformer`.
- **[One-time events in Bloc](https://medium.com/flutter-community/one-time-events-in-flutter-bloc-a-definitive-guide-22e5c45f5c15)** — artigo prático que discute exatamente o problema descrito neste documento: como evitar que um evento seja processado mais de uma vez por `BlocListener`, comparando as abordagens de flag booleana, nullable + clear e `sealed class` com versão.
- **[Command pattern in state management](https://verygood.ventures/blog/flutter-state-management)** — discussão do Very Good Ventures sobre o padrão de "comando" em state management, onde o estado carrega tanto dados quanto intenções de UI de forma isolada — base conceitual do `DashboardEffect`.
- **[Flutter BlocListener vs BlocConsumer](https://bloclibrary.dev/flutter-bloc-concepts/#bloclistener)** — documentação do `listenWhen` e quando usá-lo vs `buildWhen`, que é exatamente o mecanismo que o `effectVersion` aciona.
