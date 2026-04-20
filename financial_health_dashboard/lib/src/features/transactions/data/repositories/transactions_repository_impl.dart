import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/entities/transactions_overview_data.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/repositories/transactions_repository.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  const TransactionsRepositoryImpl(this._remoteDataSource);

  final TransactionsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppFailure, TransactionsOverviewData>> getOverview() async {
    try {
      final model = await _remoteDataSource.getOverview();
      return Right(
        TransactionsOverviewData(
          balance: model.balance,
          income: model.income,
          expense: model.expense,
          monthLabel: model.monthLabel,
          balanceChangePercent: model.balanceChangePercent,
          transactions: List.unmodifiable(model.transactions),
        ),
      );
    } on Object catch (e) {
      return Left(_mapFailure(e));
    }
  }

  AppFailure _mapFailure(Object error) {
    if (error is TimeoutException || error is SocketException) {
      return const NetworkFailure();
    }
    if (error is FormatException || error is TypeError) {
      return const ParsingFailure();
    }
    return UnknownFailure(error.toString());
  }
}
