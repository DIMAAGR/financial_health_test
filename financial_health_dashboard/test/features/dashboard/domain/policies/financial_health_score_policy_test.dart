import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/financial_health_status.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/policies/financial_health_score_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialHealthScorePolicy', () {
    const policy = FinancialHealthScorePolicy();

    test('retorna healthy para cenário forte de renda + liquidez', () {
      final result = policy.compute(
        income: 10000,
        expense: 2000,
        previousLiquidityIndex: 1.4,
        currentLiquidityIndex: 1.8,
      );

      expect(result.status, FinancialHealthStatus.healthy);
      expect(result.score, inInclusiveRange(70, 100));
      expect(result.incomeCommitmentPercent, closeTo(20, 0.01));
    });

    test('retorna attention para cenário intermediário', () {
      final result = policy.compute(
        income: 10000,
        expense: 6000,
        previousLiquidityIndex: 1.0,
        currentLiquidityIndex: 1.4,
      );

      expect(result.status, FinancialHealthStatus.attention);
      expect(result.score, inInclusiveRange(40, 69));
    });

    test('retorna critical para alto comprometimento de renda', () {
      final result = policy.compute(
        income: 10000,
        expense: 11000,
        previousLiquidityIndex: 1.0,
        currentLiquidityIndex: 0.7,
      );

      expect(result.status, FinancialHealthStatus.critical);
      expect(result.score, lessThan(45));
    });

    test('altera score ao mudar apenas liquidez', () {
      final lowLiquidity = policy.compute(
        income: 22000,
        expense: 4000,
        previousLiquidityIndex: 3.0,
        currentLiquidityIndex: 0.0,
      );

      final betterLiquidity = policy.compute(
        income: 22000,
        expense: 4000,
        previousLiquidityIndex: 3.0,
        currentLiquidityIndex: 0.6,
      );

      expect(betterLiquidity.score, greaterThan(lowLiquidity.score));
    });

    test('lança erro para valores negativos', () {
      expect(
        () => policy.compute(
          income: -1,
          expense: 10,
          previousLiquidityIndex: 1,
          currentLiquidityIndex: 1,
        ),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => policy.compute(
          income: 10,
          expense: -1,
          previousLiquidityIndex: 1,
          currentLiquidityIndex: 1,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
