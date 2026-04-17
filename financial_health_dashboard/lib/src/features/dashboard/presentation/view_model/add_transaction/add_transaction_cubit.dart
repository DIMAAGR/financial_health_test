import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/add_transaction_sheet_result.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_sheet_type.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/add_transaction/add_transaction_state.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/input_formatters/brl_currency_input_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit(this.type) : super(AddTransactionState.initial(type));

  final SheetType type;

  void onAmountChanged(String formattedAmount) {
    final cents = BrlCurrencyInputFormatter.parseToCents(formattedAmount);
    emit(state.copyWith(amountCents: cents));
  }

  void onDescriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void onCategorySelected(TransactionCategory category) {
    emit(state.copyWith(category: category));
  }

  Future<AddTransactionSheetResult?> submit() async {
    if (!state.canSubmit) return null;
    emit(state.copyWith(isSubmitting: true));

    final result = type == SheetType.income
        ? AddIncomeSheetResult(
            amount: state.amountCents / 100,
            category: state.category,
            description: state.description.trim(),
          )
        : AddExpenseSheetResult(
            amount: state.amountCents / 100,
            category: state.category,
            description: state.description.trim(),
          );

    return result;
  }

  void resetSubmitting() {
    emit(state.copyWith(isSubmitting: false));
  }
}
