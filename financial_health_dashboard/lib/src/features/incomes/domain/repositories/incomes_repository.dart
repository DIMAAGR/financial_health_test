import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/incomes_overview_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';

abstract class IncomesRepository {
  Future<Either<AppFailure, IncomesOverviewData>> getOverview();

  Future<Either<AppFailure, void>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  });
}
