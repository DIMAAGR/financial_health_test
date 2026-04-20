import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

class IncomesOverviewData {
  const IncomesOverviewData({
    required this.totalIncome,
    required this.monthLabel,
    required this.incomeChangePercent,
    required this.transactions,
    required this.categoryBreakdown,
  });

  final double totalIncome;
  final String monthLabel;
  final double incomeChangePercent;
  final List<TransactionData> transactions;
  final List<CategoryBreakdownData> categoryBreakdown;
}
