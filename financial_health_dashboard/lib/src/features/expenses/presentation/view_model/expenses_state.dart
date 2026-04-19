import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_transaction_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';

class ExpensesState {
  const ExpensesState({
    required this.totalExpense,
    required this.monthLabel,
    required this.expenseChangePercent,
    required this.transactions,
    required this.categoryBreakdown,
    required this.status,
    this.errorMessage,
    this.canRetry = false,
    this.effect,
    required this.effectVersion,
  });

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

  final double totalExpense;
  final String monthLabel;
  final double expenseChangePercent;
  final List<DashboardTransactionData> transactions;
  final List<CategoryBreakdownData> categoryBreakdown;
  final ExpensesViewStatus status;
  final String? errorMessage;
  final bool canRetry;
  final ExpensesEffect? effect;
  final int effectVersion;

  ExpensesState copyWith({
    double? totalExpense,
    String? monthLabel,
    double? expenseChangePercent,
    List<DashboardTransactionData>? transactions,
    List<CategoryBreakdownData>? categoryBreakdown,
    ExpensesViewStatus? status,
    String? errorMessage,
    bool? canRetry,
    bool clearError = false,
    ExpensesEffect? effect,
    bool clearEffect = false,
    int? effectVersion,
  }) {
    return ExpensesState(
      totalExpense: totalExpense ?? this.totalExpense,
      monthLabel: monthLabel ?? this.monthLabel,
      expenseChangePercent: expenseChangePercent ?? this.expenseChangePercent,
      transactions: transactions ?? this.transactions,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      canRetry: canRetry ?? this.canRetry,
      effect: clearEffect ? null : (effect ?? this.effect),
      effectVersion: effectVersion ?? this.effectVersion,
    );
  }
}

enum ExpensesEffect { showAddExpenseSheet }

enum ExpensesViewStatus { initial, loading, success, error }
