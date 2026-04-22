# Storage — FakeHttpService, persistência e alternativas reais

## Visão geral

O projeto não tem backend real. A persistência durante a sessão é feita por um `FakeHttpService` que simula latência de rede e mantém o estado em memória via `KeyValueWrapper`. Essa escolha foi intencional — o foco do projeto é a arquitetura da camada de apresentação e domínio, não a infraestrutura de dados.

Esta documentação explica como o storage fictício foi construído, por que funciona para o escopo do projeto e o que seria necessário para evoluir para um banco de dados real.

---

## A pilha de storage atual

```
FakeHttpService              ← simula HTTP (GET /dashboard/overview, POST /incomes etc.)
  └── KeyValueWrapper        ← abstração de storage key-value
        └── InMemoryKeyValueWrapper  ← implementação em Map<String, String>

StorageSchema                ← define as chaves com versão embutida
```

### `KeyValueWrapper` — interface agnóstica

```dart
abstract class KeyValueWrapper {
  Future<bool> setString(String key, String value);
  String? getString(String key);
  Future<bool> remove(String key);
}
```

A interface é deliberadamente minimalista — `setString`, `getString`, `remove`. Isso espelha a API do `SharedPreferences` e garante que trocar a implementação (in-memory → SharedPreferences → Hive → Drift) não exige mudança no `FakeHttpService` nem nos use cases.

### `InMemoryKeyValueWrapper` — implementação de sessão

```dart
class InMemoryKeyValueWrapper implements KeyValueWrapper {
  InMemoryKeyValueWrapper({Map<String, String>? initialValues})
    : _cache = initialValues == null
          ? <String, String>{}
          : Map<String, String>.from(initialValues);

  final Map<String, String> _cache;

  @override
  Future<bool> setString(String key, String value) {
    _cache[key] = value;
    return Future<bool>.value(true);
  }

  @override
  String? getString(String key) => _cache[key];

  @override
  Future<bool> remove(String key) {
    final exists = _cache.containsKey(key);
    _cache.remove(key);
    return Future<bool>.value(exists);
  }
}
```

Retorna `Future` mesmo sendo síncrono — isso mantém a interface compatível com implementações assíncronas reais sem mudar o contrato.

### `StorageSchema` — chaves com versão embutida

```dart
abstract class StorageSchema {
  static const version = 1;

  static const dashboardOverviewKey      = 'dashboard_overview_v$version';
  static const dashboardTransactionsKey  = 'dashboard_transactions_v$version';
}
```

> **Nota sobre nomenclatura:** as chaves usam prefixo `dashboard_` (escopo da feature) em vez de `financial_` (escopo do produto). Isso é mais preciso: se o projeto ganhar uma feature de `investments` com seu próprio storage, as chaves não colidem e ficam rastreáveis por feature.

**Por que versão na chave?**

Quando o schema de dados evolui (ex: um campo novo no JSON de overview), a chave muda de `dashboard_overview_v1` para `dashboard_overview_v2`. Isso força uma "leitura limpa" — o storage antigo é ignorado em vez de desserializar um JSON desatualizado e causar um crash silencioso. É uma estratégia simples de migração de schema sem precisar de scripts de migração.

---

## O `FakeHttpService`

O `FakeHttpService` implementa `HttpService` (a mesma interface que uma implementação com `dio` usaria) e expõe endpoints REST fictícios:

| Método | Rota | O que faz |
|---|---|---|
| GET | `/dashboard/overview` | Retorna overview financeiro serializado |
| GET | `/incomes/overview` | Retorna overview da feature de receitas |
| GET | `/expenses/overview` | Retorna overview da feature de despesas |
| GET | `/transactions/overview` | Retorna overview da feature de transações |
| GET | `/transactions` | Retorna lista completa de transações |
| POST | `/dashboard/income` ou `/incomes` | Adiciona receita, atualiza estado, persiste |
| POST | `/dashboard/expense` ou `/expenses` | Adiciona despesa, atualiza estado, persiste |

Cada request adiciona `latency` (padrão 1500ms) via `Future.delayed` — tornando o estado de loading visível na UI.

**Estado inicial aleatório mas financeiramente coerente:** ao iniciar, o `FakeHttpService` gera dados com `Random` garantindo consistência entre campos (income, expense, balance, liquidez, meta, movimentações). Isso demonstra os diferentes estados de UI (crítico, atenção, saudável) sem precisar hardcodar cenários.

**Dívida técnica reconhecida:** o `FakeHttpService` acumula store, seed aleatório, mutação e serialização na mesma classe. Em um projeto real isso seria separado — mas para o escopo do teste, a consolidação foi priorizada sobre a pureza estrutural. Isso está documentado na tabela de dívida técnica do README.

---

## Por que não usar um banco real agora

| Critério | Posição |
|---|---|
| O MVP é descartável? | Não — mas a infraestrutura de dados pode evoluir independentemente da apresentação |
| Offline-first é requisito do MVP? | Sim (mencionado no contexto do projeto), mas a demonstração das camadas de arquitetura é o foco principal desta entrega |
| SQLite/Hive adicionam dependências nativas? | Sim — em contexto de teste técnico, dependências extras aumentam risco de setup sem demonstrar diferencial arquitetural |

A decisão foi: **implementar a fronteira de storage como interface** (`KeyValueWrapper`) e deixar a implementação real como evolução natural. O contrato está definido; trocar `InMemoryKeyValueWrapper` por qualquer implementação real não muda nenhuma outra camada.

---

## Alternativas reais — o que usaríamos em produção

### 1. `shared_preferences` — drop-in replacement

A troca mais simples. A interface do `KeyValueWrapper` foi modelada propositalmente com os mesmos métodos do `SharedPreferences`:

