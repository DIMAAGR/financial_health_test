import 'package:financial_health_design_system/src/foundations/tokens/fh_radius.dart';
import 'package:financial_health_design_system/src/foundations/tokens/fh_spacing.dart';
import 'package:flutter/material.dart';

abstract final class FinancialSummaryCardTokens {
  static const double radius = FhRadius.lg;
  static const double pillRadius = FhRadius.pill;
  static const double iconContainerSize = FhSpacing.xxxl;
  static const double iconSize = FhSpacing.lg;
  static const double headerContentGap = FhSpacing.xxl;
  static const double titleValueGap = FhSpacing.xs;
  static const double shadowBlur = FhSpacing.xs;
  static const double borderWidth = 1;
  static const EdgeInsets contentPadding = EdgeInsets.all(FhSpacing.xl);
  static const EdgeInsets variationPadding = EdgeInsets.symmetric(
    horizontal: FhSpacing.md,
    vertical: FhSpacing.xs,
  );
  static const Offset shadowOffset = Offset(0, 1);
}
