import 'package:flutter/material.dart';

/// [ThemeExtension] that provides app-wide semantic colors for the dashboard
/// and metric cards.
///
/// Registered on [ThemeData] by [FinancialHealthDesignTheme] and accessed in
/// widgets via [AppThemeExtension.appColors]:
///
/// ```dart
/// final colors = context.appColors;
/// Container(color: colors.backgroundPrimary)
/// ```
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  /// Background fill for the main dashboard screen.
  final Color backgroundPrimary;

  /// Color of the title text inside the dashboard header.
  final Color headerTitle;

  /// Color of the subtitle text inside the dashboard header.
  final Color headerSubtitle;

  /// Background fill for icon-action buttons in the header.
  final Color headerActionBackground;

  /// Tint for icons inside header action buttons.
  final Color headerActionIcon;

  /// Background fill for the popup menu in the header.
  final Color headerMenuBackground;

  /// Border color of the popup menu container.
  final Color headerMenuBorder;

  /// Text color for items inside the popup menu.
  final Color headerMenuText;

  /// Icon tint for items inside the popup menu.
  final Color headerMenuIcon;

  /// Drop-shadow color for the popup menu.
  final Color headerMenuShadow;

  /// Background fill for compact metric cards (income / expense tiles).
  final Color metricCardBackground;

  /// Border color for compact metric cards.
  final Color metricCardBorder;

  /// Drop-shadow color for compact metric cards.
  final Color metricCardShadow;

  /// Default icon tint inside metric cards.
  final Color metricCardIcon;

  /// Icon tint used for the expense (negative) icon inside metric cards.
  final Color metricCardIconRed;

  /// Label / caption text color inside metric cards (e.g., "RECEITAS").
  final Color metricCardLabel;

  /// Numeric value text color inside metric cards.
  final Color metricCardValue;

  /// Creates an [AppSemanticColors] with all semantic color roles specified.
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
      headerActionBackground: headerActionBackground ?? this.headerActionBackground,
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
      backgroundPrimary: Color.lerp(backgroundPrimary, other.backgroundPrimary, t)!,
      headerTitle: Color.lerp(headerTitle, other.headerTitle, t)!,
      headerSubtitle: Color.lerp(headerSubtitle, other.headerSubtitle, t)!,
      headerActionBackground: Color.lerp(headerActionBackground, other.headerActionBackground, t)!,
      headerActionIcon: Color.lerp(headerActionIcon, other.headerActionIcon, t)!,
      headerMenuBackground: Color.lerp(headerMenuBackground, other.headerMenuBackground, t)!,
      headerMenuBorder: Color.lerp(headerMenuBorder, other.headerMenuBorder, t)!,
      headerMenuText: Color.lerp(headerMenuText, other.headerMenuText, t)!,
      headerMenuIcon: Color.lerp(headerMenuIcon, other.headerMenuIcon, t)!,
      headerMenuShadow: Color.lerp(headerMenuShadow, other.headerMenuShadow, t)!,
      metricCardBackground: Color.lerp(metricCardBackground, other.metricCardBackground, t)!,
      metricCardBorder: Color.lerp(metricCardBorder, other.metricCardBorder, t)!,
      metricCardShadow: Color.lerp(metricCardShadow, other.metricCardShadow, t)!,
      metricCardIcon: Color.lerp(metricCardIcon, other.metricCardIcon, t)!,
      metricCardIconRed: Color.lerp(metricCardIconRed, other.metricCardIconRed, t)!,
      metricCardLabel: Color.lerp(metricCardLabel, other.metricCardLabel, t)!,
      metricCardValue: Color.lerp(metricCardValue, other.metricCardValue, t)!,
    );
  }
}
