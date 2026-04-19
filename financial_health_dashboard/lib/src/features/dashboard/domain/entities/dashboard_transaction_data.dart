enum DashboardTransactionType { income, expense }

class DashboardTransactionData {
  const DashboardTransactionData({
    required this.id,
    required this.title,
    required this.category,
    required this.value,
    required this.type,
    this.date,
  });

  final String id;
  final String title;
  final String category;
  final double value;
  final DashboardTransactionType type;
  final DateTime? date;
}
