import 'dart:math' as math;

import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/flow_analysis_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/flow_analysis_status.dart';
import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';

/// Seção de análise de fluxo com comparação visual entre entradas e despesas.
///
/// O componente recebe uma série de pontos numéricos e:
/// - calcula status (`positive`, `stable`, `attention`, `critical`)
/// - gera mensagem contextual com base no resultado agregado
/// - renderiza barras de entradas (verde) e despesas (vermelho)
class FlowAnalysisSection extends StatelessWidget {
  const FlowAnalysisSection({
    super.key,
    required this.data,
    this.sectionTitle = 'Entradas x Despesas',
    this.cardTitle = 'Análise de Fluxo',
    this.iconAssetPath,
    this.onTap,
  });

  final FlowAnalysisData data;
  final String sectionTitle;
  final String cardTitle;
  final String? iconAssetPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.flowAnalysisTheme;
    final borderRadius = BorderRadius.circular(AppRadius.lg);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: AppTextStyles.flowSectionTitle.copyWith(
            color: theme.sectionTitle,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: theme.cardBackground,
            borderRadius: borderRadius,
            border: Border.all(
              color: theme.cardBorder,
              width: theme.cardBorder.a == 0 ? 0 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.cardShadow,
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: borderRadius,
            child: InkWell(
              onTap: onTap,
              borderRadius: borderRadius,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cardTitle,
                            style: AppTextStyles.flowCardTitle.copyWith(
                              color: theme.cardTitle,
                            ),
                          ),
                        ),
                        if (iconAssetPath != null)
                          AppSvgIcon(
                            asset: iconAssetPath!,
                            color: theme.cardTitle,
                            size: 18,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FlowBarsChart(data: data),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _buildMessage(data),
                      style: AppTextStyles.flowDescription.copyWith(
                        color: theme.message,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _buildMessage(FlowAnalysisData data) {
    final magnitude = data.deltaPercentage.abs().round();

    switch (data.status) {
      case FlowAnalysisStatus.positive:
        return 'Seu comprometimento de renda está $magnitude% abaixo da referência do seu perfil. Ótima gestão financeira.';
      case FlowAnalysisStatus.stable:
        return 'Seu fluxo está estável: as entradas seguem levemente acima das despesas. Continue monitorando para manter margem.';
      case FlowAnalysisStatus.attention:
        return 'Atenção: suas despesas estão $magnitude% acima das entradas no período. Vale ajustar custos não essenciais.';
      case FlowAnalysisStatus.critical:
        return 'Cenário crítico: suas despesas estão $magnitude% acima das entradas. Recomendado plano imediato de correção.';
    }
  }
}

class _FlowBarsChart extends StatelessWidget {
  const _FlowBarsChart({required this.data});

  final FlowAnalysisData data;

  static const _incomeMaxHeight = 56.0;
  static const _expenseMaxHeight = 40.0;
  static const _barWidth = 40.0;
  static const _barGap = 4.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.flowAnalysisTheme;
    if (data.points.isEmpty) return const SizedBox.shrink();

    final maxIncome = data.points.fold<double>(
      0,
      (max, point) => math.max(max, point.income),
    );
    final maxExpense = data.points.fold<double>(
      0,
      (max, point) => math.max(max, point.expense),
    );
    final incomeBase = maxIncome <= 0 ? 1.0 : maxIncome;
    final expenseBase = maxExpense <= 0 ? 1.0 : maxExpense;
    final lastIndex = data.points.length - 1;

    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(data.points.length, (index) {
          final point = data.points[index];
          final incomeHeight = math.max(
            8.0,
            (point.income / incomeBase) * _incomeMaxHeight,
          );
          final expenseHeight = math.max(
            8.0,
            (point.expense / expenseBase) * _expenseMaxHeight,
          );
          final incomeColor = _incomeColor(
            theme: theme,
            index: index,
            lastIndex: lastIndex,
          );
          final expenseColor = _expenseColor(
            theme: theme,
            index: index,
            lastIndex: lastIndex,
          );

          final topSegment = point.expense > point.income
              ? _BarSegment(
                  height: expenseHeight,
                  color: expenseColor,
                  isTop: true,
                )
              : _BarSegment(
                  height: incomeHeight,
                  color: incomeColor,
                  isTop: true,
                );
          final bottomSegment = point.expense > point.income
              ? _BarSegment(
                  height: incomeHeight,
                  color: incomeColor,
                  isTop: false,
                )
              : _BarSegment(
                  height: expenseHeight,
                  color: expenseColor,
                  isTop: false,
                );

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == lastIndex ? 0 : _barGap),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ChartBar(width: _barWidth, segment: topSegment),
                  const SizedBox(height: _barGap),
                  _ChartBar(width: _barWidth, segment: bottomSegment),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Color _incomeColor({
    required FlowAnalysisTheme theme,
    required int index,
    required int lastIndex,
  }) {
    if (index == lastIndex) return theme.incomeHighlight;
    const alphas = [0x33, 0x4C, 0x66, 0x7F, 0x99];
    return theme.incomeBase.withAlpha(alphas[index % alphas.length]);
  }

  Color _expenseColor({
    required FlowAnalysisTheme theme,
    required int index,
    required int lastIndex,
  }) {
    if (index == lastIndex) return theme.expenseHighlight;
    return theme.expenseBase.withAlpha(0x4C);
  }
}

class _BarSegment {
  const _BarSegment({
    required this.height,
    required this.color,
    required this.isTop,
  });

  final double height;
  final Color color;
  final bool isTop;
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({required this.width, required this.segment});

  final double width;
  final _BarSegment segment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: segment.height,
      decoration: BoxDecoration(
        color: segment.color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(segment.isTop ? AppRadius.sm : 0),
          topRight: Radius.circular(segment.isTop ? AppRadius.sm : 0),
          bottomLeft: Radius.circular(segment.isTop ? 0 : AppRadius.sm),
          bottomRight: Radius.circular(segment.isTop ? 0 : AppRadius.sm),
        ),
      ),
    );
  }
}
