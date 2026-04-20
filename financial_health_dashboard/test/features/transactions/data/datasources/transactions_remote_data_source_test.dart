import 'dart:io';

import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/features/transactions/data/datasources/transactions_remote_data_source.dart';
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
  }) {
    throw UnimplementedError();
  }

  static const _payload = <String, dynamic>{
    'balance': 10000,
    'income': 8000,
    'expense': 3000,
    'balanceChangePercent': 8.0,
    'monthlyGoal': {'monthLabel': 'Abril'},
    'transactions': [
      {
        'id': 'inc-1',
        'title': 'Salário',
        'category': 'salary',
        'value': 5000,
        'type': 'income',
      },
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
  group('TransactionsRemoteDataSource', () {
    test('usa endpoint próprio para getOverview', () async {
      final http = _SpyHttpService();
      final dataSource = TransactionsRemoteDataSourceImpl(
        http,
        const _AlwaysConnected(),
      );

      final model = await dataSource.getOverview();

      expect(http.lastGetPath, '/transactions/overview');
      expect(model.balance, 10000);
      expect(model.transactions, hasLength(2));
    });

    test('lança SocketException quando sem conectividade', () {
      final dataSource = TransactionsRemoteDataSourceImpl(
        _SpyHttpService(),
        const _NeverConnected(),
      );

      expect(dataSource.getOverview, throwsA(isA<SocketException>()));
    });
  });
}
