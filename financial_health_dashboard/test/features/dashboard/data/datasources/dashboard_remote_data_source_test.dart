import 'dart:io';

import 'package:financial_health_dashboard/src/core/services/http/fake_http_service.dart';
import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/core/services/storage/key_value_wrapper.dart';
import 'package:financial_health_dashboard/src/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

class _AlwaysConnected implements NetworkInfo {
  const _AlwaysConnected();

  @override
  Future<bool> get isConnected async => true;
}

void main() {
  group('DashboardRemoteDataSource', () {
    late DashboardRemoteDataSource dataSource;

    setUp(() {
      dataSource = DashboardRemoteDataSourceImpl(
        FakeHttpService(
          storage: InMemoryKeyValueWrapper(),
          latency: Duration.zero,
        ),
        const _AlwaysConnected(),
      );
    });

    test('carrega overview com valores iniciais', () async {
      final model = await dataSource.getOverview();

      expect(model.userName, isNotEmpty);
      expect(model.income, greaterThan(0));
      expect(model.expense, greaterThan(0));
      expect(model.flowPoints, hasLength(6));
    });

    test('adiciona receita e retorna overview atualizado', () async {
      final before = await dataSource.getOverview();

      final after = await dataSource.addIncome(
        amount: 500,
        title: 'Freelance',
        category: 'investment',
      );

      expect(after.income, closeTo(before.income + 500, 0.001));
      expect(after.balance, closeTo(before.balance + 500, 0.001));
      expect(
        after.goalAchievedAmount,
        closeTo(before.goalAchievedAmount + 500, 0.001),
      );
    });

    test('adiciona despesa e retorna overview atualizado', () async {
      final before = await dataSource.getOverview();

      final after = await dataSource.addExpense(
        amount: 250,
        title: 'Mercado',
        category: 'food',
      );

      expect(after.expense, closeTo(before.expense + 250, 0.001));
      expect(after.balance, closeTo(before.balance - 250, 0.001));
      expect(
        after.goalAchievedAmount,
        closeTo(before.goalAchievedAmount, 0.001),
      );
    });

    test('propaga erro quando amount de receita é inválido', () async {
      expect(
        () => dataSource.addIncome(amount: 0, title: 'X', category: 'Y'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('propaga erro quando amount de despesa é inválido', () async {
      expect(
        () => dataSource.addExpense(amount: -10, title: 'X', category: 'Y'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('usa endpoint correto para getOverview', () async {
      final spy = _SpyHttpService();
      final ds = DashboardRemoteDataSourceImpl(spy, const _AlwaysConnected());

      await ds.getOverview();

      expect(spy.lastGetPath, '/dashboard/overview');
    });

    test('usa endpoint e payload corretos para addIncome', () async {
      final spy = _SpyHttpService();
      final ds = DashboardRemoteDataSourceImpl(spy, const _AlwaysConnected());

      await ds.addIncome(
        amount: 321.5,
        title: 'Freelance',
        category: 'investment',
      );

      expect(spy.lastPostPath, '/dashboard/income');
      expect(spy.lastPostData, {
        'amount': 321.5,
        'title': 'Freelance',
        'category': 'investment',
      });
    });

    test('usa endpoint e payload corretos para addExpense', () async {
      final spy = _SpyHttpService();
      final ds = DashboardRemoteDataSourceImpl(spy, const _AlwaysConnected());

      await ds.addExpense(amount: 123.4, title: 'Mercado', category: 'food');

      expect(spy.lastPostPath, '/dashboard/expense');
      expect(spy.lastPostData, {
        'amount': 123.4,
        'title': 'Mercado',
        'category': 'food',
      });
    });

    test('faz parse resiliente quando payload vem incompleto', () async {
      final spy = _SpyHttpService(
        payload: {
          'flow': ['invalid-item'],
        },
      );
      final ds = DashboardRemoteDataSourceImpl(spy, const _AlwaysConnected());

      final model = await ds.getOverview();

      expect(model.userName, 'Usuário');
      expect(model.monthLabel, 'Mês');
      expect(model.balance, 0);
      expect(model.income, 0);
      expect(model.expense, 0);
      expect(model.flowPoints, hasLength(1));
      expect(model.flowPoints.first.income, 0);
      expect(model.flowPoints.first.expense, 0);
    });

    test('lança SocketException quando sem conectividade', () async {
      final ds = DashboardRemoteDataSourceImpl(
        _SpyHttpService(),
        const _NeverConnected(),
      );

      expect(ds.getOverview, throwsA(isA<SocketException>()));
    });
  });
}

class _NeverConnected implements NetworkInfo {
  const _NeverConnected();

  @override
  Future<bool> get isConnected async => false;
}

class _SpyHttpService implements HttpService {
  _SpyHttpService({Map<String, dynamic>? payload})
    : _payload = payload ?? _defaultPayload;

  static const Map<String, dynamic> _defaultPayload = {
    'userName': 'Júlio',
    'income': 12000,
    'expense': 7200,
    'balance': 18000,
    'liquidity': {'previousIndex': 1.2, 'currentIndex': 1.3},
    'commitment': {'percent': 60, 'benchmarkPercent': 65},
    'monthlyGoal': {
      'monthLabel': 'Abril',
      'targetAmount': 15000,
      'achievedAmount': 12000,
      'day': 16,
      'daysInMonth': 30,
    },
    'flow': [
      {'income': 1000, 'expense': 800},
    ],
  };

  final Map<String, dynamic> _payload;
  String? lastGetPath;
  String? lastPostPath;
  Map<String, dynamic>? lastPostData;

  @override
  Future<HttpResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    lastGetPath = path;
    return HttpResponse(statusCode: 200, data: _payload);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    lastPostPath = path;
    lastPostData = data;
    return HttpResponse(statusCode: 200, data: _payload);
  }
}
