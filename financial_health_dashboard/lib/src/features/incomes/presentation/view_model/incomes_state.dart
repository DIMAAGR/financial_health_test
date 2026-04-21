import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'incomes_state.freezed.dart';

@freezed
abstract class IncomesState with _$IncomesState {
  const factory IncomesState({
    required double totalIncome,
    required String monthLabel,
    required double incomeChangePercent,
    required List<TransactionData> transactions,
    required List<CategoryBreakdownData> categoryBreakdown,
    required IncomesViewStatus status,
    String? errorMessage,
    @Default(false) bool canRetry,
    IncomesEffect? effect,
    required int effectVersion,
  }) = _IncomesState;

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
}

enum IncomesEffect { showAddIncomeSheet }

enum IncomesViewStatus { initial, loading, success, error }
