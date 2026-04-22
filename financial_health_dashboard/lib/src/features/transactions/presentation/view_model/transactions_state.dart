import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions_state.freezed.dart';

@freezed
abstract class TransactionsState with _$TransactionsState {
  const factory TransactionsState({
    required double balance,
    required double income,
    required double expense,
    required String monthLabel,
    required double balanceChangePercent,
    required List<TransactionData> transactions,
    required TransactionsViewStatus status,
    String? errorMessage,
    @Default(false) bool canRetry,
  }) = _TransactionsState;

  factory TransactionsState.initial() {
    return const TransactionsState(
      balance: 0,
      income: 0,
      expense: 0,
      monthLabel: '',
      balanceChangePercent: 0,
      transactions: [],
      status: TransactionsViewStatus.initial,
    );
  }
}

enum TransactionsViewStatus { initial, loading, success, error }
