import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/incomes/data/datasources/incomes_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/incomes_overview_data.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/repositories/incomes_repository.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/services/category_breakdown_service.dart';

class IncomesRepositoryImpl implements IncomesRepository {
  const IncomesRepositoryImpl(
    this._remoteDataSource, {
    CategoryBreakdownService categoryBreakdownService =
        const CategoryBreakdownService(),
  }) : _categoryBreakdownService = categoryBreakdownService;

  final IncomesRemoteDataSource _remoteDataSource;
  final CategoryBreakdownService _categoryBreakdownService;

  @override
  Future<Either<AppFailure, IncomesOverviewData>> getOverview() async {
    try {
      final model = await _remoteDataSource.getOverview();
      final categoryBreakdown = _categoryBreakdownService.build(
        transactions: model.transactions,
        totalAmount: model.totalIncome,
      );

      return Right(
        IncomesOverviewData(
          totalIncome: model.totalIncome,
          monthLabel: model.monthLabel,
          incomeChangePercent: model.incomeChangePercent,
          transactions: model.transactions,
          categoryBreakdown: categoryBreakdown,
        ),
      );
    } on Object catch (e) {
      return Left(_mapFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, void>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  }) async {
    try {
      await _remoteDataSource.addIncome(
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
