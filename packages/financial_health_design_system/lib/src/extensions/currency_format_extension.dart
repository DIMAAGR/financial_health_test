import 'package:intl/intl.dart';

/// Extension on [num] for BRL (Brazilian Real) currency formatting.
///
/// Adds [toBRL] to any numeric type, returning a locale-aware string
/// formatted as Brazilian Real using `intl`.
///
/// ## Usage
/// ```dart
/// // With currency symbol:
/// final label = 1240.50.toBRL(); // "R$\u00a01.240,50"
///
/// // Without symbol (e.g., for display inside a card that already shows the
/// // currency context):
/// final plain = 1240.50.toBRL(true); // "1.240,50"
/// ```
extension CurrencyFormatExtension on num {
  /// Formats this number as a BRL currency string.
  ///
  /// [removeSymbol] controls whether the `R$` prefix is included in the output.
  /// Defaults to `false` (symbol is shown).
  String toBRL([bool removeSymbol = false]) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: removeSymbol ? '' : 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(this);
  }
}
