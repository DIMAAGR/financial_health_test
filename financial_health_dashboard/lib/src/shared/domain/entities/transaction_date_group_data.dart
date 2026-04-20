import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';

class TransactionDateGroupData {
  const TransactionDateGroupData({required this.date, required this.transactions});

  final DateTime date;
  final List<TransactionData> transactions;
}
