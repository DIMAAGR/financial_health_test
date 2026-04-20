import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/expenses_overview_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';

abstract class ExpensesRepository {
  Future<Either<AppFailure, ExpensesOverviewData>> getOverview();

  Future<Either<AppFailure, void>> addExpense({
    required double amount,
    required String title,
    required ExpenseCategory category,
  });
}
