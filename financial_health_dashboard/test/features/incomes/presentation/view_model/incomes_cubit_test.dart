import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_income_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_transaction_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/income_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/failures/dashboard_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/add_dashboard_income_use_case.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/use_cases/get_incomes_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/view_model/incomes_cubit.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/view_model/incomes_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDashboardRepository implements DashboardRepository {
  _FakeDashboardRepository({required this.overviewResult, required this.addIncomeResult});

  Either<DashboardFailure, DashboardOverviewData> overviewResult;
  Either<DashboardFailure, DashboardOverviewData> addIncomeResult;
  int overviewCalls = 0;
  int addIncomeCalls = 0;
  double? lastIncomeAmount;
  String? lastIncomeTitle;
  IncomeCategory? lastIncomeCategory;

  @override
  Future<Either<DashboardFailure, DashboardOverviewData>> getOverview() async {
    overviewCalls++;
    return overviewResult;
  }

  @override
  Future<Either<DashboardFailure, DashboardOverviewData>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  }) async {
    addIncomeCalls++;
    lastIncomeAmount = amount;
    lastIncomeTitle = title;
    lastIncomeCategory = category;
    return addIncomeResult;
  }

  @override
  Future<Either<DashboardFailure, DashboardOverviewData>> addExpense({
    required double amount,
    required String title,
    required ExpenseCategory category,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  group('IncomesCubit', () {
    test('loadOverview com sucesso popula state com dados de receita', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addIncomeResult: Right(overview),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddDashboardIncomeUseCase(repo));

      await cubit.loadOverview();

      expect(cubit.state.status, IncomesViewStatus.success);
      expect(cubit.state.totalIncome, 8000);
      expect(cubit.state.monthLabel, 'Abril');
      // Should only contain income transactions (2 of 4)
      expect(cubit.state.transactions, hasLength(2));
      expect(cubit.state.categoryBreakdown, isNotEmpty);
      await cubit.close();
    });

    test('loadOverview com falha emite estado de erro', () async {
      final repo = _FakeDashboardRepository(
        overviewResult: Left(const DashboardNetworkFailure()),
        addIncomeResult: Left(const DashboardNetworkFailure()),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddDashboardIncomeUseCase(repo));

      await cubit.loadOverview();

      expect(cubit.state.status, IncomesViewStatus.error);
      expect(cubit.state.canRetry, isTrue);
      await cubit.close();
    });

    test('emite efeito para abrir bottom sheet de receita', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addIncomeResult: Right(overview),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddDashboardIncomeUseCase(repo));

      final beforeVersion = cubit.state.effectVersion;
      cubit.onAddIncomePressed();

      expect(cubit.state.effect, IncomesEffect.showAddIncomeSheet);
      expect(cubit.state.effectVersion, beforeVersion + 1);
      await cubit.close();
    });

    test('clearEffect remove efeito ativo', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addIncomeResult: Right(overview),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddDashboardIncomeUseCase(repo));
      cubit.onAddIncomePressed();

      cubit.clearEffect();

      expect(cubit.state.effect, isNull);
      await cubit.close();
    });

    test('addIncome usa use case e recarrega overview no sucesso', () async {
      final updated = _overview(income: 9000);
      final repo = _FakeDashboardRepository(
        overviewResult: Right(updated),
        addIncomeResult: Right(updated),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddDashboardIncomeUseCase(repo));

      final success = await cubit.addIncome(
        AddDashboardIncomeInput(
          amount: 1000,
          title: 'Freelance',
          category: IncomeCategory.investment,
        ),
      );

      expect(success, isTrue);
      expect(repo.addIncomeCalls, 1);
      expect(repo.lastIncomeAmount, 1000);
      // Should reload overview after adding
      expect(repo.overviewCalls, 1);
      await cubit.close();
    });

    test('addIncome retorna false e emite erro na falha', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addIncomeResult: Left(const DashboardValidationFailure('Descrição é obrigatória.')),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddDashboardIncomeUseCase(repo));

      final success = await cubit.addIncome(
        AddDashboardIncomeInput(amount: 500, title: '', category: IncomeCategory.salary),
      );

      expect(success, isFalse);
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
