import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/add_expense_input.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/expenses_overview_data.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/use_cases/add_expense_use_case.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/use_cases/get_expenses_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_cubit.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_state.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeExpensesRepository implements ExpensesRepository {
  _FakeExpensesRepository({required this.overviewResult, required this.addExpenseResult});

  Either<AppFailure, ExpensesOverviewData> overviewResult;
  Either<AppFailure, void> addExpenseResult;
  int overviewCalls = 0;
  int addExpenseCalls = 0;
  double? lastExpenseAmount;
  String? lastExpenseTitle;
  ExpenseCategory? lastExpenseCategory;

  @override
  Future<Either<AppFailure, ExpensesOverviewData>> getOverview() async {
    overviewCalls++;
    return overviewResult;
  }

  @override
  Future<Either<AppFailure, void>> addExpense({
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
  group('ExpensesCubit', () {
    test('loadOverview com sucesso popula state com dados de despesa', () async {
      final data = _expensesOverview();
      final repo = _FakeExpensesRepository(
        overviewResult: Right(data),
        addExpenseResult: const Right(null),
      );
      final cubit = ExpensesCubit(GetExpensesOverviewUseCase(repo), AddExpenseUseCase(repo));

      await cubit.loadOverview();

      expect(cubit.state.status, ExpensesViewStatus.success);
      expect(cubit.state.totalExpense, 3000);
      expect(cubit.state.monthLabel, 'Abril');
      expect(cubit.state.transactions, hasLength(2));
      expect(cubit.state.categoryBreakdown, isNotEmpty);
      await cubit.close();
    });

    test('loadOverview com falha emite estado de erro', () async {
      final repo = _FakeExpensesRepository(
        overviewResult: const Left(NetworkFailure()),
        addExpenseResult: const Left(NetworkFailure()),
      );
      final cubit = ExpensesCubit(GetExpensesOverviewUseCase(repo), AddExpenseUseCase(repo));

      await cubit.loadOverview();

      expect(cubit.state.status, ExpensesViewStatus.error);
      expect(cubit.state.canRetry, isTrue);
      await cubit.close();
    });

    test('emite efeito para abrir bottom sheet de despesa', () async {
      final data = _expensesOverview();
      final repo = _FakeExpensesRepository(
        overviewResult: Right(data),
        addExpenseResult: const Right(null),
      );
      final cubit = ExpensesCubit(GetExpensesOverviewUseCase(repo), AddExpenseUseCase(repo));

      final beforeVersion = cubit.state.effectVersion;
      cubit.onAddExpensePressed();

      expect(cubit.state.effect, ExpensesEffect.showAddExpenseSheet);
      expect(cubit.state.effectVersion, beforeVersion + 1);
      await cubit.close();
    });

    test('clearEffect remove efeito ativo', () async {
      final data = _expensesOverview();
      final repo = _FakeExpensesRepository(
        overviewResult: Right(data),
        addExpenseResult: const Right(null),
      );
      final cubit = ExpensesCubit(GetExpensesOverviewUseCase(repo), AddExpenseUseCase(repo))
        ..onAddExpensePressed()
        ..clearEffect();

      expect(cubit.state.effect, isNull);
      await cubit.close();
    });

    test('addExpense usa use case e recarrega overview no sucesso', () async {
      final updated = _expensesOverview(totalExpense: 3200);
      final repo = _FakeExpensesRepository(
        overviewResult: Right(updated),
        addExpenseResult: const Right(null),
      );
      final cubit = ExpensesCubit(GetExpensesOverviewUseCase(repo), AddExpenseUseCase(repo));

      final success = await cubit.addExpense(
        const AddExpenseInput(amount: 200, title: 'Mercado', category: ExpenseCategory.food),
      );

      expect(success, isTrue);
      expect(repo.addExpenseCalls, 1);
      expect(repo.lastExpenseAmount, 200);
      // Should reload overview after adding
      expect(repo.overviewCalls, 1);
      await cubit.close();
    });

    test('addExpense retorna false e emite erro na falha', () async {
      final data = _expensesOverview();
      final repo = _FakeExpensesRepository(
        overviewResult: Right(data),
        addExpenseResult: const Left(ValidationFailure('Descrição é obrigatória.')),
      );
      final cubit = ExpensesCubit(GetExpensesOverviewUseCase(repo), AddExpenseUseCase(repo));

      final success = await cubit.addExpense(
        const AddExpenseInput(amount: 500, title: '', category: ExpenseCategory.food),
      );

      expect(success, isFalse);
      await cubit.close();
    });
  });
}

ExpensesOverviewData _expensesOverview({double totalExpense = 3000}) {
  final safeDivisor = totalExpense <= 0 ? 1.0 : totalExpense;
  return ExpensesOverviewData(
    totalExpense: totalExpense,
    monthLabel: 'Abril',
    expenseChangePercent: -5.0,
    transactions: [
      TransactionData(
        id: '2',
        title: 'Mercado',
        category: 'food',
        value: 300,
        type: TransactionType.expense,
        date: DateTime(2026, 4, 10),
      ),
      TransactionData(
        id: '4',
        title: 'Transporte',
        category: 'transport',
        value: 150,
        type: TransactionType.expense,
        date: DateTime(2026, 4, 9),
      ),
    ],
    categoryBreakdown: [
      CategoryBreakdownData(category: 'food', amount: 300, percentage: (300 / safeDivisor) * 100),
      CategoryBreakdownData(
        category: 'transport',
        amount: 150,
        percentage: (150 / safeDivisor) * 100,
      ),
    ],
  );
}
