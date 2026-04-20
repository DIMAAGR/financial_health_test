import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_input.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';

class AddDashboardIncomeInput extends AddDashboardInput {
  const AddDashboardIncomeInput({
    required this.category,
    required super.amount,
    required super.title,
  });

  final IncomeCategory category;
}
