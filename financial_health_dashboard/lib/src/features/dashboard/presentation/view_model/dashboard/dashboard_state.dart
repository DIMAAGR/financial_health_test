import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

class DashboardState {
  const DashboardState({
    required this.userName,
    required this.balance,
    required this.income,
    required this.expense,
    required this.financialHealthScore,
    required this.flowAnalysis,
    required this.monthlyGoal,
    required this.transactions,
    required this.status,
    this.errorMessage,
    this.canRetry = false,
    this.effect,
    required this.effectVersion,
  });

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
      transactions: const [],
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
      transactions: overview.transactions,
      status: DashboardViewStatus.success,
      effect: effect,
      effectVersion: effectVersion,
    );
  }

  final String userName;
  final double balance;
  final double income;
  final double expense;
  final FinancialHealthScoreData financialHealthScore;
  final FlowAnalysisData flowAnalysis;
  final MonthlyGoalData monthlyGoal;
  final List<TransactionData> transactions;
  final DashboardViewStatus status;
  final String? errorMessage;
  final bool canRetry;
  final DashboardEffect? effect;
  final int effectVersion;

  DashboardState copyWith({
    String? userName,
    double? balance,
    double? income,
    double? expense,
    FinancialHealthScoreData? financialHealthScore,
    FlowAnalysisData? flowAnalysis,
    MonthlyGoalData? monthlyGoal,
    List<TransactionData>? transactions,
    DashboardViewStatus? status,
    String? errorMessage,
    bool? canRetry,
    bool clearError = false,
    DashboardEffect? effect,
    bool clearEffect = false,
    int? effectVersion,
  }) {
    return DashboardState(
      userName: userName ?? this.userName,
      balance: balance ?? this.balance,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      financialHealthScore: financialHealthScore ?? this.financialHealthScore,
      flowAnalysis: flowAnalysis ?? this.flowAnalysis,
      monthlyGoal: monthlyGoal ?? this.monthlyGoal,
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      canRetry: canRetry ?? this.canRetry,
      effect: clearEffect ? null : (effect ?? this.effect),
      effectVersion: effectVersion ?? this.effectVersion,
    );
  }
}

enum DashboardEffect { showAddIncomeSheet, showAddExpenseSheet }

enum DashboardViewStatus { initial, loading, success, error }
