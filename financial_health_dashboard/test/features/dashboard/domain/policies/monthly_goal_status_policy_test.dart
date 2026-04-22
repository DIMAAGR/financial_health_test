import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/monthly_goal_status.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/policies/monthly_goal_status_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonthlyGoalStatusPolicy', () {
    const policy = MonthlyGoalStatusPolicy();

    test('retorna positive quando percentual atingido é >= 50', () {
      final result = policy.resolve(
        achievedPercent: 55,
        expectedPercentByDate: 90,
      );

      expect(result, MonthlyGoalStatus.positive);
    });

    test('retorna positive quando está à frente do ritmo esperado', () {
      final result = policy.resolve(
        achievedPercent: 35,
        expectedPercentByDate: 28,
      );

      expect(result, MonthlyGoalStatus.positive);
    });

    test('retorna attention quando está próximo do ritmo esperado', () {
      final result = policy.resolve(
        achievedPercent: 30,
        expectedPercentByDate: 36,
      );

      expect(result, MonthlyGoalStatus.attention);
    });

    test('retorna critical quando está muito abaixo do ritmo esperado', () {
      final result = policy.resolve(
        achievedPercent: 25,
        expectedPercentByDate: 60,
      );

      expect(result, MonthlyGoalStatus.critical);
    });

    test('lança assert quando positiveFloorPercent é inválido', () {
      expect(
        () => MonthlyGoalStatusPolicy(positiveFloorPercent: 120),
        throwsA(isA<AssertionError>()),
      );
    });

    test('lança assert quando tolerâncias são negativas', () {
      expect(
        () => MonthlyGoalStatusPolicy(positiveLeadTolerancePercent: -1),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => MonthlyGoalStatusPolicy(attentionLagTolerancePercent: -1),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
