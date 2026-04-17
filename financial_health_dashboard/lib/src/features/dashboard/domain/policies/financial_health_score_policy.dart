import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/financial_health_status.dart';

class FinancialHealthScoreComputation {
  const FinancialHealthScoreComputation({
    required this.score,
    required this.status,
    required this.incomeCommitmentPercent,
    required this.liquidityChangePercent,
  });

  final int score;
  final FinancialHealthStatus status;
  final double incomeCommitmentPercent;
  final double liquidityChangePercent;
}

/// Policy de cálculo do score de saúde financeira.
///
/// Mantém as regras de classificação desacopladas da apresentação.
class FinancialHealthScorePolicy {
  const FinancialHealthScorePolicy({
    this.healthyThreshold = 70,
    this.attentionThreshold = 45,
  }) : assert(healthyThreshold >= 0 && healthyThreshold <= 100),
       assert(attentionThreshold >= 0 && attentionThreshold <= 100),
       assert(healthyThreshold >= attentionThreshold);

  final int healthyThreshold;
  final int attentionThreshold;

  static const double _commitmentWeight = 0.65;
  static const double _liquidityLevelWeight = 0.25;
  static const double _liquidityTrendWeight = 0.10;

  FinancialHealthScoreComputation compute({
    required double income,
    required double expense,
    required double currentLiquidityIndex,
    required double previousLiquidityIndex,
  }) {
    if (income < 0) {
      throw ArgumentError.value(
        income,
        'income',
        'income não pode ser negativo.',
      );
    }
    if (expense < 0) {
      throw ArgumentError.value(
        expense,
        'expense',
        'expense não pode ser negativo.',
      );
    }
    if (currentLiquidityIndex < 0) {
      throw ArgumentError.value(
        currentLiquidityIndex,
        'currentLiquidityIndex',
        'currentLiquidityIndex não pode ser negativo.',
      );
    }
    if (previousLiquidityIndex < 0) {
      throw ArgumentError.value(
        previousLiquidityIndex,
        'previousLiquidityIndex',
        'previousLiquidityIndex não pode ser negativo.',
      );
    }

    final commitmentPercent = income <= 0
        ? (expense <= 0 ? 0.0 : 100.0)
        : (expense / income) * 100;
    final liquidityDelta = previousLiquidityIndex <= 0
        ? 0.0
        : ((currentLiquidityIndex - previousLiquidityIndex) /
                  previousLiquidityIndex) *
              100;

    final commitmentScore = (100 - commitmentPercent).clamp(0, 100).toDouble();
    final liquidityLevelScore = _liquidityLevelScore(currentLiquidityIndex);
    final liquidityTrendScore = _liquidityTrendScore(
      previousLiquidityIndex: previousLiquidityIndex,
      liquidityDelta: liquidityDelta,
    );

    final computedScore =
        (commitmentScore * _commitmentWeight +
                liquidityLevelScore * _liquidityLevelWeight +
                liquidityTrendScore * _liquidityTrendWeight)
            .clamp(0, 100)
            .round();

    final status = _resolveStatus(computedScore);

    return FinancialHealthScoreComputation(
      score: computedScore,
      status: status,
      incomeCommitmentPercent: commitmentPercent,
      liquidityChangePercent: liquidityDelta,
    );
  }

  FinancialHealthStatus _resolveStatus(int score) {
    if (score >= healthyThreshold) {
      return FinancialHealthStatus.healthy;
    }
    if (score >= attentionThreshold) {
      return FinancialHealthStatus.attention;
    }
    return FinancialHealthStatus.critical;
  }

  double _liquidityLevelScore(double currentLiquidityIndex) {
    if (currentLiquidityIndex <= 0) {
      return 0;
    }
    if (currentLiquidityIndex < 1) {
      return (currentLiquidityIndex * 50).clamp(0, 50);
    }
    if (currentLiquidityIndex <= 2) {
      return (50 + ((currentLiquidityIndex - 1) * 50)).clamp(50, 100);
    }
    return 100;
  }

  double _liquidityTrendScore({
    required double previousLiquidityIndex,
    required double liquidityDelta,
  }) {
    if (previousLiquidityIndex <= 0) {
      // Sem histórico confiável, ponto neutro para não distorcer o score.
      return 50;
    }

    // Mapeia -50%..+50% para 0..100.
    return (liquidityDelta + 50).clamp(0, 100).toDouble();
  }
}
