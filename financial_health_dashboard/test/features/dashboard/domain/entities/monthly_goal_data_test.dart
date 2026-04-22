import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/monthly_goal_status.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/policies/monthly_goal_status_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonthlyGoalData', () {
    test('calcula expectedPercentByDate com base no dia e dias no mês', () {
      final data = MonthlyGoalData(
        monthLabel: 'Abril',
        achievedPercent: 25,
        referenceDate: DateTime(2026, 4, 5),
        daysInMonth: 30,
      );

      expect(data.expectedPercentByDate, closeTo(16.67, 0.01));
    });

    test('retorna positive para 25% no dia 5 (acima do esperado)', () {
      final data = MonthlyGoalData(
        monthLabel: 'Abril',
        achievedPercent: 25,
        referenceDate: DateTime(2026, 4, 5),
        daysInMonth: 30,
      );

      expect(data.status, MonthlyGoalStatus.positive);
    });

    test('retorna critical para 25% no dia 20 (abaixo do esperado)', () {
      final data = MonthlyGoalData(
        monthLabel: 'Abril',
        achievedPercent: 25,
        referenceDate: DateTime(2026, 4, 20),
        daysInMonth: 30,
      );

      expect(data.status, MonthlyGoalStatus.critical);
    });

    test('permite injeção de policy customizada', () {
      final data = MonthlyGoalData(
        monthLabel: 'Abril',
        achievedPercent: 35,
        referenceDate: DateTime(2026, 4, 20),
        daysInMonth: 30,
        statusPolicy: const MonthlyGoalStatusPolicy(
          positiveFloorPercent: 40,
          positiveLeadTolerancePercent: 0,
          attentionLagTolerancePercent: 2,
        ),
      );

      expect(data.status, MonthlyGoalStatus.critical);
    });

    test('lança erro quando achievedPercent é negativo', () {
      expect(
        () => MonthlyGoalData(
          monthLabel: 'Abril',
          achievedPercent: -1,
          referenceDate: DateTime(2026, 4, 10),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('lança erro quando monthLabel é vazio', () {
      expect(
        () => MonthlyGoalData(
          monthLabel: '   ',
          achievedPercent: 10,
          referenceDate: DateTime(2026, 4, 10),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('lança erro quando daysInMonth é inválido', () {
      expect(
        () => MonthlyGoalData(
          monthLabel: 'Abril',
          achievedPercent: 10,
          referenceDate: DateTime(2026, 4, 10),
          daysInMonth: 0,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
