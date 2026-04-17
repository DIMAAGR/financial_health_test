import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_sheet_type.dart';

class AddTransactionState {
  const AddTransactionState({
    required this.amountCents,
    required this.description,
    required this.category,
    this.isSubmitting = false,
  });

  factory AddTransactionState.initial(SheetType type) {
    return AddTransactionState(
      amountCents: 0,
      description: '',
      category: type == SheetType.income
          ? TransactionCategory.salary
          : TransactionCategory.food,
    );
  }

  final int amountCents;
  final String description;
  final TransactionCategory category;
  final bool isSubmitting;

  bool get canSubmit =>
      !isSubmitting && amountCents > 0 && description.trim().isNotEmpty;

  AddTransactionState copyWith({
    int? amountCents,
    String? description,
    TransactionCategory? category,
    bool? isSubmitting,
  }) {
    return AddTransactionState(
      amountCents: amountCents ?? this.amountCents,
      description: description ?? this.description,
      category: category ?? this.category,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
