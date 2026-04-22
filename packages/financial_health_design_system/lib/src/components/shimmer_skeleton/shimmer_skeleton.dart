import 'package:financial_health_design_system/src/foundations/tokens/app_radius.dart';
import 'package:flutter/material.dart';

class ShimmerSkeleton extends StatefulWidget {
  const ShimmerSkeleton({super.key, required this.child});

  final Widget child;

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
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
      builder: (context, child) => ShimmerContext(
        progress: _controller.value,
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: child!,
      ),
      child: widget.child,
    );
  }
}

class ShimmerContext extends InheritedWidget {
  const ShimmerContext({
    super.key,
    required this.progress,
    required this.baseColor,
    required this.highlightColor,
    required super.child,
  });

  final double progress;
  final Color baseColor;
  final Color highlightColor;

  static ShimmerContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShimmerContext>()!;
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
  bool updateShouldNotify(ShimmerContext oldWidget) =>
      progress != oldWidget.progress;
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final shimmer = ShimmerContext.of(context);
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

class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final shimmer = ShimmerContext.of(context);
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
