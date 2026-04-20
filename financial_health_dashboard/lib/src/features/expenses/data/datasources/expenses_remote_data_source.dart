import 'dart:io';

import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/features/expenses/data/models/expenses_overview_model.dart';

abstract class ExpensesRemoteDataSource {
  Future<ExpensesOverviewModel> getOverview();

  Future<void> addExpense({
    required double amount,
    required String title,
    required String category,
  });
}

class ExpensesRemoteDataSourceImpl implements ExpensesRemoteDataSource {
  const ExpensesRemoteDataSourceImpl(this._http, this._networkInfo);

  final HttpService _http;
  final NetworkInfo _networkInfo;

  Future<void> _ensureConnected() async {
    if (!await _networkInfo.isConnected) {
      throw const SocketException('Sem conexão com a internet.');
    }
  }

  @override
  Future<ExpensesOverviewModel> getOverview() async {
    await _ensureConnected();
    final response = await _http.get('/expenses/overview');
    return ExpensesOverviewModel.fromJson(response.data);
  }

  @override
  Future<void> addExpense({
    required double amount,
    required String title,
    required String category,
  }) async {
    await _ensureConnected();
    await _http.post(
      '/expenses',
      data: {'amount': amount, 'title': title, 'category': category},
    );
  }
}
