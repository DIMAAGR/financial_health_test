import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

class IncomesState {
  const IncomesState({
    required this.totalIncome,
    required this.monthLabel,
    required this.incomeChangePercent,
    required this.transactions,
    required this.categoryBreakdown,
    required this.status,
    this.errorMessage,
    this.canRetry = false,
    this.effect,
    required this.effectVersion,
  });

  factory IncomesState.initial() {
    return const IncomesState(
      totalIncome: 0,
      monthLabel: '',
      incomeChangePercent: 0,
      transactions: [],
      categoryBreakdown: [],
      status: IncomesViewStatus.initial,
      effectVersion: 0,
    );
  }

  final double totalIncome;
  final String monthLabel;
  final double incomeChangePercent;
  final List<TransactionData> transactions;
  final List<CategoryBreakdownData> categoryBreakdown;
  final IncomesViewStatus status;
  final String? errorMessage;
  final bool canRetry;
  final IncomesEffect? effect;
  final int effectVersion;

  IncomesState copyWith({
    double? totalIncome,
    String? monthLabel,
    double? incomeChangePercent,
    List<TransactionData>? transactions,
    List<CategoryBreakdownData>? categoryBreakdown,
    IncomesViewStatus? status,
    String? errorMessage,
    bool? canRetry,
    bool clearError = false,
    IncomesEffect? effect,
    bool clearEffect = false,
    int? effectVersion,
  }) {
    return IncomesState(
      totalIncome: totalIncome ?? this.totalIncome,
      monthLabel: monthLabel ?? this.monthLabel,
      incomeChangePercent: incomeChangePercent ?? this.incomeChangePercent,
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

enum IncomesEffect { showAddIncomeSheet }

enum IncomesViewStatus { initial, loading, success, error }
