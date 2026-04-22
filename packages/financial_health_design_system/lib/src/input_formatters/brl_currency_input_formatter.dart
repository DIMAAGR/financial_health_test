import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// A [TextInputFormatter] that formats text input as a BRL currency string.
///
/// Strips all non-digit characters from the input, interprets the remaining
/// digits as integer centavos (smallest currency unit), and renders the value
/// using the Brazilian decimal format (period as thousands separator, comma
/// as decimal separator).
///
/// The cursor is always placed at the end of the formatted string.
///
/// ## Usage
/// ```dart
/// TextField(
///   inputFormatters: [BrlCurrencyInputFormatter()],
///   keyboardType: TextInputType.number,
/// )
/// ```
///
/// ## Parsing back to domain values
/// Use [BrlCurrencyInputFormatter.parseToCents] to convert the formatted
/// string back to an integer number of centavos:
/// ```dart
/// final cents = BrlCurrencyInputFormatter.parseToCents('1.240,50'); // 124050
/// ```
class BrlCurrencyInputFormatter extends TextInputFormatter {
  /// Creates a formatter that renders currency in the `pt_BR` locale.
  BrlCurrencyInputFormatter()
    : _decimalFormatter = NumberFormat.decimalPattern('pt_BR');

  final NumberFormat _decimalFormatter;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final cents = int.tryParse(digits.isEmpty ? '0' : digits) ?? 0;
    final formatted = formatFromCents(cents);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
      composing: TextRange.empty,
    );
  }

  /// Converts an integer [cents] value into a formatted BRL string.
  ///
  /// For example, `124050` becomes `"1.240,50"`. Negative values are clamped
  /// to zero.
  String formatFromCents(int cents) {
    final safeCents = cents < 0 ? 0 : cents;
    final integer = safeCents ~/ 100;
    final decimal = safeCents % 100;
    final integerText = _decimalFormatter.format(integer);
    final decimalText = decimal.toString().padLeft(2, '0');
    return '$integerText,$decimalText';
  }

  /// Parses a formatted BRL string back to an integer number of centavos.
  ///
  /// All non-digit characters are stripped before parsing. Returns `0` if the
  /// result cannot be parsed.
  ///
  /// ```dart
  /// BrlCurrencyInputFormatter.parseToCents('1.240,50'); // 124050
  /// BrlCurrencyInputFormatter.parseToCents('');         // 0
  /// ```
  static int parseToCents(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return int.tryParse(digits) ?? 0;
  }
}
