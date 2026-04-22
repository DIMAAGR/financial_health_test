import 'package:flutter/material.dart';

/// [ThemeExtension] that carries the color scheme for [ContextualFab].
///
/// Registered on [ThemeData] by [FinancialHealthDesignTheme] and accessed
/// in widgets via [AppThemeExtension.contextualFabTheme]:
///
/// ```dart
/// final theme = context.contextualFabTheme;
/// Container(color: theme.background)
/// ```
class ContextualFabTheme extends ThemeExtension<ContextualFabTheme> {
  /// Creates a [ContextualFabTheme] with all color roles specified.
  const ContextualFabTheme({
    required this.background,
    required this.foreground,
    required this.shadow,
  });

  /// Background fill for the pill-shaped FAB container.
  final Color background;

  /// Foreground color for the icon and label text inside the FAB.
  final Color foreground;

  /// Drop-shadow color for the FAB.
  final Color shadow;

  @override
  ContextualFabTheme copyWith({Color? background, Color? foreground, Color? shadow}) {
    return ContextualFabTheme(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ContextualFabTheme lerp(covariant ThemeExtension<ContextualFabTheme>? other, double t) {
    if (other is! ContextualFabTheme) return this;
    return ContextualFabTheme(
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}
