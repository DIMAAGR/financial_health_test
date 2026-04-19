import 'package:financial_health_dashboard/src/shared/presentation/design/components/shimmer_skeleton.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:flutter/material.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: SingleChildScrollView(
        key: const Key('dashboard-skeleton'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBlock(width: 140, height: 16),
              const SizedBox(height: AppSpacing.sm),
              SkeletonBlock(width: 180, height: 28),
              const SizedBox(height: AppSpacing.xxl),
              SkeletonCard(key: const Key('dashboard-skeleton-score'), height: 208),
              const SizedBox(height: AppSpacing.lg),
              SkeletonCard(key: const Key('dashboard-skeleton-balance'), height: 120),
              const SizedBox(height: AppSpacing.lg),
              Row(
                key: const Key('dashboard-skeleton-metrics'),
                children: [
                  Expanded(child: SkeletonCard(height: 120)),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(child: SkeletonCard(height: 120)),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SkeletonCard(key: const Key('dashboard-skeleton-flow'), height: 288),
              const SizedBox(height: AppSpacing.xl),
              SkeletonCard(key: const Key('dashboard-skeleton-goal'), height: 146),
            ],
          ),
        ),
      ),
    );
  }
}
