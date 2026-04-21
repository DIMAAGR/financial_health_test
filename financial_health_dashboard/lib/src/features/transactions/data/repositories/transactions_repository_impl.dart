import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/core/failures/failure_handler.dart';
import 'package:financial_health_dashboard/src/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/entities/transactions_overview_data.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/repositories/transactions_repository.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  const TransactionsRepositoryImpl(this._remoteDataSource);

  final TransactionsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppFailure, TransactionsOverviewData>> getOverview() =>
      FailureHandler.guard(() async {
        final model = await _remoteDataSource.getOverview();
        return TransactionsOverviewData(
          balance: model.balance,
          income: model.income,
          expense: model.expense,
          monthLabel: model.monthLabel,
          balanceChangePercent: model.balanceChangePercent,
          transactions: List.unmodifiable(model.transactions),
        );
      });
}
