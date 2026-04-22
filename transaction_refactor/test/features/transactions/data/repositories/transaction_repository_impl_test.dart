import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_refactor/core/failures/app_failure.dart';
import 'package:transaction_refactor/core/failures/failure_handler.dart';
import 'package:transaction_refactor/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:transaction_refactor/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:transaction_refactor/features/transactions/domain/entities/transaction_entity.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';

// ── Mock manual do datasource ──────────────────────────────────────────────

class _MockDataSource implements TransactionRemoteDataSource {
  List<TransactionEntity>? _result;
  Exception? _error;

  void mockSuccess(List<TransactionEntity> entities) {
    _result = entities;
    _error = null;
  }

  void mockThrows(Exception e) {
    _error = e;
    _result = null;
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    if (_error != null) throw _error!;
    return _result!;
  }
}

// ── Fixture ───────────────────────────────────────────────────────────────

final _tEntity = TransactionEntity(
  id: '1',
  description: 'Salário',
  amount: 5000,
  type: TransactionType.income,
);

void main() {
  late _MockDataSource dataSource;
  late TransactionRepositoryImpl sut;

  setUp(() {
    dataSource = _MockDataSource();
    sut = TransactionRepositoryImpl(dataSource);
  });

  group('TransactionRepositoryImpl', () {
    test('deve retornar Right com lista quando datasource tem sucesso', () async {
      dataSource.mockSuccess([_tEntity]);

      final result = await sut.getTransactions();

      result.fold((f) => fail('Esperava Right, obteve Left($f)'), (list) {
        expect(list.length, 1);
        expect(list.first.id, '1');
        expect(list.first.type, TransactionType.income);
      });
    });

    test('deve retornar Right com lista vazia quando datasource retorna vazio', () async {
      dataSource.mockSuccess([]);

      final result = await sut.getTransactions();

      result.fold((f) => fail('Esperava Right, obteve Left($f)'), (list) => expect(list, isEmpty));
    });

    test('deve retornar Left(NetworkFailure) quando datasource lança SocketException', () async {
      dataSource.mockThrows(const SocketException('Sem rede'));

      final result = await sut.getTransactions();

      expect(result.isLeft(), isTrue);
      result.fold((f) => expect(f, isA<NetworkFailure>()), (_) => fail('Esperava Left'));
    });

    test('deve retornar Left(ParseFailure) quando datasource lança FormatException', () async {
      dataSource.mockThrows(const FormatException('Campo inválido'));

      final result = await sut.getTransactions();

      result.fold((f) => expect(f, isA<ParseFailure>()), (_) => fail('Esperava Left'));
    });

    test('deve retornar Left(AuthFailure) quando datasource lança AuthException', () async {
      dataSource.mockThrows(const AuthException('Token expirado'));

      final result = await sut.getTransactions();

      result.fold((f) => expect(f, isA<AuthFailure>()), (_) => fail('Esperava Left'));
    });

    test('deve retornar Left(ServerFailure) quando datasource lança HttpException', () async {
      dataSource.mockThrows(const HttpException('500 Internal Server Error'));

      final result = await sut.getTransactions();

      result.fold((f) => expect(f, isA<ServerFailure>()), (_) => fail('Esperava Left'));
    });

    test('deve retornar Left(UnknownFailure) para exceção não categorizada', () async {
      dataSource.mockThrows(Exception('Algo inesperado'));

      final result = await sut.getTransactions();

      result.fold((f) => expect(f, isA<UnknownFailure>()), (_) => fail('Esperava Left'));
    });
  });
}
