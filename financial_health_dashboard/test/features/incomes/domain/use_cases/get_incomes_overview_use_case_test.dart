import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/incomes_overview_data.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/repositories/incomes_repository.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/use_cases/get_incomes_overview_use_case.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeIncomesRepository implements IncomesRepository {
  _FakeIncomesRepository(this._result);

  final Either<AppFailure, IncomesOverviewData> _result;
  int getOverviewCalls = 0;

  @override
  Future<Either<AppFailure, IncomesOverviewData>> getOverview() async {
    getOverviewCalls++;
    return _result;
  }

  @override
  Future<Either<AppFailure, void>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  group('GetIncomesOverviewUseCase', () {
    test('delegates to repository and returns income data', () async {
      final data = _incomesOverview();
      final repo = _FakeIncomesRepository(Right(data));
      final useCase = GetIncomesOverviewUseCase(repo);

      final result = await useCase();

      expect(repo.getOverviewCalls, 1);
      result.fold((_) => fail('expected Right'), (overview) {
        expect(overview.totalIncome, 8000);
        expect(overview.monthLabel, 'Abril');
        expect(overview.transactions, hasLength(2));
        expect(overview.transactions.every((t) => t.type == TransactionType.income), isTrue);
      });
    });

    test('returns category breakdown from repository', () async {
      final data = _incomesOverview();
      final repo = _FakeIncomesRepository(Right(data));
      final useCase = GetIncomesOverviewUseCase(repo);

      final result = await useCase();

      result.fold((_) => fail('expected Right'), (overview) {
        expect(overview.categoryBreakdown, hasLength(2));
        // salary: 5000, services: 2000
        expect(overview.categoryBreakdown[0].category, 'salary');
        expect(overview.categoryBreakdown[0].amount, 5000);
        expect(overview.categoryBreakdown[1].category, 'services');
        expect(overview.categoryBreakdown[1].amount, 2000);
      });
    });

    test('category percentages are relative to total income', () async {
      final data = _incomesOverview();
      final repo = _FakeIncomesRepository(Right(data));
      final useCase = GetIncomesOverviewUseCase(repo);

      final result = await useCase();

      result.fold((_) => fail('expected Right'), (overview) {
        // Salário: 5000 / 8000 = 62.5%
        expect(overview.categoryBreakdown[0].percentage, closeTo(62.5, 0.1));
        // Serviços: 2000 / 8000 = 25%
        expect(overview.categoryBreakdown[1].percentage, closeTo(25.0, 0.1));
      });
    });

    test('propagates repository failure', () async {
      final repo = _FakeIncomesRepository(const Left(NetworkFailure()));
      final useCase = GetIncomesOverviewUseCase(repo);

      final result = await useCase();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('handles zero total income without division error', () async {
      final data = _incomesOverview(totalIncome: 0);
      final repo = _FakeIncomesRepository(Right(data));
      final useCase = GetIncomesOverviewUseCase(repo);

      final result = await useCase();

      result.fold((_) => fail('expected Right'), (overview) {
        expect(overview.totalIncome, 0);
        for (final breakdown in overview.categoryBreakdown) {
          expect(breakdown.percentage.isFinite, isTrue);
        }
      });
    });
  });
}

IncomesOverviewData _incomesOverview({double totalIncome = 8000}) {
  final safeDivisor = totalIncome <= 0 ? 1.0 : totalIncome;
  return IncomesOverviewData(
    totalIncome: totalIncome,
    monthLabel: 'Abril',
    incomeChangePercent: 12.5,
    transactions: [
      TransactionData(
        id: '1',
        title: 'Salário',
        category: 'salary',
        value: 5000,
        type: TransactionType.income,
        date: DateTime(2026, 4, 10),
      ),
      TransactionData(
        id: '3',
        title: 'Freelance',
        category: 'services',
        value: 2000,
        type: TransactionType.income,
        date: DateTime(2026, 4, 9),
      ),
    ],
    categoryBreakdown: [
      CategoryBreakdownData(
        category: 'salary',
        amount: 5000,
        percentage: (5000 / safeDivisor) * 100,
      ),
      CategoryBreakdownData(
        category: 'services',
        amount: 2000,
        percentage: (2000 / safeDivisor) * 100,
      ),
    ],
  );
}
