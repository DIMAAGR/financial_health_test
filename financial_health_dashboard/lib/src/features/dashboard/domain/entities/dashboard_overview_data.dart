import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';

/// Agregado principal da feature Dashboard.
///
/// Em uma aplicação real, esse payload tende a vir do backend já consolidado.
/// O app mobile trata este objeto como snapshot da tela principal.
class DashboardOverviewData {
  const DashboardOverviewData({
    required this.userName,
    required this.balance,
    required this.income,
    required this.expense,
    required this.financialHealthScore,
    required this.flowAnalysis,
    required this.monthlyGoal,
  });

  final String userName;
  final double balance;
  final double income;
  final double expense;

  final FinancialHealthScoreData financialHealthScore;
  final FlowAnalysisData flowAnalysis;
  final MonthlyGoalData monthlyGoal;
}
