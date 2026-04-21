import 'package:financial_health_dashboard/src/shared/data/models/transaction_model.dart';
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
      totalExpense: _requireDouble(json['expense'], field: 'expense'),
      monthLabel: (monthlyGoal['monthLabel'] as String? ?? 'Mês').trim(),
      expenseChangePercent: _requireDouble(
        json['expenseChangePercent'],
        field: 'expenseChangePercent',
      ),
      transactions: transactions,
    );
  }

  final double totalExpense;
  final String monthLabel;
  final double expenseChangePercent;
  final List<TransactionData> transactions;

  static double _requireDouble(Object? value, {required String field}) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Invalid double for field: $field');
  }
}
