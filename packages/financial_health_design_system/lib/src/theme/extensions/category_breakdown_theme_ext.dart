import 'package:flutter/material.dart';

@immutable
class CategoryBreakdownTheme extends ThemeExtension<CategoryBreakdownTheme> {
  final Color heroCardBackground;
  final Color heroCardBorder;
  final Color heroIconBackground;
  final Color heroPercent;
  final Color heroTitle;
  final Color heroAmount;
  final Color itemCardBackground;
  final Color itemCardBorder;
  final Color itemIconBackgroundAccent;
  final Color itemIconBackgroundNeutral;
  final Color itemLabel;
  final Color itemAmount;

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
      itemIconBackgroundAccent:
          itemIconBackgroundAccent ?? this.itemIconBackgroundAccent,
      itemIconBackgroundNeutral:
          itemIconBackgroundNeutral ?? this.itemIconBackgroundNeutral,
      itemLabel: itemLabel ?? this.itemLabel,
      itemAmount: itemAmount ?? this.itemAmount,
    );
  }

  @override
  CategoryBreakdownTheme lerp(
    ThemeExtension<CategoryBreakdownTheme>? other,
    double t,
  ) {
    if (other is! CategoryBreakdownTheme) return this;

    return CategoryBreakdownTheme(
      heroCardBackground: Color.lerp(
        heroCardBackground,
        other.heroCardBackground,
        t,
      )!,
      heroCardBorder: Color.lerp(heroCardBorder, other.heroCardBorder, t)!,
      heroIconBackground: Color.lerp(
        heroIconBackground,
        other.heroIconBackground,
        t,
      )!,
      heroPercent: Color.lerp(heroPercent, other.heroPercent, t)!,
      heroTitle: Color.lerp(heroTitle, other.heroTitle, t)!,
      heroAmount: Color.lerp(heroAmount, other.heroAmount, t)!,
      itemCardBackground: Color.lerp(
        itemCardBackground,
        other.itemCardBackground,
        t,
      )!,
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
