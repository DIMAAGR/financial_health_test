import 'package:financial_health_design_system/src/theme/extensions/add_income_sheet_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/app_semantic_colors.dart';
import 'package:financial_health_design_system/src/theme/extensions/category_breakdown_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/contextual_fab_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/financial_health_score_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/financial_summary_card_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/flow_analysis_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/month_summary_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/monthly_goal_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/transaction_list_theme_ext.dart';
import 'package:flutter/material.dart';

/// Typed [ThemeExtension] accessors for the design system.
///
/// Add this extension to [BuildContext] to access every registered
/// [ThemeExtension] without casting. All getters throw if the corresponding
/// extension is not registered on the nearest [Theme] \u2014 ensure
/// [FinancialHealthDesignTheme] is applied at the root of the widget tree.
///
/// ## Usage
/// ```dart
/// // In any widget's build method:
/// final colors = context.appColors;
/// final fab    = context.contextualFabTheme;
/// ```
extension AppThemeExtension on BuildContext {
  /// App-wide semantic colors for the dashboard and metric cards.
  ///
  /// See [AppSemanticColors] for the full list of roles.
  AppSemanticColors get appColors => Theme.of(this).extension<AppSemanticColors>()!;

  /// Colors for the financial health score card.
  ///
  /// Use [FinancialHealthScoreTheme.healthy], [.attention], or [.critical]
  /// based on the user's computed score.
  FinancialHealthScoreTheme get financialHealthScoreTheme =>
      Theme.of(this).extension<FinancialHealthScoreTheme>()!;

  /// Colors for the [FinancialSummaryCard] widget.
  ///
  /// Use [FinancialSummaryCardTheme.positive] for income cards and
  /// [FinancialSummaryCardTheme.negative] for expense cards.
  FinancialSummaryCardTheme get financialSummaryCardTheme =>
      Theme.of(this).extension<FinancialSummaryCardTheme>()!;

  /// Colors for the cash-flow analysis section.
  FlowAnalysisTheme get flowAnalysisTheme => Theme.of(this).extension<FlowAnalysisTheme>()!;

  /// Colors for the monthly-goal progress card.
  ///
  /// Use [MonthlyGoalTheme.positive] when on track and [.negative] when at risk.
  MonthlyGoalTheme get monthlyGoalTheme => Theme.of(this).extension<MonthlyGoalTheme>()!;

  /// Colors for the add-income / add-expense bottom sheet.
  AddIncomeSheetTheme get addIncomeSheetTheme => Theme.of(this).extension<AddIncomeSheetTheme>()!;

  /// Colors for [MonthSummaryCard].
  MonthSummaryTheme get monthSummaryTheme => Theme.of(this).extension<MonthSummaryTheme>()!;

  /// Colors for [CategoryBreakdownSection].
  CategoryBreakdownTheme get categoryBreakdownTheme =>
      Theme.of(this).extension<CategoryBreakdownTheme>()!;

  /// Colors for [ContextualFab].
  ContextualFabTheme get contextualFabTheme => Theme.of(this).extension<ContextualFabTheme>()!;

  /// Colors for [TransactionListSection].
  TransactionListTheme get transactionListTheme =>
      Theme.of(this).extension<TransactionListTheme>()!;
}
