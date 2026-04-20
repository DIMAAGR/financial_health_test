import 'dart:io';

import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/features/incomes/data/datasources/incomes_remote_data_source.dart';
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
    'income': 8000,
    'incomeChangePercent': 12.5,
    'monthlyGoal': {'monthLabel': 'Abril'},
    'transactions': [
      {
        'id': 'inc-1',
        'title': 'Salário',
        'category': 'salary',
        'value': 5000,
        'type': 'income',
      },
    ],
  };
}

void main() {
  group('IncomesRemoteDataSource', () {
    test('usa endpoint próprio para getOverview', () async {
      final http = _SpyHttpService();
      final dataSource = IncomesRemoteDataSourceImpl(
        http,
        const _AlwaysConnected(),
      );

      final model = await dataSource.getOverview();

      expect(http.lastGetPath, '/incomes/overview');
      expect(model.totalIncome, 8000);
      expect(model.transactions, hasLength(1));
    });

    test('usa endpoint próprio para addIncome', () async {
      final http = _SpyHttpService();
      final dataSource = IncomesRemoteDataSourceImpl(
        http,
        const _AlwaysConnected(),
      );

      await dataSource.addIncome(
        amount: 100,
        title: 'Freelance',
        category: 'services',
      );

      expect(http.lastPostPath, '/incomes');
      expect(http.lastPostData, {
        'amount': 100,
        'title': 'Freelance',
        'category': 'services',
      });
    });

    test('lança SocketException quando sem conectividade', () {
      final dataSource = IncomesRemoteDataSourceImpl(
        _SpyHttpService(),
        const _NeverConnected(),
      );

      expect(dataSource.getOverview, throwsA(isA<SocketException>()));
    });
  });
}
