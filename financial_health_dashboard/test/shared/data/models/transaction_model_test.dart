import 'package:financial_health_dashboard/src/shared/data/models/transaction_model.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionModel', () {
    test('fromJson converte transação válida', () {
      // Arrange
      final json = {
        'id': 'tx-1',
        'title': 'Salário',
        'category': 'salary',
        'value': '1200.50',
        'type': 'income',
      };

      // Act
      final entity = TransactionModel.fromJson(json).toEntity();

      // Assert
      expect(entity.id, 'tx-1');
      expect(entity.value, 1200.50);
      expect(entity.type, TransactionType.income);
    });

    test(
      'fromJson lança FormatException quando valor financeiro é inválido',
      () {
        // Arrange
        final json = {
          'id': 'tx-1',
          'title': 'Salário',
          'category': 'salary',
          'value': 'not-a-number',
          'type': 'income',
        };

        // Act / Assert
        expect(
          () => TransactionModel.fromJson(json),
          throwsA(isA<FormatException>()),
        );
      },
    );
  });
}
