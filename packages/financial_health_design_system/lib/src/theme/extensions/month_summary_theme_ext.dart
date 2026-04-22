import 'package:flutter/material.dart';

/// [ThemeExtension] that carries the color scheme for [MonthSummaryCard].
///
/// Registered on [ThemeData] by [FinancialHealthDesignTheme] and accessed
/// in widgets via [AppThemeExtension.monthSummaryTheme]:
///
/// ```dart
/// final theme = context.monthSummaryTheme;
/// Container(
///   decoration: BoxDecoration(
///     color: theme.cardBackground,
///     boxShadow: [BoxShadow(color: theme.glowColor)],
///   ),
/// )
/// ```
@immutable
class MonthSummaryTheme extends ThemeExtension<MonthSummaryTheme> {
  /// Background fill for the summary card container.
  final Color cardBackground;

  /// Border / outline color for the summary card container.
  final Color cardBorder;

  /// Drop-shadow color for the summary card.
  final Color cardShadow;

  /// Ambient glow color rendered behind the card (a soft colored halo).
  final Color glowColor;

  /// Color of the metric label (e.g., "SALDO", "RECEITA", "DESPESA").
  final Color label;

  /// Color of the primary monetary amount displayed on the card.
  final Color amount;

  /// Color of the month-year text (e.g., "ABR 2026").
  final Color monthYear;

  /// Background fill for the trend-percentage badge.
  final Color badgeBackground;

  /// Border color for the trend-percentage badge.
  final Color badgeBorder;

  /// Text color inside the trend-percentage badge.
  final Color badgeLabel;

  /// Icon / text tint for a positive trend arrow (value went up).
  final Color trendPositive;

  /// Icon / text tint for a negative trend arrow (value went down).
  final Color trendNegative;

  /// Creates a [MonthSummaryTheme] with all color roles specified.
  const MonthSummaryTheme({
    required this.cardBackground,
    required this.cardBorder,
    required this.cardShadow,
    required this.glowColor,
    required this.label,
    required this.amount,
    required this.monthYear,
    required this.badgeBackground,
    required this.badgeBorder,
    required this.badgeLabel,
    required this.trendPositive,
    required this.trendNegative,
  });

  @override
  MonthSummaryTheme copyWith({
    Color? cardBackground,
    Color? cardBorder,
    Color? cardShadow,
    Color? glowColor,
    Color? label,
    Color? amount,
    Color? monthYear,
    Color? badgeBackground,
    Color? badgeBorder,
    Color? badgeLabel,
    Color? trendPositive,
    Color? trendNegative,
  }) {
    return MonthSummaryTheme(
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      cardShadow: cardShadow ?? this.cardShadow,
      glowColor: glowColor ?? this.glowColor,
      label: label ?? this.label,
      amount: amount ?? this.amount,
      monthYear: monthYear ?? this.monthYear,
      badgeBackground: badgeBackground ?? this.badgeBackground,
      badgeBorder: badgeBorder ?? this.badgeBorder,
      badgeLabel: badgeLabel ?? this.badgeLabel,
      trendPositive: trendPositive ?? this.trendPositive,
      trendNegative: trendNegative ?? this.trendNegative,
    );
  }

  @override
  MonthSummaryTheme lerp(ThemeExtension<MonthSummaryTheme>? other, double t) {
    if (other is! MonthSummaryTheme) return this;

    return MonthSummaryTheme(
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      glowColor: Color.lerp(glowColor, other.glowColor, t)!,
      label: Color.lerp(label, other.label, t)!,
      amount: Color.lerp(amount, other.amount, t)!,
      monthYear: Color.lerp(monthYear, other.monthYear, t)!,
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t)!,
      badgeBorder: Color.lerp(badgeBorder, other.badgeBorder, t)!,
      badgeLabel: Color.lerp(badgeLabel, other.badgeLabel, t)!,
      trendPositive: Color.lerp(trendPositive, other.trendPositive, t)!,
      trendNegative: Color.lerp(trendNegative, other.trendNegative, t)!,
    );
  }
}
