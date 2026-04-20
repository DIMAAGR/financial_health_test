import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/expenses_overview_data.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/use_cases/get_expenses_overview_use_case.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeExpensesRepository implements ExpensesRepository {
  _FakeExpensesRepository(this._result);

  final Either<AppFailure, ExpensesOverviewData> _result;
  int getOverviewCalls = 0;

  @override
  Future<Either<AppFailure, ExpensesOverviewData>> getOverview() async {
    getOverviewCalls++;
    return _result;
  }

  @override
  Future<Either<AppFailure, void>> addExpense({
    required double amount,
    required String title,
    required ExpenseCategory category,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  group('GetExpensesOverviewUseCase', () {
    test('delegates to repository and returns expense data', () async {
      final data = _expensesOverview();
      final repo = _FakeExpensesRepository(Right(data));
      final useCase = GetExpensesOverviewUseCase(repo);

      final result = await useCase();

      expect(repo.getOverviewCalls, 1);
      result.fold((_) => fail('expected Right'), (overview) {
        expect(overview.totalExpense, 3000);
        expect(overview.monthLabel, 'Abril');
        expect(overview.transactions, hasLength(2));
        expect(overview.transactions.every((t) => t.type == TransactionType.expense), isTrue);
      });
    });

    test('returns category breakdown from repository', () async {
      final data = _expensesOverview();
      final repo = _FakeExpensesRepository(Right(data));
      final useCase = GetExpensesOverviewUseCase(repo);

      final result = await useCase();

      result.fold((_) => fail('expected Right'), (overview) {
        expect(overview.categoryBreakdown, hasLength(2));
        expect(overview.categoryBreakdown[0].category, 'food');
        expect(overview.categoryBreakdown[0].amount, 300);
        expect(overview.categoryBreakdown[1].category, 'transport');
        expect(overview.categoryBreakdown[1].amount, 150);
      });
    });

    test('category percentages are relative to total expense', () async {
      final data = _expensesOverview();
      final repo = _FakeExpensesRepository(Right(data));
      final useCase = GetExpensesOverviewUseCase(repo);

      final result = await useCase();

      result.fold((_) => fail('expected Right'), (overview) {
        // food: 300 / 3000 = 10%
        expect(overview.categoryBreakdown[0].percentage, closeTo(10.0, 0.1));
        // transport: 150 / 3000 = 5%
        expect(overview.categoryBreakdown[1].percentage, closeTo(5.0, 0.1));
      });
    });

    test('propagates repository failure', () async {
      final repo = _FakeExpensesRepository(const Left(NetworkFailure()));
      final useCase = GetExpensesOverviewUseCase(repo);

      final result = await useCase();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('handles zero total expense without division error', () async {
      final data = _expensesOverview(totalExpense: 0);
      final repo = _FakeExpensesRepository(Right(data));
      final useCase = GetExpensesOverviewUseCase(repo);

      final result = await useCase();

      result.fold((_) => fail('expected Right'), (overview) {
        expect(overview.totalExpense, 0);
        for (final breakdown in overview.categoryBreakdown) {
          expect(breakdown.percentage.isFinite, isTrue);
        }
      });
    });
  });
}

ExpensesOverviewData _expensesOverview({double totalExpense = 3000}) {
  final safeDivisor = totalExpense <= 0 ? 1.0 : totalExpense;
  return ExpensesOverviewData(
    totalExpense: totalExpense,
    monthLabel: 'Abril',
    expenseChangePercent: -5.0,
    transactions: [
      TransactionData(
        id: '2',
        title: 'Mercado',
        category: 'food',
        value: 300,
        type: TransactionType.expense,
        date: DateTime(2026, 4, 10),
      ),
      TransactionData(
        id: '4',
        title: 'Transporte',
        category: 'transport',
        value: 150,
        type: TransactionType.expense,
        date: DateTime(2026, 4, 9),
      ),
    ],
    categoryBreakdown: [
      CategoryBreakdownData(category: 'food', amount: 300, percentage: (300 / safeDivisor) * 100),
      CategoryBreakdownData(
        category: 'transport',
        amount: 150,
        percentage: (150 / safeDivisor) * 100,
      ),
    ],
  );
}
