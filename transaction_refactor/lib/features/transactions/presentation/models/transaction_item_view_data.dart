import 'package:flutter/material.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';

/// Modelo de apresentação de uma transação individual.
///
/// Resolve #5 e #13: a UI nunca toca em `TransactionEntity` nem em
/// chaves brutas da API. Todos os dados já chegam pré-transformados
/// (formatação monetária, ícone, label) para exibição direta.
///
/// Cor não é pré-computada aqui porque depende de [ThemeExtension]
/// (context-sensitive). O campo [type] é mantido somente para que
/// o widget consulte `context.transactionColors.colorFor(type)`.
@immutable
class TransactionItemViewData {
  const TransactionItemViewData({
    required this.id,
    required this.description,
    required this.formattedAmount,
    required this.icon,
    required this.typeLabel,
    required this.type,
  });

  /// Identificador da transação — usado como key em listas.
  final String id;

  /// Descrição legível da transação.
  final String description;

  /// Valor já formatado como moeda BRL (ex: "R$ 1.500,00").
  final String formattedAmount;

  /// Ícone associado ao tipo — pré-computado via [TransactionTypePresenter].
  final IconData icon;

  /// Label de exibição do tipo (ex: "Receita", "Despesa").
  final String typeLabel;

  /// Mantido exclusivamente para lookup de cor via [TransactionColors].
  final TransactionType type;
}
