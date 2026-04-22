import 'package:financial_health_dashboard/src/features/dashboard/domain/enum/financial_health_status.dart';
import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';

final class FinancialHealthCardStyleResolver {
  FinancialHealthCardStyleResolver._();

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
