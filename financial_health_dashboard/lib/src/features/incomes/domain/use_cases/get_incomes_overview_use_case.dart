import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_transaction_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/failures/dashboard_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/incomes_overview_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';

class GetIncomesOverviewUseCase {
  const GetIncomesOverviewUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<DashboardFailure, IncomesOverviewData>> call() async {
    final result = await _repository.getOverview();
    return result.map((overview) {
      final incomeTransactions = overview.transactions
          .where((t) => t.type == DashboardTransactionType.income)
          .toList(growable: false);

      final categoryBreakdown = _buildCategoryBreakdown(incomeTransactions, overview.income);

      return IncomesOverviewData(
        totalIncome: overview.income,
        monthLabel: overview.monthlyGoal.monthLabel,
        incomeChangePercent: overview.incomeChangePercent,
        transactions: incomeTransactions,
        categoryBreakdown: categoryBreakdown,
      );
    });
  }

  List<CategoryBreakdownData> _buildCategoryBreakdown(
    List<DashboardTransactionData> transactions,
    double totalIncome,
  ) {
    final grouped = <String, double>{};
    for (final t in transactions) {
      grouped[t.category] = (grouped[t.category] ?? 0) + t.value;
    }

    final safeDivisor = totalIncome <= 0 ? 1.0 : totalIncome;
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
