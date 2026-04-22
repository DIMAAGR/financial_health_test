import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';

class AddIncomeInput {
  const AddIncomeInput({required this.amount, required this.title, required this.category});

  final double amount;
  final String title;
  final IncomeCategory category;

  String get normalizedTitle => title.trim();
}
