import 'dart:convert';
import 'dart:math';

import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/storage/key_value_wrapper.dart';
import 'package:financial_health_dashboard/src/core/services/storage/storage_schema.dart';

class FakeHttpService implements HttpService {
  FakeHttpService({
    required KeyValueWrapper storage,
    Duration latency = const Duration(milliseconds: 1500),
  }) : _storage = storage,
       _latency = latency,
       _state = _loadOrCreateState(storage);

  final KeyValueWrapper _storage;
  final Duration _latency;
  final _FakeFinancialState _state;

  @override
  Future<HttpResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    await Future.delayed(_latency);

    switch (path) {
      case '/dashboard/overview':
        return HttpResponse(
          statusCode: 200,
          data: _state.toDashboardOverviewJson(),
        );
      case '/incomes/overview':
        return HttpResponse(
          statusCode: 200,
          data: _state.toIncomesOverviewJson(),
        );
      case '/expenses/overview':
        return HttpResponse(
          statusCode: 200,
          data: _state.toExpensesOverviewJson(),
        );
      case '/transactions/overview':
        return HttpResponse(
          statusCode: 200,
          data: _state.toTransactionsOverviewJson(),
        );
      case '/transactions':
        return HttpResponse(
          statusCode: 200,
          data: {'transactions': _state.transactionsJson()},
        );
      default:
        throw UnsupportedError('GET $path não suportado no FakeHttpService.');
    }
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    await Future.delayed(_latency);

    switch (path) {
      case '/dashboard/income':
      case '/incomes':
        final amount = _readPositiveAmount(data);
        _state.addIncome(
          amount,
          title: _readTextOrFallback(data, 'title', fallback: 'Receita extra'),
          category: _readTextOrFallback(data, 'category', fallback: 'other'),
        );
        await _persistState();
        return HttpResponse(
          statusCode: 200,
          data: _state.responseForPost(path),
        );
      case '/dashboard/expense':
      case '/expenses':
        final amount = _readPositiveAmount(data);
        _state.addExpense(
          amount,
          title: _readTextOrFallback(data, 'title', fallback: 'Nova despesa'),
          category: _readTextOrFallback(data, 'category', fallback: 'other'),
        );
        await _persistState();
        return HttpResponse(
          statusCode: 200,
          data: _state.responseForPost(path),
        );
      default:
        throw UnsupportedError('POST $path não suportado no FakeHttpService.');
    }
  }

  double _readPositiveAmount(Map<String, dynamic>? data) {
    final rawAmount = data?['amount'];
    if (rawAmount is! num || rawAmount <= 0) {
      throw ArgumentError.value(
        rawAmount,
        'amount',
        'amount deve ser numérico e maior que zero.',
      );
    }
    return rawAmount.toDouble();
  }

  String _readTextOrFallback(
    Map<String, dynamic>? data,
    String key, {
    required String fallback,
  }) {
    final raw = data?[key] as String?;
    final value = raw?.trim();
    return (value == null || value.isEmpty) ? fallback : value;
  }

  Future<void> _persistState() async {
    await Future.wait([
      _storage.setString(
        StorageSchema.financialOverviewKey,
        jsonEncode(_state.toFinancialOverviewJson()),
      ),
      _storage.setString(
        StorageSchema.financialTransactionsKey,
        jsonEncode(_state.transactionsJson()),
      ),
    ]);
  }

  static _FakeFinancialState _loadOrCreateState(KeyValueWrapper storage) {
    final raw = storage.getString(StorageSchema.financialOverviewKey);
    if (raw == null || raw.isEmpty) {
      final randomState = _FakeFinancialState.random(Random(), DateTime.now());
      _persistInitialState(storage, randomState);
      return randomState;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return _withPersistedTransactions(storage, decoded);
      }
      if (decoded is Map) {
        return _withPersistedTransactions(
          storage,
          decoded.cast<String, dynamic>(),
        );
      }
    } catch (_) {
      // Fall back to random state when cached payload is corrupted.
    }

    final fallback = _FakeFinancialState.random(Random(), DateTime.now());
    _persistInitialState(storage, fallback);
    return fallback;
  }

  static void _persistInitialState(
    KeyValueWrapper storage,
    _FakeFinancialState state,
  ) {
    storage
      ..setString(
        StorageSchema.financialOverviewKey,
        jsonEncode(state.toFinancialOverviewJson()),
      )
      ..setString(
        StorageSchema.financialTransactionsKey,
        jsonEncode(state.transactionsJson()),
      );
  }

  static _FakeFinancialState _withPersistedTransactions(
    KeyValueWrapper storage,
    Map<String, dynamic> overviewJson,
  ) {
    final state = _FakeFinancialState.fromFinancialOverviewJson(overviewJson);
    final persistedTransactions = _readPersistedTransactions(storage);

    if (persistedTransactions == null) {
      storage.setString(
        StorageSchema.financialTransactionsKey,
        jsonEncode(state.transactionsJson()),
      );
      return state;
    }

    state.transactions
      ..clear()
      ..addAll(persistedTransactions);
    return state;
  }

  static List<_Transaction>? _readPersistedTransactions(
    KeyValueWrapper storage,
  ) {
    final raw = storage.getString(StorageSchema.financialTransactionsKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded
          .map(_asMap)
          .map(_Transaction.fromJson)
          .where((item) => item.id.isNotEmpty)
          .toList(growable: true);
    } catch (_) {
      return null;
    }
  }
}

