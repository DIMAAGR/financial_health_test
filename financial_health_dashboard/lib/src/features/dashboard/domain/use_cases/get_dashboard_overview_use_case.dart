import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/failures/dashboard_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardOverviewUseCase {
  const GetDashboardOverviewUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<DashboardFailure, DashboardOverviewData>> call() {
    return _repository.getOverview();
  }
}
