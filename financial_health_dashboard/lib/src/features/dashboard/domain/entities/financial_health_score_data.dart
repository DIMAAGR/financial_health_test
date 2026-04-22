import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/financial_health_status.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/policies/financial_health_score_policy.dart';

/// Entidade de domínio com dados calculados de saúde financeira.
///
/// Não contém textos de apresentação. Labels e mensagens devem ser geradas
/// na camada de apresentação via mapper.
class FinancialHealthScoreData {
  const FinancialHealthScoreData({
    required this.status,
    required this.score,
    required this.incomeCommitmentPercent,
    required this.liquidityChangePercent,
  });

  factory FinancialHealthScoreData.fromMetrics({
    required double income,
    required double expense,
    required double currentLiquidityIndex,
    required double previousLiquidityIndex,
    FinancialHealthScorePolicy policy = const FinancialHealthScorePolicy(),
  }) {
    final result = policy.compute(
      income: income,
      expense: expense,
      currentLiquidityIndex: currentLiquidityIndex,
      previousLiquidityIndex: previousLiquidityIndex,
    );

    return FinancialHealthScoreData(
      status: result.status,
      score: result.score,
      incomeCommitmentPercent: result.incomeCommitmentPercent,
      liquidityChangePercent: result.liquidityChangePercent,
    );
  }

  final FinancialHealthStatus status;
  final int score;
  final double incomeCommitmentPercent;
  final double liquidityChangePercent;
}
