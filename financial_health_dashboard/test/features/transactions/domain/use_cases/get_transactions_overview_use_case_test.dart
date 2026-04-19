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
import 'package:financial_health_dashboard/src/features/transactions/domain/use_cases/get_transactions_overview_use_case.dart';
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
  group('GetTransactionsOverviewUseCase', () {
    test('delegates to repository and maps overview to TransactionsOverviewData', () async {
      // Arrange
      final overview = _overview();
      final repo = _FakeDashboardRepository(Right(overview));
      final useCase = GetTransactionsOverviewUseCase(repo);

      // Act
      final result = await useCase();

      // Assert
      expect(repo.getOverviewCalls, 1);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (data) {
        expect(data.balance, 10000);
        expect(data.income, 8000);
        expect(data.expense, 3000);
        expect(data.monthLabel, 'Abril');
        expect(data.transactions, hasLength(3));
      });
    });

    test('returns all transactions (income + expense) without filtering', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(Right(overview));
      final useCase = GetTransactionsOverviewUseCase(repo);

      final result = await useCase();

      result.fold((_) => fail('expected Right'), (data) {
        final types = data.transactions.map((t) => t.type).toSet();
        expect(types, contains(DashboardTransactionType.income));
        expect(types, contains(DashboardTransactionType.expense));
      });
    });

    test('propagates repository failure', () async {
      final repo = _FakeDashboardRepository(Left(const DashboardNetworkFailure()));
      final useCase = GetTransactionsOverviewUseCase(repo);

      final result = await useCase();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<DashboardNetworkFailure>()),
        (_) => fail('expected Left'),
      );
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
    ],
  );
}
