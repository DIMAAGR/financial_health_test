import 'package:financial_health_dashboard/src/features/dashboard/domain/failures/dashboard_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardFailure', () {
    test('representa falhas esperadas da feature', () {
      const failures = <DashboardFailure>[
        DashboardNetworkFailure(),
        DashboardServerFailure(),
        DashboardValidationFailure('Valor inválido.'),
        DashboardStorageFailure(),
        DashboardParsingFailure(),
        DashboardUnknownFailure(),
      ];

      expect(failures, hasLength(6));
      expect(failures.map((item) => item.message), everyElement(isNotEmpty));
    });
  });
}
