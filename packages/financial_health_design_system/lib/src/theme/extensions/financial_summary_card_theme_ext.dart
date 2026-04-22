import 'package:flutter/material.dart';

/// Color palette for a single state variant of [FinancialSummaryCard].
///
/// A [FinancialSummaryCardTheme] holds two instances of this class —
/// [FinancialSummaryCardTheme.positive] and [FinancialSummaryCardTheme.negative] —
/// one for income / positive metrics and one for expense / negative metrics.
///
/// All fields are required; there is no optional fallback. All instances are
/// provided by [FinancialHealthDesignTheme] so consumers never create them
/// directly.
@immutable
class FinancialSummaryCardPalette {
  /// Creates an immutable color palette for a [FinancialSummaryCard] variant.
  const FinancialSummaryCardPalette({
    required this.background,
    required this.foreground,
    required this.accentBackground,
    required this.accentForeground,
    required this.border,
    required this.shadow,
  });

  /// Fill color for the card container.
  final Color background;

  /// Primary foreground color for the label and value text.
  final Color foreground;

  /// Fill color of the circular icon badge in the card header.
  final Color accentBackground;

  /// Icon tint inside the circular icon badge.
  final Color accentForeground;

  /// Border / outline color for the card container.
  final Color border;

  /// Drop-shadow color for the card.
  final Color shadow;

  /// Linearly interpolates between two [FinancialSummaryCardPalette]s.
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

/// [ThemeExtension] that carries the color scheme for [FinancialSummaryCard].
///
/// Registered on [ThemeData] by [FinancialHealthDesignTheme] and accessed in
/// widgets via the [AppThemeExtension] helper:
///
/// ```dart
/// final theme = context.financialSummaryCardTheme;
/// final palette = isPositive ? theme.positive : theme.negative;
/// ```
@immutable
class FinancialSummaryCardTheme extends ThemeExtension<FinancialSummaryCardTheme> {
  /// Creates a [FinancialSummaryCardTheme] with separate palettes for positive
  /// and negative card variants.
  const FinancialSummaryCardTheme({required this.positive, required this.negative});

  /// Palette applied when the card represents a positive metric (e.g., income).
  final FinancialSummaryCardPalette positive;

  /// Palette applied when the card represents a negative metric (e.g., expense).
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
  FinancialSummaryCardTheme lerp(ThemeExtension<FinancialSummaryCardTheme>? other, double t) {
    if (other is! FinancialSummaryCardTheme) return this;
    return FinancialSummaryCardTheme(
      positive: FinancialSummaryCardPalette.lerp(positive, other.positive, t),
      negative: FinancialSummaryCardPalette.lerp(negative, other.negative, t),
    );
  }
}
