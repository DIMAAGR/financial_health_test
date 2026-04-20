import 'dart:io';

import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/features/incomes/data/models/incomes_overview_model.dart';

abstract class IncomesRemoteDataSource {
  Future<IncomesOverviewModel> getOverview();

  Future<void> addIncome({required double amount, required String title, required String category});
}

class IncomesRemoteDataSourceImpl implements IncomesRemoteDataSource {
  const IncomesRemoteDataSourceImpl(this._http, this._networkInfo);

  final HttpService _http;
  final NetworkInfo _networkInfo;

  Future<void> _ensureConnected() async {
    if (!await _networkInfo.isConnected) {
      throw const SocketException('Sem conexão com a internet.');
    }
  }

  @override
  Future<IncomesOverviewModel> getOverview() async {
    await _ensureConnected();
    final response = await _http.get('/dashboard/overview');
    return IncomesOverviewModel.fromJson(response.data);
  }

  @override
  Future<void> addIncome({
    required double amount,
    required String title,
    required String category,
  }) async {
    await _ensureConnected();
    await _http.post(
      '/dashboard/income',
      data: {'amount': amount, 'title': title, 'category': category},
    );
  }
}
