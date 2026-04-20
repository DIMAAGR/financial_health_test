import 'package:financial_health_dashboard/src/core/services/storage/storage_schema.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StorageSchema', () {
    test('version começa em 1', () {
      expect(StorageSchema.version, 1);
    });

    test('chaves usam sufixo de versão para evitar conflito de migração', () {
      expect(StorageSchema.financialOverviewKey, 'financial_overview_v1');
      expect(
        StorageSchema.financialTransactionsKey,
        'financial_transactions_v1',
      );
    });
  });
}
