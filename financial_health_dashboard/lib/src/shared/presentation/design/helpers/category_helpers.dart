import 'package:financial_health_dashboard/src/shared/presentation/design/assets/icons.dart';

const _categoryLabels = <String, String>{
  'salary': 'Salário',
  'services': 'Serviços',
  'freelance': 'Freelance',
  'investment': 'Investimento',
  'food': 'Alimentação',
  'transport': 'Transporte',
  'shopping': 'Compras',
  'housing': 'Moradia',
  'other': 'Outros',
};

String categoryLabel(String code) {
  return _categoryLabels[code.toLowerCase()] ?? code;
}

String categoryIcon(String code) {
  switch (code.toLowerCase()) {
    case 'salary':
    case 'housing':
      return AppIcons.wallet;
    case 'services':
    case 'freelance':
    case 'transport':
      return AppIcons.money;
    case 'investment':
    case 'food':
    case 'shopping':
      return AppIcons.bag;
    case 'gift':
      return AppIcons.gift;
    default:
      return AppIcons.money;
  }
}
