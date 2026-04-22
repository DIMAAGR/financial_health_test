import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

class ExpensesOverviewData {
  const ExpensesOverviewData({
    required this.totalExpense,
    required this.monthLabel,
    required this.expenseChangePercent,
    required this.transactions,
    required this.categoryBreakdown,
  });

  final double totalExpense;
  final String monthLabel;
  final double expenseChangePercent;
  final List<TransactionData> transactions;
  final List<CategoryBreakdownData> categoryBreakdown;
}
