import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_category.dart';

sealed class AddTransactionSheetResult {
  const AddTransactionSheetResult({
    required this.amount,
    required this.description,
    required this.category,
  });

  final double amount;
  final String description;
  final TransactionCategory category;
}

class AddIncomeSheetResult extends AddTransactionSheetResult {
  AddIncomeSheetResult({
    required super.amount,
    required super.description,
    required super.category,
  });
}

class AddExpenseSheetResult extends AddTransactionSheetResult {
  AddExpenseSheetResult({
    required super.amount,
    required super.description,
    required super.category,
  });
}
