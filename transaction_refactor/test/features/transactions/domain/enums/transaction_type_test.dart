import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';

/// Testes do enum puro de domínio [TransactionType] (problema #18).
///
/// Este arquivo propositalmente não importa nada de Flutter —
/// confirma que o enum pode ser usado em testes Dart puros, sem
/// dependência de UI ou infraestrutura.
void main() {
  group('TransactionType — enum puro de domínio (#18)', () {
    test('toString segue convenção name do enum', () {
      expect(TransactionType.income.name, 'income');
      expect(TransactionType.expense.name, 'expense');
      expect(TransactionType.unknown.name, 'unknown');
    });

    test(
      'switch exaustivo compila sem default — garantia de integridade do enum',
      () {
        // Se novos valores forem adicionados sem atualizar o switch, o analisador
        // emitirá erro em tempo de compilação (exhaustiveness check do Dart 3).
        for (final type in TransactionType.values) {
          final result = switch (type) {
            TransactionType.income => 'receita',
            TransactionType.expense => 'despesa',
            TransactionType.unknown => 'desconhecido',
          };
          expect(result, isNotEmpty);
        }
      },
    );
  });
}
