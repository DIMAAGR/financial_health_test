import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/add_transaction_sheet_result.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_sheet_type.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/add_transaction/add_transaction_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddTransactionCubit', () {
    test('income começa com categoria salary', () {
      final cubit = AddTransactionCubit(SheetType.income);

      expect(cubit.type, SheetType.income);
      expect(cubit.state.category, TransactionCategory.salary);
      expect(cubit.state.canSubmit, isFalse);

      cubit.close();
    });

    test('expense começa com categoria food', () {
      final cubit = AddTransactionCubit(SheetType.expense);

      expect(cubit.type, SheetType.expense);
      expect(cubit.state.category, TransactionCategory.food);
      expect(cubit.state.canSubmit, isFalse);

      cubit.close();
    });

    test('onAmountChanged parseia texto monetário com máscara', () {
      final cubit = AddTransactionCubit(SheetType.income)..onAmountChanged('R\$ 1.234,56');

      expect(cubit.state.amountCents, 123456);
      cubit.close();
    });

    test('onDescriptionChanged com espaços mantém submit inválido', () {
      final cubit = AddTransactionCubit(SheetType.income)
        ..onAmountChanged('10,00')
        ..onDescriptionChanged('   ');

      expect(cubit.state.amountCents, 1000);
      expect(cubit.state.canSubmit, isFalse);
      cubit.close();
    });

    test('onCategorySelected atualiza categoria atual sem booleano', () {
      final cubit = AddTransactionCubit(SheetType.expense)
        ..onCategorySelected(TransactionCategory.shopping);

      expect(cubit.state.category, TransactionCategory.shopping);
      cubit.close();
    });

    test('submit inválido retorna null sem travar', () async {
      final cubit = AddTransactionCubit(SheetType.income);

      final result = await cubit.submit();

      expect(result, isNull);
      expect(cubit.state.isSubmitting, isFalse);
      await cubit.close();
    });

    test('submit de income retorna AddIncomeSheetResult', () async {
      final cubit = AddTransactionCubit(SheetType.income)
        ..onAmountChanged('10,00')
        ..onDescriptionChanged('Salário mensal')
        ..onCategorySelected(TransactionCategory.investment);

      final result = await cubit.submit();

      expect(result, isA<AddIncomeSheetResult>());
      expect(result?.amount, 10);
      expect(result?.description, 'Salário mensal');
      expect(result?.category, TransactionCategory.investment);
      expect(cubit.state.isSubmitting, isTrue);
      await cubit.close();
    });

    test('submit de expense retorna AddExpenseSheetResult', () async {
      final cubit = AddTransactionCubit(SheetType.expense)
        ..onAmountChanged('25,00')
        ..onDescriptionChanged('Mercado')
        ..onCategorySelected(TransactionCategory.shopping);

      final result = await cubit.submit();

      expect(result, isA<AddExpenseSheetResult>());
      expect(result?.amount, 25);
      expect(result?.description, 'Mercado');
      expect(result?.category, TransactionCategory.shopping);
      expect(cubit.state.isSubmitting, isTrue);
      await cubit.close();
    });

    test('resetSubmitting libera botão após falha', () async {
      final cubit = AddTransactionCubit(SheetType.income)
        ..onAmountChanged('10,00')
        ..onDescriptionChanged('Salário mensal');

      await cubit.submit();
      expect(cubit.state.isSubmitting, isTrue);

      cubit.resetSubmitting();
      expect(cubit.state.isSubmitting, isFalse);
      await cubit.close();
    });
  });
}
