import 'package:financial_health_dashboard/src/shared/presentation/design/components/shimmer_skeleton.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:flutter/material.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerSkeleton(
      child: SingleChildScrollView(
        key: Key('dashboard-skeleton'),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBlock(width: 140, height: 16),
              SizedBox(height: AppSpacing.sm),
              SkeletonBlock(width: 180, height: 28),
              SizedBox(height: AppSpacing.xxl),
              SkeletonCard(key: Key('dashboard-skeleton-score'), height: 208),
              SizedBox(height: AppSpacing.lg),
              SkeletonCard(key: Key('dashboard-skeleton-balance'), height: 120),
              SizedBox(height: AppSpacing.lg),
              Row(
                key: Key('dashboard-skeleton-metrics'),
                children: [
                  Expanded(child: SkeletonCard(height: 120)),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(child: SkeletonCard(height: 120)),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              SkeletonCard(key: Key('dashboard-skeleton-flow'), height: 288),
              SizedBox(height: AppSpacing.xl),
              SkeletonCard(key: Key('dashboard-skeleton-goal'), height: 146),
            ],
          ),
        ),
      ),
    );
  }
}
