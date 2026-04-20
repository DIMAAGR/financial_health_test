import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_expense_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';

class AddDashboardExpenseUseCase {
  const AddDashboardExpenseUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<AppFailure, DashboardOverviewData>> call(AddDashboardExpenseInput data) async {
    if (data.amount <= 0) {
      return left(const AmountValueFailure());
    }
    if (data.normalizedTitle.isEmpty) {
      return left(const ValidationFailure('Descrição é obrigatória.'));
    }

    return _repository.addExpense(
      amount: data.amount,
      title: data.normalizedTitle,
      category: data.category,
    );
  }
}
