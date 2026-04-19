import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_transaction_data.dart';

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
    required this.transactions,
  });

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    final liquidity = _asMap(json['liquidity']);
    final commitment = _asMap(json['commitment']);
    final monthlyGoal = _asMap(json['monthlyGoal']);
    final flow = (json['flow'] as List<dynamic>? ?? const [])
        .map((item) => _asMap(item))
        .map(
          (item) => FlowAnalysisPoint(
            income: _toDouble(item['income']),
            expense: _toDouble(item['expense']),
          ),
        )
        .toList(growable: false);
    final transactions = (json['transactions'] as List<dynamic>? ?? const [])
        .map((item) => _asMap(item))
        .map(
          (item) => DashboardTransactionData(
            id: (item['id'] as String? ?? '').trim(),
            title: (item['title'] as String? ?? '').trim(),
            category: (item['category'] as String? ?? '').trim(),
            value: _toDouble(item['value']),
            type: (item['type'] as String? ?? '').toLowerCase() == 'expense'
                ? DashboardTransactionType.expense
                : DashboardTransactionType.income,
            date: DateTime.tryParse(item['date'] as String? ?? ''),
          ),
        )
        .where((item) => item.id.isNotEmpty)
        .toList(growable: false);

    return DashboardOverviewModel(
      userName: (json['userName'] as String? ?? 'Usuário').trim(),
      balance: _toDouble(json['balance']),
      income: _toDouble(json['income']),
      expense: _toDouble(json['expense']),
      incomeChangePercent: _toDouble(json['incomeChangePercent']),
      expenseChangePercent: _toDouble(json['expenseChangePercent']),
      balanceChangePercent: _toDouble(json['balanceChangePercent']),
      previousLiquidityIndex: _toDouble(liquidity['previousIndex']),
      currentLiquidityIndex: _toDouble(liquidity['currentIndex']),
      commitmentPercent: _toDouble(commitment['percent']),
      commitmentBenchmarkPercent: _toDouble(commitment['benchmarkPercent']),
      monthLabel: (monthlyGoal['monthLabel'] as String? ?? 'Mês').trim(),
      goalTargetAmount: _toDouble(monthlyGoal['targetAmount']),
      goalAchievedAmount: _toDouble(monthlyGoal['achievedAmount']),
      goalDay: _toInt(monthlyGoal['day'], fallback: 1),
      goalDaysInMonth: _toInt(monthlyGoal['daysInMonth'], fallback: 30),
      flowPoints: flow,
      transactions: transactions,
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
  final List<DashboardTransactionData> transactions;

  DashboardOverviewData toEntity({required DateTime referenceDate}) {
    final safeTarget = goalTargetAmount <= 0 ? 1.0 : goalTargetAmount;
    final achievedPercent = (goalAchievedAmount / safeTarget) * 100;

    final normalizedReferenceDate = DateTime(referenceDate.year, referenceDate.month, goalDay);

    return DashboardOverviewData(
      userName: userName,
      balance: balance,
      income: income,
      expense: expense,
      incomeChangePercent: incomeChangePercent,
      expenseChangePercent: expenseChangePercent,
      balanceChangePercent: balanceChangePercent,
      previousLiquidityIndex: previousLiquidityIndex,
      currentLiquidityIndex: currentLiquidityIndex,
      commitmentPercent: commitmentPercent,
      commitmentBenchmarkPercent: commitmentBenchmarkPercent,
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
      monthlyGoalTargetAmount: goalTargetAmount,
      monthlyGoalAchievedAmount: goalAchievedAmount,
      transactions: transactions,
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return <String, dynamic>{};
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return 0;
  }

  static int _toInt(dynamic value, {required int fallback}) {
    if (value is num) return value.toInt();
    return fallback;
  }
}
