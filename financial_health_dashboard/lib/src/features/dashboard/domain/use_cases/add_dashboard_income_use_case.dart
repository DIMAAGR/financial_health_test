import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_income_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/failures/dashboard_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';

class AddDashboardIncomeUseCase {
  const AddDashboardIncomeUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<DashboardFailure, DashboardOverviewData>> call(
    AddDashboardIncomeInput data,
  ) async {
    if (data.amount <= 0) {
      return left(DashboardAmountValueFailure());
    }
    if (data.normalizedTitle.isEmpty) {
      return left(const DashboardValidationFailure('Descrição é obrigatória.'));
    }

    return _repository.addIncome(
      amount: data.amount,
      title: data.normalizedTitle,
      category: data.category,
    );
  }
}
