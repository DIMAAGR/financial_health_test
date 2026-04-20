import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_expense_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_income_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';

import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/add_dashboard_expense_use_case.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/add_dashboard_income_use_case.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/get_dashboard_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/dashboard/dashboard_cubit.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/dashboard/dashboard_state.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDashboardRepository implements DashboardRepository {
  _FakeDashboardRepository({
    required this.overviewResult,
    required this.addIncomeResult,
    required this.addExpenseResult,
  });

  Either<AppFailure, DashboardOverviewData> overviewResult;
  Either<AppFailure, DashboardOverviewData> addIncomeResult;
  Either<AppFailure, DashboardOverviewData> addExpenseResult;

  int overviewCalls = 0;
  int addIncomeCalls = 0;
  int addExpenseCalls = 0;

  double? lastIncomeAmount;
  String? lastIncomeTitle;
  IncomeCategory? lastIncomeCategory;

  double? lastExpenseAmount;
  String? lastExpenseTitle;
  ExpenseCategory? lastExpenseCategory;

  @override
  Future<Either<AppFailure, DashboardOverviewData>> getOverview() async {
    overviewCalls++;
    return overviewResult;
  }

  @override
  Future<Either<AppFailure, DashboardOverviewData>> addIncome({
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
  Future<Either<AppFailure, DashboardOverviewData>> addExpense({
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
}

void main() {
  group('DashboardCubit', () {
    test('carrega overview no bootstrap com sucesso', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addIncomeResult: Right(overview),
        addExpenseResult: Right(overview),
      );

      final cubit = DashboardCubit(
        AddDashboardExpenseUseCase(repo),
        AddDashboardIncomeUseCase(repo),
        GetDashboardOverviewUseCase(repo),
      );

      await cubit.loadOverview();

      expect(repo.overviewCalls, 1);
      expect(cubit.state.status, DashboardViewStatus.success);
      expect(cubit.state.userName, 'Júlio');
      await cubit.close();
    });

    test('carrega overview no bootstrap com falha', () async {
      final repo = _FakeDashboardRepository(
        overviewResult: const Left(AppFailure('falha no load')),
        addIncomeResult: const Left(AppFailure('falha income')),
        addExpenseResult: const Left(AppFailure('falha expense')),
      );

      final cubit = DashboardCubit(
        AddDashboardExpenseUseCase(repo),
        AddDashboardIncomeUseCase(repo),
        GetDashboardOverviewUseCase(repo),
      );

      await cubit.loadOverview();

      expect(cubit.state.status, DashboardViewStatus.error);
      expect(cubit.state.errorMessage, contains('falha no load'));
      await cubit.close();
    });

    test('emite efeito para abrir bottom sheet de receita', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addIncomeResult: Right(overview),
        addExpenseResult: Right(overview),
      );
      final cubit = DashboardCubit(
        AddDashboardExpenseUseCase(repo),
        AddDashboardIncomeUseCase(repo),
        GetDashboardOverviewUseCase(repo),
      );
      await Future<void>.delayed(Duration.zero);

      final beforeVersion = cubit.state.effectVersion;
      cubit.onAddIncomePressed();

      expect(cubit.state.effect, DashboardEffect.showAddIncomeSheet);
      expect(cubit.state.effectVersion, beforeVersion + 1);
      await cubit.close();
    });

    test('clearEffect remove efeito ativo sem alterar version', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addIncomeResult: Right(overview),
        addExpenseResult: Right(overview),
      );
      final cubit = DashboardCubit(
        AddDashboardExpenseUseCase(repo),
        AddDashboardIncomeUseCase(repo),
        GetDashboardOverviewUseCase(repo),
      );
      await Future<void>.delayed(Duration.zero);
      cubit.onAddIncomePressed();
      final version = cubit.state.effectVersion;

      cubit.clearEffect();

      expect(cubit.state.effect, isNull);
      expect(cubit.state.effectVersion, version);
      await cubit.close();
    });

    test('addIncome usa use case e atualiza estado no sucesso', () async {
      final overview = _overview();
      final updated = _overview(income: 9000, balance: 11000);
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addIncomeResult: Right(updated),
        addExpenseResult: Right(overview),
      );

      final cubit = DashboardCubit(
        AddDashboardExpenseUseCase(repo),
        AddDashboardIncomeUseCase(repo),
        GetDashboardOverviewUseCase(repo),
      );
      await Future<void>.delayed(Duration.zero);

      final success = await cubit.addIncome(
        const AddDashboardIncomeInput(
          amount: 500,
          title: 'Freelance',
          category: IncomeCategory.investment,
        ),
      );

      expect(success, isTrue);
      expect(repo.addIncomeCalls, 1);
      expect(repo.lastIncomeAmount, 500);
      expect(repo.lastIncomeTitle, 'Freelance');
      expect(repo.lastIncomeCategory, IncomeCategory.investment);
      expect(cubit.state.income, 9000);
      expect(cubit.state.balance, 11000);
      expect(cubit.state.status, DashboardViewStatus.success);
      await cubit.close();
    });

    test('addExpense usa use case e atualiza estado no sucesso', () async {
      final overview = _overview();
      final updated = _overview(expense: 3200, balance: 9800);
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addIncomeResult: Right(overview),
        addExpenseResult: Right(updated),
      );

      final cubit = DashboardCubit(
        AddDashboardExpenseUseCase(repo),
        AddDashboardIncomeUseCase(repo),
        GetDashboardOverviewUseCase(repo),
      );
      await Future<void>.delayed(Duration.zero);

      final success = await cubit.addExpense(
        const AddDashboardExpenseInput(
          amount: 200,
          title: 'Mercado',
          category: ExpenseCategory.food,
        ),
      );

      expect(success, isTrue);
      expect(repo.addExpenseCalls, 1);
      expect(repo.lastExpenseAmount, 200);
      expect(repo.lastExpenseTitle, 'Mercado');
      expect(repo.lastExpenseCategory, ExpenseCategory.food);
      expect(cubit.state.expense, 3200);
      expect(cubit.state.balance, 9800);
      expect(cubit.state.status, DashboardViewStatus.success);
      await cubit.close();
    });

    test('ignora addIncome/addExpense quando amount é inválido', () async {
      final overview = _overview();
      final repo = _FakeDashboardRepository(
        overviewResult: Right(overview),
        addIncomeResult: Right(overview),
        addExpenseResult: Right(overview),
      );

      final cubit = DashboardCubit(
        AddDashboardExpenseUseCase(repo),
        AddDashboardIncomeUseCase(repo),
        GetDashboardOverviewUseCase(repo),
      );
      await Future<void>.delayed(Duration.zero);

      await cubit.addIncome(
        const AddDashboardIncomeInput(
          amount: 0,
          title: 'X',
          category: IncomeCategory.gift,
        ),
      );
      await cubit.addExpense(
        const AddDashboardExpenseInput(
          amount: -1,
          title: 'X',
          category: ExpenseCategory.shopping,
        ),
      );

      expect(repo.addIncomeCalls, 0);
      expect(repo.addExpenseCalls, 0);
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
  );
}
