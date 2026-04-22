# Transaction Refactor — Desafio 2

O enunciado apresenta um trecho de código Flutter com tudo acoplado na UI — HTTP direto no widget, token lido de `SharedPrefs` na camada de apresentação, estado representado por três flags booleanas independentes, cálculo de total no `build`. Padrão comum em codebases legadas.

A tarefa: analisar, criticar e modernizar usando IA como ferramenta principal, documentando cada etapa com evidências.

**IAs utilizadas:** Claude Sonnet 4.6 (GitHub Copilot) e GPT 5.4.

---

## Resultado

**25 problemas identificados**, categorizados por causa raiz em 6 grupos de correção. Código modernizado com Clean Architecture e MVVM. **75 testes unitários — 0 falhas.**

```
lib/
  core/
    app/               # MaterialApp e bootstrap
    di/                # get_it — injeção de dependências
    failures/          # hierarquia selada de Failure + handler
    services/auth/     # AuthTokenProvider (abstração do token)
  features/
    transactions/
      data/
        datasources/   # TransactionRemoteDataSource (HTTP)
        models/        # TransactionDto com fromJson validado
        repositories/  # TransactionRepositoryImpl
      domain/
        entities/      # TransactionEntity com campos tipados
        enums/         # TransactionType
        repositories/  # interface TransactionRepository
        use_cases/     # GetTransactionsUseCase
      presentation/
        mappers/       # TransactionItemMapper
        models/        # TransactionItemViewData (dado formatado para UI)
        view/          # TransactionPage
        view_model/    # TransactionViewModel (ValueNotifier) + TransactionState
        widgets/       # TransactionListItem, TransactionTotalCard
  shared/
    presentation/
      design/          # TransactionColors
      extensions/      # TransactionTypeExt
      formatters/      # CurrencyFormatter
```

---

## O que foi feito — e por quê

### Do código original

```dart
// ❌ código legado — HTTP no widget, token exposto, estado com flags
class _TransactionPageState extends State<TransactionPage> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = false;
  String? error;

  Future<void> _loadTransactions() async {
    setState(() { isLoading = true; });
    final response = await http.get(
      Uri.parse('https://api.example.com/v1/transactions'),
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'},
    );
    // sem validação de statusCode
    final data = json.decode(response.body) as List;
    setState(() { transactions = data.cast<Map<String, dynamic>>(); });
  }
}
```

Três flags (`isLoading`, `error`, `transactions`) permitem estados impossíveis: `isLoading: true` com `error != null`, ou lista vazia sem estado visual. Sem separação de responsabilidades, impossível escrever testes unitários sem inicializar widgets.

### Para o código modernizado

```dart
// ✅ estado selado — estados mutuamente exclusivos
sealed class TransactionState {
  const TransactionState();
}
class TransactionLoading  extends TransactionState { const TransactionLoading(); }
class TransactionSuccess  extends TransactionState { const TransactionSuccess(this.items, this.total); ... }
class TransactionEmpty    extends TransactionState { const TransactionEmpty(); }
class TransactionError    extends TransactionState { const TransactionError(this.failure); ... }
```

```dart
// ✅ use case isolado — testável sem widget
class GetTransactionsUseCase {
  final TransactionRepository _repository;
  Future<Either<AppFailure, TransactionReport>> execute() => _repository.getTransactions();
}
```

A IA gerou a estrutura inicial a partir do código legado usado como especificação — ver [docs/modernizacao.md](./docs/modernizacao.md) para o prompt exato. As iterações de correção foram necessárias (ver abaixo).

---

## Principais decisões

| Decisão | Alternativa considerada | Por que esta |
|---|---|---|
| `ValueNotifier` para estado | `flutter_bloc` Cubit | Escopo pequeno; Cubit adicionaria boilerplate sem diferencial de testabilidade para uma feature isolada |
| `Either<AppFailure, T>` | Exceptions | Força tratamento explícito do erro em cada chamada; sem risco de crash silencioso |
| `TransactionItemViewData` para UI | Usar a entidade diretamente | A entidade tem `int amount` em centavos; a view data tem `String formattedAmount` — separar evita formatação na entidade |
| `AuthTokenProvider` abstrato | `SharedPrefs.getToken()` direto | Permite mock nos testes; o datasource não sabe de onde vem o token |

---

## O que a IA acertou e o que precisou de correção

**Acertou:**
- Estrutura de diretórios e naming seguindo o padrão feature-first
- Hierarquia de `Failure` com tipos por categoria de erro
- Scaffold dos 75 testes com padrão AAA

**Precisou de correção:**
- Gerou `_calcularTotal()` dentro do `ViewModel` usando `double` — foi alterado para `int` (centavos) no domínio e formatação na camada de apresentação
- Gerou `TransactionDto.fromJson` sem validação de campos obrigatórios — adicionada validação explícita com `FormatException` para campos ausentes
- O prompt log documenta cada questionamento pós-geração: [docs/prompt_log.md](./docs/prompt_log.md)

---

## Como executar

```bash
cd transaction_refactor
flutter pub get
flutter run
```

**Testes:**

```bash
flutter test
flutter test --coverage
```

---

## Documentação

| Arquivo | Conteúdo |
|---------|----------|
| [docs/problemas.md](./docs/problemas.md) | 5 principais problemas do código legado |
| [docs/problemas_detalhados.md](./docs/problemas_detalhados.md) | Análise dos 25 problemas por tema e impacto |
| [docs/grupos_correcao.md](./docs/grupos_correcao.md) | 6 grupos de correção por causa raiz — checklist completo |
| [docs/modernizacao.md](./docs/modernizacao.md) | Prompt exato, estratégia de uso da IA e decisões arquiteturais |
| [docs/prompt_log.md](./docs/prompt_log.md) | Histórico de prompts, questionamentos e correções iterativas |

