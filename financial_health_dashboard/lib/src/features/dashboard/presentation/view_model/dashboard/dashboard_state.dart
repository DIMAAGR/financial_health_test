import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    required String userName,
    required double balance,
    required double income,
    required double expense,
    required FinancialHealthScoreData financialHealthScore,
    required FlowAnalysisData flowAnalysis,
    required MonthlyGoalData monthlyGoal,
    required DashboardViewStatus status,
    String? errorMessage,
    @Default(false) bool canRetry,
    DashboardEffect? effect,
    required int effectVersion,
  }) = _DashboardState;

  factory DashboardState.initial() {
    return DashboardState(
      userName: '',
      balance: 0,
      income: 0,
      expense: 0,
      financialHealthScore: FinancialHealthScoreData.fromMetrics(
        income: 0,
        expense: 0,
        previousLiquidityIndex: 0,
        currentLiquidityIndex: 0,
      ),
      flowAnalysis: FlowAnalysisData(points: const []),
      monthlyGoal: MonthlyGoalData(
        monthLabel: '—',
        achievedPercent: 0,
        referenceDate: DateTime(1970),
      ),
      status: DashboardViewStatus.initial,
      effectVersion: 0,
    );
  }

  factory DashboardState.fromOverview(
    DashboardOverviewData overview, {
    required int effectVersion,
    DashboardEffect? effect,
  }) {
    return DashboardState(
      userName: overview.userName,
      balance: overview.balance,
      income: overview.income,
      expense: overview.expense,
      financialHealthScore: overview.financialHealthScore,
      flowAnalysis: overview.flowAnalysis,
      monthlyGoal: overview.monthlyGoal,
      status: DashboardViewStatus.success,
      effect: effect,
      effectVersion: effectVersion,
    );
  }
}

enum DashboardEffect { showAddIncomeSheet, showAddExpenseSheet }

enum DashboardViewStatus { initial, loading, success, error }
