import 'package:flutter/material.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';

/// ThemeExtension que centraliza as cores semânticas de transações.
///
/// Registrado no [ThemeData.extensions] do app, acessível em qualquer
/// widget via [BuildContext.transactionColors] sem hardcoded `Colors.*`.
/// Suporta temas claro e escuro independentemente.
@immutable
class TransactionColors extends ThemeExtension<TransactionColors> {
  const TransactionColors({
    required this.incomeColor,
    required this.expenseColor,
    required this.unknownColor,
    required this.incomeBackground,
    required this.expenseBackground,
    required this.incomeBorder,
    required this.expenseBorder,
    required this.mutedTextColor,
    required this.emptyIconColor,
    required this.errorColor,
  });

  /// Paleta padrão para tema claro.
  static const light = TransactionColors(
    incomeColor: Color(0xFF2E7D32), // green[800]
    expenseColor: Color(0xFFC62828), // red[800]
    unknownColor: Color(0xFF757575), // grey[600]
    incomeBackground: Color(0xFFE8F5E9),
    expenseBackground: Color(0xFFFFEBEE),
    incomeBorder: Color(0xFFA5D6A7),
    expenseBorder: Color(0xFFEF9A9A),
    mutedTextColor: Color(0xFF616161),
    emptyIconColor: Color(0xFFBDBDBD),
    errorColor: Color(0xFFEF5350),
  );

  /// Paleta para tema escuro.
  static const dark = TransactionColors(
    incomeColor: Color(0xFF66BB6A), // green[400]
    expenseColor: Color(0xFFEF5350), // red[400]
    unknownColor: Color(0xFFBDBDBD), // grey[400]
    incomeBackground: Color(0xFF12351F),
    expenseBackground: Color(0xFF3B1719),
    incomeBorder: Color(0xFF2E7D32),
    expenseBorder: Color(0xFFC62828),
    mutedTextColor: Color(0xFFBDBDBD),
    emptyIconColor: Color(0xFF757575),
    errorColor: Color(0xFFFF8A80),
  );

  final Color incomeColor;
  final Color expenseColor;
  final Color unknownColor;
  final Color incomeBackground;
  final Color expenseBackground;
  final Color incomeBorder;
  final Color expenseBorder;
  final Color mutedTextColor;
  final Color emptyIconColor;
  final Color errorColor;

  /// Retorna a cor correspondente ao [TransactionType].
  /// Exaustivo: o compilador avisa se um novo caso for adicionado ao enum.
  Color colorFor(TransactionType type) => switch (type) {
    TransactionType.income => incomeColor,
    TransactionType.expense => expenseColor,
    TransactionType.unknown => unknownColor,
  };

  Color backgroundForTotal(int total) {
    return total >= 0 ? incomeBackground : expenseBackground;
  }

  Color borderForTotal(int total) {
    return total >= 0 ? incomeBorder : expenseBorder;
  }

  Color amountColorForTotal(int total) {
    return total >= 0 ? incomeColor : expenseColor;
  }

  @override
  TransactionColors copyWith({
    Color? incomeColor,
    Color? expenseColor,
    Color? unknownColor,
    Color? incomeBackground,
    Color? expenseBackground,
    Color? incomeBorder,
    Color? expenseBorder,
    Color? mutedTextColor,
    Color? emptyIconColor,
    Color? errorColor,
  }) {
    return TransactionColors(
      incomeColor: incomeColor ?? this.incomeColor,
      expenseColor: expenseColor ?? this.expenseColor,
      unknownColor: unknownColor ?? this.unknownColor,
      incomeBackground: incomeBackground ?? this.incomeBackground,
      expenseBackground: expenseBackground ?? this.expenseBackground,
      incomeBorder: incomeBorder ?? this.incomeBorder,
      expenseBorder: expenseBorder ?? this.expenseBorder,
      mutedTextColor: mutedTextColor ?? this.mutedTextColor,
      emptyIconColor: emptyIconColor ?? this.emptyIconColor,
      errorColor: errorColor ?? this.errorColor,
    );
  }

  @override
  TransactionColors lerp(TransactionColors? other, double t) {
    if (other == null) return this;
    return TransactionColors(
      incomeColor: Color.lerp(incomeColor, other.incomeColor, t)!,
      expenseColor: Color.lerp(expenseColor, other.expenseColor, t)!,
      unknownColor: Color.lerp(unknownColor, other.unknownColor, t)!,
      incomeBackground: Color.lerp(
        incomeBackground,
        other.incomeBackground,
        t,
      )!,
      expenseBackground: Color.lerp(
        expenseBackground,
        other.expenseBackground,
        t,
      )!,
      incomeBorder: Color.lerp(incomeBorder, other.incomeBorder, t)!,
      expenseBorder: Color.lerp(expenseBorder, other.expenseBorder, t)!,
      mutedTextColor: Color.lerp(mutedTextColor, other.mutedTextColor, t)!,
      emptyIconColor: Color.lerp(emptyIconColor, other.emptyIconColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
    );
  }
}

/// Atalho para acessar [TransactionColors] a partir de qualquer [BuildContext].
extension TransactionColorsX on BuildContext {
  TransactionColors get transactionColors =>
      Theme.of(this).extension<TransactionColors>()!;
}
