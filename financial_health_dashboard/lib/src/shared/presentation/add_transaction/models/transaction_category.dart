enum TransactionCategory { salary, gift, investment, food, transport, shopping }

extension TransactionCategoryPresentationExt on TransactionCategory {
  bool get isIncome {
    switch (this) {
      case TransactionCategory.salary:
      case TransactionCategory.gift:
      case TransactionCategory.investment:
        return true;
      case TransactionCategory.food:
      case TransactionCategory.transport:
      case TransactionCategory.shopping:
        return false;
    }
  }

  bool get isExpense => !isIncome;

  String get label {
    switch (this) {
      case TransactionCategory.salary:
        return 'Salário';
      case TransactionCategory.gift:
        return 'Presente';
      case TransactionCategory.investment:
        return 'Investimento';
      case TransactionCategory.food:
        return 'Alimentação';
      case TransactionCategory.transport:
        return 'Transporte';
      case TransactionCategory.shopping:
        return 'Compras';
    }
  }
}
