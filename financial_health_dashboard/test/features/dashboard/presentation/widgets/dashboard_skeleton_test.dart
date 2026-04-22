import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/theme.dart';
import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DashboardSkeleton preserva placeholders principais do loading', (
    tester,
  ) async {
    await pumpDashboardSkeleton(tester);

    expect(find.byKey(const Key('dashboard-skeleton')), findsOneWidget);
    expect(find.byType(ShimmerSkeleton), findsOneWidget);
    expect(find.byType(SkeletonBlock), findsNWidgets(2));

    final blockSizes = tester
        .widgetList<SkeletonBlock>(find.byType(SkeletonBlock))
        .map((block) => (width: block.width, height: block.height))
        .toList();
    expect(blockSizes, [
      (width: 140.0, height: 16.0),
      (width: 180.0, height: 28.0),
    ]);

    final cardHeights = tester
        .widgetList<SkeletonCard>(find.byType(SkeletonCard))
        .map((card) => card.height);
    expect(cardHeights, [208, 120, 120, 120, 288, 146]);
  });

  testWidgets(
    'DashboardSkeleton atualiza o gradiente shimmer durante o loading',
    (tester) async {
      await pumpDashboardSkeleton(tester);

      final before = cardGradientStops(
        tester,
        const Key('dashboard-skeleton-score'),
      );

      await tester.pump(const Duration(milliseconds: 600));

      final after = cardGradientStops(
        tester,
        const Key('dashboard-skeleton-score'),
      );
      expect(after, isNot(equals(before)));
    },
  );
}

Future<void> pumpDashboardSkeleton(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: appLightTheme,
      home: const Scaffold(body: DashboardSkeleton()),
    ),
  );
}

List<double> cardGradientStops(WidgetTester tester, Key skeletonCardKey) {
  final container = tester.widget<Container>(
    find.descendant(
      of: find.byKey(skeletonCardKey),
      matching: find.byType(Container),
    ),
  );
  final decoration = container.decoration! as BoxDecoration;
  final gradient = decoration.gradient! as LinearGradient;
  return List<double>.of(gradient.stops!);
}
