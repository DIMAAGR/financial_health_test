import 'package:flutter/material.dart';

/// Color palette for a single variant of the monthly-goal progress card.
///
/// A [MonthlyGoalTheme] holds two instances — [MonthlyGoalTheme.positive] and
/// [MonthlyGoalTheme.negative] — one for an on-track goal and one for an
/// at-risk or exceeded goal.
@immutable
class MonthlyGoalCardColors {
  /// Creates an immutable color palette for a [MonthlyGoalTheme] variant.
  const MonthlyGoalCardColors({
    required this.background,
    required this.border,
    required this.shadow,
    required this.title,
    required this.description,
    required this.iconColor,
  });

  /// Background fill for the goal card container.
  final Color background;

  /// Border / outline color for the goal card container.
  final Color border;

  /// Drop-shadow color for the goal card.
  final Color shadow;

  /// Color of the goal card title text.
  final Color title;

  /// Color of the goal card description body text.
  final Color description;

  /// Tint for the decorative icon inside the goal card.
  final Color iconColor;

  /// Linearly interpolates between two [MonthlyGoalCardColors].
  static MonthlyGoalCardColors lerp(MonthlyGoalCardColors a, MonthlyGoalCardColors b, double t) {
    return MonthlyGoalCardColors(
      background: Color.lerp(a.background, b.background, t)!,
      border: Color.lerp(a.border, b.border, t)!,
      shadow: Color.lerp(a.shadow, b.shadow, t)!,
      title: Color.lerp(a.title, b.title, t)!,
      description: Color.lerp(a.description, b.description, t)!,
      iconColor: Color.lerp(a.iconColor, b.iconColor, t)!,
    );
  }
}

/// [ThemeExtension] that carries the color schemes for the monthly-goal card
/// across its two state variants (positive / negative).
///
/// Registered on [ThemeData] by [FinancialHealthDesignTheme] and accessed
/// in widgets via [AppThemeExtension.monthlyGoalTheme]:
///
/// ```dart
/// final theme = context.monthlyGoalTheme;
/// final colors = isOnTrack ? theme.positive : theme.negative;
/// ```
@immutable
class MonthlyGoalTheme extends ThemeExtension<MonthlyGoalTheme> {
  /// Creates a [MonthlyGoalTheme] with palettes for on-track and at-risk states.
  const MonthlyGoalTheme({required this.positive, required this.negative});

  /// Colors applied when the user is on track to meet their monthly goal.
  final MonthlyGoalCardColors positive;

  /// Colors applied when the user has exceeded or is at risk of missing their
  /// monthly goal.
  final MonthlyGoalCardColors negative;

  @override
  MonthlyGoalTheme copyWith({MonthlyGoalCardColors? positive, MonthlyGoalCardColors? negative}) {
    return MonthlyGoalTheme(
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
    );
  }

  @override
  MonthlyGoalTheme lerp(ThemeExtension<MonthlyGoalTheme>? other, double t) {
    if (other is! MonthlyGoalTheme) return this;
    return MonthlyGoalTheme(
      positive: MonthlyGoalCardColors.lerp(positive, other.positive, t),
      negative: MonthlyGoalCardColors.lerp(negative, other.negative, t),
    );
  }
}
