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
    final map = _requireMap(json, field: 'transaction');
    return TransactionModel(
      id: (map['id'] as String? ?? '').trim(),
      title: (map['title'] as String? ?? '').trim(),
      category: (map['category'] as String? ?? '').trim(),
      value: _requireDouble(map['value'], field: 'transaction.value'),
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
    if (json == null) return const [];
    if (json is! List) {
      throw const FormatException('Invalid list for field: transactions');
    }

    return json
        .map(TransactionModel.fromJson)
        .where((item) => item.isValid)
        .map((item) => item.toEntity())
        .toList(growable: false);
  }

  static Map<String, dynamic> _requireMap(
    Object? value, {
    required String field,
  }) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) {
        if (key is! String) {
          throw FormatException('Invalid key type for field: $field');
        }
        return MapEntry(key, value);
      });
    }
    throw FormatException('Invalid map for field: $field');
  }

  static double _requireDouble(Object? value, {required String field}) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Invalid double for field: $field');
  }
}
