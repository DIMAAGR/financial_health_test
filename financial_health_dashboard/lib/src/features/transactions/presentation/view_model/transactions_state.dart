import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

class TransactionsState {
  const TransactionsState({
    required this.balance,
    required this.income,
    required this.expense,
    required this.monthLabel,
    required this.balanceChangePercent,
    required this.transactions,
    required this.status,
    this.errorMessage,
    this.canRetry = false,
  });

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

  final double balance;
  final double income;
  final double expense;
  final String monthLabel;
  final double balanceChangePercent;
  final List<TransactionData> transactions;
  final TransactionsViewStatus status;
  final String? errorMessage;
  final bool canRetry;

  TransactionsState copyWith({
    double? balance,
    double? income,
    double? expense,
    String? monthLabel,
    double? balanceChangePercent,
    List<TransactionData>? transactions,
    TransactionsViewStatus? status,
    String? errorMessage,
    bool? canRetry,
    bool clearError = false,
  }) {
    return TransactionsState(
      balance: balance ?? this.balance,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      monthLabel: monthLabel ?? this.monthLabel,
      balanceChangePercent: balanceChangePercent ?? this.balanceChangePercent,
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      canRetry: canRetry ?? this.canRetry,
    );
  }
}

enum TransactionsViewStatus { initial, loading, success, error }
