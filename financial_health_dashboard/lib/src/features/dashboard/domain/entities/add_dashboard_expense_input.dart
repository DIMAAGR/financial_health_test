import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/expense_category.dart';

class AddDashboardExpenseInput extends AddDashboardInput {
  const AddDashboardExpenseInput({
    required this.category,
    required super.amount,
    required super.title,
  });

  final ExpenseCategory category;
}
