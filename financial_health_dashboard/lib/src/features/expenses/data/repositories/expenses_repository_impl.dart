import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/core/failures/failure_handler.dart';
import 'package:financial_health_dashboard/src/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/expenses_overview_data.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/services/category_breakdown_service.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  const ExpensesRepositoryImpl(
    this._remoteDataSource, {
    CategoryBreakdownService categoryBreakdownService = const CategoryBreakdownService(),
  }) : _categoryBreakdownService = categoryBreakdownService;

  final ExpensesRemoteDataSource _remoteDataSource;
  final CategoryBreakdownService _categoryBreakdownService;

  @override
  Future<Either<AppFailure, ExpensesOverviewData>> getOverview() => FailureHandler.guard(() async {
    final model = await _remoteDataSource.getOverview();
    final categoryBreakdown = _categoryBreakdownService.build(
      transactions: model.transactions,
      totalAmount: model.totalExpense,
    );
    return ExpensesOverviewData(
      totalExpense: model.totalExpense,
      monthLabel: model.monthLabel,
      expenseChangePercent: model.expenseChangePercent,
      transactions: model.transactions,
      categoryBreakdown: categoryBreakdown,
    );
  });

  @override
  Future<Either<AppFailure, void>> addExpense({
    required double amount,
    required String title,
    required ExpenseCategory category,
  }) => FailureHandler.guard(() async {
    await _remoteDataSource.addExpense(amount: amount, title: title, category: category.code);
  });
}
