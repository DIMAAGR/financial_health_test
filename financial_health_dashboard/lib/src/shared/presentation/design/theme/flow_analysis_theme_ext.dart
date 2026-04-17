import 'package:flutter/material.dart';

@immutable
class FlowAnalysisTheme extends ThemeExtension<FlowAnalysisTheme> {
  const FlowAnalysisTheme({
    required this.sectionTitle,
    required this.cardBackground,
    required this.cardBorder,
    required this.cardShadow,
    required this.cardTitle,
    required this.message,
    required this.incomeBase,
    required this.incomeHighlight,
    required this.expenseBase,
    required this.expenseHighlight,
  });

  final Color sectionTitle;
  final Color cardBackground;
  final Color cardBorder;
  final Color cardShadow;
  final Color cardTitle;
  final Color message;
  final Color incomeBase;
  final Color incomeHighlight;
  final Color expenseBase;
  final Color expenseHighlight;

  @override
  FlowAnalysisTheme copyWith({
    Color? sectionTitle,
    Color? cardBackground,
    Color? cardBorder,
    Color? cardShadow,
    Color? cardTitle,
    Color? message,
    Color? incomeBase,
    Color? incomeHighlight,
    Color? expenseBase,
    Color? expenseHighlight,
  }) {
    return FlowAnalysisTheme(
      sectionTitle: sectionTitle ?? this.sectionTitle,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      cardShadow: cardShadow ?? this.cardShadow,
      cardTitle: cardTitle ?? this.cardTitle,
      message: message ?? this.message,
      incomeBase: incomeBase ?? this.incomeBase,
      incomeHighlight: incomeHighlight ?? this.incomeHighlight,
      expenseBase: expenseBase ?? this.expenseBase,
      expenseHighlight: expenseHighlight ?? this.expenseHighlight,
    );
  }

  @override
  FlowAnalysisTheme lerp(ThemeExtension<FlowAnalysisTheme>? other, double t) {
    if (other is! FlowAnalysisTheme) return this;

    return FlowAnalysisTheme(
      sectionTitle: Color.lerp(sectionTitle, other.sectionTitle, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      cardTitle: Color.lerp(cardTitle, other.cardTitle, t)!,
      message: Color.lerp(message, other.message, t)!,
      incomeBase: Color.lerp(incomeBase, other.incomeBase, t)!,
      incomeHighlight: Color.lerp(incomeHighlight, other.incomeHighlight, t)!,
      expenseBase: Color.lerp(expenseBase, other.expenseBase, t)!,
      expenseHighlight: Color.lerp(
        expenseHighlight,
        other.expenseHighlight,
        t,
      )!,
    );
  }
}
