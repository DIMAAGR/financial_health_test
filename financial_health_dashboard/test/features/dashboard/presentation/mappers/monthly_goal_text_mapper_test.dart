import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/mappers/monthly_goal_text_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonthlyGoalTextMapper', () {
    test('gera título com mês informado', () {
      final data = MonthlyGoalData(
        monthLabel: 'Abril',
        achievedPercent: 82,
        referenceDate: DateTime(2026, 4, 10),
        daysInMonth: 30,
      );

      expect(MonthlyGoalTextMapper.title(data), 'Meta de Abril');
    });

    test('gera descrição positiva', () {
      final data = MonthlyGoalData(
        monthLabel: 'Abril',
        achievedPercent: 82,
        referenceDate: DateTime(2026, 4, 10),
        daysInMonth: 30,
      );

      expect(
        MonthlyGoalTextMapper.description(data),
        'Você atingiu 82% do seu objetivo de renda mensal.',
      );
    });
  });
}
