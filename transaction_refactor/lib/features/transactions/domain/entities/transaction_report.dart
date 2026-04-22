import 'package:transaction_refactor/features/transactions/domain/entities/transaction_entity.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';

/// Agregado de domínio que representa o extrato de transações de um usuário.
///
/// Centraliza o cálculo do total líquido, evitando que a lógica seja duplicada
/// em múltiplos casos de uso ou telas (ex: Dashboard, Relatório).
///
/// Todos os valores são em **centavos** (int) para eliminar imprecisão de
/// ponto flutuante em operações monetárias (ex: 0.1 + 0.2 ≠ 0.3 em double).
class TransactionReport {
  const TransactionReport({required this.transactions});

  final List<TransactionEntity> transactions;

  /// Saldo líquido em centavos (receitas − despesas).
  ///
  /// Switch exaustivo: o compilador emite erro se um novo [TransactionType]
  /// for adicionado sem tratamento aqui.
  int get total => transactions.fold(0, (sum, t) {
    return switch (t.type) {
      TransactionType.income => sum + t.amount,
      TransactionType.expense => sum - t.amount,
      TransactionType.unknown => sum,
    };
  });

  bool get isEmpty => transactions.isEmpty;
}
