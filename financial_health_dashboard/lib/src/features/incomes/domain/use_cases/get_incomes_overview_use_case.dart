import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/incomes_overview_data.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/repositories/incomes_repository.dart';

class GetIncomesOverviewUseCase {
  const GetIncomesOverviewUseCase(this._repository);

  final IncomesRepository _repository;

  Future<Either<AppFailure, IncomesOverviewData>> call() {
    return _repository.getOverview();
  }
}
