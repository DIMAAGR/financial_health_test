enum ExpenseCategory { food, transport, shopping }

extension ExpenseCategoryCodeExt on ExpenseCategory {
  String get code {
    switch (this) {
      case ExpenseCategory.food:
        return 'food';
      case ExpenseCategory.transport:
        return 'transport';
      case ExpenseCategory.shopping:
        return 'shopping';
    }
  }
}
