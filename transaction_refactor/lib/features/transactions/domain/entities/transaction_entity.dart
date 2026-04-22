import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';

/// Entidade de domínio que representa uma transação financeira.
///
/// Todos os campos são fortemente tipados — sem `Map<String, dynamic>`,
/// sem strings mágicas, sem casting em runtime (problema #4 do desafio).
class TransactionEntity {
  const TransactionEntity({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
  });

  final String id;
  final String description;

  /// Valor em centavos (int) para evitar imprecisão de ponto flutuante.
  /// Ex: R$15,99 → 1599, R$1.500,00 → 150000.
  final int amount;

  final TransactionType type;
}
