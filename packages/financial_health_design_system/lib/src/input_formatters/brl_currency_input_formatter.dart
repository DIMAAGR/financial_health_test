import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BrlCurrencyInputFormatter extends TextInputFormatter {
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

  String formatFromCents(int cents) {
    final safeCents = cents < 0 ? 0 : cents;
    final integer = safeCents ~/ 100;
    final decimal = safeCents % 100;
    final integerText = _decimalFormatter.format(integer);
    final decimalText = decimal.toString().padLeft(2, '0');
    return '$integerText,$decimalText';
  }

  static int parseToCents(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return int.tryParse(digits) ?? 0;
  }
}
