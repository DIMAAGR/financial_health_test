import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:financial_health_dashboard/src/shared/data/parsers/json_parsers.dart';

class DashboardOverviewModel {
  const DashboardOverviewModel({
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
    required this.monthLabel,
    required this.goalTargetAmount,
    required this.goalAchievedAmount,
    required this.goalDay,
    required this.goalDaysInMonth,
    required this.flowPoints,
  });

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    final liquidity = parseJsonMap(json['liquidity']);
    final commitment = parseJsonMap(json['commitment']);
    final monthlyGoal = parseJsonMap(json['monthlyGoal']);
    final flow = (json['flow'] as List<dynamic>? ?? const [])
        .map(parseJsonMap)
        .map(
          (item) => FlowAnalysisPoint(
            income: parseJsonDouble(item['income']),
            expense: parseJsonDouble(item['expense']),
          ),
        )
        .toList(growable: false);
    return DashboardOverviewModel(
      userName: (json['userName'] as String? ?? 'Usuário').trim(),
      balance: parseJsonDouble(json['balance']),
      income: parseJsonDouble(json['income']),
      expense: parseJsonDouble(json['expense']),
      incomeChangePercent: parseJsonDouble(json['incomeChangePercent']),
      expenseChangePercent: parseJsonDouble(json['expenseChangePercent']),
      balanceChangePercent: parseJsonDouble(json['balanceChangePercent']),
      previousLiquidityIndex: parseJsonDouble(liquidity['previousIndex']),
      currentLiquidityIndex: parseJsonDouble(liquidity['currentIndex']),
      commitmentPercent: parseJsonDouble(commitment['percent']),
      commitmentBenchmarkPercent: parseJsonDouble(
        commitment['benchmarkPercent'],
      ),
      monthLabel: (monthlyGoal['monthLabel'] as String? ?? 'Mês').trim(),
      goalTargetAmount: parseJsonDouble(monthlyGoal['targetAmount']),
      goalAchievedAmount: parseJsonDouble(monthlyGoal['achievedAmount']),
      goalDay: parseJsonInt(monthlyGoal['day'], fallback: 1),
      goalDaysInMonth: parseJsonInt(monthlyGoal['daysInMonth'], fallback: 30),
      flowPoints: flow,
    );
  }

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

  final String monthLabel;
  final double goalTargetAmount;
  final double goalAchievedAmount;
  final int goalDay;
  final int goalDaysInMonth;

  final List<FlowAnalysisPoint> flowPoints;

  DashboardOverviewData toEntity({required DateTime referenceDate}) {
    final safeTarget = goalTargetAmount <= 0 ? 1.0 : goalTargetAmount;
    final achievedPercent = (goalAchievedAmount / safeTarget) * 100;

    final normalizedReferenceDate = DateTime(
      referenceDate.year,
      referenceDate.month,
      goalDay,
    );

    return DashboardOverviewData(
      userName: userName,
      balance: balance,
      income: income,
      expense: expense,
      financialHealthScore: FinancialHealthScoreData.fromMetrics(
        income: income,
        expense: expense,
        currentLiquidityIndex: currentLiquidityIndex,
        previousLiquidityIndex: previousLiquidityIndex,
      ),
      flowAnalysis: FlowAnalysisData(points: flowPoints),
      monthlyGoal: MonthlyGoalData(
        monthLabel: monthLabel,
        achievedPercent: achievedPercent,
        daysInMonth: goalDaysInMonth,
        referenceDate: normalizedReferenceDate,
      ),
    );
  }
}