class _FakeFinancialState {
  _FakeFinancialState({
    required this.userName,
    required this.monthLabel,
    required this.balance,
    required this.income,
    required this.expense,
    required this.previousLiquidityIndex,
    required this.currentLiquidityIndex,
    required this.goalTargetAmount,
    required this.goalAchievedAmount,
    required this.goalDay,
    required this.goalDaysInMonth,
    required this.flow,
    required this.transactions,
  });

  factory _FakeFinancialState.random(Random random, DateTime now) {
    final income = _randomInRange(random, min: 8000, max: 26000);
    final expense = _randomInRange(random, min: 3500, max: income * 0.95);
    final balance = _randomInRange(
      random,
      min: income * 0.6,
      max: income * 2.2,
    );
    final currentLiquidityIndex = (income / expense).clamp(0.5, 4.0);
    final previousLiquidityIndex =
        (currentLiquidityIndex + _randomInRange(random, min: -0.2, max: 0.2))
            .clamp(0.3, 4.0);

    final monthDays = DateTime(now.year, now.month + 1, 0).day;
    final monthLabel = _ptBrMonth(now.month);
    final goalTargetAmount = _randomInRange(
      random,
      min: income * 1.1,
      max: income * 1.8,
    );
    final goalAchievedAmount = _randomInRange(
      random,
      min: income * 0.3,
      max: income * 1.1,
    );

    final flow = List<_FlowMonth>.generate(6, (_) {
      final monthIncome = _randomInRange(
        random,
        min: income * 0.7,
        max: income * 1.15,
      );
      final monthExpense = _randomInRange(
        random,
        min: expense * 0.7,
        max: monthIncome * 0.95,
      );
      return _FlowMonth(income: monthIncome, expense: monthExpense);
    });

    flow[flow.length - 1] = _FlowMonth(income: income, expense: expense);

    final transactions = <_Transaction>[
      ...List<_Transaction>.generate(
        5,
        (i) => _Transaction(
          id: _randomId(random, prefix: 'inc'),
          title: _incomeTitles[random.nextInt(_incomeTitles.length)],
          category: _incomeCategories[random.nextInt(_incomeCategories.length)],
          value: _randomInRange(random, min: 150, max: income * 0.16),
          type: _TransactionType.income,
          date: now.subtract(Duration(days: random.nextInt(7))),
        ),
      ),
      ...List<_Transaction>.generate(
        5,
        (i) => _Transaction(
          id: _randomId(random, prefix: 'exp'),
          title: _expenseTitles[random.nextInt(_expenseTitles.length)],
          category:
              _expenseCategories[random.nextInt(_expenseCategories.length)],
          value: _randomInRange(random, min: 80, max: expense * 0.14),
          type: _TransactionType.expense,
          date: now.subtract(Duration(days: random.nextInt(7))),
        ),
      ),
    ]..shuffle(random);

    return _FakeFinancialState(
      userName: 'Júlio',
      monthLabel: monthLabel,
      balance: balance,
      income: income,
      expense: expense,
      previousLiquidityIndex: previousLiquidityIndex,
      currentLiquidityIndex: currentLiquidityIndex,
      goalTargetAmount: goalTargetAmount,
      goalAchievedAmount: goalAchievedAmount,
      goalDay: now.day.clamp(1, monthDays),
      goalDaysInMonth: monthDays,
      flow: flow,
      transactions: transactions,
    );
  }

