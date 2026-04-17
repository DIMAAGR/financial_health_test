import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_expense_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_income_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/income_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/add_transaction_sheet_result.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_category.dart';

final class AddTransactionInputMapper {
  const AddTransactionInputMapper._();

  static AddDashboardIncomeInput toIncomeInput(AddIncomeSheetResult result) {
    return AddDashboardIncomeInput(
      amount: result.amount,
      title: result.description,
      category: _toIncomeCategory(result.category),
    );
  }

  static AddDashboardExpenseInput toExpenseInput(AddExpenseSheetResult result) {
    return AddDashboardExpenseInput(
      amount: result.amount,
      title: result.description,
      category: _toExpenseCategory(result.category),
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
        throw ArgumentError.value(
          category,
          'category',
          'Categoria não é válida para receita.',
        );
    }
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
        throw ArgumentError.value(
          category,
          'category',
          'Categoria não é válida para despesa.',
        );
    }
  }
}
