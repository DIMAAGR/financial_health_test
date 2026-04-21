import 'package:flutter/material.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';

/// ThemeExtension que centraliza as cores semânticas de transações.
///
/// Registrado no [ThemeData.extensions] do app, acessível em qualquer
/// widget via [BuildContext.transactionColors] sem hardcoded `Colors.green`.
/// Suporta temas claro e escuro independentemente.
@immutable
class TransactionColors extends ThemeExtension<TransactionColors> {
  const TransactionColors({
    required this.incomeColor,
    required this.expenseColor,
    required this.unknownColor,
  });

  /// Paleta padrão para tema claro.
  static const light = TransactionColors(
    incomeColor: Color(0xFF2E7D32), // green[800]
    expenseColor: Color(0xFFC62828), // red[800]
    unknownColor: Color(0xFF757575), // grey[600]
  );

  /// Paleta para tema escuro.
  static const dark = TransactionColors(
    incomeColor: Color(0xFF66BB6A), // green[400]
    expenseColor: Color(0xFFEF5350), // red[400]
    unknownColor: Color(0xFFBDBDBD), // grey[400]
  );

  final Color incomeColor;
  final Color expenseColor;
  final Color unknownColor;

  /// Retorna a cor correspondente ao [TransactionType].
  /// Exaustivo: o compilador avisa se um novo caso for adicionado ao enum.
  Color colorFor(TransactionType type) => switch (type) {
    TransactionType.income => incomeColor,
    TransactionType.expense => expenseColor,
    TransactionType.unknown => unknownColor,
  };

  @override
  TransactionColors copyWith({Color? incomeColor, Color? expenseColor, Color? unknownColor}) {
    return TransactionColors(
      incomeColor: incomeColor ?? this.incomeColor,
      expenseColor: expenseColor ?? this.expenseColor,
      unknownColor: unknownColor ?? this.unknownColor,
    );
  }

  @override
  TransactionColors lerp(TransactionColors? other, double t) {
    if (other == null) return this;
    return TransactionColors(
      incomeColor: Color.lerp(incomeColor, other.incomeColor, t)!,
      expenseColor: Color.lerp(expenseColor, other.expenseColor, t)!,
      unknownColor: Color.lerp(unknownColor, other.unknownColor, t)!,
    );
  }
}

/// Atalho para acessar [TransactionColors] a partir de qualquer [BuildContext].
extension TransactionColorsX on BuildContext {
  TransactionColors get transactionColors => Theme.of(this).extension<TransactionColors>()!;
}
