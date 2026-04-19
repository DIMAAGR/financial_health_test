import 'package:flutter/material.dart';

class ContextualFabTheme extends ThemeExtension<ContextualFabTheme> {
  const ContextualFabTheme({
    required this.background,
    required this.foreground,
    required this.shadow,
  });

  final Color background;
  final Color foreground;
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
