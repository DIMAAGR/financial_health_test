import 'package:financial_health_dashboard/src/shared/presentation/design/theme/app_semantic_colors.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/add_income_sheet_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/financial_health_score_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/flow_analysis_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/monthly_goal_theme_ext.dart';
import 'package:flutter/material.dart';

extension AppThemeExtension on BuildContext {
  AppSemanticColors get appColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
  FinancialHealthScoreTheme get financialHealthScoreTheme =>
      Theme.of(this).extension<FinancialHealthScoreTheme>()!;
  FlowAnalysisTheme get flowAnalysisTheme =>
      Theme.of(this).extension<FlowAnalysisTheme>()!;
  MonthlyGoalTheme get monthlyGoalTheme =>
      Theme.of(this).extension<MonthlyGoalTheme>()!;
  AddIncomeSheetTheme get addIncomeSheetTheme =>
      Theme.of(this).extension<AddIncomeSheetTheme>()!;
}
