import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/flow_analysis_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlowAnalysisData', () {
    test('retorna positive quando delta percentual >= 20', () {
      final data = FlowAnalysisData(
        points: [FlowAnalysisPoint(income: 120, expense: 80)],
      );

      expect(data.status, FlowAnalysisStatus.positive);
    });

    test('retorna stable quando delta positivo é menor que 20%', () {
      final data = FlowAnalysisData(
        points: [FlowAnalysisPoint(income: 100, expense: 90)],
      );

      expect(data.status, FlowAnalysisStatus.stable);
    });

    test('retorna attention quando déficit é pequeno', () {
      final data = FlowAnalysisData(
        points: [FlowAnalysisPoint(income: 95, expense: 100)],
      );

      expect(data.status, FlowAnalysisStatus.attention);
    });

    test('retorna critical quando déficit é alto', () {
      final data = FlowAnalysisData(
        points: [FlowAnalysisPoint(income: 60, expense: 100)],
      );

      expect(data.status, FlowAnalysisStatus.critical);
    });

    test('lança erro para income negativo', () {
      expect(
        () => FlowAnalysisPoint(income: -1, expense: 10),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('lança erro para expense negativo', () {
      expect(
        () => FlowAnalysisPoint(income: 10, expense: -1),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('protege lista points contra mutação externa', () {
      final source = [FlowAnalysisPoint(income: 100, expense: 50)];
      final data = FlowAnalysisData(points: source);

      expect(
        () => data.points.add(FlowAnalysisPoint(income: 10, expense: 5)),
        throwsUnsupportedError,
      );
    });
  });
}
