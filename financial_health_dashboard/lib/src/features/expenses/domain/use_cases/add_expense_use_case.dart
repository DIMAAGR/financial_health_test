import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/entities/add_expense_input.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/repositories/expenses_repository.dart';

class AddExpenseUseCase {
  const AddExpenseUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<AppFailure, void>> call(AddExpenseInput data) async {
    if (data.amount <= 0) {
      return left(const AmountValueFailure());
    }
    if (data.normalizedTitle.isEmpty) {
      return left(const ValidationFailure('Descrição é obrigatória.'));
    }

    return _repository.addExpense(
      amount: data.amount,
      title: data.normalizedTitle,
      category: data.category,
    );
  }
}
