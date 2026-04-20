import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

final class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.value,
    required this.type,
    this.date,
  });

  factory TransactionModel.fromJson(Object? json) {
    final map = _asMap(json);
    return TransactionModel(
      id: (map['id'] as String? ?? '').trim(),
      title: (map['title'] as String? ?? '').trim(),
      category: (map['category'] as String? ?? '').trim(),
      value: _toDouble(map['value']),
      type: (map['type'] as String? ?? '').toLowerCase() == 'expense'
          ? TransactionType.expense
          : TransactionType.income,
      date: DateTime.tryParse(map['date'] as String? ?? ''),
    );
  }

  final String id;
  final String title;
  final String category;
  final double value;
  final TransactionType type;
  final DateTime? date;

  bool get isValid => id.isNotEmpty;

  TransactionData toEntity() {
    return TransactionData(
      id: id,
      title: title,
      category: category,
      value: value,
      type: type,
      date: date,
    );
  }

  static List<TransactionData> listFromJson(Object? json) {
    if (json is! List) return const [];

    return json
        .map(TransactionModel.fromJson)
        .where((item) => item.isValid)
        .map((item) => item.toEntity())
        .toList(growable: false);
  }

  static Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return <String, dynamic>{};
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
