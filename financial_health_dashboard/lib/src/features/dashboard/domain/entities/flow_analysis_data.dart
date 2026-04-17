import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/flow_analysis_status.dart';

/// Ponto de série temporal para análise de fluxo.
///
/// Cada ponto representa o par entrada/saída de um recorte do período.
class FlowAnalysisPoint {
  FlowAnalysisPoint({required this.income, required this.expense}) {
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
  }

  final double income;
  final double expense;
}

/// Entidade de domínio para análise agregada de entradas x despesas.
///
/// Em DDD pragmático, este objeto concentra a regra de classificação
/// (`status`) e cálculos (`delta`, `deltaPercentage`), enquanto a camada
/// de apresentação apenas consome o resultado para renderização.
class FlowAnalysisData {
  FlowAnalysisData({required List<FlowAnalysisPoint> points})
    : points = List.unmodifiable(points);

  final List<FlowAnalysisPoint> points;
  static const double _positiveThreshold = 20;
  static const double _attentionThreshold = 12;

  late final double totalIncome = points.fold(
    0,
    (sum, point) => sum + point.income,
  );
  late final double totalExpense = points.fold(
    0,
    (sum, point) => sum + point.expense,
  );

  late final double delta = totalIncome - totalExpense;

  late final double deltaPercentage = () {
    if (totalIncome <= 0) return 0.0;
    return (delta / totalIncome) * 100;
  }();

  late final FlowAnalysisStatus status = () {
    if (delta >= 0) {
      if (deltaPercentage >= _positiveThreshold) {
        return FlowAnalysisStatus.positive;
      }
      return FlowAnalysisStatus.stable;
    }

    if (totalExpense <= 0) {
      return FlowAnalysisStatus.critical;
    }
    final deficitPercentage = (delta.abs().toDouble() / totalExpense) * 100;
    if (deficitPercentage <= _attentionThreshold) {
      return FlowAnalysisStatus.attention;
    }
    return FlowAnalysisStatus.critical;
  }();
}
