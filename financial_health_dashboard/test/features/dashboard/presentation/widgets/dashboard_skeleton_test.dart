import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DashboardSkeleton renderiza estrutura de loading', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appLightTheme,
        home: const Scaffold(body: DashboardSkeleton()),
      ),
    );

    expect(find.byKey(const Key('dashboard-skeleton')), findsOneWidget);
    expect(find.byKey(const Key('dashboard-skeleton-score')), findsOneWidget);
    expect(find.byKey(const Key('dashboard-skeleton-balance')), findsOneWidget);
    expect(find.byKey(const Key('dashboard-skeleton-metrics')), findsOneWidget);
    expect(find.byKey(const Key('dashboard-skeleton-flow')), findsOneWidget);
    expect(find.byKey(const Key('dashboard-skeleton-goal')), findsOneWidget);
  });
}
