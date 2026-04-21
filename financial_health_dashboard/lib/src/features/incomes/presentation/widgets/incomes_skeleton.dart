import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';

/// Skeleton loading placeholder for the Incomes detail screen.
/// Mimics: MonthSummaryCard + CategoryBreakdownSection + transaction list.
class IncomesSkeleton extends StatelessWidget {
  const IncomesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerSkeleton(
      child: SingleChildScrollView(
        key: Key('incomes-skeleton'),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MonthSummaryCard placeholder
            SkeletonCard(key: Key('incomes-skeleton-summary'), height: 254),
            SizedBox(height: AppSpacing.lg),
            // Hero category card
            SkeletonCard(key: Key('incomes-skeleton-hero'), height: 180),
            SizedBox(height: AppSpacing.md),
            // Category items
            SkeletonCard(height: 88),
            SizedBox(height: AppSpacing.md),
            SkeletonCard(height: 88),
            SizedBox(height: AppSpacing.xl),
            // "Histórico Detalhado" title row
            SkeletonBlock(width: 180, height: 28),
            SizedBox(height: AppSpacing.xl),
            // Date label
            SkeletonBlock(width: 120, height: 16),
            SizedBox(height: AppSpacing.md),
            // Transaction group card (3 items)
            SkeletonCard(height: 266),
            SizedBox(height: AppSpacing.huge),
          ],
        ),
      ),
    );
  }
}
