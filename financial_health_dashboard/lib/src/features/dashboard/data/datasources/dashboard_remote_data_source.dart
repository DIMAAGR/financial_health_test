import 'dart:io';

import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/features/dashboard/data/models/dashboard_overview_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardOverviewModel> getOverview();

  Future<DashboardOverviewModel> addIncome({
    required double amount,
    required String title,
    required String category,
  });

  Future<DashboardOverviewModel> addExpense({
    required double amount,
    required String title,
    required String category,
  });
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  const DashboardRemoteDataSourceImpl(this._http, this._networkInfo);

  final HttpService _http;
  final NetworkInfo _networkInfo;

  Future<void> _ensureConnected() async {
    if (!await _networkInfo.isConnected) {
      throw const SocketException('Sem conexão com a internet.');
    }
  }

  @override
  Future<DashboardOverviewModel> getOverview() async {
    await _ensureConnected();
    final response = await _http.get('/dashboard/overview');
    return DashboardOverviewModel.fromJson(response.data);
  }

  @override
  Future<DashboardOverviewModel> addIncome({
    required double amount,
    required String title,
    required String category,
  }) async {
    await _ensureConnected();
    final response = await _http.post(
      '/dashboard/income',
      data: {'amount': amount, 'title': title, 'category': category},
    );
    return DashboardOverviewModel.fromJson(response.data);
  }

  @override
  Future<DashboardOverviewModel> addExpense({
    required double amount,
    required String title,
    required String category,
  }) async {
    await _ensureConnected();
    final response = await _http.post(
      '/dashboard/expense',
      data: {'amount': amount, 'title': title, 'category': category},
    );
    return DashboardOverviewModel.fromJson(response.data);
  }
}
