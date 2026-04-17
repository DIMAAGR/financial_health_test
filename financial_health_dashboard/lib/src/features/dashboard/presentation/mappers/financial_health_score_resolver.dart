import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/financial_health_status.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/app_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/financial_health_score_theme_ext.dart';
import 'package:flutter/material.dart';

class FinancialHealthCardStyleResolver {
  static FinancialHealthCardColors resolve(
    BuildContext context,
    FinancialHealthStatus status,
  ) {
    final theme = context.financialHealthScoreTheme;
    switch (status) {
      case FinancialHealthStatus.healthy:
        return theme.healthy;
      case FinancialHealthStatus.attention:
        return theme.attention;
      case FinancialHealthStatus.critical:
        return theme.critical;
    }
  }
}
