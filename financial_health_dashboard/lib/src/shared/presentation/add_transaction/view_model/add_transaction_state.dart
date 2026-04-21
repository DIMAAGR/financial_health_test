import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/models/transaction_category.dart';
import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/models/transaction_sheet_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_transaction_state.freezed.dart';

@freezed
abstract class AddTransactionState with _$AddTransactionState {
  const AddTransactionState._();

  const factory AddTransactionState({
    required int amountCents,
    required String description,
    required TransactionCategory category,
    @Default(false) bool isSubmitting,
  }) = _AddTransactionState;

  factory AddTransactionState.initial(SheetType type) {
    return AddTransactionState(
      amountCents: 0,
      description: '',
      category: type == SheetType.income
          ? TransactionCategory.salary
          : TransactionCategory.food,
    );
  }

  bool get canSubmit =>
      !isSubmitting && amountCents > 0 && description.trim().isNotEmpty;
}
