import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expenses_state.freezed.dart';

@freezed
abstract class ExpensesState with _$ExpensesState {
  const factory ExpensesState({
    required double totalExpense,
    required String monthLabel,
    required double expenseChangePercent,
    required List<TransactionData> transactions,
    required List<CategoryBreakdownData> categoryBreakdown,
    required ExpensesViewStatus status,
    String? errorMessage,
    @Default(false) bool canRetry,
    ExpensesEffect? effect,
    required int effectVersion,
  }) = _ExpensesState;

  factory ExpensesState.initial() {
    return const ExpensesState(
      totalExpense: 0,
      monthLabel: '',
      expenseChangePercent: 0,
      transactions: [],
      categoryBreakdown: [],
      status: ExpensesViewStatus.initial,
      effectVersion: 0,
    );
  }
}

enum ExpensesEffect { showAddExpenseSheet }

enum ExpensesViewStatus { initial, loading, success, error }
