import 'package:dartz/dartz.dart';
import 'package:transaction_refactor/core/failures/app_failure.dart';
import 'package:transaction_refactor/features/transactions/domain/entities/transaction_entity.dart';

/// Contrato do repositório de transações.
///
/// A camada de apresentação depende apenas desta abstração,
/// nunca da implementação concreta (DIP — problema #16).
abstract class TransactionRepository {
  /// Retorna a lista de transações do usuário autenticado.
  /// Falhas são encapsuladas em [AppFailure] — nenhuma exceção atravessa
  /// para a camada de apresentação.
  Future<Either<AppFailure, List<TransactionEntity>>> getTransactions();
}
