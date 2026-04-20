import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

final class CategoryBreakdownService {
  const CategoryBreakdownService();

  List<CategoryBreakdownData> build({
    required List<TransactionData> transactions,
    required double totalAmount,
  }) {
    final grouped = <String, double>{};
    for (final transaction in transactions) {
      grouped[transaction.category] =
          (grouped[transaction.category] ?? 0) + transaction.value;
    }

    final safeDivisor = totalAmount <= 0 ? 1.0 : totalAmount;
    final entries = grouped.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return entries
        .map(
          (entry) => CategoryBreakdownData(
            category: entry.key,
            amount: entry.value,
            percentage: (entry.value / safeDivisor) * 100,
          ),
        )
        .toList(growable: false);
  }
}
