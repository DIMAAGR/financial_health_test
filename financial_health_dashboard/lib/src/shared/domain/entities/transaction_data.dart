enum TransactionType { income, expense }

class TransactionData {
  const TransactionData({
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
  final TransactionType type;
  final DateTime? date;
}
