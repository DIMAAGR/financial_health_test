import 'package:financial_health_dashboard/src/features/dashboard/presentation/mappers/add_transaction_input_mapper.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/add_transaction_sheet_result.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/expense_category.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddTransactionInputMapper', () {
    test('converte resultado de receita para input de domínio tipado', () {
      final result = AddIncomeSheetResult(
        amount: 1200,
        description: 'Freelance',
        category: TransactionCategory.investment,
      );

      final input = AddTransactionInputMapper.toIncomeInput(result);

      expect(input.amount, 1200);
      expect(input.title, 'Freelance');
      expect(input.category, IncomeCategory.investment);
    });

    test('converte resultado de despesa para input de domínio tipado', () {
      final result = AddExpenseSheetResult(
        amount: 180,
        description: 'Mercado',
        category: TransactionCategory.food,
      );

      final input = AddTransactionInputMapper.toExpenseInput(result);

      expect(input.amount, 180);
      expect(input.title, 'Mercado');
      expect(input.category, ExpenseCategory.food);
    });

    test('falha ao tentar mapear categoria de despesa como receita', () {
      final result = AddIncomeSheetResult(
        amount: 1200,
        description: 'Freelance',
        category: TransactionCategory.food,
      );

      expect(() => AddTransactionInputMapper.toIncomeInput(result), throwsA(isA<ArgumentError>()));
    });

    test('falha ao tentar mapear categoria de receita como despesa', () {
      final result = AddExpenseSheetResult(
        amount: 180,
        description: 'Mercado',
        category: TransactionCategory.salary,
      );

      expect(() => AddTransactionInputMapper.toExpenseInput(result), throwsA(isA<ArgumentError>()));
    });
  });
}
