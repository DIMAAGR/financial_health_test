import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/monthly_goal_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/monthly_goal_status.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/mappers/monthly_goal_text_mapper.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/assets/icons.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/svg_icons.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/app_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_radius.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Card de meta mensal com variação visual por status.
///
/// Usa o tema semântico para suportar modo claro/escuro e alterna automaticamente
/// entre estado positivo e negativo.
class MonthlyGoalCard extends StatelessWidget {
  const MonthlyGoalCard({super.key, required this.data, this.onTap});

  final MonthlyGoalData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.monthlyGoalTheme;
    final colors = data.status == MonthlyGoalStatus.positive
        ? theme.positive
        : theme.negative;
    final borderRadius = BorderRadius.circular(AppRadius.lg);
    final icon = data.status == MonthlyGoalStatus.positive
        ? AppIcons.rocket
        : AppIcons.attention;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: borderRadius,
        border: Border.all(
          color: colors.border,
          width: colors.border.a == 0 ? 0 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 2,
            offset: const Offset(0, 1),
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
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSvgIcon(asset: icon, size: 32, color: colors.iconColor),
                Text(
                  MonthlyGoalTextMapper.title(data),
                  style: AppTextStyles.monthlyGoalTitle.copyWith(
                    color: colors.title,
                  ),
                ),
                Text(
                  MonthlyGoalTextMapper.description(data),
                  style: AppTextStyles.monthlyGoalDescription.copyWith(
                    color: colors.description,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
