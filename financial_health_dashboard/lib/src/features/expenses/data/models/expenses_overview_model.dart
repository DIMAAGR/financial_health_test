import 'package:financial_health_dashboard/src/shared/data/models/transaction_model.dart';
import 'package:financial_health_dashboard/src/shared/data/parsers/json_parsers.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

class ExpensesOverviewModel {
  const ExpensesOverviewModel({
    required this.totalExpense,
    required this.monthLabel,
    required this.expenseChangePercent,
    required this.transactions,
  });

  factory ExpensesOverviewModel.fromJson(Map<String, dynamic> json) {
    final monthlyGoal =
        json['monthlyGoal'] as Map<String, dynamic>? ?? const {};
    final transactions = TransactionModel.listFromJson(json['transactions'])
        .where(
          (item) => item.id.isNotEmpty && item.type == TransactionType.expense,
        )
        .toList(growable: false);

    return ExpensesOverviewModel(
      totalExpense: parseJsonDouble(json['expense']),
      monthLabel: (monthlyGoal['monthLabel'] as String? ?? 'Mês').trim(),
      expenseChangePercent: parseJsonDouble(json['expenseChangePercent']),
      transactions: transactions,
    );
  }

  final double totalExpense;
  final String monthLabel;
  final double expenseChangePercent;
  final List<TransactionData> transactions;
}
