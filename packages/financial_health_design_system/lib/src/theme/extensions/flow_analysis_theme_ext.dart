import 'package:flutter/material.dart';

/// [ThemeExtension] that carries the color scheme for the cash-flow analysis
/// section of the dashboard.
///
/// Registered on [ThemeData] by [FinancialHealthDesignTheme] and accessed
/// in widgets via [AppThemeExtension.flowAnalysisTheme]:
///
/// ```dart
/// final theme = context.flowAnalysisTheme;
/// Text('Análise de fluxo', style: style.copyWith(color: theme.sectionTitle))
/// ```
@immutable
class FlowAnalysisTheme extends ThemeExtension<FlowAnalysisTheme> {
  /// Creates a [FlowAnalysisTheme] with all color roles specified.
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

  /// Color of the section heading (e.g., "Análise de fluxo").
  final Color sectionTitle;

  /// Background fill for each flow card.
  final Color cardBackground;

  /// Border / outline color for each flow card.
  final Color cardBorder;

  /// Drop-shadow color for each flow card.
  final Color cardShadow;

  /// Title text color inside each flow card.
  final Color cardTitle;

  /// Descriptive message text color inside each flow card.
  final Color message;

  /// Base icon / bar color for the income flow indicator (muted state).
  final Color incomeBase;

  /// Highlighted icon / bar color for the income flow indicator (active state).
  final Color incomeHighlight;

  /// Base icon / bar color for the expense flow indicator (muted state).
  final Color expenseBase;

  /// Highlighted icon / bar color for the expense flow indicator (active state).
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
      expenseHighlight: Color.lerp(expenseHighlight, other.expenseHighlight, t)!,
    );
  }
}
