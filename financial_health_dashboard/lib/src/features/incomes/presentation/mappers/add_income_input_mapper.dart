import 'package:financial_health_dashboard/src/features/incomes/domain/entities/add_income_input.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';
import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/models/add_transaction_sheet_result.dart';
import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/models/transaction_category.dart';

final class AddIncomeInputMapper {
  const AddIncomeInputMapper._();

  static AddIncomeInput fromSheetResult(AddIncomeSheetResult result) {
    return AddIncomeInput(
      amount: result.amount,
      title: result.description,
      category: _toIncomeCategory(result.category),
    );
  }

  static IncomeCategory _toIncomeCategory(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.salary:
        return IncomeCategory.salary;
      case TransactionCategory.gift:
        return IncomeCategory.gift;
      case TransactionCategory.investment:
        return IncomeCategory.investment;
      case TransactionCategory.food:
      case TransactionCategory.transport:
      case TransactionCategory.shopping:
        throw ArgumentError.value(category, 'category', 'Categoria não é válida para receita.');
    }
  }
}
