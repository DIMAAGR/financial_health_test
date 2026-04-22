import 'package:flutter/material.dart';

@immutable
class FinancialSummaryCardPalette {
  const FinancialSummaryCardPalette({
    required this.background,
    required this.foreground,
    required this.accentBackground,
    required this.accentForeground,
    required this.border,
    required this.shadow,
  });

  final Color background;
  final Color foreground;
  final Color accentBackground;
  final Color accentForeground;
  final Color border;
  final Color shadow;

  static FinancialSummaryCardPalette lerp(
    FinancialSummaryCardPalette a,
    FinancialSummaryCardPalette b,
    double t,
  ) {
    return FinancialSummaryCardPalette(
      background: Color.lerp(a.background, b.background, t)!,
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      accentBackground: Color.lerp(a.accentBackground, b.accentBackground, t)!,
      accentForeground: Color.lerp(a.accentForeground, b.accentForeground, t)!,
      border: Color.lerp(a.border, b.border, t)!,
      shadow: Color.lerp(a.shadow, b.shadow, t)!,
    );
  }
}

@immutable
class FinancialSummaryCardTheme
    extends ThemeExtension<FinancialSummaryCardTheme> {
  const FinancialSummaryCardTheme({
    required this.positive,
    required this.negative,
  });

  final FinancialSummaryCardPalette positive;
  final FinancialSummaryCardPalette negative;

  @override
  FinancialSummaryCardTheme copyWith({
    FinancialSummaryCardPalette? positive,
    FinancialSummaryCardPalette? negative,
  }) {
    return FinancialSummaryCardTheme(
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
    );
  }

  @override
  FinancialSummaryCardTheme lerp(
    ThemeExtension<FinancialSummaryCardTheme>? other,
    double t,
  ) {
    if (other is! FinancialSummaryCardTheme) return this;
    return FinancialSummaryCardTheme(
      positive: FinancialSummaryCardPalette.lerp(positive, other.positive, t),
      negative: FinancialSummaryCardPalette.lerp(negative, other.negative, t),
    );
  }
}
