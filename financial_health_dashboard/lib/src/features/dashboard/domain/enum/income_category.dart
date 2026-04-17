enum IncomeCategory { salary, gift, investment }

extension IncomeCategoryCodeExt on IncomeCategory {
  String get code {
    switch (this) {
      case IncomeCategory.salary:
        return 'salary';
      case IncomeCategory.gift:
        return 'gift';
      case IncomeCategory.investment:
        return 'investment';
    }
  }
}
