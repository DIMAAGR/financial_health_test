import 'package:flutter/material.dart';

@immutable
class MonthlyGoalCardColors {
  const MonthlyGoalCardColors({
    required this.background,
    required this.border,
    required this.shadow,
    required this.title,
    required this.description,
    required this.iconColor,
  });

  final Color background;
  final Color border;
  final Color shadow;
  final Color title;
  final Color description;
  final Color iconColor;

  static MonthlyGoalCardColors lerp(
    MonthlyGoalCardColors a,
    MonthlyGoalCardColors b,
    double t,
  ) {
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

@immutable
class MonthlyGoalTheme extends ThemeExtension<MonthlyGoalTheme> {
  const MonthlyGoalTheme({required this.positive, required this.negative});

  final MonthlyGoalCardColors positive;
  final MonthlyGoalCardColors negative;

  @override
  MonthlyGoalTheme copyWith({
    MonthlyGoalCardColors? positive,
    MonthlyGoalCardColors? negative,
  }) {
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
