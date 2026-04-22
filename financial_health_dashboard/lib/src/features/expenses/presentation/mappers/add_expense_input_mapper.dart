import 'package:financial_health_dashboard/src/features/expenses/domain/entities/add_expense_input.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/models/add_transaction_sheet_result.dart';
import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/models/transaction_category.dart';

final class AddExpenseInputMapper {
  const AddExpenseInputMapper._();

  static AddExpenseInput fromSheetResult(AddExpenseSheetResult result) {
    return AddExpenseInput(
      amount: result.amount,
      title: result.description,
      category: _toExpenseCategory(result.category),
    );
  }

  static ExpenseCategory _toExpenseCategory(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food:
        return ExpenseCategory.food;
      case TransactionCategory.transport:
        return ExpenseCategory.transport;
      case TransactionCategory.shopping:
        return ExpenseCategory.shopping;
      case TransactionCategory.salary:
      case TransactionCategory.gift:
      case TransactionCategory.investment:
        throw ArgumentError.value(category, 'category', 'Categoria não é válida para despesa.');
    }
  }
}
