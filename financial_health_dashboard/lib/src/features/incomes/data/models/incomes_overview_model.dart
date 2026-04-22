import 'package:financial_health_dashboard/src/shared/data/models/transaction_model.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

class IncomesOverviewModel {
  const IncomesOverviewModel({
    required this.totalIncome,
    required this.monthLabel,
    required this.incomeChangePercent,
    required this.transactions,
  });

  factory IncomesOverviewModel.fromJson(Map<String, dynamic> json) {
    final monthlyGoal =
        json['monthlyGoal'] as Map<String, dynamic>? ?? const {};
    final transactions = TransactionModel.listFromJson(json['transactions'])
        .where(
          (item) => item.id.isNotEmpty && item.type == TransactionType.income,
        )
        .toList(growable: false);

    return IncomesOverviewModel(
      totalIncome: _requireDouble(json['income'], field: 'income'),
      monthLabel: (monthlyGoal['monthLabel'] as String? ?? 'Mês').trim(),
      incomeChangePercent: _requireDouble(
        json['incomeChangePercent'],
        field: 'incomeChangePercent',
      ),
      transactions: transactions,
    );
  }

  final double totalIncome;
  final String monthLabel;
  final double incomeChangePercent;
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
