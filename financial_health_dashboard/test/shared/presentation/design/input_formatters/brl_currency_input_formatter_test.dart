import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BrlCurrencyInputFormatter', () {
    final formatter = BrlCurrencyInputFormatter();

    test('formata sequência incremental esperada', () {
      final values = [
        '0',
        '1',
        '10',
        '100',
        '1000',
        '10000',
        '100000',
        '1000000',
      ];
      final expected = [
        '0,00',
        '0,01',
        '0,10',
        '1,00',
        '10,00',
        '100,00',
        '1.000,00',
        '10.000,00',
      ];

      for (var i = 0; i < values.length; i++) {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          TextEditingValue(text: values[i]),
        );
        expect(result.text, expected[i]);
      }
    });

    test('parseToCents ignora caracteres não numéricos', () {
      expect(BrlCurrencyInputFormatter.parseToCents('R\$ 1.234,56'), 123456);
      expect(BrlCurrencyInputFormatter.parseToCents('abc'), 0);
    });
  });
}
