import 'package:financial_health_dashboard/src/core/services/http/fake_http_service.dart';
import 'package:financial_health_dashboard/src/core/services/storage/key_value_wrapper.dart';
import 'package:financial_health_dashboard/src/core/services/storage/storage_schema.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeHttpService', () {
    late InMemoryKeyValueWrapper storage;
    late FakeHttpService service;

    setUp(() {
      storage = InMemoryKeyValueWrapper();
      service = FakeHttpService(storage: storage, latency: Duration.zero);
    });

    test(
      'GET /dashboard/overview retorna status 200 e payload esperado',
      () async {
        final response = await service.get('/dashboard/overview');

        expect(response.statusCode, 200);
        expect(response.data['userName'], isNotEmpty);
        expect(response.data['liquidity'], isA<Map<String, dynamic>>());
        expect(response.data['commitment'], isA<Map<String, dynamic>>());
        expect(response.data['monthlyGoal'], isA<Map<String, dynamic>>());
        expect(response.data['flow'], isA<List<dynamic>>());
        expect(response.data.containsKey('transactions'), isFalse);
      },
    );

    test(
      'transactions overview inicial vem com 5 receitas e 5 despesas',
      () async {
        final response = await service.get('/transactions/overview');
        final transactions = response.data['transactions'] as List<dynamic>;

        final incomes = transactions
            .where((item) => (item as Map<String, dynamic>)['type'] == 'income')
            .length;
        final expenses = transactions
            .where(
              (item) => (item as Map<String, dynamic>)['type'] == 'expense',
            )
            .length;

        expect(incomes, 5);
        expect(expenses, 5);
      },
    );

    test('GET /incomes/overview retorna apenas receitas', () async {
      final response = await service.get('/incomes/overview');
      final transactions = response.data['transactions'] as List<dynamic>;

      expect(response.data['income'], greaterThan(0));
      expect(transactions, isNotEmpty);
      expect(
        transactions.every(
          (item) => (item as Map<String, dynamic>)['type'] == 'income',
        ),
        isTrue,
      );
    });

    test('GET /expenses/overview retorna apenas despesas', () async {
      final response = await service.get('/expenses/overview');
      final transactions = response.data['transactions'] as List<dynamic>;

      expect(response.data['expense'], greaterThan(0));
      expect(transactions, isNotEmpty);
      expect(
        transactions.every(
          (item) => (item as Map<String, dynamic>)['type'] == 'expense',
        ),
        isTrue,
      );
    });

    test('inicializa overview e transactions em chaves separadas', () async {
      await service.get('/dashboard/overview');

      expect(storage.getString(StorageSchema.financialOverviewKey), isNotNull);
      expect(
        storage.getString(StorageSchema.financialTransactionsKey),
        isNotNull,
      );
    });

    test('GET /transactions retorna lista persistida para detalhe', () async {
      final overview = await service.get('/transactions/overview');
      final overviewTransactions =
          overview.data['transactions'] as List<dynamic>;

      final response = await service.get('/transactions');
      final transactions = response.data['transactions'] as List<dynamic>;

      expect(response.statusCode, 200);
      expect(transactions, hasLength(overviewTransactions.length));
      expect(transactions.first, isA<Map<String, dynamic>>());
    });

    test(
      'POST /dashboard/income atualiza income, balance, goal e flow atual',
      () async {
        final before = await service.get('/dashboard/overview');
        final beforeDetail = await service.get('/transactions');
        final beforeFlow = before.data['flow'] as List<dynamic>;
        final beforeLastFlow = beforeFlow.last as Map<String, dynamic>;

        final after = await service.post(
          '/dashboard/income',
          data: {'amount': 500},
        );
        final afterFlow = after.data['flow'] as List<dynamic>;
        final afterLastFlow = afterFlow.last as Map<String, dynamic>;

        expect(
          after.data['income'] as num,
          closeTo((before.data['income'] as num) + 500, 0.001),
        );
        expect(
          after.data['balance'] as num,
          closeTo((before.data['balance'] as num) + 500, 0.001),
        );

        final beforeGoal =
            (before.data['monthlyGoal']
                    as Map<String, dynamic>)['achievedAmount']
                as num;
        final afterGoal =
            (after.data['monthlyGoal']
                    as Map<String, dynamic>)['achievedAmount']
                as num;
        expect(afterGoal, closeTo(beforeGoal + 500, 0.001));

        expect(
          afterLastFlow['income'] as num,
          closeTo((beforeLastFlow['income'] as num) + 500, 0.001),
        );
        expect(afterLastFlow['expense'], beforeLastFlow['expense']);

        final beforeTransactions =
            beforeDetail.data['transactions'] as List<dynamic>;
        final detail = await service.get('/transactions');
        final detailTransactions = detail.data['transactions'] as List<dynamic>;
        expect(detailTransactions.length, beforeTransactions.length + 1);
        final lastTx = detailTransactions.last as Map<String, dynamic>;
        expect(lastTx['type'], 'income');
        expect(
          storage.getString(StorageSchema.financialTransactionsKey),
          isNotNull,
        );
      },
    );

    test('POST /incomes retorna overview de receitas atualizado', () async {
      final before = await service.get('/incomes/overview');

      final after = await service.post(
        '/incomes',
        data: {'amount': 500, 'title': 'Freelance', 'category': 'services'},
      );

      expect(
        after.data['income'] as num,
        closeTo((before.data['income'] as num) + 500, 0.001),
      );
      final transactions = after.data['transactions'] as List<dynamic>;
      expect((transactions.last as Map<String, dynamic>)['type'], 'income');
      expect(after.data.containsKey('expense'), isFalse);
    });

    test(
      'POST /dashboard/expense atualiza expense, balance e flow atual',
      () async {
        final before = await service.get('/dashboard/overview');
        final beforeDetail = await service.get('/transactions');
        final beforeFlow = before.data['flow'] as List<dynamic>;
        final beforeLastFlow = beforeFlow.last as Map<String, dynamic>;

        final after = await service.post(
          '/dashboard/expense',
          data: {'amount': 250},
        );
        final afterFlow = after.data['flow'] as List<dynamic>;
        final afterLastFlow = afterFlow.last as Map<String, dynamic>;

        expect(
          after.data['expense'] as num,
          closeTo((before.data['expense'] as num) + 250, 0.001),
        );
        expect(
          after.data['balance'] as num,
          closeTo((before.data['balance'] as num) - 250, 0.001),
        );

        final beforeGoal =
            (before.data['monthlyGoal']
                    as Map<String, dynamic>)['achievedAmount']
                as num;
        final afterGoal =
            (after.data['monthlyGoal']
                    as Map<String, dynamic>)['achievedAmount']
                as num;
        expect(afterGoal, closeTo(beforeGoal, 0.001));

        expect(afterLastFlow['income'], beforeLastFlow['income']);
        expect(
          afterLastFlow['expense'] as num,
          closeTo((beforeLastFlow['expense'] as num) + 250, 0.001),
        );

        final beforeTransactions =
            beforeDetail.data['transactions'] as List<dynamic>;
        final detail = await service.get('/transactions');
        final detailTransactions = detail.data['transactions'] as List<dynamic>;
        expect(detailTransactions.length, beforeTransactions.length + 1);
        final lastTx = detailTransactions.last as Map<String, dynamic>;
        expect(lastTx['type'], 'expense');
        expect(
          storage.getString(StorageSchema.financialTransactionsKey),
          isNotNull,
        );
      },
    );

    test('POST /expenses retorna overview de despesas atualizado', () async {
      final before = await service.get('/expenses/overview');

      final after = await service.post(
        '/expenses',
        data: {'amount': 250, 'title': 'Mercado', 'category': 'food'},
      );

      expect(
        after.data['expense'] as num,
        closeTo((before.data['expense'] as num) + 250, 0.001),
      );
      final transactions = after.data['transactions'] as List<dynamic>;
      expect((transactions.last as Map<String, dynamic>)['type'], 'expense');
      expect(after.data.containsKey('income'), isFalse);
    });

    test(
      'atualiza liquidez após mutações mantendo previous=current anterior',
      () async {
        final before = await service.get('/dashboard/overview');
        final beforeLiquidity =
            before.data['liquidity'] as Map<String, dynamic>;
        final beforeCurrent = (beforeLiquidity['currentIndex'] as num)
            .toDouble();

        final after = await service.post(
          '/dashboard/income',
          data: {'amount': 500},
        );
        final afterLiquidity = after.data['liquidity'] as Map<String, dynamic>;

        final expectedCurrent =
            ((after.data['income'] as num).toDouble() /
                    (after.data['expense'] as num).toDouble())
                .clamp(0, 4)
                .toDouble();

        expect(
          afterLiquidity['previousIndex'] as num,
          closeTo(beforeCurrent, 0.001),
        );
        expect(
          afterLiquidity['currentIndex'] as num,
          closeTo(expectedCurrent, 0.001),
        );
      },
    );

    test('GET com rota não suportada lança UnsupportedError', () async {
      expect(() => service.get('/unknown'), throwsA(isA<UnsupportedError>()));
    });

    test('POST com rota não suportada lança UnsupportedError', () async {
      expect(
        () => service.post('/unknown', data: {'amount': 10}),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('POST income sem amount válido lança ArgumentError', () async {
      expect(
        () => service.post('/dashboard/income'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.post('/dashboard/income', data: {'amount': 0}),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.post('/dashboard/income', data: {'amount': -1}),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.post('/dashboard/income', data: {'amount': '100'}),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('POST expense sem amount válido lança ArgumentError', () async {
      expect(
        () => service.post('/dashboard/expense'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.post('/dashboard/expense', data: {'amount': 0}),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.post('/dashboard/expense', data: {'amount': -1}),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.post('/dashboard/expense', data: {'amount': true}),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
