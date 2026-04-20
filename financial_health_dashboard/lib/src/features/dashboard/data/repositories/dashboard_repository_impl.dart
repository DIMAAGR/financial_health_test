import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/core/services/clock/clock.dart';
import 'package:financial_health_dashboard/src/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._remoteDataSource, this._clock);

  final DashboardRemoteDataSource _remoteDataSource;
  final Clock _clock;

  @override
  Future<Either<AppFailure, DashboardOverviewData>> getOverview() async {
    try {
      final model = await _remoteDataSource.getOverview();
      return Right(model.toEntity(referenceDate: _referenceDate()));
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
    if (error is FileSystemException || error is StateError) {
      return const StorageFailure();
    }
    if (error is UnsupportedError) {
      return const ServerFailure();
    }
    return UnknownFailure(error.toString());
  }

  @override
  Future<Either<AppFailure, DashboardOverviewData>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  }) async {
    try {
      final model = await _remoteDataSource.addIncome(
        amount: amount,
        title: title,
        category: category.code,
      );
      return Right(model.toEntity(referenceDate: _referenceDate()));
    } on Object catch (e) {
      return Left(_mapFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, DashboardOverviewData>> addExpense({
    required double amount,
    required String title,
    required ExpenseCategory category,
  }) async {
    try {
      final model = await _remoteDataSource.addExpense(
        amount: amount,
        title: title,
        category: category.code,
      );
      return Right(model.toEntity(referenceDate: _referenceDate()));
    } on Object catch (e) {
      return Left(_mapFailure(e));
    }
  }

  DateTime _referenceDate() {
    final now = _clock.now();
    return DateTime(now.year, now.month, now.day);
  }
}
