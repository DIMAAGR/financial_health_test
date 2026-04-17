import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/financial_health_status.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/mappers/financial_health_score_text_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialHealthScoreTextMapper', () {
    test('retorna label por status', () {
      expect(
        FinancialHealthScoreTextMapper.label(FinancialHealthStatus.healthy),
        'SAUDÁVEL',
      );
      expect(
        FinancialHealthScoreTextMapper.label(FinancialHealthStatus.attention),
        'ATENÇÃO',
      );
      expect(
        FinancialHealthScoreTextMapper.label(FinancialHealthStatus.critical),
        'CRÍTICO',
      );
    });

    test('gera headline e descrição com dados de domínio', () {
      const data = FinancialHealthScoreData(
        status: FinancialHealthStatus.healthy,
        score: 78,
        incomeCommitmentPercent: 60,
        liquidityChangePercent: 4,
      );

      expect(
        FinancialHealthScoreTextMapper.headline(data),
        'Você está gastando 60% da sua renda.',
      );
      expect(
        FinancialHealthScoreTextMapper.description(data),
        'Seu índice de liquidez melhorou 4% desde o mês passado. Mantenha o ritmo.',
      );
    });
  });
}
