import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_expense_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_transaction_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/income_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/failures/dashboard_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/add_dashboard_expense_use_case.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/use_cases/get_expenses_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_cubit.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDashboardRepository implements DashboardRepository {
  _FakeDashboardRepository({required this.overviewResult, required this.addExpenseResult});

  Either<DashboardFailure, DashboardOverviewData> overviewResult;
  Either<DashboardFailure, DashboardOverviewData> addExpenseResult;
  int overviewCalls = 0;
  int addExpenseCalls = 0;
  double? lastExpenseAmount;
  String? lastExpenseTitle;
  ExpenseCategory? lastExpenseCategory;

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
  }) async {
    addExpenseCalls++;
    lastExpenseAmount = amount;
    lastExpenseTitle = title;
    lastExpenseCategory = category;
    return addExpenseResult;
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
  group('ExpensesCubit', () {
    test('loadOverview com sucesso popula state com dados de despesa', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addExpenseResult: Right(overview),
      );
      final cubit = ExpensesCubit(
        GetExpensesOverviewUseCase(repo),
        AddDashboardExpenseUseCase(repo),
      );

      await cubit.loadOverview();

      expect(cubit.state.status, ExpensesViewStatus.success);
      expect(cubit.state.totalExpense, 3000);
      expect(cubit.state.monthLabel, 'Abril');
      // Should only contain expense transactions (2 of 4)
      expect(cubit.state.transactions, hasLength(2));
      expect(cubit.state.categoryBreakdown, isNotEmpty);
      await cubit.close();
    });

    test('loadOverview com falha emite estado de erro', () async {
      final repo = _FakeDashboardRepository(
        overviewResult: Left(const DashboardNetworkFailure()),
        addExpenseResult: Left(const DashboardNetworkFailure()),
      );
      final cubit = ExpensesCubit(
        GetExpensesOverviewUseCase(repo),
        AddDashboardExpenseUseCase(repo),
      );

      await cubit.loadOverview();

      expect(cubit.state.status, ExpensesViewStatus.error);
      expect(cubit.state.canRetry, isTrue);
      await cubit.close();
    });

    test('emite efeito para abrir bottom sheet de despesa', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addExpenseResult: Right(overview),
      );
      final cubit = ExpensesCubit(
        GetExpensesOverviewUseCase(repo),
        AddDashboardExpenseUseCase(repo),
      );

      final beforeVersion = cubit.state.effectVersion;
      cubit.onAddExpensePressed();

      expect(cubit.state.effect, ExpensesEffect.showAddExpenseSheet);
      expect(cubit.state.effectVersion, beforeVersion + 1);
      await cubit.close();
    });

    test('clearEffect remove efeito ativo', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addExpenseResult: Right(overview),
      );
      final cubit = ExpensesCubit(
        GetExpensesOverviewUseCase(repo),
        AddDashboardExpenseUseCase(repo),
      );
      cubit.onAddExpensePressed();

      cubit.clearEffect();

      expect(cubit.state.effect, isNull);
      await cubit.close();
    });

    test('addExpense usa use case e recarrega overview no sucesso', () async {
      final updated = _overview(expense: 3200);
      final repo = _FakeDashboardRepository(
        overviewResult: Right(updated),
        addExpenseResult: Right(updated),
      );
      final cubit = ExpensesCubit(
        GetExpensesOverviewUseCase(repo),
        AddDashboardExpenseUseCase(repo),
      );

      final success = await cubit.addExpense(
        AddDashboardExpenseInput(amount: 200, title: 'Mercado', category: ExpenseCategory.food),
      );

      expect(success, isTrue);
      expect(repo.addExpenseCalls, 1);
      expect(repo.lastExpenseAmount, 200);
      // Should reload overview after adding
      expect(repo.overviewCalls, 1);
      await cubit.close();
    });

    test('addExpense retorna false e emite erro na falha', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addExpenseResult: Left(const DashboardValidationFailure('Descrição é obrigatória.')),
      );
      final cubit = ExpensesCubit(
        GetExpensesOverviewUseCase(repo),
        AddDashboardExpenseUseCase(repo),
      );

      final success = await cubit.addExpense(
        AddDashboardExpenseInput(amount: 500, title: '', category: ExpenseCategory.food),
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
