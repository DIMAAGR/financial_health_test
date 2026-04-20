import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';

import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/get_dashboard_overview_use_case.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDashboardRepository implements DashboardRepository {
  _FakeDashboardRepository(this._result);

  final Either<AppFailure, DashboardOverviewData> _result;
  int getOverviewCalls = 0;

  @override
  Future<Either<AppFailure, DashboardOverviewData>> getOverview() async {
    getOverviewCalls++;
    return _result;
  }

  @override
  Future<Either<AppFailure, DashboardOverviewData>> addExpense({
    required double amount,
    required String title,
    required ExpenseCategory category,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<AppFailure, DashboardOverviewData>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  test('delegates overview loading to repository', () async {
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
      financialHealthScore: FinancialHealthScoreData.fromMetrics(
        income: 8000,
        expense: 3000,
        currentLiquidityIndex: 1.3,
        previousLiquidityIndex: 1.2,
      ),
      flowAnalysis: FlowAnalysisData(
        points: [
          FlowAnalysisPoint(income: 1000, expense: 800),
          FlowAnalysisPoint(income: 1200, expense: 900),
        ],
      ),
      monthlyGoal: MonthlyGoalData(
        monthLabel: 'Abril',
        achievedPercent: 60,
        referenceDate: DateTime(2026, 4, 10),
      ),
      monthlyGoalTargetAmount: 15000,
      monthlyGoalAchievedAmount: 9000,
    );

    final repo = _FakeDashboardRepository(Right(overview));
    final useCase = GetDashboardOverviewUseCase(repo);

    final result = await useCase();

    expect(repo.getOverviewCalls, 1);
    expect(result.isRight(), isTrue);
    result.fold((_) => fail('esperava Right'), (data) {
      expect(data.userName, 'Júlio');
      expect(data.income, 8000);
    });
  });
}
