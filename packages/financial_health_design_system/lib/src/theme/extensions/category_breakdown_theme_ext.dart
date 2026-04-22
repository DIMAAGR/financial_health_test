import 'package:flutter/material.dart';

/// [ThemeExtension] that carries the color scheme for [CategoryBreakdownSection].
///
/// Registered on [ThemeData] by [FinancialHealthDesignTheme] and accessed
/// in widgets via [AppThemeExtension.categoryBreakdownTheme]:
///
/// ```dart
/// final theme = context.categoryBreakdownTheme;
/// Container(color: theme.heroCardBackground)
/// ```
///
/// Colors are grouped into two tiers:
/// - `hero*` — the large featured card for the dominant category.
/// - `item*` — the smaller cards for the remaining categories.
@immutable
class CategoryBreakdownTheme extends ThemeExtension<CategoryBreakdownTheme> {
  /// Background fill for the hero (dominant) category card.
  final Color heroCardBackground;

  /// Border / outline color for the hero card.
  final Color heroCardBorder;

  /// Background fill for the circular icon badge inside the hero card.
  final Color heroIconBackground;

  /// Color of the large percentage text inside the hero card.
  final Color heroPercent;

  /// Color of the category title text inside the hero card.
  final Color heroTitle;

  /// Color of the monetary amount text inside the hero card.
  final Color heroAmount;

  /// Background fill for a regular (non-hero) category item card.
  final Color itemCardBackground;

  /// Border / outline color for item cards.
  final Color itemCardBorder;

  /// Background fill for icon badges in the accent style (top-N categories).
  final Color itemIconBackgroundAccent;

  /// Background fill for icon badges in the neutral style (remaining categories).
  final Color itemIconBackgroundNeutral;

  /// Label / name text color for item cards.
  final Color itemLabel;

  /// Monetary amount text color for item cards.
  final Color itemAmount;

  /// Creates a [CategoryBreakdownTheme] with all color roles specified.
  const CategoryBreakdownTheme({
    required this.heroCardBackground,
    required this.heroCardBorder,
    required this.heroIconBackground,
    required this.heroPercent,
    required this.heroTitle,
    required this.heroAmount,
    required this.itemCardBackground,
    required this.itemCardBorder,
    required this.itemIconBackgroundAccent,
    required this.itemIconBackgroundNeutral,
    required this.itemLabel,
    required this.itemAmount,
  });

  @override
  CategoryBreakdownTheme copyWith({
    Color? heroCardBackground,
    Color? heroCardBorder,
    Color? heroIconBackground,
    Color? heroPercent,
    Color? heroTitle,
    Color? heroAmount,
    Color? itemCardBackground,
    Color? itemCardBorder,
    Color? itemIconBackgroundAccent,
    Color? itemIconBackgroundNeutral,
    Color? itemLabel,
    Color? itemAmount,
  }) {
    return CategoryBreakdownTheme(
      heroCardBackground: heroCardBackground ?? this.heroCardBackground,
      heroCardBorder: heroCardBorder ?? this.heroCardBorder,
      heroIconBackground: heroIconBackground ?? this.heroIconBackground,
      heroPercent: heroPercent ?? this.heroPercent,
      heroTitle: heroTitle ?? this.heroTitle,
      heroAmount: heroAmount ?? this.heroAmount,
      itemCardBackground: itemCardBackground ?? this.itemCardBackground,
      itemCardBorder: itemCardBorder ?? this.itemCardBorder,
      itemIconBackgroundAccent: itemIconBackgroundAccent ?? this.itemIconBackgroundAccent,
      itemIconBackgroundNeutral: itemIconBackgroundNeutral ?? this.itemIconBackgroundNeutral,
      itemLabel: itemLabel ?? this.itemLabel,
      itemAmount: itemAmount ?? this.itemAmount,
    );
  }

  @override
  CategoryBreakdownTheme lerp(ThemeExtension<CategoryBreakdownTheme>? other, double t) {
    if (other is! CategoryBreakdownTheme) return this;

    return CategoryBreakdownTheme(
      heroCardBackground: Color.lerp(heroCardBackground, other.heroCardBackground, t)!,
      heroCardBorder: Color.lerp(heroCardBorder, other.heroCardBorder, t)!,
      heroIconBackground: Color.lerp(heroIconBackground, other.heroIconBackground, t)!,
      heroPercent: Color.lerp(heroPercent, other.heroPercent, t)!,
      heroTitle: Color.lerp(heroTitle, other.heroTitle, t)!,
      heroAmount: Color.lerp(heroAmount, other.heroAmount, t)!,
      itemCardBackground: Color.lerp(itemCardBackground, other.itemCardBackground, t)!,
      itemCardBorder: Color.lerp(itemCardBorder, other.itemCardBorder, t)!,
      itemIconBackgroundAccent: Color.lerp(
        itemIconBackgroundAccent,
        other.itemIconBackgroundAccent,
        t,
      )!,
      itemIconBackgroundNeutral: Color.lerp(
        itemIconBackgroundNeutral,
        other.itemIconBackgroundNeutral,
        t,
      )!,
      itemLabel: Color.lerp(itemLabel, other.itemLabel, t)!,
      itemAmount: Color.lerp(itemAmount, other.itemAmount, t)!,
    );
  }
}
