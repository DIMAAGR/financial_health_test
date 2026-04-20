import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFailure', () {
    test('mantem mensagens das falhas esperadas do app', () {
      const failures = <AppFailure>[
        NetworkFailure(),
        ServerFailure(),
        ValidationFailure('Valor inválido.'),
        StorageFailure(),
        ParsingFailure(),
        UnknownFailure(),
        AmountValueFailure(),
      ];

      expect(failures, hasLength(7));
      expect(failures.map((item) => item.message), everyElement(isNotEmpty));
    });

    test('permite switch exaustivo sobre todos os tipos de falha', () {
      expect(_failureKind(const NetworkFailure()), 'network');
      expect(_failureKind(const ServerFailure()), 'server');
      expect(
        _failureKind(const ValidationFailure('Valor inválido.')),
        'validation',
      );
      expect(_failureKind(const StorageFailure()), 'storage');
      expect(_failureKind(const ParsingFailure()), 'parsing');
      expect(_failureKind(const UnknownFailure()), 'unknown');
      expect(_failureKind(const AmountValueFailure()), 'amount');
    });
  });
}

String _failureKind(AppFailure failure) {
  return switch (failure) {
    NetworkFailure() => 'network',
    ServerFailure() => 'server',
    ValidationFailure() => 'validation',
    StorageFailure() => 'storage',
    ParsingFailure() => 'parsing',
    UnknownFailure() => 'unknown',
    AmountValueFailure() => 'amount',
  };
}
