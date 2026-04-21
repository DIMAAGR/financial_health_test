import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_refactor/features/transactions/domain/entities/transaction_entity.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';
import 'package:transaction_refactor/features/transactions/presentation/mappers/transaction_item_mapper.dart';
import 'package:transaction_refactor/features/transactions/presentation/models/transaction_item_view_data.dart';

void main() {
  // ── Fixtures ────────────────────────────────────────────────────────────────

  TransactionEntity entity({
    String id = '1',
    String description = 'Salário',
    int amount = 500000, // R$ 5.000,00
    TransactionType type = TransactionType.income,
  }) => TransactionEntity(id: id, description: description, amount: amount, type: type);

  // ── fromEntity ──────────────────────────────────────────────────────────────

  group('TransactionItemMapper.fromEntity', () {
    test('mapeia id e description corretamente', () {
      final result = TransactionItemMapper.fromEntity(
        entity(id: 'abc', description: 'Conta de luz'),
      );
      expect(result.id, 'abc');
      expect(result.description, 'Conta de luz');
    });

    test('formata amount em centavos como moeda BRL', () {
      // 150000 centavos = R$ 1.500,00
      final result = TransactionItemMapper.fromEntity(entity(amount: 150000));
      expect(result.formattedAmount, contains('1.500'));
    });

    test('formata valores com centavos corretamente', () {
      // 32050 centavos = R$ 320,50
      final result = TransactionItemMapper.fromEntity(entity(amount: 32050));
      expect(result.formattedAmount, contains('320'));
      expect(result.formattedAmount, contains('50'));
    });

    test('retorna ícone de seta para cima para income', () {
      final result = TransactionItemMapper.fromEntity(entity(type: TransactionType.income));
      expect(result.icon, Icons.arrow_upward_rounded);
    });

    test('retorna ícone de seta para baixo para expense', () {
      final result = TransactionItemMapper.fromEntity(entity(type: TransactionType.expense));
      expect(result.icon, Icons.arrow_downward_rounded);
    });

    test('retorna ícone de ajuda para unknown', () {
      final result = TransactionItemMapper.fromEntity(entity(type: TransactionType.unknown));
      expect(result.icon, Icons.help_outline_rounded);
    });

    test('typeLabel "Receita" para income', () {
      final result = TransactionItemMapper.fromEntity(entity(type: TransactionType.income));
      expect(result.typeLabel, 'Receita');
    });

    test('typeLabel "Despesa" para expense', () {
      final result = TransactionItemMapper.fromEntity(entity(type: TransactionType.expense));
      expect(result.typeLabel, 'Despesa');
    });

    test('typeLabel "Desconhecido" para unknown', () {
      final result = TransactionItemMapper.fromEntity(entity(type: TransactionType.unknown));
      expect(result.typeLabel, 'Desconhecido');
    });

    test('preserva type original para lookup de cor', () {
      final result = TransactionItemMapper.fromEntity(entity(type: TransactionType.expense));
      expect(result.type, TransactionType.expense);
    });

    test('retorna instância de TransactionItemViewData', () {
      final result = TransactionItemMapper.fromEntity(entity());
      expect(result, isA<TransactionItemViewData>());
    });
  });

  // ── fromEntities ────────────────────────────────────────────────────────────

  group('TransactionItemMapper.fromEntities', () {
    test('lista vazia retorna lista vazia', () {
      final result = TransactionItemMapper.fromEntities([]);
      expect(result, isEmpty);
    });

    test('preserva ordem e quantidade dos itens', () {
      final entities = [
        entity(id: '1', description: 'Salário', type: TransactionType.income),
        entity(id: '2', description: 'Aluguel', type: TransactionType.expense),
        entity(id: '3', description: 'Freelance', type: TransactionType.income),
      ];

      final result = TransactionItemMapper.fromEntities(entities);

      expect(result.length, 3);
      expect(result[0].id, '1');
      expect(result[1].id, '2');
      expect(result[2].id, '3');
    });

    test('retorna lista imutável (growable: false)', () {
      final result = TransactionItemMapper.fromEntities([entity()]);
      expect(() => result.add(TransactionItemMapper.fromEntity(entity())), throwsUnsupportedError);
    });
  });
}
