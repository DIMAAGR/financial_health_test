import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_refactor/core/failures/app_failure.dart';
import 'package:transaction_refactor/core/use_cases/no_params.dart';
import 'package:transaction_refactor/features/transactions/domain/entities/transaction_entity.dart';
import 'package:transaction_refactor/features/transactions/domain/entities/transaction_report.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';
import 'package:transaction_refactor/features/transactions/domain/use_cases/get_transactions_use_case.dart';
import 'package:transaction_refactor/features/transactions/presentation/view_model/transaction_state.dart';
import 'package:transaction_refactor/features/transactions/presentation/view_model/transaction_view_model.dart';

// ── Mock manual do UseCase ─────────────────────────────────────────────────

class _MockGetTransactionsUseCase implements GetTransactionsUseCase {
  Either<AppFailure, TransactionReport>? _result;

  void mockSuccess(List<TransactionEntity> entities) {
    _result = Right(TransactionReport(transactions: entities));
  }

  void mockFailure(AppFailure failure) {
    _result = Left(failure);
  }

  @override
  Future<Either<AppFailure, TransactionReport>> call(NoParams params) async => _result!;
}

// ── Fixture ────────────────────────────────────────────────────────────────

final _tEntities = [
  TransactionEntity(id: '1', description: 'Salário', amount: 500000, type: TransactionType.income),
];

void main() {
  late _MockGetTransactionsUseCase useCase;
  late TransactionViewModel sut;

  setUp(() {
    useCase = _MockGetTransactionsUseCase();
    sut = TransactionViewModel(useCase);
  });

  tearDown(() => sut.dispose());

  group('TransactionViewModel', () {
    test('estado inicial deve ser TransactionLoadingState', () {
      expect(sut.state.value, isA<TransactionLoadingState>());
    });

    test('deve emitir TransactionSuccessState após loadTransactions com sucesso', () async {
      useCase.mockSuccess(_tEntities);

      await sut.loadTransactions();

      expect(sut.state.value, isA<TransactionSuccessState>());
      final success = sut.state.value as TransactionSuccessState;
      expect(success.items.length, 1);
      expect(success.total, 500000);
    });

    test('deve emitir TransactionEmptyState quando use case retorna lista vazia', () async {
      useCase.mockSuccess([]);

      await sut.loadTransactions();

      expect(sut.state.value, isA<TransactionEmptyState>());
    });

    test('deve emitir TransactionErrorState com canRetry=true para NetworkFailure', () async {
      useCase.mockFailure(const NetworkFailure());

      await sut.loadTransactions();

      expect(sut.state.value, isA<TransactionErrorState>());
      final error = sut.state.value as TransactionErrorState;
      expect(error.canRetry, isTrue);
      expect(error.message, isNotEmpty);
    });

    test('deve emitir TransactionErrorState com canRetry=true para ServerFailure', () async {
      useCase.mockFailure(const ServerFailure());

      await sut.loadTransactions();

      final error = sut.state.value as TransactionErrorState;
      expect(error.canRetry, isTrue);
    });

    test('deve emitir TransactionErrorState com canRetry=false para ParseFailure', () async {
      useCase.mockFailure(const ParseFailure());

      await sut.loadTransactions();

      final error = sut.state.value as TransactionErrorState;
      expect(error.canRetry, isFalse);
    });

    test(
      'deve emitir TransactionLoadingState no início de cada nova chamada a loadTransactions',
      () async {
        // Primeira chamada: leva ao estado de sucesso
        useCase.mockSuccess(_tEntities);
        await sut.loadTransactions();
        expect(sut.state.value, isA<TransactionSuccessState>());

        // Registra listener a partir do estado de sucesso
        final states = <TransactionState>[];
        sut.state.addListener(() => states.add(sut.state.value));

        useCase.mockSuccess(_tEntities);
        await sut.loadTransactions();

        expect(states.first, isA<TransactionLoadingState>());
        expect(states.last, isA<TransactionSuccessState>());
      },
    );
  });
}
