import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_refactor/core/failures/app_failure.dart';
import 'package:transaction_refactor/features/transactions/domain/entities/transaction_entity.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';
import 'package:transaction_refactor/features/transactions/domain/use_cases/get_transactions_use_case.dart';

import '../../mocks.dart';

void main() {
  late MockTransactionRepository repository;
  late GetTransactionsUseCase sut;

  setUp(() {
    repository = MockTransactionRepository();
    sut = GetTransactionsUseCase(repository);
  });

  // ── Fixtures ────────────────────────────────────────────────────────────────

  TransactionEntity income(int amount) => TransactionEntity(
    id: 'i',
    description: 'Receita',
    amount: amount,
    type: TransactionType.income,
  );

  TransactionEntity expense(int amount) => TransactionEntity(
    id: 'e',
    description: 'Despesa',
    amount: amount,
    type: TransactionType.expense,
  );

  // ── Testes ──────────────────────────────────────────────────────────────────

  group('GetTransactionsUseCase', () {
    test(
      'deve retornar Right com lista e total líquido correto (receitas - despesas)',
      () async {
        // Arrange: 500000 + 80000 - 150000 - 32050 = 397950 centavos
        repository.mockSuccess([
          income(500000),
          expense(150000),
          expense(32050),
          income(80000),
        ]);

        // Act
        final result = await sut();

        // Assert
        result.fold((f) => fail('Esperava Right, obteve Left($f)'), (report) {
          expect(report.transactions.length, 4);
          expect(report.total, 397950); // precisão exata com int
        });
      },
    );

    test(
      'deve retornar total positivo quando todas as transações são receitas',
      () async {
        repository.mockSuccess([income(100000), income(50000)]);

        final result = await sut();

        result.fold(
          (f) => fail('Esperava Right, obteve Left($f)'),
          (report) => expect(report.total, 150000),
        );
      },
    );

    test(
      'deve retornar total negativo quando despesas superam receitas',
      () async {
        repository.mockSuccess([income(10000), expense(60000)]);

        final result = await sut();

        result.fold(
          (f) => fail('Esperava Right, obteve Left($f)'),
          (report) => expect(report.total, -50000),
        );
      },
    );

    test(
      'deve retornar Right com lista vazia e total zero quando repositório retorna vazio',
      () async {
        repository.mockSuccess([]);

        final result = await sut();

        result.fold((f) => fail('Esperava Right, obteve Left($f)'), (report) {
          expect(report.transactions, isEmpty);
          expect(report.total, 0);
        });
      },
    );

    test('deve propagar NetworkFailure quando o repositório falha', () async {
      repository.mockFailure(const NetworkFailure());

      final result = await sut();

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Esperava Left, obteve Right'),
      );
    });

    test(
      'deve propagar ServerFailure quando o repositório falha com erro de servidor',
      () async {
        repository.mockFailure(const ServerFailure());

        final result = await sut();

        result.fold(
          (f) => expect(f, isA<ServerFailure>()),
          (_) => fail('Esperava Left, obteve Right'),
        );
      },
    );

    test(
      'deve chamar o repositório exatamente uma vez por invocação',
      () async {
        repository.mockSuccess([]);

        await sut();

        expect(repository.callCount, 1);
      },
    );
  });
}
