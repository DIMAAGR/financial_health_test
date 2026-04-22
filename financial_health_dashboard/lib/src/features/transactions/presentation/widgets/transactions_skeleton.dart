import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';

/// Skeleton loading placeholder for the Transactions detail screen.
/// Mimics: MonthSummaryCard + transaction list groups.
class TransactionsSkeleton extends StatelessWidget {
  const TransactionsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: SingleChildScrollView(
        key: const Key('transactions-skeleton'),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MonthSummaryCard placeholder
            const SkeletonCard(
              key: Key('transactions-skeleton-summary'),
              height: 254,
            ),
            const SizedBox(height: AppSpacing.xl),
            // "Histórico Detalhado" title row
            const SkeletonBlock(width: 180, height: 28),
            const SizedBox(height: AppSpacing.xl),
            // Transaction group 1
            ..._buildTransactionGroupPlaceholder(),
            const SizedBox(height: AppSpacing.xl),
            // Transaction group 2
            ..._buildTransactionGroupPlaceholder(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTransactionGroupPlaceholder() {
    return [
      // Date label
      const SkeletonBlock(width: 120, height: 16),
      const SizedBox(height: AppSpacing.md),
      // Transaction group card (3 items)
      const SkeletonCard(height: 266),
    ];
  }
}
