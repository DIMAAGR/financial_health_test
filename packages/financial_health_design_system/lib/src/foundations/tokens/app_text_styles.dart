import 'package:flutter/material.dart';

/// Application-wide typography scale.
///
/// All styles are color-agnostic: no [TextStyle.color] is set on any constant.
/// Color is always applied at the call site from the active [ThemeExtension]
/// so that text adapts to light and dark modes without hardcoded values.
///
/// ## Usage
/// ```dart
/// Text(
///   'RENDA',
///   style: AppTextStyles.financialBadge.copyWith(color: theme.label),
/// )
/// ```
///
/// For the [FinancialSummaryCard]-specific typography see [FhTextStyles].
class AppTextStyles {
  AppTextStyles._();

  /// Subtitle shown below the main header title (e.g., the greeting line).
  static const TextStyle headerSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.4,
  );

  /// Primary heading for the dashboard header (e.g., the app name or score label).
  static const TextStyle headerTitle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 40 / 36,
    letterSpacing: -0.9,
  );

  /// Text inside small status badge chips (e.g., "SAUDÁVEL", "ATENÇÃO", "CRÍTICO").
  static const TextStyle financialBadge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 1.2,
  );

  /// Caption label displayed inside compact metric cards (e.g., "Receitas").
  static const TextStyle financialCardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
  );

  /// The large numeric score inside the financial-health summary card.
  static const TextStyle financialScore = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: -3.6,
  );

  /// The suffix appended to the score (e.g., "/100").
  static const TextStyle financialScoreSuffix = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  /// Headline inside score or goal cards (e.g., "Boa saúde financeira").
  static const TextStyle financialHeadline = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.56,
  );

  /// Descriptive body text below headlines inside financial summary cards.
  static const TextStyle financialDescription = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );

  /// Uppercase label with wide tracking used in metric card headers.
  static const TextStyle metricLabelLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.8,
  );

  /// Numeric value inside a compact metric card (e.g., "R$ 12.400").
  static const TextStyle metricValue = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: -0.6,
  );

  /// Section title for the flow-analysis widget (e.g., "Análise de fluxo").
  static const TextStyle flowSectionTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: -0.6,
  );

  /// Card title inside the flow-analysis section.
  static const TextStyle flowCardTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.5,
  );

  /// Contextual description body text inside the flow-analysis card.
  static const TextStyle flowDescription = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.63,
  );

  /// Title inside the monthly-goal progress card.
  static const TextStyle monthlyGoalTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.56,
  );

  /// Description body text inside the monthly-goal card.
  static const TextStyle monthlyGoalDescription = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );

  /// Heading of the add-income / add-expense bottom sheet.
  static const TextStyle sheetTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 1.33,
    letterSpacing: -0.6,
  );

  /// Uppercase label above each input field inside the bottom sheet.
  static const TextStyle sheetFieldLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 1.1,
  );

  /// Large currency amount displayed in the sheet's monetary input field.
  static const TextStyle sheetAmount = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    height: 1.2,
  );

  /// Default text style for text fields inside the bottom sheet.
  static const TextStyle sheetInput = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  /// Label for the currently selected category chip in the bottom sheet.
  static const TextStyle sheetCategorySelected = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  /// Label for unselected category chips in the bottom sheet.
  static const TextStyle sheetCategoryUnselected = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  /// Text on the primary action button at the bottom of the sheet.
  static const TextStyle sheetPrimaryButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.56,
  );
}
