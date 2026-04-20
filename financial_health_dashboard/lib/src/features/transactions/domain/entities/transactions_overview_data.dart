import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

class TransactionsOverviewData {
  const TransactionsOverviewData({
    required this.balance,
    required this.income,
    required this.expense,
    required this.monthLabel,
    required this.balanceChangePercent,
    required this.transactions,
  });

  final double balance;
  final double income;
  final double expense;
  final String monthLabel;
  final double balanceChangePercent;
  final List<TransactionData> transactions;
}
