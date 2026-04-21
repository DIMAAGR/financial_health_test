import 'package:flutter/material.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';

/// Extension de apresentação para [TransactionType].
///
/// Mantém a lógica visual (ícone, label) separada do domínio.
/// Cores ficam em [TransactionColors] (ThemeExtension) para
/// respeitar o sistema de temas — não são responsabilidade desta extension.
///
/// Em um app com i18n real, `label` receberia um [BuildContext] e usaria
/// `AppLocalizations.of(context)` em vez de strings hardcoded.
extension TransactionTypePresenter on TransactionType {
  /// Ícone associado ao tipo de transação.
  IconData get icon => switch (this) {
    TransactionType.income => Icons.arrow_upward_rounded,
    TransactionType.expense => Icons.arrow_downward_rounded,
    TransactionType.unknown => Icons.help_outline_rounded,
  };

  /// Label de exibição.
  /// Placeholder de i18n — mover para `AppLocalizations` quando necessário.
  String get label => switch (this) {
    TransactionType.income => 'Receita',
    TransactionType.expense => 'Despesa',
    TransactionType.unknown => 'Desconhecido',
  };
}
