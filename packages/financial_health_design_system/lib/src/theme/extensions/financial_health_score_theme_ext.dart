import 'package:flutter/material.dart';

@immutable
class FinancialHealthCardColors {
  const FinancialHealthCardColors({
    required this.backgroundStart,
    required this.backgroundEnd,
    required this.backgroundSolid,
    required this.badgeBackground,
    required this.badgeText,
    required this.titleText,
    required this.scoreText,
    required this.scoreSuffixText,
    required this.headlineText,
    required this.descriptionText,
    required this.divider,
    required this.iconColor,
    required this.borderColor,
    required this.shadowColor,
    required this.useGradient,
  });

  final Color backgroundStart;
  final Color backgroundEnd;
  final Color backgroundSolid;
  final Color badgeBackground;
  final Color badgeText;
  final Color titleText;
  final Color scoreText;
  final Color scoreSuffixText;
  final Color headlineText;
  final Color descriptionText;
  final Color divider;
  final Color iconColor;
  final Color borderColor;
  final Color shadowColor;
  final bool useGradient;

  FinancialHealthCardColors copyWith({
    Color? backgroundStart,
    Color? backgroundEnd,
    Color? backgroundSolid,
    Color? badgeBackground,
    Color? badgeText,
    Color? titleText,
    Color? scoreText,
    Color? scoreSuffixText,
    Color? headlineText,
    Color? descriptionText,
    Color? divider,
    Color? iconColor,
    Color? borderColor,
    Color? shadowColor,
    bool? useGradient,
  }) {
    return FinancialHealthCardColors(
      backgroundStart: backgroundStart ?? this.backgroundStart,
      backgroundEnd: backgroundEnd ?? this.backgroundEnd,
      backgroundSolid: backgroundSolid ?? this.backgroundSolid,
      badgeBackground: badgeBackground ?? this.badgeBackground,
      badgeText: badgeText ?? this.badgeText,
      titleText: titleText ?? this.titleText,
      scoreText: scoreText ?? this.scoreText,
      scoreSuffixText: scoreSuffixText ?? this.scoreSuffixText,
      headlineText: headlineText ?? this.headlineText,
      descriptionText: descriptionText ?? this.descriptionText,
      divider: divider ?? this.divider,
      iconColor: iconColor ?? this.iconColor,
      borderColor: borderColor ?? this.borderColor,
      shadowColor: shadowColor ?? this.shadowColor,
      useGradient: useGradient ?? this.useGradient,
    );
  }

  static FinancialHealthCardColors lerp(
    FinancialHealthCardColors a,
    FinancialHealthCardColors b,
    double t,
  ) {
    return FinancialHealthCardColors(
      backgroundStart: Color.lerp(a.backgroundStart, b.backgroundStart, t)!,
      backgroundEnd: Color.lerp(a.backgroundEnd, b.backgroundEnd, t)!,
      backgroundSolid: Color.lerp(a.backgroundSolid, b.backgroundSolid, t)!,
      badgeBackground: Color.lerp(a.badgeBackground, b.badgeBackground, t)!,
      badgeText: Color.lerp(a.badgeText, b.badgeText, t)!,
      titleText: Color.lerp(a.titleText, b.titleText, t)!,
      scoreText: Color.lerp(a.scoreText, b.scoreText, t)!,
      scoreSuffixText: Color.lerp(a.scoreSuffixText, b.scoreSuffixText, t)!,
      headlineText: Color.lerp(a.headlineText, b.headlineText, t)!,
      descriptionText: Color.lerp(a.descriptionText, b.descriptionText, t)!,
      divider: Color.lerp(a.divider, b.divider, t)!,
      iconColor: Color.lerp(a.iconColor, b.iconColor, t)!,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t)!,
      shadowColor: Color.lerp(a.shadowColor, b.shadowColor, t)!,
      useGradient: t < 0.5 ? a.useGradient : b.useGradient,
    );
  }
}

@immutable
class FinancialHealthScoreTheme
    extends ThemeExtension<FinancialHealthScoreTheme> {
  const FinancialHealthScoreTheme({
    required this.healthy,
    required this.attention,
    required this.critical,
  });

  final FinancialHealthCardColors healthy;
  final FinancialHealthCardColors attention;
  final FinancialHealthCardColors critical;

  @override
  FinancialHealthScoreTheme copyWith({
    FinancialHealthCardColors? healthy,
    FinancialHealthCardColors? attention,
    FinancialHealthCardColors? critical,
  }) {
    return FinancialHealthScoreTheme(
      healthy: healthy ?? this.healthy,
      attention: attention ?? this.attention,
      critical: critical ?? this.critical,
    );
  }

  @override
  FinancialHealthScoreTheme lerp(
    ThemeExtension<FinancialHealthScoreTheme>? other,
    double t,
  ) {
    if (other is! FinancialHealthScoreTheme) return this;
    return FinancialHealthScoreTheme(
      healthy: FinancialHealthCardColors.lerp(healthy, other.healthy, t),
      attention: FinancialHealthCardColors.lerp(attention, other.attention, t),
      critical: FinancialHealthCardColors.lerp(critical, other.critical, t),
    );
  }
}
