import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/monthly_goal_status.dart';

/// Mapper de textos de apresentação para o card de meta mensal.
///
/// Mantém a camada de domínio livre de strings de UI e facilita futura migração
/// para i18n/l10n.
class MonthlyGoalTextMapper {
  static String title(MonthlyGoalData data) => 'Meta de ${data.monthLabel}';

  static String description(MonthlyGoalData data) {
    final value = data.achievedPercentRounded;
    switch (data.status) {
      case MonthlyGoalStatus.positive:
        return 'Você atingiu $value% do seu objetivo de renda mensal.';
      case MonthlyGoalStatus.attention:
        return 'Você atingiu $value% da meta até agora. Atenção para manter o ritmo esperado do mês.';
      case MonthlyGoalStatus.critical:
        return 'Você atingiu apenas $value% do seu objetivo de renda mensal. Meta em risco.';
    }
  }
}
