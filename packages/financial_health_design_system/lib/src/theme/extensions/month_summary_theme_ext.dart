import 'package:flutter/material.dart';

@immutable
class MonthSummaryTheme extends ThemeExtension<MonthSummaryTheme> {
  final Color cardBackground;
  final Color cardBorder;
  final Color cardShadow;
  final Color glowColor;
  final Color label;
  final Color amount;
  final Color monthYear;
  final Color badgeBackground;
  final Color badgeBorder;
  final Color badgeLabel;
  final Color trendPositive;
  final Color trendNegative;

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
