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
import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_cubit.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDashboardRepository implements DashboardRepository {
  _FakeDashboardRepository({required this.overviewResult});

  Either<DashboardFailure, DashboardOverviewData> overviewResult;
  int overviewCalls = 0;

  @override
  Future<Either<DashboardFailure, DashboardOverviewData>> getOverview() async {
    overviewCalls++;
    return overviewResult;
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
  group('TransactionsCubit', () {
    test('loadOverview com sucesso popula state', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(overviewResult: Right(overview));
      final cubit = TransactionsCubit(GetTransactionsOverviewUseCase(repo));

      await cubit.loadOverview();

      expect(repo.overviewCalls, 1);
      expect(cubit.state.status, TransactionsViewStatus.success);
      expect(cubit.state.balance, 10000);
      expect(cubit.state.income, 8000);
      expect(cubit.state.expense, 3000);
      expect(cubit.state.monthLabel, 'Abril');
      expect(cubit.state.transactions, hasLength(3));
      await cubit.close();
    });

    test('loadOverview com falha emite estado de erro', () async {
      final repo = _FakeDashboardRepository(overviewResult: Left(const DashboardNetworkFailure()));
      final cubit = TransactionsCubit(GetTransactionsOverviewUseCase(repo));

      await cubit.loadOverview();

      expect(cubit.state.status, TransactionsViewStatus.error);
      expect(cubit.state.canRetry, isTrue);
      await cubit.close();
    });

    test('loadOverview emite loading antes do resultado', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(overviewResult: Right(overview));
      final cubit = TransactionsCubit(GetTransactionsOverviewUseCase(repo));

      expectLater(
        cubit.stream.map((s) => s.status),
        emitsInOrder([TransactionsViewStatus.loading, TransactionsViewStatus.success]),
      );

      await cubit.loadOverview();
      await cubit.close();
    });

    test('server failure não permite retry', () async {
      final repo = _FakeDashboardRepository(
        overviewResult: Left(const DashboardUnknownFailure('erro')),
      );
      final cubit = TransactionsCubit(GetTransactionsOverviewUseCase(repo));

      await cubit.loadOverview();

      expect(cubit.state.status, TransactionsViewStatus.error);
      expect(cubit.state.canRetry, isFalse);
      await cubit.close();
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
