import 'dart:io';

import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

class _AlwaysConnected implements NetworkInfo {
  const _AlwaysConnected();

  @override
  Future<bool> get isConnected async => true;
}

class _NeverConnected implements NetworkInfo {
  const _NeverConnected();

  @override
  Future<bool> get isConnected async => false;
}

class _SpyHttpService implements HttpService {
  String? lastGetPath;
  String? lastPostPath;
  Map<String, dynamic>? lastPostData;

  @override
  Future<HttpResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    lastGetPath = path;
    return const HttpResponse(statusCode: 200, data: _payload);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    lastPostPath = path;
    lastPostData = data;
    return const HttpResponse(statusCode: 200, data: _payload);
  }

  static const _payload = <String, dynamic>{
    'expense': 3000,
    'expenseChangePercent': -5.0,
    'monthlyGoal': {'monthLabel': 'Abril'},
    'transactions': [
      {
        'id': 'exp-1',
        'title': 'Mercado',
        'category': 'food',
        'value': 300,
        'type': 'expense',
      },
    ],
  };
}

void main() {
  group('ExpensesRemoteDataSource', () {
    test('usa endpoint próprio para getOverview', () async {
      final http = _SpyHttpService();
      final dataSource = ExpensesRemoteDataSourceImpl(
        http,
        const _AlwaysConnected(),
      );

      final model = await dataSource.getOverview();

      expect(http.lastGetPath, '/expenses/overview');
      expect(model.totalExpense, 3000);
      expect(model.transactions, hasLength(1));
    });

    test('usa endpoint próprio para addExpense', () async {
      final http = _SpyHttpService();
      final dataSource = ExpensesRemoteDataSourceImpl(
        http,
        const _AlwaysConnected(),
      );

      await dataSource.addExpense(
        amount: 100,
        title: 'Mercado',
        category: 'food',
      );

      expect(http.lastPostPath, '/expenses');
      expect(http.lastPostData, {
        'amount': 100,
        'title': 'Mercado',
        'category': 'food',
      });
    });

    test('lança SocketException quando sem conectividade', () {
      final dataSource = ExpensesRemoteDataSourceImpl(
        _SpyHttpService(),
        const _NeverConnected(),
      );

      expect(dataSource.getOverview, throwsA(isA<SocketException>()));
    });
  });
}
