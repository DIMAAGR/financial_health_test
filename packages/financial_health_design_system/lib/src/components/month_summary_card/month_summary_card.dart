import 'package:financial_health_design_system/src/assets/icons.dart';
import 'package:financial_health_design_system/src/components/svg_icon/app_svg_icon.dart';
import 'package:financial_health_design_system/src/foundations/tokens/app_radius.dart';
import 'package:financial_health_design_system/src/foundations/tokens/app_spacing.dart';
import 'package:financial_health_design_system/src/theme/extensions/app_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/month_summary_theme_ext.dart';
import 'package:flutter/material.dart';

enum MonthSummaryType { balance, income, expense }

enum TrendDirection { up, down, neutral }

class MonthSummaryCard extends StatelessWidget {
  const MonthSummaryCard({
    super.key,
    required this.type,
    required this.amount,
    required this.monthYear,
    required this.changePercent,
    required this.trendDirection,
  });

  final MonthSummaryType type;
  final String amount;
  final String monthYear;
  final double changePercent;
  final TrendDirection trendDirection;

  @override
  Widget build(BuildContext context) {
    final theme = context.monthSummaryTheme;

    final isPositiveTrend = _isPositiveTrend(type, trendDirection);
    final trendColor = isPositiveTrend
        ? theme.trendPositive
        : theme.trendNegative;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.xl),
        border: Border.all(color: theme.cardBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: theme.cardShadow,
            blurRadius: 50,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Glow circle
          Positioned(
            right: -32,
            top: -96,
            child: IgnorePointer(
              child: Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.glowColor,
                      blurRadius: 80,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.lg,
              children: [
                _HeaderSection(
                  label: _label,
                  amount: amount,
                  monthYear: monthYear,
                  theme: theme,
                ),
                SizedBox(
                  width: double.infinity,
                  child: _ComparativeBadge(
                    changePercent: changePercent,
                    trendDirection: trendDirection,
                    trendColor: trendColor,
                    theme: theme,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _label {
    return switch (type) {
      MonthSummaryType.balance => 'SALDO TOTAL',
      MonthSummaryType.income => 'TOTAL DO MÊS',
      MonthSummaryType.expense => 'TOTAL DO MÊS',
    };
  }

  static bool _isPositiveTrend(MonthSummaryType type, TrendDirection dir) {
    if (dir == TrendDirection.neutral) return true;

    return switch (type) {
      // Expenses: going down = good, going up = bad
      MonthSummaryType.expense => dir == TrendDirection.down,
      // Income/Balance: going up = good, going down = bad
      MonthSummaryType.income ||
      MonthSummaryType.balance => dir == TrendDirection.up,
    };
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.label,
    required this.amount,
    required this.monthYear,
    required this.theme,
  });

  final String label;
  final String amount;
  final String monthYear;
  final MonthSummaryTheme theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.label,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.65,
            height: 1.5,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: theme.amount,
            fontSize: 48,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        Text(
          monthYear,
          style: TextStyle(
            color: theme.monthYear,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 28 / 18,
          ),
        ),
      ],
    );
  }
}

class _ComparativeBadge extends StatelessWidget {
  const _ComparativeBadge({
    required this.changePercent,
    required this.trendDirection,
    required this.trendColor,
    required this.theme,
  });

  final double changePercent;
  final TrendDirection trendDirection;
  final Color trendColor;
  final MonthSummaryTheme theme;

  @override
  Widget build(BuildContext context) {
    final sign = changePercent >= 0 ? '+' : '';
    final percentText = '$sign${changePercent.toStringAsFixed(1)}%';

    final trendIcon = trendDirection == TrendDirection.down
        ? AppIcons.trendingDown
        : AppIcons.trendingUp;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: theme.badgeBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm + 4),
        border: Border.all(color: theme.badgeBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COMPARATIVO',
            style: TextStyle(
              color: theme.badgeLabel,
              fontSize: 9.6,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.48,
              height: 1.5,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xs,
            children: [
              AppSvgIcon(asset: trendIcon, size: 18, color: trendColor),
              Text(
                percentText,
                style: TextStyle(
                  color: trendColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 20 / 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
