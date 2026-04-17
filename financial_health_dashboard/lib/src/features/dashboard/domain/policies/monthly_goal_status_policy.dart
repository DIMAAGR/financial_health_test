import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/monthly_goal_status.dart';

/// Policy de classificação de status da meta mensal.
///
/// Em DDD pragmático, esta policy concentra uma regra de negócio que tende
/// a mudar com decisões de produto sem inflar a entidade.
class MonthlyGoalStatusPolicy {
  const MonthlyGoalStatusPolicy({
    this.positiveFloorPercent = 50,
    this.positiveLeadTolerancePercent = 5,
    this.attentionLagTolerancePercent = 10,
  }) : assert(positiveFloorPercent >= 0 && positiveFloorPercent <= 100),
       assert(positiveLeadTolerancePercent >= 0),
       assert(attentionLagTolerancePercent >= 0);

  final double positiveFloorPercent;
  final double positiveLeadTolerancePercent;
  final double attentionLagTolerancePercent;

  MonthlyGoalStatus resolve({
    required double achievedPercent,
    required double expectedPercentByDate,
  }) {
    final leadThreshold = expectedPercentByDate + positiveLeadTolerancePercent;
    final lagThreshold = expectedPercentByDate - attentionLagTolerancePercent;

    if (achievedPercent >= positiveFloorPercent) {
      return MonthlyGoalStatus.positive;
    }
    if (achievedPercent >= leadThreshold) {
      return MonthlyGoalStatus.positive;
    }
    if (achievedPercent >= lagThreshold) {
      return MonthlyGoalStatus.attention;
    }
    return MonthlyGoalStatus.critical;
  }
}
