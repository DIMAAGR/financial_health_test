import 'package:flutter/material.dart';

/// [ThemeExtension] that carries the color scheme for [TransactionListSection].
///
/// Registered on [ThemeData] by [FinancialHealthDesignTheme] and accessed
/// in widgets via [AppThemeExtension.transactionListTheme]:
///
/// ```dart
/// final theme = context.transactionListTheme;
/// Text('Transações', style: style.copyWith(color: theme.sectionTitle))
/// ```
class TransactionListTheme extends ThemeExtension<TransactionListTheme> {
  /// Creates a [TransactionListTheme] with all color roles specified.
  const TransactionListTheme({
    required this.sectionTitle,
    required this.itemCount,
    required this.dateLabelText,
    required this.dateBorderToday,
    required this.dateBorderOther,
    required this.cardBorder,
    required this.itemBackground,
    required this.iconBackground,
    required this.itemTitle,
    required this.itemSubtitle,
    required this.itemAmount,
    required this.itemAmountExpense,
    required this.itemAmountIncome,
    required this.itemPaymentMethod,
  });

  /// Color of the section heading (e.g., "Transações").
  final Color sectionTitle;

  /// Color of the item-count badge text (e.g., "12 itens").
  final Color itemCount;

  /// Color of the date-group label text (e.g., "HOJE, 22 ABR").
  final Color dateLabelText;

  /// Border color on the date-group pill for today's transactions.
  final Color dateBorderToday;

  /// Border color on the date-group pill for past-day transactions.
  final Color dateBorderOther;

  /// Border / outline color for individual transaction item cards.
  final Color cardBorder;

  /// Background fill for individual transaction item cards.
  final Color itemBackground;

  /// Background fill for the circular icon badge on each transaction.
  final Color iconBackground;

  /// Primary text color for the transaction name / description.
  final Color itemTitle;

  /// Secondary text color for the transaction subtitle (e.g., category name).
  final Color itemSubtitle;

  /// Default amount text color (used when [isExpense] is unset or null).
  final Color itemAmount;

  /// Amount text color when the transaction is an expense (debit).
  final Color itemAmountExpense;

  /// Amount text color when the transaction is income (credit).
  final Color itemAmountIncome;

  /// Color of the payment method label (e.g., "Crédito", "Débito").
  final Color itemPaymentMethod;

  @override
  TransactionListTheme copyWith({
    Color? sectionTitle,
    Color? itemCount,
    Color? dateLabelText,
    Color? dateBorderToday,
    Color? dateBorderOther,
    Color? cardBorder,
    Color? itemBackground,
    Color? iconBackground,
    Color? itemTitle,
    Color? itemSubtitle,
    Color? itemAmount,
    Color? itemAmountExpense,
    Color? itemAmountIncome,
    Color? itemPaymentMethod,
  }) {
    return TransactionListTheme(
      sectionTitle: sectionTitle ?? this.sectionTitle,
      itemCount: itemCount ?? this.itemCount,
      dateLabelText: dateLabelText ?? this.dateLabelText,
      dateBorderToday: dateBorderToday ?? this.dateBorderToday,
      dateBorderOther: dateBorderOther ?? this.dateBorderOther,
      cardBorder: cardBorder ?? this.cardBorder,
      itemBackground: itemBackground ?? this.itemBackground,
      iconBackground: iconBackground ?? this.iconBackground,
      itemTitle: itemTitle ?? this.itemTitle,
      itemSubtitle: itemSubtitle ?? this.itemSubtitle,
      itemAmount: itemAmount ?? this.itemAmount,
      itemAmountExpense: itemAmountExpense ?? this.itemAmountExpense,
      itemAmountIncome: itemAmountIncome ?? this.itemAmountIncome,
      itemPaymentMethod: itemPaymentMethod ?? this.itemPaymentMethod,
    );
  }

  @override
  TransactionListTheme lerp(covariant ThemeExtension<TransactionListTheme>? other, double t) {
    if (other is! TransactionListTheme) return this;
    return TransactionListTheme(
      sectionTitle: Color.lerp(sectionTitle, other.sectionTitle, t)!,
      itemCount: Color.lerp(itemCount, other.itemCount, t)!,
      dateLabelText: Color.lerp(dateLabelText, other.dateLabelText, t)!,
      dateBorderToday: Color.lerp(dateBorderToday, other.dateBorderToday, t)!,
      dateBorderOther: Color.lerp(dateBorderOther, other.dateBorderOther, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      itemBackground: Color.lerp(itemBackground, other.itemBackground, t)!,
      iconBackground: Color.lerp(iconBackground, other.iconBackground, t)!,
      itemTitle: Color.lerp(itemTitle, other.itemTitle, t)!,
      itemSubtitle: Color.lerp(itemSubtitle, other.itemSubtitle, t)!,
      itemAmount: Color.lerp(itemAmount, other.itemAmount, t)!,
      itemAmountExpense: Color.lerp(itemAmountExpense, other.itemAmountExpense, t)!,
      itemAmountIncome: Color.lerp(itemAmountIncome, other.itemAmountIncome, t)!,
      itemPaymentMethod: Color.lerp(itemPaymentMethod, other.itemPaymentMethod, t)!,
    );
  }
}
