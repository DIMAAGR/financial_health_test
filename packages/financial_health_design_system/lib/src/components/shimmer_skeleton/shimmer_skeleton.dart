import 'package:financial_health_design_system/src/foundations/tokens/app_radius.dart';
import 'package:flutter/material.dart';

/// Wraps a subtree in a shimmer loading animation.
///
/// Place any combination of [SkeletonCard] and [SkeletonBlock] inside
/// [ShimmerSkeleton.child] to create a placeholder that animates while data
/// loads. The base and highlight colors are derived from the active
/// [ColorScheme] so the animation adapts to light and dark modes.
///
/// ## Usage
/// ```dart
/// ShimmerSkeleton(
///   child: Column(
///     children: [
///       SkeletonCard(height: 120),
///       SkeletonBlock(width: 200, height: 16),
///     ],
///   ),
/// )
/// ```
class ShimmerSkeleton extends StatefulWidget {
  /// Creates a [ShimmerSkeleton].
  const ShimmerSkeleton({super.key, required this.child});

  /// The subtree to animate. Replace your real widgets with [SkeletonCard]
  /// and [SkeletonBlock] placeholders as the child.
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

/// [InheritedWidget] that propagates shimmer animation state to skeleton
/// placeholder widgets in the subtree.
///
/// Automatically inserted by [ShimmerSkeleton] — you do not create this
/// directly. [SkeletonCard] and [SkeletonBlock] read from it via
/// `ShimmerContext.of(context)`.
class ShimmerContext extends InheritedWidget {
  /// Creates a [ShimmerContext]. Used internally by [ShimmerSkeleton].
  const ShimmerContext({
    super.key,
    required this.progress,
    required this.baseColor,
    required this.highlightColor,
    required super.child,
  });

  /// Current animation progress in the range `[0.0, 1.0]`.
  final double progress;

  /// Base (muted) shimmer color.
  final Color baseColor;

  /// Peak (highlight) shimmer color at the center of the sweep.
  final Color highlightColor;

  /// Returns the nearest [ShimmerContext] ancestor.
  static ShimmerContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShimmerContext>()!;
  }

  /// A [LinearGradient] that represents the current shimmer sweep position.
  ///
  /// Transitions from [baseColor] → [highlightColor] → [baseColor] using
  /// [progress] to determine the highlight center.
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

/// A full-width rounded rectangle placeholder used inside [ShimmerSkeleton].
///
/// Suitable for replacing card-sized content blocks while data loads.
class SkeletonCard extends StatelessWidget {
  /// Creates a [SkeletonCard] with the given [height].
  const SkeletonCard({super.key, required this.height});

  /// Height of the placeholder rectangle in logical pixels.
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

/// A fixed-size rounded rectangle placeholder used inside [ShimmerSkeleton].
///
/// Use for smaller inline elements such as text lines or icon placeholders.
class SkeletonBlock extends StatelessWidget {
  /// Creates a [SkeletonBlock] with the given [width] and [height].
  const SkeletonBlock({super.key, required this.width, required this.height});

  /// Width of the placeholder in logical pixels.
  final double width;

  /// Height of the placeholder in logical pixels.
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
