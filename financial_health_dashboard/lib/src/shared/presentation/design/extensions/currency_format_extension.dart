import 'package:intl/intl.dart';

extension CurrencyFormatExtension on num {
  String toBRL() {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(this);
  }
}
