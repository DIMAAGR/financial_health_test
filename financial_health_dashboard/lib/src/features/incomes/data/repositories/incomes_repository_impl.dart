import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/incomes/data/datasources/incomes_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/incomes/data/models/incomes_overview_model.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/incomes_overview_data.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/repositories/incomes_repository.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';

class IncomesRepositoryImpl implements IncomesRepository {
  const IncomesRepositoryImpl(this._remoteDataSource);

  final IncomesRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppFailure, IncomesOverviewData>> getOverview() async {
    try {
      final model = await _remoteDataSource.getOverview();
      final categoryBreakdown = _buildCategoryBreakdown(model);

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
      await _remoteDataSource.addIncome(amount: amount, title: title, category: category.code);
      return const Right(null);
    } on Object catch (e) {
      return Left(_mapFailure(e));
    }
  }

  List<CategoryBreakdownData> _buildCategoryBreakdown(IncomesOverviewModel model) {
    final grouped = <String, double>{};
    for (final t in model.transactions) {
      grouped[t.category] = (grouped[t.category] ?? 0) + t.value;
    }

    final safeDivisor = model.totalIncome <= 0 ? 1.0 : model.totalIncome;
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
