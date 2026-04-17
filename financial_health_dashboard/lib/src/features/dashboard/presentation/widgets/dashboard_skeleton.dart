import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_radius.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:flutter/material.dart';

class DashboardSkeleton extends StatefulWidget {
  const DashboardSkeleton({super.key});

  @override
  State<DashboardSkeleton> createState() => _DashboardSkeletonState();
}

class _DashboardSkeletonState extends State<DashboardSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.onSurface.withValues(alpha: 0.08);
    final highlightColor = colorScheme.onSurface.withValues(alpha: 0.14);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => _ShimmerContext(
        progress: _controller.value,
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: child!,
      ),
      child: SingleChildScrollView(
        key: const Key('dashboard-skeleton'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonBlock(width: 140, height: 16),
              const SizedBox(height: AppSpacing.sm),
              _SkeletonBlock(width: 180, height: 28),
              const SizedBox(height: AppSpacing.xxl),
              _SkeletonCard(key: const Key('dashboard-skeleton-score'), height: 208),
              const SizedBox(height: AppSpacing.lg),
              _SkeletonCard(key: const Key('dashboard-skeleton-balance'), height: 120),
              const SizedBox(height: AppSpacing.lg),
              Row(
                key: const Key('dashboard-skeleton-metrics'),
                children: [
                  Expanded(child: _SkeletonCard(height: 120)),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(child: _SkeletonCard(height: 120)),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              _SkeletonCard(key: const Key('dashboard-skeleton-flow'), height: 288),
              const SizedBox(height: AppSpacing.xl),
              _SkeletonCard(key: const Key('dashboard-skeleton-goal'), height: 146),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerContext extends InheritedWidget {
  const _ShimmerContext({
    required this.progress,
    required this.baseColor,
    required this.highlightColor,
    required super.child,
  });

  final double progress;
  final Color baseColor;
  final Color highlightColor;

  static _ShimmerContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ShimmerContext>()!;
  }

  Gradient get gradient {
    return LinearGradient(
      begin: const Alignment(-1, 0),
      end: const Alignment(1, 0),
      colors: [baseColor, highlightColor, baseColor],
      stops: [
        (progress - 0.3).clamp(0.0, 1.0),
        progress.clamp(0.0, 1.0),
        (progress + 0.3).clamp(0.0, 1.0),
      ],
    );
  }

  @override
  bool updateShouldNotify(_ShimmerContext oldWidget) => progress != oldWidget.progress;
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final shimmer = _ShimmerContext.of(context);
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: shimmer.gradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final shimmer = _ShimmerContext.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: shimmer.gradient,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    );
  }
}
