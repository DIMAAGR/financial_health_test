import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/monthly_goal_status.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/policies/monthly_goal_status_policy.dart';

/// Entidade de domínio para avaliação de meta mensal.
///
/// Aplicação pragmática de DDD neste projeto:
/// - regra de negócio (`status`, `expectedPercentByDate`) fica no domínio
/// - apresentação (cores, ícones, layout) fica no widget
///
/// Isso reduz acoplamento da UI com lógica financeira e facilita testes.
class MonthlyGoalData {
  MonthlyGoalData({
    required this.monthLabel,
    required this.achievedPercent,
    required DateTime referenceDate,
    this.daysInMonth,
    MonthlyGoalStatusPolicy? statusPolicy,
  }) : _referenceDate = referenceDate,
       _statusPolicy = statusPolicy ?? const MonthlyGoalStatusPolicy() {
    if (monthLabel.trim().isEmpty) {
      throw ArgumentError.value(
        monthLabel,
        'monthLabel',
        'monthLabel não pode ser vazio.',
      );
    }
    if (achievedPercent < 0) {
      throw ArgumentError.value(
        achievedPercent,
        'achievedPercent',
        'achievedPercent não pode ser negativo.',
      );
    }
    if (daysInMonth != null && daysInMonth! <= 0) {
      throw ArgumentError.value(
        daysInMonth,
        'daysInMonth',
        'daysInMonth deve ser maior que zero.',
      );
    }
  }

  final String monthLabel;
  final double achievedPercent;
  final int? daysInMonth;
  final DateTime _referenceDate;
  final MonthlyGoalStatusPolicy _statusPolicy;

  late final int _resolvedDaysInMonth =
      daysInMonth ??
      DateTime(_referenceDate.year, _referenceDate.month + 1, 0).day;

  double get expectedPercentByDate {
    final day = _referenceDate.day.clamp(1, _resolvedDaysInMonth);
    return (day / _resolvedDaysInMonth) * 100;
  }

  /// Classificação de progresso considerando percentual atual e ritmo do mês.
  MonthlyGoalStatus get status {
    return _statusPolicy.resolve(
      achievedPercent: achievedPercent,
      expectedPercentByDate: expectedPercentByDate,
    );
  }

  int get achievedPercentRounded => achievedPercent.round();
}
