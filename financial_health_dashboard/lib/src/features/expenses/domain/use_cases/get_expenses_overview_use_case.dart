import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_transaction_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/failures/dashboard_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/expenses_overview_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';

class GetExpensesOverviewUseCase {
  const GetExpensesOverviewUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<DashboardFailure, ExpensesOverviewData>> call() async {
    final result = await _repository.getOverview();
    return result.map((overview) {
      final expenseTransactions = overview.transactions
          .where((t) => t.type == DashboardTransactionType.expense)
          .toList(growable: false);

      final categoryBreakdown = _buildCategoryBreakdown(expenseTransactions, overview.expense);

      return ExpensesOverviewData(
        totalExpense: overview.expense,
        monthLabel: overview.monthlyGoal.monthLabel,
        expenseChangePercent: overview.expenseChangePercent,
        transactions: expenseTransactions,
        categoryBreakdown: categoryBreakdown,
      );
    });
  }

  List<CategoryBreakdownData> _buildCategoryBreakdown(
    List<DashboardTransactionData> transactions,
    double totalExpense,
  ) {
    final grouped = <String, double>{};
    for (final t in transactions) {
      grouped[t.category] = (grouped[t.category] ?? 0) + t.value;
    }

    final safeDivisor = totalExpense <= 0 ? 1.0 : totalExpense;
    final entries = grouped.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return entries
        .map(
          (e) => CategoryBreakdownData(
            category: e.key,
            amount: e.value,
            percentage: (e.value / safeDivisor) * 100,
          ),
        )
        .toList(growable: false);
  }
}
