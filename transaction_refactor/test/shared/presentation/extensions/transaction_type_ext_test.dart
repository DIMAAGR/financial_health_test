import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';
import 'package:transaction_refactor/shared/presentation/extensions/transaction_type_ext.dart';

/// Testes da extension de apresentação [TransactionTypePresenter] (problemas #18, #24).
///
/// Verifica que ícones e labels estão mapeados corretamente, que nenhum tipo
/// é silenciosamente ignorado e que todos os identificadores seguem inglês.
void main() {
  group('TransactionTypePresenter.icon (#18)', () {
    test('income → Icons.arrow_upward_rounded', () {
      expect(TransactionType.income.icon, Icons.arrow_upward_rounded);
    });

    test('expense → Icons.arrow_downward_rounded', () {
      expect(TransactionType.expense.icon, Icons.arrow_downward_rounded);
    });

    test('unknown → Icons.help_outline_rounded', () {
      expect(TransactionType.unknown.icon, Icons.help_outline_rounded);
    });

    test('todos os tipos retornam um ícone não-nulo', () {
      for (final type in TransactionType.values) {
        expect(type.icon, isNotNull, reason: 'Tipo $type não tem ícone mapeado');
      }
    });

    test('tipos diferentes retornam ícones diferentes', () {
      final icons = TransactionType.values.map((t) => t.icon).toSet();
      expect(
        icons.length,
        TransactionType.values.length,
        reason: 'Cada tipo deve ter ícone exclusivo',
      );
    });
  });

  group('TransactionTypePresenter.label (#18, #24)', () {
    test('income → "Receita"', () {
      expect(TransactionType.income.label, 'Receita');
    });

    test('expense → "Despesa"', () {
      expect(TransactionType.expense.label, 'Despesa');
    });

    test('unknown → "Desconhecido"', () {
      expect(TransactionType.unknown.label, 'Desconhecido');
    });

    test('todos os tipos retornam label não-vazio', () {
      for (final type in TransactionType.values) {
        expect(type.label, isNotEmpty, reason: 'Tipo $type não tem label mapeado');
      }
    });

    test('tipos diferentes retornam labels diferentes', () {
      final labels = TransactionType.values.map((t) => t.label).toSet();
      expect(
        labels.length,
        TransactionType.values.length,
        reason: 'Cada tipo deve ter label exclusivo',
      );
    });
  });
}
