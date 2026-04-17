import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/metric_card.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/assets/icons.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/app_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:flutter/material.dart';

class MetricsOverviewSection extends StatelessWidget {
  const MetricsOverviewSection({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
    this.onBalanceTap,
    this.onIncomeTap,
    this.onExpensesTap,
  });

  final double balance;
  final double income;
  final double expenses;

  final VoidCallback? onBalanceTap;
  final VoidCallback? onIncomeTap;
  final VoidCallback? onExpensesTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        MetricCard(
          label: 'SALDO',
          value: balance,
          iconAsset: AppIcons.wallet,
          iconColor: colors.metricCardIcon,
          onTap: onBalanceTap,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: 'ENTRADAS',
                value: income,
                iconAsset: AppIcons.money,
                iconColor: colors.metricCardIcon,
                onTap: onIncomeTap,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: MetricCard(
                label: 'GASTOS',
                value: expenses,
                iconAsset: AppIcons.bag,
                iconColor: colors.metricCardIconRed,
                onTap: onExpensesTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
