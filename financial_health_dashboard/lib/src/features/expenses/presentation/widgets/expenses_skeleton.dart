import 'package:financial_health_dashboard/src/shared/presentation/design/components/shimmer_skeleton.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:flutter/material.dart';

/// Skeleton loading placeholder for the Expenses detail screen.
/// Mimics: MonthSummaryCard + CategoryBreakdownSection + transaction list.
class ExpensesSkeleton extends StatelessWidget {
  const ExpensesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: SingleChildScrollView(
        key: const Key('expenses-skeleton'),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MonthSummaryCard placeholder
            SkeletonCard(key: const Key('expenses-skeleton-summary'), height: 254),
            const SizedBox(height: AppSpacing.lg),
            // Hero category card
            SkeletonCard(key: const Key('expenses-skeleton-hero'), height: 180),
            const SizedBox(height: AppSpacing.md),
            // Category items
            SkeletonCard(height: 88),
            const SizedBox(height: AppSpacing.md),
            SkeletonCard(height: 88),
            const SizedBox(height: AppSpacing.xl),
            // "Histórico Detalhado" title row
            SkeletonBlock(width: 180, height: 28),
            const SizedBox(height: AppSpacing.xl),
            // Date label
            SkeletonBlock(width: 120, height: 16),
            const SizedBox(height: AppSpacing.md),
            // Transaction group card (3 items)
            SkeletonCard(height: 266),
            const SizedBox(height: AppSpacing.huge),
          ],
        ),
      ),
    );
  }
}