  factory _FakeFinancialState.fromFinancialOverviewJson(
    Map<String, dynamic> json,
  ) {
    final liquidity = _asMap(json['liquidity']);
    final monthlyGoal = _asMap(json['monthlyGoal']);
    final flowJson = (json['flow'] as List<dynamic>? ?? const [])
        .map(_asMap)
        .toList(growable: false);
    final transactionsJson =
        (json['transactions'] as List<dynamic>? ?? const [])
            .map(_asMap)
            .toList(growable: false);

    final flow = flowJson
        .map(
          (item) => _FlowMonth(
            income: _toDouble(item['income']),
            expense: _toDouble(item['expense']),
          ),
        )
        .toList(growable: false);

    final transactions = transactionsJson
        .map(
          (item) => _Transaction(
            id: (item['id'] as String? ?? '').trim(),
            title: (item['title'] as String? ?? '').trim(),
            category: (item['category'] as String? ?? '').trim(),
            value: _toDouble(item['value']),
            type: (item['type'] as String? ?? '').toLowerCase() == 'expense'
                ? _TransactionType.expense
                : _TransactionType.income,
            date:
                DateTime.tryParse(item['date'] as String? ?? '') ??
                DateTime.now(),
          ),
        )
        .where((item) => item.id.isNotEmpty)
        .toList(growable: true);

    final now = DateTime.now();
    return _FakeFinancialState(
      userName: (json['userName'] as String? ?? 'Júlio').trim(),
      monthLabel:
          (monthlyGoal['monthLabel'] as String? ?? _ptBrMonth(now.month))
              .trim(),
      balance: _toDouble(json['balance']),
      income: _toDouble(json['income']),
      expense: _toDouble(json['expense']),
      previousLiquidityIndex: _toDouble(liquidity['previousIndex']),
      currentLiquidityIndex: _toDouble(liquidity['currentIndex']),
      goalTargetAmount: _toDouble(monthlyGoal['targetAmount']),
      goalAchievedAmount: _toDouble(monthlyGoal['achievedAmount']),
      goalDay: _toInt(monthlyGoal['day'], fallback: now.day),
      goalDaysInMonth: _toInt(
        monthlyGoal['daysInMonth'],
        fallback: DateTime(now.year, now.month + 1, 0).day,
      ),
      flow: flow.isEmpty
          ? <_FlowMonth>[const _FlowMonth(income: 0, expense: 0)]
          : flow,
      transactions: transactions,
    );
  }

  String userName;
  String monthLabel;
  double balance;
  double income;
  double expense;
  double previousLiquidityIndex;
  double currentLiquidityIndex;
  double goalTargetAmount;
  double goalAchievedAmount;
  int goalDay;
  int goalDaysInMonth;
  final double commitmentBenchmarkPercent = 65;
  final List<_FlowMonth> flow;
  final List<_Transaction> transactions;

  double get commitmentPercent {
    if (income <= 0) return expense <= 0 ? 0 : 100;
    return (expense / income) * 100;
  }

  double get commitmentDifferencePercent =>
      commitmentBenchmarkPercent - commitmentPercent;

  void addIncome(
    double amount, {
    required String title,
    required String category,
  }) {
    income += amount;
    balance += amount;
    goalAchievedAmount += amount;
    transactions.add(
      _Transaction(
        id: _runtimeId('inc'),
        title: title,
        category: category,
        value: amount,
        type: _TransactionType.income,
        date: DateTime.now(),
      ),
    );
    _touchCurrentFlow(incomeDelta: amount, expenseDelta: 0);
    _refreshLiquidity();
  }

  void addExpense(
    double amount, {
    required String title,
    required String category,
  }) {
    expense += amount;
    balance -= amount;
    transactions.add(
      _Transaction(
        id: _runtimeId('exp'),
        title: title,
        category: category,
        value: amount,
        type: _TransactionType.expense,
        date: DateTime.now(),
      ),
    );
    _touchCurrentFlow(incomeDelta: 0, expenseDelta: amount);
    _refreshLiquidity();
  }

  void _touchCurrentFlow({
    required double incomeDelta,
    required double expenseDelta,
  }) {
    final current = flow.last;
    flow[flow.length - 1] = _FlowMonth(
      income: current.income + incomeDelta,
      expense: current.expense + expenseDelta,
    );
  }

  void _refreshLiquidity() {
    previousLiquidityIndex = currentLiquidityIndex;
    final newIndex = expense <= 0 ? 2.0 : income / expense;
    currentLiquidityIndex = min(newIndex, 4.0);
  }

  double _changePercent(double current, double previous) {
    if (previous <= 0) return current > 0 ? 100 : 0;
    return ((current - previous) / previous) * 100;
  }

  Map<String, dynamic> responseForPost(String path) {
    switch (path) {
      case '/incomes':
        return toIncomesOverviewJson();
      case '/expenses':
        return toExpensesOverviewJson();
      case '/dashboard/income':
      case '/dashboard/expense':
      default:
        return toDashboardOverviewJson();
    }
  }

