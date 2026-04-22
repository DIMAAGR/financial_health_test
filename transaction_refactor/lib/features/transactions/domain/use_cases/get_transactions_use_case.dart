import 'package:dartz/dartz.dart';
import 'package:transaction_refactor/core/failures/app_failure.dart';
import 'package:transaction_refactor/features/transactions/domain/entities/transaction_report.dart';
import 'package:transaction_refactor/features/transactions/domain/repositories/transaction_repository.dart';

/// Caso de uso responsável por buscar as transações e montar o [TransactionReport].
///
/// O cálculo do total saiu daqui e passou para [TransactionReport] (entidade de domínio),
/// tornando a lógica reutilizável em qualquer outro caso de uso ou tela (Dashboard, etc.).
///
class GetTransactionsUseCase {
  const GetTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  Future<Either<AppFailure, TransactionReport>> call() async {
    return (await _repository.getTransactions()).map(
      (transactions) => TransactionReport(transactions: transactions),
    );
  }
}
