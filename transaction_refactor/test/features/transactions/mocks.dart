import 'package:dartz/dartz.dart';
import 'package:transaction_refactor/core/failures/app_failure.dart';
import 'package:transaction_refactor/features/transactions/domain/entities/transaction_entity.dart';
import 'package:transaction_refactor/features/transactions/domain/repositories/transaction_repository.dart';

/// Mock manual do repositório — sem dependência de Mockito ou Mocktail.
/// Permite controlar o retorno via [mockSuccess] e [mockFailure].
class MockTransactionRepository implements TransactionRepository {
  Either<AppFailure, List<TransactionEntity>>? _result;
  int callCount = 0;

  void mockSuccess(List<TransactionEntity> entities) {
    _result = Right(entities);
  }

  void mockFailure(AppFailure failure) {
    _result = Left(failure);
  }

  @override
  Future<Either<AppFailure, List<TransactionEntity>>> getTransactions() async {
    callCount++;
    return _result!;
  }
}
