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
    required this.incomeChangePercent,
    required this.expenseChangePercent,
    required this.balanceChangePercent,
    required this.previousLiquidityIndex,
    required this.currentLiquidityIndex,
    required this.commitmentPercent,
    required this.commitmentBenchmarkPercent,
    required this.financialHealthScore,
    required this.flowAnalysis,
    required this.monthlyGoal,
    required this.monthlyGoalTargetAmount,
    required this.monthlyGoalAchievedAmount,
  });

  final String userName;
  final double balance;
  final double income;
  final double expense;

  final double incomeChangePercent;
  final double expenseChangePercent;
  final double balanceChangePercent;

  final double previousLiquidityIndex;
  final double currentLiquidityIndex;

  final double commitmentPercent;
  final double commitmentBenchmarkPercent;

  final FinancialHealthScoreData financialHealthScore;
  final FlowAnalysisData flowAnalysis;
  final MonthlyGoalData monthlyGoal;

  final double monthlyGoalTargetAmount;
  final double monthlyGoalAchievedAmount;
}
