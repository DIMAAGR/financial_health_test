import 'package:intl/intl.dart';

extension CurrencyFormatExtension on num {
  String toBRL([bool removeSymbol = false]) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: removeSymbol ? '' : 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(this);
  }
}
