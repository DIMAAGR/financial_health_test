import 'package:dartz/dartz.dart';
import 'package:transaction_refactor/core/failures/app_failure.dart';
import 'package:transaction_refactor/core/failures/failure_handler.dart';
import 'package:transaction_refactor/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:transaction_refactor/features/transactions/domain/entities/transaction_entity.dart';
import 'package:transaction_refactor/features/transactions/domain/repositories/transaction_repository.dart';

/// Implementação concreta do repositório.
///
/// Converte exceções do datasource em [AppFailure] via [FailureHandler.guard],
/// garantindo que a camada de domínio nunca receba exceções não tratadas.
class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl(this._dataSource);

  final TransactionRemoteDataSource _dataSource;

  @override
  Future<Either<AppFailure, List<TransactionEntity>>> getTransactions() {
    return FailureHandler.guard(_dataSource.getTransactions);
  }
}
