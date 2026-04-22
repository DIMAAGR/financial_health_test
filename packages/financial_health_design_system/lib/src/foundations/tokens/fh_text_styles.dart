import 'package:flutter/material.dart';

/// Typography scale for the [FinancialSummaryCard] component.
///
/// All styles are color-agnostic: no [TextStyle.color] is set here. Color is
/// always applied at the call site using the active [FinancialSummaryCardTheme]
/// so the card adapts to light and dark modes without hardcoded values.
///
/// These styles are separate from [AppTextStyles] for the same reason
/// [FhSpacing] is separate from [AppSpacing] — independent evolution.
abstract final class FhTextStyles {
  /// Style for the category label rendered above the monetary value.
  ///
  /// Displayed in uppercase by the caller (e.g., `"INCOME"`, `"EXPENSES"`).
  /// The positive letter-spacing (0.35) aids legibility at the small 14 pt
  /// size typical for labels.
  static const TextStyle financialSummaryTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.35,
  );

  /// Style for the primary monetary value displayed in the card body.
  ///
  /// Extra-heavy weight (w900) at 36 pt makes the value the dominant
  /// typographic element on the card.
  static const TextStyle financialSummaryValue = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    height: 1.11,
  );

  /// Style for the text inside the percentage-variation pill badge.
  static const TextStyle financialSummaryVariation = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.33,
  );
}