  Map<String, dynamic> toFinancialOverviewJson() {
    return {
      ..._metricsJson(),
      'userName': userName,
      'liquidity': {
        'previousIndex': previousLiquidityIndex,
        'currentIndex': currentLiquidityIndex,
      },
      'commitment': {
        'percent': commitmentPercent,
        'benchmarkPercent': commitmentBenchmarkPercent,
        'differencePercent': commitmentDifferencePercent,
      },
      'monthlyGoal': _monthlyGoalJson(),
      'flow': flow
          .map((item) => {'income': item.income, 'expense': item.expense})
          .toList(),
    };
  }

  Map<String, dynamic> toDashboardOverviewJson() {
    return toFinancialOverviewJson();
  }

  Map<String, dynamic> toIncomesOverviewJson() {
    return {
      'income': income,
      'incomeChangePercent': _metricsJson()['incomeChangePercent'],
      'monthlyGoal': _monthlyGoalJson(),
      'transactions': transactionsJson(type: _TransactionType.income),
    };
  }

  Map<String, dynamic> toExpensesOverviewJson() {
    return {
      'expense': expense,
      'expenseChangePercent': _metricsJson()['expenseChangePercent'],
      'monthlyGoal': _monthlyGoalJson(),
      'transactions': transactionsJson(type: _TransactionType.expense),
    };
  }

  Map<String, dynamic> toTransactionsOverviewJson() {
    return {
      ..._metricsJson(),
      'monthlyGoal': _monthlyGoalJson(),
      'transactions': transactionsJson(),
    };
  }

  Map<String, dynamic> _metricsJson() {
    final previousMonth = flow.length >= 2
        ? flow[flow.length - 2]
        : const _FlowMonth(income: 0, expense: 0);

    return {
      'income': income,
      'expense': expense,
      'balance': balance,
      'incomeChangePercent': _changePercent(income, previousMonth.income),
      'expenseChangePercent': _changePercent(expense, previousMonth.expense),
      'balanceChangePercent': _changePercent(
        income - expense,
        previousMonth.income - previousMonth.expense,
      ),
    };
  }

  Map<String, dynamic> _monthlyGoalJson() {
    return {
      'monthLabel': monthLabel,
      'targetAmount': goalTargetAmount,
      'achievedAmount': goalAchievedAmount,
      'day': goalDay,
      'daysInMonth': goalDaysInMonth,
    };
  }

  List<Map<String, dynamic>> transactionsJson({_TransactionType? type}) {
    return transactions
        .where((item) => type == null || item.type == type)
        .map((item) => item.toJson())
        .toList();
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  return <String, dynamic>{};
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return 0;
}

int _toInt(dynamic value, {required int fallback}) {
  if (value is num) return value.toInt();
  return fallback;
}

double _randomInRange(
  Random random, {
  required double min,
  required double max,
}) {
  if (max <= min) return min;
  return min + random.nextDouble() * (max - min);
}

String _ptBrMonth(int month) {
  const months = <String>[
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];
  return months[(month - 1).clamp(0, 11)];
}

String _randomId(Random random, {required String prefix}) {
  final seed = random.nextInt(1 << 32).toRadixString(16);
  return '$prefix-$seed';
}

String _runtimeId(String prefix) {
  return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
}

class _FlowMonth {
  const _FlowMonth({required this.income, required this.expense});

  final double income;
  final double expense;
}

enum _TransactionType { income, expense }

class _Transaction {
  const _Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.value,
    required this.type,
    required this.date,
  });

  final String id;
  final String title;
  final String category;
  final double value;
  final _TransactionType type;
  final DateTime date;

  factory _Transaction.fromJson(Map<String, dynamic> json) {
    return _Transaction(
      id: (json['id'] as String? ?? '').trim(),
      title: (json['title'] as String? ?? '').trim(),
      category: (json['category'] as String? ?? '').trim(),
      value: _toDouble(json['value']),
      type: (json['type'] as String? ?? '').toLowerCase() == 'expense'
          ? _TransactionType.expense
          : _TransactionType.income,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'value': value,
      'type': type.name,
      'date': date.toIso8601String(),
    };
  }
}

const _incomeTitles = <String>[
  'Salário',
  'Freelance',
  'Venda de Produto',
  'Reembolso',
  'Rendimento',
];

const _incomeCategories = <String>['salary', 'services', 'investment', 'other'];

const _expenseTitles = <String>[
  'Mercado',
  'Transporte',
  'Internet',
  'Assinatura',
  'Compra do mês',
];

const _expenseCategories = <String>[
  'food',
  'transport',
  'shopping',
  'housing',
  'other',
];
