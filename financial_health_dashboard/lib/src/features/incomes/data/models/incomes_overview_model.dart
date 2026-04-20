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
      totalIncome: _toDouble(json['income']),
      monthLabel: (monthlyGoal['monthLabel'] as String? ?? 'Mês').trim(),
      incomeChangePercent: _toDouble(json['incomeChangePercent']),
      transactions: transactions,
    );
  }

  final double totalIncome;
  final String monthLabel;
  final double incomeChangePercent;
  final List<TransactionData> transactions;

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
