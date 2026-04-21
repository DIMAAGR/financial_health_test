import 'package:flutter/material.dart';

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color backgroundPrimary;

  final Color headerTitle;
  final Color headerSubtitle;
  final Color headerActionBackground;
  final Color headerActionIcon;
  final Color headerMenuBackground;
  final Color headerMenuBorder;
  final Color headerMenuText;
  final Color headerMenuIcon;
  final Color headerMenuShadow;
  final Color metricCardBackground;
  final Color metricCardBorder;
  final Color metricCardShadow;
  final Color metricCardIcon;
  final Color metricCardIconRed;
  final Color metricCardLabel;
  final Color metricCardValue;

  const AppSemanticColors({
    required this.backgroundPrimary,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.headerActionBackground,
    required this.headerActionIcon,
    required this.headerMenuBackground,
    required this.headerMenuBorder,
    required this.headerMenuText,
    required this.headerMenuIcon,
    required this.headerMenuShadow,
    required this.metricCardBackground,
    required this.metricCardBorder,
    required this.metricCardShadow,
    required this.metricCardIcon,
    required this.metricCardLabel,
    required this.metricCardValue,
    required this.metricCardIconRed,
  });

  @override
  AppSemanticColors copyWith({
    Color? backgroundPrimary,
    Color? headerTitle,
    Color? headerSubtitle,
    Color? headerActionBackground,
    Color? headerActionIcon,
    Color? headerMenuBackground,
    Color? headerMenuBorder,
    Color? headerMenuText,
    Color? headerMenuIcon,
    Color? headerMenuShadow,
    Color? metricCardBackground,
    Color? metricCardBorder,
    Color? metricCardShadow,
    Color? metricCardIcon,
    Color? metricCardIconRed,

    Color? metricCardLabel,
    Color? metricCardValue,
  }) {
    return AppSemanticColors(
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      headerTitle: headerTitle ?? this.headerTitle,
      headerSubtitle: headerSubtitle ?? this.headerSubtitle,
      headerActionBackground:
          headerActionBackground ?? this.headerActionBackground,
      headerActionIcon: headerActionIcon ?? this.headerActionIcon,
      headerMenuBackground: headerMenuBackground ?? this.headerMenuBackground,
      headerMenuBorder: headerMenuBorder ?? this.headerMenuBorder,
      headerMenuText: headerMenuText ?? this.headerMenuText,
      headerMenuIcon: headerMenuIcon ?? this.headerMenuIcon,
      headerMenuShadow: headerMenuShadow ?? this.headerMenuShadow,
      metricCardBackground: metricCardBackground ?? this.metricCardBackground,
      metricCardBorder: metricCardBorder ?? this.metricCardBorder,
      metricCardShadow: metricCardShadow ?? this.metricCardShadow,
      metricCardIcon: metricCardIcon ?? this.metricCardIcon,
      metricCardLabel: metricCardLabel ?? this.metricCardLabel,
      metricCardValue: metricCardValue ?? this.metricCardValue,
      metricCardIconRed: metricCardIconRed ?? this.metricCardIconRed,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;

    return AppSemanticColors(
      backgroundPrimary: Color.lerp(
        backgroundPrimary,
        other.backgroundPrimary,
        t,
      )!,
      headerTitle: Color.lerp(headerTitle, other.headerTitle, t)!,
      headerSubtitle: Color.lerp(headerSubtitle, other.headerSubtitle, t)!,
      headerActionBackground: Color.lerp(
        headerActionBackground,
        other.headerActionBackground,
        t,
      )!,
      headerActionIcon: Color.lerp(
        headerActionIcon,
        other.headerActionIcon,
        t,
      )!,
      headerMenuBackground: Color.lerp(
        headerMenuBackground,
        other.headerMenuBackground,
        t,
      )!,
      headerMenuBorder: Color.lerp(
        headerMenuBorder,
        other.headerMenuBorder,
        t,
      )!,
      headerMenuText: Color.lerp(headerMenuText, other.headerMenuText, t)!,
      headerMenuIcon: Color.lerp(headerMenuIcon, other.headerMenuIcon, t)!,
      headerMenuShadow: Color.lerp(
        headerMenuShadow,
        other.headerMenuShadow,
        t,
      )!,
      metricCardBackground: Color.lerp(
        metricCardBackground,
        other.metricCardBackground,
        t,
      )!,
      metricCardBorder: Color.lerp(
        metricCardBorder,
        other.metricCardBorder,
        t,
      )!,
      metricCardShadow: Color.lerp(
        metricCardShadow,
        other.metricCardShadow,
        t,
      )!,
      metricCardIcon: Color.lerp(metricCardIcon, other.metricCardIcon, t)!,
      metricCardIconRed: Color.lerp(
        metricCardIconRed,
        other.metricCardIconRed,
        t,
      )!,
      metricCardLabel: Color.lerp(metricCardLabel, other.metricCardLabel, t)!,
      metricCardValue: Color.lerp(metricCardValue, other.metricCardValue, t)!,
    );
  }
}