```dart
class SharedPreferencesWrapper implements KeyValueWrapper {
  SharedPreferencesWrapper(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<bool> remove(String key) => _prefs.remove(key);
}
```

**Quando usar:** dados de sessão simples, preferências do usuário, cache de overview leve. Não é adequado para listas de transações com queries — string JSON serializado em chave única não escala para filtros e ordenação.

**Trade-off:** persistência real entre sessões, mas sem queries. Para o overview (um único JSON por feature), funciona perfeitamente.

---

### 2. `Hive` — NoSQL de alta performance

Banco de objetos local com codegen. Adequado para entidades que são lidas/escritas por ID.

```dart
// Exemplo: cada transação como objeto tipado
@HiveType(typeId: 0)
class TransactionRecord extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late double amount;
  @HiveField(2) late String category;
  @HiveField(3) late DateTime date;
}

final box = await Hive.openBox<TransactionRecord>('transactions');
await box.add(record);
final recent = box.values.where((t) => t.date.isAfter(cutoff)).toList();
```

**Quando usar:** listas de entidades (transações, categorias, histórico) onde você precisa de filtro por campo. Mais rápido que SQLite para reads simples. Não precisa de SQL.

**Trade-off:** codegen (`build_runner`), sem suporte a relações complexas. Se o modelo de dados for relacional (ex: transação pertence a conta, conta pertence a usuário), Hive não é a ferramenta certa.

---

### 3. `Drift` (antes `moor`) — SQLite com type safety

ORM sobre SQLite com queries tipadas em Dart. Adequado para dados relacionais e histórico de longo prazo.

```dart
// Tabela de transações com query tipada
class Transactions extends Table {
  IntColumn get id    => integer().autoIncrement()();
  RealColumn get amount    => real()();
  TextColumn get category  => text()();
  DateTimeColumn get date  => dateTime()();
}

// Query com filtro e ordenação — type-safe
final recent = await (select(transactions)
  ..where((t) => t.date.isBiggerThanValue(cutoff))
  ..orderBy([(t) => OrderingTerm.desc(t.date)])
).get();
```

**Quando usar:** apps com dados relacionais, histórico extenso, ou quando a query precisa cruzar entidades. Suporta migrations formais de schema — mais robusto que a versão na chave do `StorageSchema`.

**Trade-off:** dependência nativa (SQLite), codegen mais pesado, curva de aprendizado maior. Para o scope deste projeto, seria overengineering.

---

### 4. `Isar` — banco NoSQL rápido com índices

Alternativa ao Hive com suporte a índices, full-text search e queries complexas sem SQL.

**Quando usar:** apps com grande volume de dados locais onde performance de leitura é crítica (ex: app de finanças com anos de histórico de transações).

---

## Offline-first: o que significaria para este projeto

O contexto do projeto menciona `Persistência offline` como requisito. A implementação atual persiste dados **na sessão** (in-memory). Offline-first de verdade exigiria:

```
[API real]  ←→  [Repositório]  ←→  [Cache local (Drift/Hive)]
                                    ↑
                              serve dados quando offline
                              sincroniza quando voltar à rede
```

### Fluxo de sincronização típico

```dart
// No repository — read-through cache
@override
Future<Either<AppFailure, DashboardOverviewData>> getOverview() async {
  // 1. tenta rede
  if (await _network.isConnected) {
    final result = await _remoteDataSource.getOverview();
    return result.fold(
      (failure) => _getCachedOrFail(failure),  // rede falhou → cache
      (data) async {
        await _localDataSource.saveOverview(data); // atualiza cache
        return Right(data);
      },
    );
  }
  // 2. sem rede → cache direto
  return _getCachedOrFail(NetworkFailure());
}
```

### Packages do ecossistema BLoC para offline-first

| Package | O que faz |
|---|---|
| [`hydrated_bloc`](https://pub.dev/packages/hydrated_bloc) | Persiste e restaura automaticamente o estado do Cubit/BLoC entre sessões. Drop-in para `Cubit` — basta implementar `fromJson`/`toJson`. Usa `HydratedStorage` (padrão: `path_provider` + JSON) |
| [`replay_bloc`](https://pub.dev/packages/replay_bloc) | Adiciona undo/redo ao estado do Cubit. Útil para apps com histórico de ações do usuário |

**`hydrated_bloc` seria a adição mais natural aqui.** Bastaria estender `HydratedCubit<DashboardState>` em vez de `Cubit<DashboardState>` e implementar a serialização do state. O estado da dashboard seria restaurado automaticamente entre sessões sem mudar a lógica do cubit:

```dart
// Antes
class DashboardCubit extends Cubit<DashboardState> { ... }

// Com hydrated_bloc — estado persiste entre sessões automaticamente
class DashboardCubit extends HydratedCubit<DashboardState> {
  @override
  DashboardState? fromJson(Map<String, dynamic> json) =>
      DashboardState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(DashboardState state) =>
      state.toJson();
}
```

O custo: `freezed` + `hydrated_bloc` exige implementar `fromJson`/`toJson` no state (que com `freezed` pode ser gerado via `json_serializable`). A lógica de negócio não muda.

---

## Referências

- [`hydrated_bloc` — pub.dev](https://pub.dev/packages/hydrated_bloc)
- [`Drift` — documentação oficial](https://drift.simonbinder.eu/)
- [`Hive` — pub.dev](https://pub.dev/packages/hive)
- [`shared_preferences` — pub.dev](https://pub.dev/packages/shared_preferences)
- [Offline-first with Flutter — Very Good Ventures](https://verygood.ventures/blog/offline-first-flutter)
- [Arquitetura do projeto →](./architecture.md)
- [Dívida técnica conhecida →](../README.md#dívida-técnica-conhecida)
