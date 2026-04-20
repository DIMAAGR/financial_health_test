import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/expenses_overview_data.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/repositories/expenses_repository.dart';

class GetExpensesOverviewUseCase {
  const GetExpensesOverviewUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<AppFailure, ExpensesOverviewData>> call() {
    return _repository.getOverview();
  }
}
