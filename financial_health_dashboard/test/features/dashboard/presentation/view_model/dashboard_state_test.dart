import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/dashboard/dashboard_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardState', () {
    test('initial monta estado base válido', () {
      final state = DashboardState.initial();

      expect(state.userName, isEmpty);
      expect(state.transactions, isEmpty);
      expect(state.status, DashboardViewStatus.initial);
      expect(state.effect, isNull);
      expect(state.effectVersion, 0);
      expect(state.financialHealthScore.score, inInclusiveRange(0, 100));
      expect(state.flowAnalysis.points, isEmpty);
    });

    test('fromOverview usa snapshots consolidados do overview', () {
      final score = FinancialHealthScoreData.fromMetrics(
        income: 8000,
        expense: 3000,
        previousLiquidityIndex: 1.2,
        currentLiquidityIndex: 1.3,
      );
      final flow = FlowAnalysisData(points: [FlowAnalysisPoint(income: 1000, expense: 700)]);
      final goal = MonthlyGoalData(
        monthLabel: 'Abril',
        achievedPercent: 60,
        referenceDate: DateTime(2026, 4, 10),
      );
      final overview = DashboardOverviewData(
        userName: 'Júlio',
        balance: 10000,
        income: 8000,
        expense: 3000,
        incomeChangePercent: 12.5,
        expenseChangePercent: -5.0,
        balanceChangePercent: 8.0,
        previousLiquidityIndex: 1.2,
        currentLiquidityIndex: 1.3,
        commitmentPercent: 37.5,
        commitmentBenchmarkPercent: 65,
        financialHealthScore: score,
        flowAnalysis: flow,
        monthlyGoal: goal,
        monthlyGoalTargetAmount: 15000,
        monthlyGoalAchievedAmount: 9000,
        transactions: const [],
      );

      final state = DashboardState.fromOverview(overview, effectVersion: 2);

      expect(identical(state.financialHealthScore, score), isTrue);
      expect(identical(state.flowAnalysis, flow), isTrue);
      expect(identical(state.monthlyGoal, goal), isTrue);
      expect(state.status, DashboardViewStatus.success);
      expect(state.effectVersion, 2);
    });

    test('copyWith atualiza apenas campos informados', () {
      final state = DashboardState.initial();

      final updated = state.copyWith(income: state.income + 1);

      expect(updated.income, closeTo(state.income + 1, 0.001));
      expect(updated.balance, state.balance);
      expect(updated.userName, state.userName);
      expect(updated.status, state.status);
    });

    test('copyWith com clearEffect limpa efeito atual', () {
      final state = DashboardState.initial().copyWith(
        effect: DashboardEffect.showAddIncomeSheet,
        effectVersion: 1,
      );

      final cleared = state.copyWith(clearEffect: true);

      expect(cleared.effect, isNull);
      expect(cleared.effectVersion, 1);
    });
  });
}
