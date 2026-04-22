import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/core/failures/failure_handler.dart';
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
  Future<Either<AppFailure, DashboardOverviewData>> getOverview() => FailureHandler.guard(() async {
    final model = await _remoteDataSource.getOverview();
    return model.toEntity(referenceDate: _referenceDate());
  });

  @override
  Future<Either<AppFailure, DashboardOverviewData>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  }) => FailureHandler.guard(() async {
    final model = await _remoteDataSource.addIncome(
      amount: amount,
      title: title,
      category: category.code,
    );
    return model.toEntity(referenceDate: _referenceDate());
  });

  @override
  Future<Either<AppFailure, DashboardOverviewData>> addExpense({
    required double amount,
    required String title,
    required ExpenseCategory category,
  }) => FailureHandler.guard(() async {
    final model = await _remoteDataSource.addExpense(
      amount: amount,
      title: title,
      category: category.code,
    );
    return model.toEntity(referenceDate: _referenceDate());
  });

  DateTime _referenceDate() {
    final now = _clock.now();
    return DateTime(now.year, now.month, now.day);
  }
}
