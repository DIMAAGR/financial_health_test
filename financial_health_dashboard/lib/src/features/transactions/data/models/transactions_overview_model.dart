import 'package:financial_health_dashboard/src/shared/data/models/transaction_model.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

class TransactionsOverviewModel {
  const TransactionsOverviewModel({
    required this.balance,
    required this.income,
    required this.expense,
    required this.monthLabel,
    required this.balanceChangePercent,
    required this.transactions,
  });

  factory TransactionsOverviewModel.fromJson(Map<String, dynamic> json) {
    final monthlyGoal =
        json['monthlyGoal'] as Map<String, dynamic>? ?? const {};
    final transactions = TransactionModel.listFromJson(json['transactions']);

    return TransactionsOverviewModel(
      balance: _toDouble(json['balance']),
      income: _toDouble(json['income']),
      expense: _toDouble(json['expense']),
      monthLabel: (monthlyGoal['monthLabel'] as String? ?? 'Mês').trim(),
      balanceChangePercent: _toDouble(json['balanceChangePercent']),
      transactions: transactions,
    );
  }

  final double balance;
  final double income;
  final double expense;
  final String monthLabel;
  final double balanceChangePercent;
  final List<TransactionData> transactions;

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
