import 'dart:io';

import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/features/transactions/data/models/transactions_overview_model.dart';

abstract class TransactionsRemoteDataSource {
  Future<TransactionsOverviewModel> getOverview();
}

class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  const TransactionsRemoteDataSourceImpl(this._http, this._networkInfo);

  final HttpService _http;
  final NetworkInfo _networkInfo;

  @override
  Future<TransactionsOverviewModel> getOverview() async {
    if (!await _networkInfo.isConnected) {
      throw const SocketException('Sem conexão com a internet.');
    }
    final response = await _http.get('/dashboard/overview');
    return TransactionsOverviewModel.fromJson(response.data);
  }
}
