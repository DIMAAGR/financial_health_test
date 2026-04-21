import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_refactor/features/transactions/data/models/transaction_dto.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';

void main() {
  group('TransactionDto.fromJson', () {
    test('deve mapear JSON válido para entidade corretamente', () {
      final json = {'id': '1', 'descricao': 'Salário', 'valor': 500000, 'tipo': 'receita'};

      final entity = TransactionDto.fromJson(json).toEntity();

      expect(entity.id, '1');
      expect(entity.description, 'Salário');
      expect(entity.amount, 500000);
      expect(entity.type, TransactionType.income);
    });

    test('deve mapear "despesa" para TransactionType.expense', () {
      final json = {'id': '2', 'descricao': 'Aluguel', 'valor': 150000, 'tipo': 'despesa'};

      final entity = TransactionDto.fromJson(json).toEntity();

      expect(entity.type, TransactionType.expense);
    });

    test('deve aceitar "valor" como inteiro e preservar como int', () {
      final json = {'id': '3', 'descricao': 'Teste', 'valor': 10000, 'tipo': 'receita'};

      final entity = TransactionDto.fromJson(json).toEntity();

      expect(entity.amount, 10000);
      expect(entity.amount, isA<int>());
    });

    test('deve lançar FormatException quando "valor" é double (não aceita frações)', () {
      final json = {'id': '1', 'descricao': 'Teste', 'valor': 100.50, 'tipo': 'receita'};

      expect(() => TransactionDto.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('deve lançar FormatException quando "id" está ausente', () {
      final json = {'descricao': 'Teste', 'valor': 10000, 'tipo': 'receita'};

      expect(() => TransactionDto.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('deve lançar FormatException quando "id" está vazio', () {
      final json = {'id': '', 'descricao': 'Teste', 'valor': 10000, 'tipo': 'receita'};

      expect(() => TransactionDto.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('deve lançar FormatException quando "descricao" está ausente', () {
      final json = {'id': '1', 'valor': 10000, 'tipo': 'receita'};

      expect(() => TransactionDto.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('deve lançar FormatException quando "valor" está ausente', () {
      final json = {'id': '1', 'descricao': 'Teste', 'tipo': 'receita'};

      expect(() => TransactionDto.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('deve lançar FormatException quando "valor" é string não-numérica', () {
      final json = {'id': '1', 'descricao': 'Teste', 'valor': 'abc', 'tipo': 'receita'};

      expect(() => TransactionDto.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('deve lançar FormatException quando "tipo" está ausente', () {
      final json = {'id': '1', 'descricao': 'Teste', 'valor': 10000};

      expect(() => TransactionDto.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('deve mapear tipo desconhecido para TransactionType.unknown', () {
      final json = {'id': '1', 'descricao': 'Teste', 'valor': 10000, 'tipo': 'tipo_desconhecido'};

      final entity = TransactionDto.fromJson(json).toEntity();

      expect(entity.type, TransactionType.unknown);
    });
  });
}
