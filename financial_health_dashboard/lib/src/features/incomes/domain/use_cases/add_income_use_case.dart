import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/add_income_input.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/repositories/incomes_repository.dart';

class AddIncomeUseCase {
  const AddIncomeUseCase(this._repository);

  final IncomesRepository _repository;

  Future<Either<AppFailure, void>> call(AddIncomeInput data) async {
    if (data.amount <= 0) {
      return left(const AmountValueFailure());
    }
    if (data.normalizedTitle.isEmpty) {
      return left(const ValidationFailure('Descrição é obrigatória.'));
    }

    return _repository.addIncome(
      amount: data.amount,
      title: data.normalizedTitle,
      category: data.category,
    );
  }
}
