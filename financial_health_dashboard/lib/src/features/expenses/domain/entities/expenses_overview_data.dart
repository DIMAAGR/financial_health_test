import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_transaction_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';

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
  final List<DashboardTransactionData> transactions;
  final List<CategoryBreakdownData> categoryBreakdown;
}
