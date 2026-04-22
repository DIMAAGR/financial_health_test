import 'package:financial_health_design_system/src/assets/icons.dart';

// Internal mapping of category code to display label.
// Keeping this private avoids polluting the public API with the raw map.
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

/// Returns the human-readable display label for a category [code].
///
/// [code] is case-insensitive (e.g., `"salary"` and `"Salary"` both resolve).
/// Falls back to [code] itself when no mapping is found, so unknown categories
/// are always displayable.
///
/// ## Usage
/// ```dart
/// Text(categoryLabel('salary')); // "Salário"
/// Text(categoryLabel('FOOD'));   // "Alimentação"
/// ```
String categoryLabel(String code) {
  return _categoryLabels[code.toLowerCase()] ?? code;
}

/// Returns the [AppIcons] asset path for a category [code].
///
/// Categories are mapped to semantically appropriate icons:
/// - `salary`, `housing` → wallet icon
/// - `services`, `freelance`, `transport` → money icon
/// - `investment`, `food`, `shopping` → bag icon
/// - `gift` → gift icon
/// - All other codes → money icon (safe fallback)
///
/// [code] is case-insensitive.
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
