import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/financial_health_status.dart';

class FinancialHealthScoreTextMapper {
  static const String title = 'Score de Saúde Financeira';

  static String label(FinancialHealthStatus status) {
    switch (status) {
      case FinancialHealthStatus.healthy:
        return 'SAUDÁVEL';
      case FinancialHealthStatus.attention:
        return 'ATENÇÃO';
      case FinancialHealthStatus.critical:
        return 'CRÍTICO';
    }
  }

  static String headline(FinancialHealthScoreData data) {
    return 'Você está gastando ${data.incomeCommitmentPercent.round()}% da sua renda.';
  }

  static String description(FinancialHealthScoreData data) {
    final delta = data.liquidityChangePercent.round();
    if (delta >= 0) {
      return 'Seu índice de liquidez melhorou $delta% desde o mês passado. Mantenha o ritmo.';
    }
    return 'Seu índice de liquidez caiu ${delta.abs()}% desde o mês passado. Atenção ao ritmo de gastos.';
  }
}
