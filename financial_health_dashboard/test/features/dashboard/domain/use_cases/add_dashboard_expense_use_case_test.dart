import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_expense_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';

import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';

import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/add_dashboard_expense_use_case.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDashboardRepository implements DashboardRepository {
  _FakeDashboardRepository(this._result);

  final Either<AppFailure, DashboardOverviewData> _result;
  int addExpenseCalls = 0;
  double? lastAmount;
  String? lastTitle;
  ExpenseCategory? lastCategory;

  @override
  Future<Either<AppFailure, DashboardOverviewData>> addExpense({
    required double amount,
    required String title,
    required ExpenseCategory category,
  }) async {
    addExpenseCalls++;
    lastAmount = amount;
    lastTitle = title;
    lastCategory = category;
    return _result;
  }

  @override
  Future<Either<AppFailure, DashboardOverviewData>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<AppFailure, DashboardOverviewData>> getOverview() {
    throw UnimplementedError();
  }
}

void main() {
  test('retorna Right e delega parâmetros para o repository', () async {
    final overview = _overview();
    final repo = _FakeDashboardRepository(Right(overview));
    final useCase = AddDashboardExpenseUseCase(repo);

    final result = await useCase(
      const AddDashboardExpenseInput(
        amount: 250,
        title: '  Mercado  ',
        category: ExpenseCategory.food,
      ),
    );

    expect(repo.addExpenseCalls, 1);
    expect(repo.lastAmount, 250);
    expect(repo.lastTitle, 'Mercado');
    expect(repo.lastCategory, ExpenseCategory.food);
    expect(result.isRight(), isTrue);
  });

  test('retorna Left quando amount é zero ou negativo', () async {
    final overview = _overview();
    final repo = _FakeDashboardRepository(Right(overview));
    final useCase = AddDashboardExpenseUseCase(repo);

    final zeroResult = await useCase(
      const AddDashboardExpenseInput(
        amount: 0,
        title: 'Mercado',
        category: ExpenseCategory.food,
      ),
    );
    final negativeResult = await useCase(
      const AddDashboardExpenseInput(
        amount: -1,
        title: 'Mercado',
        category: ExpenseCategory.food,
      ),
    );

    expect(repo.addExpenseCalls, 0);
    expect(zeroResult.isLeft(), isTrue);
    expect(negativeResult.isLeft(), isTrue);
    zeroResult.fold(
      (failure) => expect(failure, isA<AmountValueFailure>()),
      (_) => fail('esperava Left'),
    );
  });

  test('retorna Left quando title fica vazio após trim', () async {
    final overview = _overview();
    final repo = _FakeDashboardRepository(Right(overview));
    final useCase = AddDashboardExpenseUseCase(repo);

    final result = await useCase(
      const AddDashboardExpenseInput(
        amount: 250,
        title: '   ',
        category: ExpenseCategory.food,
      ),
    );

    expect(repo.addExpenseCalls, 0);
    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('esperava Left'),
    );
  });

  test('retorna Left quando repository falha', () async {
    final repo = _FakeDashboardRepository(
      const Left(AppFailure('erro inesperado')),
    );
    final useCase = AddDashboardExpenseUseCase(repo);

    final result = await useCase(
      const AddDashboardExpenseInput(
        amount: 250,
        title: 'Mercado',
        category: ExpenseCategory.food,
      ),
    );

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure.message, 'erro inesperado'),
      (_) => fail('esperava Left'),
    );
  });
}

DashboardOverviewData _overview() {
  return DashboardOverviewData(
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
}
