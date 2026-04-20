import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardFailure', () {
    test('representa falhas esperadas da feature', () {
      const failures = <AppFailure>[
        NetworkFailure(),
        ServerFailure(),
        ValidationFailure('Valor inválido.'),
        StorageFailure(),
        ParsingFailure(),
        UnknownFailure(),
      ];

      expect(failures, hasLength(6));
      expect(failures.map((item) => item.message), everyElement(isNotEmpty));
    });
  });
}
