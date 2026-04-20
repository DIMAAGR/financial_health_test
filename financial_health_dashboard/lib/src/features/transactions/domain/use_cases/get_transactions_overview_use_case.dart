import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/entities/transactions_overview_data.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/repositories/transactions_repository.dart';

class GetTransactionsOverviewUseCase {
  const GetTransactionsOverviewUseCase(this._repository);

  final TransactionsRepository _repository;

  Future<Either<AppFailure, TransactionsOverviewData>> call() {
    return _repository.getOverview();
  }
}
