import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';

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
    final liquidity = _requireMap(json['liquidity'], field: 'liquidity');
    final commitment = _requireMap(json['commitment'], field: 'commitment');
    final monthlyGoal = _requireMap(json['monthlyGoal'], field: 'monthlyGoal');
    final flow = (json['flow'] as List<dynamic>? ?? const [])
        .map((item) => _requireMap(item, field: 'flow[]'))
        .map(
          (item) => FlowAnalysisPoint(
            income: _requireDouble(item['income'], field: 'flow[].income'),
            expense: _requireDouble(item['expense'], field: 'flow[].expense'),
          ),
        )
        .toList(growable: false);
    return DashboardOverviewModel(
      userName: (json['userName'] as String? ?? 'Usuário').trim(),
      balance: _requireDouble(json['balance'], field: 'balance'),
      income: _requireDouble(json['income'], field: 'income'),
      expense: _requireDouble(json['expense'], field: 'expense'),
      incomeChangePercent: _requireDouble(
        json['incomeChangePercent'],
        field: 'incomeChangePercent',
      ),
      expenseChangePercent: _requireDouble(
        json['expenseChangePercent'],
        field: 'expenseChangePercent',
      ),
      balanceChangePercent: _requireDouble(
        json['balanceChangePercent'],
        field: 'balanceChangePercent',
      ),
      previousLiquidityIndex: _requireDouble(
        liquidity['previousIndex'],
        field: 'liquidity.previousIndex',
      ),
      currentLiquidityIndex: _requireDouble(
        liquidity['currentIndex'],
        field: 'liquidity.currentIndex',
      ),
      commitmentPercent: _requireDouble(
        commitment['percent'],
        field: 'commitment.percent',
      ),
      commitmentBenchmarkPercent: _requireDouble(
        commitment['benchmarkPercent'],
        field: 'commitment.benchmarkPercent',
      ),
      monthLabel: (monthlyGoal['monthLabel'] as String? ?? 'Mês').trim(),
      goalTargetAmount: _requireDouble(
        monthlyGoal['targetAmount'],
        field: 'monthlyGoal.targetAmount',
      ),
      goalAchievedAmount: _requireDouble(
        monthlyGoal['achievedAmount'],
        field: 'monthlyGoal.achievedAmount',
      ),
      goalDay: _requireInt(monthlyGoal['day'], field: 'monthlyGoal.day'),
      goalDaysInMonth: _requireInt(
        monthlyGoal['daysInMonth'],
        field: 'monthlyGoal.daysInMonth',
      ),
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

  static Map<String, dynamic> _requireMap(
    Object? value, {
    required String field,
  }) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) {
        if (key is! String) {
          throw FormatException('Invalid key type for field: $field');
        }
        return MapEntry(key, value);
      });
    }
    throw FormatException('Invalid map for field: $field');
  }

  static double _requireDouble(Object? value, {required String field}) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Invalid double for field: $field');
  }

  static int _requireInt(Object? value, {required String field}) {
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Invalid int for field: $field');
  }
}
