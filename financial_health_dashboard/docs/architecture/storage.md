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

### O que um teste técnico avalia

Este é um projeto de teste técnico, não um produto em produção. Isso muda completamente o que vale a pena implementar.

O que o teste avalia: separação de responsabilidades, arquitetura em camadas, testabilidade, uso de abstrações corretas, qualidade do código e das decisões. O que o teste **não** avalia: configuração de banco de dados nativo, migrations de schema, sincronização offline — essa infraestrutura não demonstra nada do que está sendo avaliado e adiciona complexidade operacional real (dependências nativas, CI mais complexo, setup de device mais frágil).

O critério de decisão foi: **"implementar isso demonstra algo que o teste avalia?"**

| O que foi implementado com cuidado | Por quê |
|---|---|
| Interface `KeyValueWrapper` | Demonstra conhecimento do padrão e garante que a troca de implementação é trivial |
| `StorageSchema` com versão na chave | Demonstra raciocínio sobre schema evolution sem migrations formais |
| `FakeHttpService` simulando latência real | Demonstra como a UI se comporta com dados assíncronos — o estado de loading, erro e success são o ponto do teste |

| O que ficou fora | Por quê |
|---|---|
| `SharedPreferences` / SQLite / Hive reais | Persistência entre sessões não é avaliada; adicionaria dependência nativa sem demonstrar diferencial |
| Offline-first completo | Ver seção abaixo |

A decisão foi: **implementar a fronteira de storage como interface** (`KeyValueWrapper`) e documentar as alternativas. O contrato está definido; trocar `InMemoryKeyValueWrapper` por qualquer implementação real não muda nenhuma outra camada.

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

## Offline-first: faz sentido para este tipo de app?

### Primeiro: de qual dado estamos falando?

Um dashboard financeiro como este lê dados **gerados no servidor** (ou em conta bancária real): saldo, movimentações históricas, score calculado. O usuário não produz dados offline — ele apenas consulta. Isso muda fundamentalmente a equação do offline-first.

Offline-first faz sentido quando o usuário **gera dados offline** que precisam ser sincronizados depois (ex: anotações, tarefas, formulários). Para consulta pura de dados de servidor, o que faz sentido é **cache do último estado conhecido** — que é uma versão mais simples do offline-first.

### O que seria implementar para este app

Para este app, offline-first significaria: se o usuário abre o app sem rede, ele vê os dados da última sessão em vez de uma tela de erro.

```
[API simulada]  →  [Repositório]  →  [Cache local (SharedPreferences ou Hive)]
                                      ↑
                         serve dados quando offline
                         atualiza quando voltar à rede
```

O repositório teria lógica read-through cache:

```dart
@override
Future<Either<AppFailure, DashboardOverviewData>> getOverview() async {
  if (await _network.isConnected) {
    final result = await _remoteDataSource.getOverview();
    return result.fold(
      (failure) => _getCachedOrFail(failure),      // rede falhou → tenta cache
      (data) async {
        await _localDataSource.saveOverview(data); // atualiza cache
        return Right(data);
      },
    );
  }
  return _getCachedOrFail(NetworkFailure());        // sem rede → cache direto
}
```

### Por que não foi implementado aqui

Três razões concretas:

1. **O app não tem backend real** — o `FakeHttpService` já é in-memory. Adicionar cache do cache não agrega nada.
2. **O teste avalia arquitetura de apresentação e domínio** — a camada de dados é deliberadamente simplificada para não distrair do que está sendo avaliado.
3. **A fronteira está preparada** — `KeyValueWrapper` existe exatamente para que quando houver backend real, o cache seja implementado trocando apenas a implementação, sem mudar repositórios, use cases ou cubits.

### `hydrated_bloc` — a rota mais rápida para cache de estado

Para caching do estado da UI entre sessões (restaurar o último estado conhecido ao abrir o app), o `hydrated_bloc` seria a adição mais natural. Basta estender `HydratedCubit` em vez de `Cubit` e implementar a serialização do state:

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

O custo: `freezed` + `hydrated_bloc` exige implementar `fromJson`/`toJson` no state. Com `freezed` isso pode ser gerado via `json_serializable`. A lógica de negócio do cubit não muda — só a persistência do estado é adicionada.

---

## Outros packages do ecossistema BLoC relacionados a storage

| Package | O que faz | Quando usar |
|---|---|---|
| [`hydrated_bloc`](https://pub.dev/packages/hydrated_bloc) | Persiste e restaura o estado do Cubit/BLoC entre sessões | Cache do último estado da UI sem backend; app que deve mostrar dados offline imediatamente |
| [`replay_bloc`](https://pub.dev/packages/replay_bloc) | Adiciona undo/redo ao estado do Cubit | Apps com histórico de ações do usuário (ex: editor, formulário multi-step) |

- [`hydrated_bloc` — pub.dev](https://pub.dev/packages/hydrated_bloc)
- [`Drift` — documentação oficial](https://drift.simonbinder.eu/)
- [`Hive` — pub.dev](https://pub.dev/packages/hive)
- [`shared_preferences` — pub.dev](https://pub.dev/packages/shared_preferences)
- [Offline-first with Flutter — Very Good Ventures](https://verygood.ventures/blog/offline-first-flutter)
- [Arquitetura do projeto →](./architecture.md)
- [Dívida técnica conhecida →](../README.md#dívida-técnica-conhecida)
