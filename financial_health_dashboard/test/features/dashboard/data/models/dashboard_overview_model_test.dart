import 'package:financial_health_dashboard/src/features/dashboard/data/models/dashboard_overview_model.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/financial_health_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardOverviewModel', () {
    test('fromJson faz parse completo quando payload é válido', () {
      final model = DashboardOverviewModel.fromJson(_validJson());

      expect(model.userName, 'Júlio');
      expect(model.income, 12000);
      expect(model.expense, 7200);
      expect(model.flowPoints, hasLength(2));
      expect(model.flowPoints.first.income, 1000);
      expect(model.flowPoints.first.expense, 800);
    });

    test(
      'fromJson falha cedo quando campo financeiro obrigatório é inválido',
      () {
        expect(
          () => DashboardOverviewModel.fromJson({
            ..._validJson(),
            'balance': 'not-a-number',
          }),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test('toEntity protege target zero e calcula score/status', () {
      final model = DashboardOverviewModel.fromJson({
        ..._validJson(),
        'monthlyGoal': {
          'monthLabel': 'Abril',
          'targetAmount': 0,
          'achievedAmount': 500,
          'day': 10,
          'daysInMonth': 30,
        },
      });

      final entity = model.toEntity(referenceDate: DateTime(2026, 4, 10));

      expect(entity.monthlyGoal.achievedPercentRounded, 50000);
      expect(entity.financialHealthScore.score, inInclusiveRange(0, 100));
      expect(entity.financialHealthScore.status, isA<FinancialHealthStatus>());
    });

    test('toEntity usa goalDay do payload com mês e ano da referenceDate', () {
      final model = DashboardOverviewModel.fromJson({
        ..._validJson(),
        'monthlyGoal': {
          'monthLabel': 'Abril',
          'targetAmount': 1000,
          'achievedAmount': 250,
          'day': 20,
          'daysInMonth': 30,
        },
      });

      final entity = model.toEntity(referenceDate: DateTime(2026, 4, 1));

      expect(entity.monthlyGoal.expectedPercentByDate, closeTo(66.67, 0.01));
    });
  });
}

Map<String, dynamic> _validJson() {
  return {
    'userName': 'Júlio',
    'income': 12000,
    'expense': 7200,
    'balance': 18000,
    'incomeChangePercent': 15.5,
    'expenseChangePercent': -3.2,
    'balanceChangePercent': 10.0,
    'liquidity': {'previousIndex': 1.2, 'currentIndex': 1.3},
    'commitment': {'percent': 60, 'benchmarkPercent': 65},
    'monthlyGoal': {
      'monthLabel': 'Abril',
      'targetAmount': 15000,
      'achievedAmount': 12000,
      'day': 16,
      'daysInMonth': 30,
    },
    'flow': [
      {'income': 1000, 'expense': 800},
      {'income': 1200, 'expense': 900},
    ],
    'transactions': [
      {
        'id': 'tx-1',
        'title': 'Salário',
        'category': 'salary',
        'value': 2000,
        'type': 'income',
      },
      {
        'id': 'tx-2',
        'title': 'Mercado',
        'category': 'food',
        'value': 400,
        'type': 'expense',
      },
    ],
  };
}
