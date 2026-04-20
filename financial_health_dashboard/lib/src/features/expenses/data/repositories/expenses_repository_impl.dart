import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/expenses/data/models/expenses_overview_model.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/expenses_overview_data.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  const ExpensesRepositoryImpl(this._remoteDataSource);

  final ExpensesRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppFailure, ExpensesOverviewData>> getOverview() async {
    try {
      final model = await _remoteDataSource.getOverview();
      final categoryBreakdown = _buildCategoryBreakdown(model);

      return Right(
        ExpensesOverviewData(
          totalExpense: model.totalExpense,
          monthLabel: model.monthLabel,
          expenseChangePercent: model.expenseChangePercent,
          transactions: model.transactions,
          categoryBreakdown: categoryBreakdown,
        ),
      );
    } on Object catch (e) {
      return Left(_mapFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, void>> addExpense({
    required double amount,
    required String title,
    required ExpenseCategory category,
  }) async {
    try {
      await _remoteDataSource.addExpense(amount: amount, title: title, category: category.code);
      return const Right(null);
    } on Object catch (e) {
      return Left(_mapFailure(e));
    }
  }

  List<CategoryBreakdownData> _buildCategoryBreakdown(ExpensesOverviewModel model) {
    final grouped = <String, double>{};
    for (final t in model.transactions) {
      grouped[t.category] = (grouped[t.category] ?? 0) + t.value;
    }

    final safeDivisor = model.totalExpense <= 0 ? 1.0 : model.totalExpense;
    final entries = grouped.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return entries
        .map(
          (e) => CategoryBreakdownData(
            category: e.key,
            amount: e.value,
            percentage: (e.value / safeDivisor) * 100,
          ),
        )
        .toList(growable: false);
  }

  AppFailure _mapFailure(Object error) {
    if (error is ArgumentError) {
      return ValidationFailure(error.message?.toString() ?? 'Dados inválidos.');
    }
    if (error is TimeoutException || error is SocketException) {
      return const NetworkFailure();
    }
    if (error is FormatException || error is TypeError) {
      return const ParsingFailure();
    }
    return UnknownFailure(error.toString());
  }
}
