import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/add_expense_input.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/expenses_overview_data.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/use_cases/add_expense_use_case.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/use_cases/get_expenses_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit(this._getOverviewUseCase, this._addExpenseUseCase)
    : super(ExpensesState.initial());

  final GetExpensesOverviewUseCase _getOverviewUseCase;
  final AddExpenseUseCase _addExpenseUseCase;

  Future<void> loadOverview() async {
    emit(
      state.copyWith(
        status: ExpensesViewStatus.loading,
        errorMessage: null,
        effect: null,
      ),
    );

    final result = await _getOverviewUseCase();
    result.fold(_setError, _updateContent);
  }

  void onAddExpensePressed() {
    emit(
      state.copyWith(
        effect: ExpensesEffect.showAddExpenseSheet,
        effectVersion: state.effectVersion + 1,
      ),
    );
  }

  void clearEffect() => emit(state.copyWith(effect: null));

  Future<bool> addExpense(AddExpenseInput input) async {
    final result = await _addExpenseUseCase(input);
    return result.fold(
      (failure) {
        _setError(failure);
        return false;
      },
      (_) async {
        await _silentReload();
        return true;
      },
    );
  }

  Future<void> _silentReload() async {
    final result = await _getOverviewUseCase();
    result.fold(_setError, _updateContent);
  }

  void _setError(AppFailure failure) {
    emit(
      state.copyWith(
        status: ExpensesViewStatus.error,
        errorMessage: failure.message,
        canRetry: failure is NetworkFailure || failure is ServerFailure,
        effect: null,
      ),
    );
  }

  void _updateContent(ExpensesOverviewData data) {
    emit(
      ExpensesState(
        totalExpense: data.totalExpense,
        monthLabel: data.monthLabel,
        expenseChangePercent: data.expenseChangePercent,
        transactions: data.transactions,
        categoryBreakdown: data.categoryBreakdown,
        status: ExpensesViewStatus.success,
        effectVersion: state.effectVersion,
      ),
    );
  }
}
