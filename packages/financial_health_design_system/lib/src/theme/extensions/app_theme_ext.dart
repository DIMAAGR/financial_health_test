import 'package:financial_health_design_system/src/components/financial_summary_card/financial_summary_card_theme.dart';
import 'package:financial_health_design_system/src/theme/extensions/add_income_sheet_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/app_semantic_colors.dart';
import 'package:financial_health_design_system/src/theme/extensions/category_breakdown_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/contextual_fab_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/financial_health_score_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/flow_analysis_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/month_summary_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/monthly_goal_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/transaction_list_theme_ext.dart';
import 'package:flutter/material.dart';

extension AppThemeExtension on BuildContext {
  AppSemanticColors get appColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
  FinancialHealthScoreTheme get financialHealthScoreTheme =>
      Theme.of(this).extension<FinancialHealthScoreTheme>()!;
  FinancialSummaryCardTheme get financialSummaryCardTheme =>
      Theme.of(this).extension<FinancialSummaryCardTheme>()!;
  FlowAnalysisTheme get flowAnalysisTheme =>
      Theme.of(this).extension<FlowAnalysisTheme>()!;
  MonthlyGoalTheme get monthlyGoalTheme =>
      Theme.of(this).extension<MonthlyGoalTheme>()!;
  AddIncomeSheetTheme get addIncomeSheetTheme =>
      Theme.of(this).extension<AddIncomeSheetTheme>()!;
  MonthSummaryTheme get monthSummaryTheme =>
      Theme.of(this).extension<MonthSummaryTheme>()!;
  CategoryBreakdownTheme get categoryBreakdownTheme =>
      Theme.of(this).extension<CategoryBreakdownTheme>()!;
  ContextualFabTheme get contextualFabTheme =>
      Theme.of(this).extension<ContextualFabTheme>()!;
  TransactionListTheme get transactionListTheme =>
      Theme.of(this).extension<TransactionListTheme>()!;
}
