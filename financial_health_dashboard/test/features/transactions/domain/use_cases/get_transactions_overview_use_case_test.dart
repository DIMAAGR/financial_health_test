import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/entities/transactions_overview_data.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/use_cases/get_transactions_overview_use_case.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTransactionsRepository implements TransactionsRepository {
  _FakeTransactionsRepository(this._result);

  final Either<AppFailure, TransactionsOverviewData> _result;
  int getOverviewCalls = 0;

  @override
  Future<Either<AppFailure, TransactionsOverviewData>> getOverview() async {
    getOverviewCalls++;
    return _result;
  }
}

void main() {
  group('GetTransactionsOverviewUseCase', () {
    test('delegates to repository and maps overview to TransactionsOverviewData', () async {
      final overview = _overview();
      final repo = _FakeTransactionsRepository(Right(overview));
      final useCase = GetTransactionsOverviewUseCase(repo);

      final result = await useCase();

      expect(repo.getOverviewCalls, 1);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (data) {
        expect(data.balance, 10000);
        expect(data.income, 8000);
        expect(data.expense, 3000);
        expect(data.monthLabel, 'Abril');
        expect(data.transactions, hasLength(3));
      });
    });

    test('returns all transactions (income + expense) without filtering', () async {
      final overview = _overview();
      final repo = _FakeTransactionsRepository(Right(overview));
      final useCase = GetTransactionsOverviewUseCase(repo);

      final result = await useCase();

      result.fold((_) => fail('expected Right'), (data) {
        final types = data.transactions.map((t) => t.type).toSet();
        expect(types, contains(TransactionType.income));
        expect(types, contains(TransactionType.expense));
      });
    });

    test('propagates repository failure', () async {
      final repo = _FakeTransactionsRepository(const Left(NetworkFailure()));
      final useCase = GetTransactionsOverviewUseCase(repo);

      final result = await useCase();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });
  });
}

TransactionsOverviewData _overview() {
  return TransactionsOverviewData(
    balance: 10000,
    income: 8000,
    expense: 3000,
    monthLabel: 'Abril',
    balanceChangePercent: 8.0,
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
        id: '2',
        title: 'Mercado',
        category: 'food',
        value: 300,
        type: TransactionType.expense,
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
  );
}
