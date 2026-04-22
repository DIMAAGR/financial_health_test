import 'package:flutter/material.dart';

/// Immutable color set for a single health-status variant of the financial
/// health score card.
///
/// A [FinancialHealthScoreTheme] holds three instances of this class —
/// [healthy], [attention], and [critical] — one per status level.
@immutable
class FinancialHealthCardColors {
  /// Creates an immutable color set for one health-status variant.
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

  /// Start color of the card background gradient (top / left).
  final Color backgroundStart;

  /// End color of the card background gradient (bottom / right).
  final Color backgroundEnd;

  /// Solid fallback background color used when [useGradient] is `false`.
  final Color backgroundSolid;

  /// Background fill of the status badge (e.g., the "SAUDÁVEL" chip).
  final Color badgeBackground;

  /// Text color inside the status badge.
  final Color badgeText;

  /// Color of the card's title text (e.g., "Saúde Financeira").
  final Color titleText;

  /// Color of the large numeric score.
  final Color scoreText;

  /// Color of the score suffix text (e.g., "/100").
  final Color scoreSuffixText;

  /// Color of the headline text below the score (e.g., "Boa saúde financeira").
  final Color headlineText;

  /// Color of the description body text.
  final Color descriptionText;

  /// Color of the horizontal divider between the score and description.
  final Color divider;

  /// Tint for the decorative icon in the card.
  final Color iconColor;

  /// Border / outline color of the card container.
  final Color borderColor;

  /// Drop-shadow color of the card.
  final Color shadowColor;

  /// When `true`, the card renders [backgroundStart] → [backgroundEnd] as a
  /// gradient fill. When `false`, [backgroundSolid] is used instead.
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

/// [ThemeExtension] that carries the color schemes for the financial health
/// score card across all three health-status levels.
///
/// Registered on [ThemeData] by [FinancialHealthDesignTheme] and accessed in
/// widgets via [AppThemeExtension.financialHealthScoreTheme]:
///
/// ```dart
/// final theme = context.financialHealthScoreTheme;
/// // Select the correct palette based on the user's score:
/// final colors = score >= 75 ? theme.healthy
///              : score >= 40 ? theme.attention
///              : theme.critical;
/// ```
@immutable
class FinancialHealthScoreTheme
    extends ThemeExtension<FinancialHealthScoreTheme> {
  /// Creates a [FinancialHealthScoreTheme] with color sets for each status.
  const FinancialHealthScoreTheme({
    required this.healthy,
    required this.attention,
    required this.critical,
  });

  /// Colors applied when the user's financial health score is healthy (high).
  final FinancialHealthCardColors healthy;

  /// Colors applied when the score is in the attention / warning range.
  final FinancialHealthCardColors attention;

  /// Colors applied when the score is critical (low).
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
