import 'package:financial_health_design_system/src/theme/extensions/financial_summary_card_theme_ext.dart';
import 'package:flutter/material.dart';

abstract final class FinancialHealthDesignTheme {
  static const FinancialSummaryCardTheme financialSummaryLight =
      FinancialSummaryCardTheme(
        positive: FinancialSummaryCardPalette(
          background: Color(0xFFB1EFD8),
          foreground: Color(0xFF1D5C4A),
          accentBackground: Color(0xFF2D6957),
          accentForeground: Color(0xFFE4FFF3),
          border: Color(0x00000000),
          shadow: Color(0x0C000000),
        ),
        negative: FinancialSummaryCardPalette(
          background: Color(0xFFFA746F),
          foreground: Color(0xFF6E0A12),
          accentBackground: Color(0xFFA83836),
          accentForeground: Color(0xFFFFF7F6),
          border: Color(0x00000000),
          shadow: Color(0x0C000000),
        ),
      );

  static const FinancialSummaryCardTheme financialSummaryDark =
      FinancialSummaryCardTheme(
        positive: FinancialSummaryCardPalette(
          background: Color(0xFF1D5C4A),
          foreground: Color(0xFFB1EFD8),
          accentBackground: Color(0xFFB1EFD8),
          accentForeground: Color(0xFF00382B),
          border: Color(0x33B1EFD8),
          shadow: Color(0x00000000),
        ),
        negative: FinancialSummaryCardPalette(
          background: Color(0xFF450A0A),
          foreground: Color(0xFFFFE2E2),
          accentBackground: Color(0xFFFFB4AB),
          accentForeground: Color(0xFF410002),
          border: Color(0x7F7F1D1D),
          shadow: Color(0x00000000),
        ),
      );

  static const List<ThemeExtension<dynamic>> lightExtensions =
      <ThemeExtension<dynamic>>[financialSummaryLight];

  static const List<ThemeExtension<dynamic>> darkExtensions =
      <ThemeExtension<dynamic>>[financialSummaryDark];
}
