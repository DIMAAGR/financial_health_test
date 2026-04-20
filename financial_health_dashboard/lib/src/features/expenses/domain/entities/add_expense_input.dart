import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';

class AddExpenseInput {
  const AddExpenseInput({required this.amount, required this.title, required this.category});

  final double amount;
  final String title;
  final ExpenseCategory category;

  String get normalizedTitle => title.trim();
}
