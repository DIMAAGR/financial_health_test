import 'package:flutter/material.dart';

class TransactionListTheme extends ThemeExtension<TransactionListTheme> {
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

  final Color sectionTitle;
  final Color itemCount;
  final Color dateLabelText;
  final Color dateBorderToday;
  final Color dateBorderOther;
  final Color cardBorder;
  final Color itemBackground;
  final Color iconBackground;
  final Color itemTitle;
  final Color itemSubtitle;
  final Color itemAmount;
  final Color itemAmountExpense;
  final Color itemAmountIncome;
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
  TransactionListTheme lerp(
    covariant ThemeExtension<TransactionListTheme>? other,
    double t,
  ) {
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
      itemAmountExpense: Color.lerp(
        itemAmountExpense,
        other.itemAmountExpense,
        t,
      )!,
      itemAmountIncome: Color.lerp(
        itemAmountIncome,
        other.itemAmountIncome,
        t,
      )!,
      itemPaymentMethod: Color.lerp(
        itemPaymentMethod,
        other.itemPaymentMethod,
        t,
      )!,
    );
  }
}
