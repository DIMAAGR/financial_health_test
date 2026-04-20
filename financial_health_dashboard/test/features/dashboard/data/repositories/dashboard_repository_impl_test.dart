import 'dart:async';
import 'dart:io';

import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/core/services/clock/clock.dart';
import 'package:financial_health_dashboard/src/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/dashboard/data/models/dashboard_overview_model.dart';
import 'package:financial_health_dashboard/src/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';

import 'package:flutter_test/flutter_test.dart';

class _FixedClock implements Clock {
  const _FixedClock(this.value);

  final DateTime value;

  @override
  DateTime now() => value;
}

class _FakeDashboardRemoteDataSource implements DashboardRemoteDataSource {
  _FakeDashboardRemoteDataSource(this.model);

  final DashboardOverviewModel model;
  String? lastIncomeCategory;
  String? lastExpenseCategory;

  @override
  Future<DashboardOverviewModel> getOverview() async => model;

  @override
  Future<DashboardOverviewModel> addIncome({
    required double amount,
    required String title,
    required String category,
  }) async {
    lastIncomeCategory = category;
    return model;
  }

  @override
  Future<DashboardOverviewModel> addExpense({
    required double amount,
    required String title,
    required String category,
  }) async {
    lastExpenseCategory = category;
    return model;
  }
}

class _ThrowingDataSource implements DashboardRemoteDataSource {
  _ThrowingDataSource(this.error);

  final Object error;

  @override
  Future<DashboardOverviewModel> getOverview() async => throw error;

  @override
  Future<DashboardOverviewModel> addIncome({
    required double amount,
    required String title,
    required String category,
  }) async => throw error;

  @override
  Future<DashboardOverviewModel> addExpense({
    required double amount,
    required String title,
    required String category,
  }) async => throw error;
}

void main() {
  group('DashboardRepositoryImpl', () {
    test('getOverview converte model usando data do Clock', () async {
      final remote = _FakeDashboardRemoteDataSource(_modelWithGoalDay(20));
      final repository = DashboardRepositoryImpl(remote, _FixedClock(DateTime(2026, 4, 1, 23, 59)));

      final result = await repository.getOverview();

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('esperava Right'), (overview) {
        expect(overview.monthlyGoal.expectedPercentByDate, closeTo(66.67, 0.01));
      });
    });

    test('addIncome serializa categoria por code e usa Clock', () async {
      final remote = _FakeDashboardRemoteDataSource(_modelWithGoalDay(20));
      final repository = DashboardRepositoryImpl(remote, _FixedClock(DateTime(2026, 4, 1)));

      final result = await repository.addIncome(
        amount: 100,
        title: 'Freelance',
        category: IncomeCategory.investment,
      );

      expect(remote.lastIncomeCategory, 'investment');
      result.fold((_) => fail('esperava Right'), (overview) {
        expect(overview.monthlyGoal.expectedPercentByDate, closeTo(66.67, 0.01));
      });
    });

    test('addExpense serializa categoria por code e usa Clock', () async {
      final remote = _FakeDashboardRemoteDataSource(_modelWithGoalDay(20));
      final repository = DashboardRepositoryImpl(remote, _FixedClock(DateTime(2026, 4, 1)));

      final result = await repository.addExpense(
        amount: 100,
        title: 'Mercado',
        category: ExpenseCategory.food,
      );

      expect(remote.lastExpenseCategory, 'food');
      result.fold((_) => fail('esperava Right'), (overview) {
        expect(overview.monthlyGoal.expectedPercentByDate, closeTo(66.67, 0.01));
      });
    });
  });

  group('_mapFailure', () {
    final clock = _FixedClock(DateTime(2026, 4, 1));

    DashboardRepositoryImpl repoThrowing(Object error) =>
        DashboardRepositoryImpl(_ThrowingDataSource(error), clock);

    test('ArgumentError → DashboardValidationFailure', () async {
      final result = await repoThrowing(ArgumentError('campo x')).getOverview();

      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('esperava Left'),
      );
    });

    test('TimeoutException → DashboardNetworkFailure', () async {
      final result = await repoThrowing(TimeoutException('timeout')).getOverview();

      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('esperava Left'),
      );
    });

    test('SocketException → DashboardNetworkFailure', () async {
      final result = await repoThrowing(const SocketException('sem rede')).getOverview();

      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('esperava Left'),
      );
    });

    test('FormatException → DashboardParsingFailure', () async {
      final result = await repoThrowing(const FormatException('json')).getOverview();

      result.fold(
        (failure) => expect(failure, isA<ParsingFailure>()),
        (_) => fail('esperava Left'),
      );
    });

    test('TypeError → DashboardParsingFailure', () async {
      final result = await repoThrowing(TypeError()).getOverview();

      result.fold(
        (failure) => expect(failure, isA<ParsingFailure>()),
        (_) => fail('esperava Left'),
      );
    });

    test('FileSystemException → DashboardStorageFailure', () async {
      final result = await repoThrowing(const FileSystemException('disco')).getOverview();

      result.fold(
        (failure) => expect(failure, isA<StorageFailure>()),
        (_) => fail('esperava Left'),
      );
    });

    test('StateError → DashboardStorageFailure', () async {
      final result = await repoThrowing(StateError('bad state')).getOverview();

      result.fold(
        (failure) => expect(failure, isA<StorageFailure>()),
        (_) => fail('esperava Left'),
      );
    });

    test('UnsupportedError → DashboardServerFailure', () async {
      final result = await repoThrowing(UnsupportedError('op')).getOverview();

      result.fold((failure) => expect(failure, isA<ServerFailure>()), (_) => fail('esperava Left'));
    });

    test('Exception genérica → DashboardUnknownFailure', () async {
      final result = await repoThrowing(Exception('qualquer')).getOverview();

      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('esperava Left'),
      );
    });
  });
}

DashboardOverviewModel _modelWithGoalDay(int day) {
  return DashboardOverviewModel(
    userName: 'Júlio',
    balance: 10000,
    income: 8000,
    expense: 3000,
    incomeChangePercent: 12.5,
    expenseChangePercent: -5.0,
    balanceChangePercent: 8.0,
    previousLiquidityIndex: 1.2,
    currentLiquidityIndex: 1.3,
    commitmentPercent: 37.5,
    commitmentBenchmarkPercent: 65,
    monthLabel: 'Abril',
    goalTargetAmount: 15000,
    goalAchievedAmount: 9000,
    goalDay: day,
    goalDaysInMonth: 30,
    flowPoints: const [],
    transactions: const [],
  );
}
