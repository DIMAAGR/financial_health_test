import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/expenses_overview_data.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/services/category_breakdown_service.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  const ExpensesRepositoryImpl(
    this._remoteDataSource, {
    CategoryBreakdownService categoryBreakdownService =
        const CategoryBreakdownService(),
  }) : _categoryBreakdownService = categoryBreakdownService;

  final ExpensesRemoteDataSource _remoteDataSource;
  final CategoryBreakdownService _categoryBreakdownService;

  @override
  Future<Either<AppFailure, ExpensesOverviewData>> getOverview() async {
    try {
      final model = await _remoteDataSource.getOverview();
      final categoryBreakdown = _categoryBreakdownService.build(
        transactions: model.transactions,
        totalAmount: model.totalExpense,
      );

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
      await _remoteDataSource.addExpense(
        amount: amount,
        title: title,
        category: category.code,
      );
      return const Right(null);
    } on Object catch (e) {
      return Left(_mapFailure(e));
    }
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
