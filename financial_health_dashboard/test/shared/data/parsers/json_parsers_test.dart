import 'package:financial_health_dashboard/src/shared/data/parsers/json_parsers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JsonParsers', () {
    test('toDouble aceita num e String numerica', () {
      // Arrange / Act / Assert
      expect(parseJsonDouble(10), 10);
      expect(parseJsonDouble(10.5), 10.5);
      expect(parseJsonDouble('42.25'), 42.25);
    });

    test('toDouble usa zero para valores invalidos', () {
      // Arrange / Act / Assert
      expect(parseJsonDouble('abc'), 0);
      expect(parseJsonDouble(null), 0);
      expect(parseJsonDouble({'value': 10}), 0);
    });

    test('toInt respeita fallback para valores invalidos', () {
      // Arrange / Act / Assert
      expect(parseJsonInt(7, fallback: 1), 7);
      expect(parseJsonInt('9', fallback: 1), 9);
      expect(parseJsonInt('x', fallback: 1), 1);
    });

    test('toStringKeyMap converte mapas e protege valores invalidos', () {
      // Arrange
      final source = {'amount': 10};

      // Act / Assert
      expect(parseJsonMap(source), source);
      expect(parseJsonMap(null), isEmpty);
    });
  });
}
