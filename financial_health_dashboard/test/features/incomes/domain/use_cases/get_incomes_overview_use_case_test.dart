import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_transaction_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/income_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/failures/dashboard_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/use_cases/get_incomes_overview_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDashboardRepository implements DashboardRepository {
  _FakeDashboardRepository(this._result);

  final Either<DashboardFailure, DashboardOverviewData> _result;
  int getOverviewCalls = 0;

  @override
  Future<Either<DashboardFailure, DashboardOverviewData>> getOverview() async {
    getOverviewCalls++;
    return _result;
  }

  @override
  Future<Either<DashboardFailure, DashboardOverviewData>> addExpense({
    required double amount,
    required String title,
    required ExpenseCategory category,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<DashboardFailure, DashboardOverviewData>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  group('GetIncomesOverviewUseCase', () {
    test('filters only income transactions from overview', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(Right(overview));
      final useCase = GetIncomesOverviewUseCase(repo);

      final result = await useCase();

      expect(repo.getOverviewCalls, 1);
      result.fold((_) => fail('expected Right'), (data) {
        expect(data.totalIncome, 8000);
        expect(data.monthLabel, 'Abril');
        expect(data.transactions, hasLength(2));
        expect(data.transactions.every((t) => t.type == DashboardTransactionType.income), isTrue);
      });
    });

    test('computes category breakdown sorted by amount descending', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(Right(overview));
      final useCase = GetIncomesOverviewUseCase(repo);

      final result = await useCase();

      result.fold((_) => fail('expected Right'), (data) {
        expect(data.categoryBreakdown, hasLength(2));
        // salary: 5000, services: 2000
        expect(data.categoryBreakdown[0].category, 'salary');
        expect(data.categoryBreakdown[0].amount, 5000);
        expect(data.categoryBreakdown[1].category, 'services');
        expect(data.categoryBreakdown[1].amount, 2000);
      });
    });

    test('computes category percentage relative to total income', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(Right(overview));
      final useCase = GetIncomesOverviewUseCase(repo);

      final result = await useCase();

      result.fold((_) => fail('expected Right'), (data) {
        // Salário: 5000 / 8000 = 62.5%
        expect(data.categoryBreakdown[0].percentage, closeTo(62.5, 0.1));
        // Serviços: 2000 / 8000 = 25%
        expect(data.categoryBreakdown[1].percentage, closeTo(25.0, 0.1));
      });
    });

    test('propagates repository failure', () async {
      final repo = _FakeDashboardRepository(Left(const DashboardNetworkFailure()));
      final useCase = GetIncomesOverviewUseCase(repo);

      final result = await useCase();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<DashboardNetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('handles zero total income without division error', () async {
      final overview = _overview(income: 0);
      final repo = _FakeDashboardRepository(Right(overview));
      final useCase = GetIncomesOverviewUseCase(repo);

      final result = await useCase();

      result.fold((_) => fail('expected Right'), (data) {
        expect(data.totalIncome, 0);
        for (final breakdown in data.categoryBreakdown) {
          expect(breakdown.percentage.isFinite, isTrue);
        }
      });
    });
  });
}

DashboardOverviewData _overview({
  double income = 8000,
  double expense = 3000,
  double balance = 10000,
}) {
  return DashboardOverviewData(
    userName: 'Júlio',
    balance: balance,
    income: income,
    expense: expense,
    incomeChangePercent: 12.5,
    expenseChangePercent: -5.0,
    balanceChangePercent: 8.0,
    previousLiquidityIndex: 1.2,
    currentLiquidityIndex: 1.3,
    commitmentPercent: 37.5,
    commitmentBenchmarkPercent: 65,
    financialHealthScore: FinancialHealthScoreData.fromMetrics(
      income: income,
      expense: expense,
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
    transactions: [
      DashboardTransactionData(
        id: '1',
        title: 'Salário',
        category: 'salary',
        value: 5000,
        type: DashboardTransactionType.income,
        date: DateTime(2026, 4, 10),
      ),
      DashboardTransactionData(
        id: '2',
        title: 'Mercado',
        category: 'food',
        value: 300,
        type: DashboardTransactionType.expense,
        date: DateTime(2026, 4, 10),
      ),
      DashboardTransactionData(
        id: '3',
        title: 'Freelance',
        category: 'services',
        value: 2000,
        type: DashboardTransactionType.income,
        date: DateTime(2026, 4, 9),
      ),
      DashboardTransactionData(
        id: '4',
        title: 'Transporte',
        category: 'transport',
        value: 150,
        type: DashboardTransactionType.expense,
        date: DateTime(2026, 4, 9),
      ),
    ],
  );
}
