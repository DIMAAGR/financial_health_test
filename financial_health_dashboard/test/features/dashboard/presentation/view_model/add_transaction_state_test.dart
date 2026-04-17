import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_sheet_type.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/add_transaction/add_transaction_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddTransactionState', () {
    test('initial de income começa com categoria de receita', () {
      final state = AddTransactionState.initial(SheetType.income);

      expect(state.amountCents, 0);
      expect(state.description, '');
      expect(state.category, TransactionCategory.salary);
      expect(state.isSubmitting, isFalse);
      expect(state.canSubmit, isFalse);
    });

    test('initial de expense começa com categoria de despesa', () {
      final state = AddTransactionState.initial(SheetType.expense);

      expect(state.amountCents, 0);
      expect(state.description, '');
      expect(state.category, TransactionCategory.food);
      expect(state.isSubmitting, isFalse);
      expect(state.canSubmit, isFalse);
    });

    test('canSubmit é false quando amount é zero mesmo com descrição', () {
      const state = AddTransactionState(
        amountCents: 0,
        description: 'Mercado',
        category: TransactionCategory.food,
      );

      expect(state.canSubmit, isFalse);
    });

    test('canSubmit é false quando descrição só tem espaços', () {
      const state = AddTransactionState(
        amountCents: 100,
        description: '   ',
        category: TransactionCategory.food,
      );

      expect(state.canSubmit, isFalse);
    });

    test('canSubmit é true com amount e descrição válidos', () {
      const state = AddTransactionState(
        amountCents: 100,
        description: 'Mercado',
        category: TransactionCategory.food,
      );

      expect(state.canSubmit, isTrue);
    });

    test('canSubmit é false durante submissão', () {
      const state = AddTransactionState(
        amountCents: 100,
        description: 'Mercado',
        category: TransactionCategory.food,
        isSubmitting: true,
      );

      expect(state.canSubmit, isFalse);
    });

    test('copyWith mantém campos não alterados', () {
      const state = AddTransactionState(
        amountCents: 100,
        description: 'A',
        category: TransactionCategory.shopping,
      );

      final copied = state.copyWith(description: 'B');

      expect(copied.amountCents, 100);
      expect(copied.description, 'B');
      expect(copied.category, TransactionCategory.shopping);
      expect(copied.isSubmitting, isFalse);
    });
  });
}
