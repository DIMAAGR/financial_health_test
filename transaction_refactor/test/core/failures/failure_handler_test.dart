import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_refactor/core/failures/app_failure.dart';
import 'package:transaction_refactor/core/failures/failure_handler.dart';

void main() {
  // ── AppFailure — mensagens amigáveis (#10) ─────────────────────────────────

  group('AppFailure — mensagens padrão', () {
    test('NetworkFailure tem mensagem sobre conexão', () {
      const f = NetworkFailure();
      expect(f.message, contains('internet'));
    });

    test('ServerFailure tem mensagem sobre servidor', () {
      const f = ServerFailure();
      expect(f.message, contains('servidor'));
    });

    test('AuthFailure tem mensagem sobre sessão', () {
      const f = AuthFailure();
      expect(f.message, contains('sessão'));
    });

    test('ParseFailure tem mensagem sobre formato inválido', () {
      const f = ParseFailure();
      expect(f.message, contains('formato'));
    });

    test('UnknownFailure tem mensagem de fallback', () {
      const f = UnknownFailure();
      expect(f.message, isNotEmpty);
    });

    test('mensagem customizada é preservada', () {
      const f = ServerFailure('Serviço indisponível (503).');
      expect(f.message, 'Serviço indisponível (503).');
    });
  });

  // ── FailureHandler.guard — mapeamento de exceções (#9, #10) ────────────────

  group('FailureHandler.guard', () {
    test('retorna Right quando action tem sucesso', () async {
      final result = await FailureHandler.guard(() async => 42);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Esperava Right'), (v) => expect(v, 42));
    });

    test('SocketException → NetworkFailure', () async {
      final result = await FailureHandler.guard<int>(() async => throw const SocketException(''));
      expect(result.isLeft(), isTrue);
      result.fold((f) => expect(f, isA<NetworkFailure>()), (_) => fail('Esperava Left'));
    });

    test('HttpException com mensagem → ServerFailure preserva mensagem', () async {
      final result = await FailureHandler.guard<int>(
        () async => throw const HttpException('Erro 500'),
      );
      result.fold((f) {
        expect(f, isA<ServerFailure>());
        expect(f.message, 'Erro 500');
      }, (_) => fail('Esperava Left'));
    });

    test('AuthException → AuthFailure', () async {
      final result = await FailureHandler.guard<int>(
        () async => throw const AuthException('Token expirado.'),
      );
      result.fold((f) {
        expect(f, isA<AuthFailure>());
        expect(f.message, 'Token expirado.');
      }, (_) => fail('Esperava Left'));
    });

    test('ParseException → ParseFailure', () async {
      final result = await FailureHandler.guard<int>(
        () async => throw const ParseException('Campo ausente.'),
      );
      result.fold((f) {
        expect(f, isA<ParseFailure>());
        expect(f.message, 'Campo ausente.');
      }, (_) => fail('Esperava Left'));
    });

    test('FormatException (nativa do Dart) → ParseFailure', () async {
      final result = await FailureHandler.guard<int>(
        () async => throw const FormatException('JSON malformado'),
      );
      result.fold((f) {
        expect(f, isA<ParseFailure>());
        expect(f.message, 'JSON malformado');
      }, (_) => fail('Esperava Left'));
    });

    test('Exception genérica → UnknownFailure', () async {
      final result = await FailureHandler.guard<int>(
        () async => throw Exception('algo inesperado'),
      );
      result.fold((f) => expect(f, isA<UnknownFailure>()), (_) => fail('Esperava Left'));
    });

    test('action é executada exatamente uma vez', () async {
      var callCount = 0;
      await FailureHandler.guard(() async {
        callCount++;
        return 'ok';
      });
      expect(callCount, 1);
    });
  });
}
