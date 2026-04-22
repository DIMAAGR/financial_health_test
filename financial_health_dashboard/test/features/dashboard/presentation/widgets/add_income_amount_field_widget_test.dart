import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddIncome amount TextField', () {
    testWidgets('formata sequência 0,00 -> 0,01 -> 0,10 -> 1,00...', (
      tester,
    ) async {
      final controller = TextEditingController(text: '0,00');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              key: const Key('amount-field'),
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                BrlCurrencyInputFormatter(),
              ],
            ),
          ),
        ),
      );

      final fieldFinder = find.byKey(const Key('amount-field'));

      await tester.enterText(fieldFinder, '0');
      await tester.pump();
      expect(controller.text, '0,00');

      await tester.enterText(fieldFinder, '1');
      await tester.pump();
      expect(controller.text, '0,01');

      await tester.enterText(fieldFinder, '10');
      await tester.pump();
      expect(controller.text, '0,10');

      await tester.enterText(fieldFinder, '100');
      await tester.pump();
      expect(controller.text, '1,00');

      await tester.enterText(fieldFinder, '1000');
      await tester.pump();
      expect(controller.text, '10,00');

      await tester.enterText(fieldFinder, '10000');
      await tester.pump();
      expect(controller.text, '100,00');

      await tester.enterText(fieldFinder, '100000');
      await tester.pump();
      expect(controller.text, '1.000,00');

      await tester.enterText(fieldFinder, '1000000');
      await tester.pump();
      expect(controller.text, '10.000,00');
    });

    testWidgets('quando vazio permanece 0,00', (tester) async {
      final controller = TextEditingController(text: '0,00');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              key: const Key('amount-field-empty'),
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                BrlCurrencyInputFormatter(),
              ],
            ),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('amount-field-empty')), '');
      await tester.pump();

      expect(controller.text, '0,00');
    });
  });
}
