import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/entities/transactions_overview_data.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/use_cases/get_transactions_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_cubit.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_state.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTransactionsRepository implements TransactionsRepository {
  _FakeTransactionsRepository({required this.overviewResult});

  Either<AppFailure, TransactionsOverviewData> overviewResult;
  int overviewCalls = 0;

  @override
  Future<Either<AppFailure, TransactionsOverviewData>> getOverview() async {
    overviewCalls++;
    return overviewResult;
  }
}

void main() {
  group('TransactionsCubit', () {
    test('loadOverview com sucesso popula state', () async {
      final overview = _overview();
      final repo = _FakeTransactionsRepository(overviewResult: Right(overview));
      final cubit = TransactionsCubit(GetTransactionsOverviewUseCase(repo));

      await cubit.loadOverview();

      expect(repo.overviewCalls, 1);
      expect(cubit.state.status, TransactionsViewStatus.success);
      expect(cubit.state.balance, 10000);
      expect(cubit.state.income, 8000);
      expect(cubit.state.expense, 3000);
      expect(cubit.state.monthLabel, 'Abril');
      expect(cubit.state.transactions, hasLength(3));
      await cubit.close();
    });

    test('loadOverview com falha emite estado de erro', () async {
      final repo = _FakeTransactionsRepository(overviewResult: const Left(NetworkFailure()));
      final cubit = TransactionsCubit(GetTransactionsOverviewUseCase(repo));

      await cubit.loadOverview();

      expect(cubit.state.status, TransactionsViewStatus.error);
      expect(cubit.state.canRetry, isTrue);
      await cubit.close();
    });

    test('loadOverview emite loading antes do resultado', () async {
      final overview = _overview();
      final repo = _FakeTransactionsRepository(overviewResult: Right(overview));
      final cubit = TransactionsCubit(GetTransactionsOverviewUseCase(repo));

      unawaited(
        expectLater(
          cubit.stream.map((s) => s.status),
          emitsInOrder([TransactionsViewStatus.loading, TransactionsViewStatus.success]),
        ),
      );

      await cubit.loadOverview();
      await cubit.close();
    });

    test('server failure não permite retry', () async {
      final repo = _FakeTransactionsRepository(overviewResult: const Left(UnknownFailure('erro')));
      final cubit = TransactionsCubit(GetTransactionsOverviewUseCase(repo));

      await cubit.loadOverview();

      expect(cubit.state.status, TransactionsViewStatus.error);
      expect(cubit.state.canRetry, isFalse);
      await cubit.close();
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
