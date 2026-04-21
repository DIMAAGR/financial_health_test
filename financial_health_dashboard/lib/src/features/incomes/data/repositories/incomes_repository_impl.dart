import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/core/failures/failure_handler.dart';
import 'package:financial_health_dashboard/src/features/incomes/data/datasources/incomes_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/incomes_overview_data.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/repositories/incomes_repository.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/services/category_breakdown_service.dart';

class IncomesRepositoryImpl implements IncomesRepository {
  const IncomesRepositoryImpl(
    this._remoteDataSource, {
    CategoryBreakdownService categoryBreakdownService = const CategoryBreakdownService(),
  }) : _categoryBreakdownService = categoryBreakdownService;

  final IncomesRemoteDataSource _remoteDataSource;
  final CategoryBreakdownService _categoryBreakdownService;

  @override
  Future<Either<AppFailure, IncomesOverviewData>> getOverview() => FailureHandler.guard(() async {
    final model = await _remoteDataSource.getOverview();
    final categoryBreakdown = _categoryBreakdownService.build(
      transactions: model.transactions,
      totalAmount: model.totalIncome,
    );
    return IncomesOverviewData(
      totalIncome: model.totalIncome,
      monthLabel: model.monthLabel,
      incomeChangePercent: model.incomeChangePercent,
      transactions: model.transactions,
      categoryBreakdown: categoryBreakdown,
    );
  });

  @override
  Future<Either<AppFailure, void>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  }) => FailureHandler.guard(() async {
    await _remoteDataSource.addIncome(amount: amount, title: title, category: category.code);
  });
}
