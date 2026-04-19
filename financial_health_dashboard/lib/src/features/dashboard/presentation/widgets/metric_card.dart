import 'package:financial_health_dashboard/src/shared/presentation/design/components/svg_icons.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/extensions/currency_format_extension.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/app_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_radius.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Card reutilizável para exibição de métricas financeiras.
///
/// Pode representar saldo, entradas ou gastos, mantendo consistência visual
/// com o design system.
///
/// Exemplo:
/// ```dart
/// MetricCard(
///   label: 'SALDO',
///   value: 9160.0,
///   iconAsset: AppIcons.wallet,
///   onTap: () {},
/// )
/// ```
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.iconAsset,
    required this.iconColor,
    this.onTap,
  });

  /// Rótulo curto da métrica (ex: `SALDO`, `ENTRADAS`, `GASTOS`).
  final String label;

  /// Valor principal da métrica.
  ///
  /// Deve ser informado como número bruto para formatação monetária em BRL.
  final double value;

  /// Caminho do asset SVG exibido como ícone da métrica.
  final String iconAsset;

  /// Cor semântica usada para o ícone da métrica.
  final Color iconColor;

  /// Callback disparado ao tocar no card.
  ///
  /// Quando `null`, o card permanece visível, porém não-interativo.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final borderRadius = BorderRadius.circular(AppRadius.lg);

    return Container(
      decoration: BoxDecoration(
        color: colors.metricCardBackground,
        borderRadius: borderRadius,
        border: Border.all(
          color: colors.metricCardBorder,
          width: colors.metricCardBorder.a == 0 ? 0 : 1,
        ),
        boxShadow: [
          BoxShadow(color: colors.metricCardShadow, blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSvgIcon(asset: iconAsset, size: 24, color: iconColor),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  style: AppTextStyles.metricLabelLarge.copyWith(color: colors.metricCardLabel),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value.toBRL(),
                  style: AppTextStyles.metricValue.copyWith(color: colors.metricCardValue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
