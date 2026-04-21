import 'package:financial_health_dashboard/src/shared/data/models/transaction_model.dart';
import 'package:financial_health_dashboard/src/shared/data/parsers/json_parsers.dart';
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
      balance: parseJsonDouble(json['balance']),
      income: parseJsonDouble(json['income']),
      expense: parseJsonDouble(json['expense']),
      monthLabel: (monthlyGoal['monthLabel'] as String? ?? 'Mês').trim(),
      balanceChangePercent: parseJsonDouble(json['balanceChangePercent']),
      transactions: transactions,
    );
  }

  final double balance;
  final double income;
  final double expense;
  final String monthLabel;
  final double balanceChangePercent;
  final List<TransactionData> transactions;
}
