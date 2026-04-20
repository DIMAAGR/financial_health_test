import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';

abstract class DashboardRepository {
  Future<Either<AppFailure, DashboardOverviewData>> getOverview();

  Future<Either<AppFailure, DashboardOverviewData>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  });

  Future<Either<AppFailure, DashboardOverviewData>> addExpense({
    required double amount,
    required String title,
    required ExpenseCategory category,
  });
}
