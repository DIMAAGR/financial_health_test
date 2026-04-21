import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renderiza estado positivo com palette de tema claro', (
    tester,
  ) async {
    // Arrange
    final theme = _lightTheme.extension<FinancialSummaryCardTheme>()!;

    // Act
    await tester.pumpWidget(
      _TestApp(
        theme: _lightTheme,
        child: const FinancialSummaryCard(
          title: 'INCOME',
          value: 'R\$ 12.400,00',
          variationPercent: 15,
          icon: Icon(Icons.trending_up),
        ),
      ),
    );

    // Assert
    expect(find.text('INCOME'), findsOneWidget);
    expect(find.text('R\$ 12.400,00'), findsOneWidget);
    expect(find.text('+15%'), findsOneWidget);
    expect(find.byIcon(Icons.trending_up), findsOneWidget);
    expect(_surfaceColor(tester), theme.positive.background);
    expect(_textColor(tester, 'INCOME'), theme.positive.foreground);
    expect(_textColor(tester, '+15%'), theme.positive.accentForeground);
  });

  testWidgets('renderiza estado negativo com palette de tema escuro', (
    tester,
  ) async {
    // Arrange
    final theme = _darkTheme.extension<FinancialSummaryCardTheme>()!;

    // Act
    await tester.pumpWidget(
      _TestApp(
        theme: _darkTheme,
        child: const FinancialSummaryCard(
          title: 'EXPENSES',
          value: 'R\$ 3.240,00',
          variationPercent: -8,
          icon: Icon(Icons.trending_down),
        ),
      ),
    );

    // Assert
    expect(find.text('EXPENSES'), findsOneWidget);
    expect(find.text('R\$ 3.240,00'), findsOneWidget);
    expect(find.text('-8%'), findsOneWidget);
    expect(find.byIcon(Icons.trending_down), findsOneWidget);
    expect(_surfaceColor(tester), theme.negative.background);
    expect(_textColor(tester, 'EXPENSES'), theme.negative.foreground);
    expect(_textColor(tester, '-8%'), theme.negative.accentForeground);
  });

  testWidgets('chama callback ao tocar no card', (tester) async {
    // Arrange
    var tapCount = 0;

    await tester.pumpWidget(
      _TestApp(
        theme: _lightTheme,
        child: FinancialSummaryCard(
          title: 'BALANCE',
          value: 'R\$ 9.160,00',
          variationPercent: 4,
          icon: const Icon(Icons.account_balance_wallet),
          onTap: () => tapCount++,
        ),
      ),
    );

    // Act
    await tester.tap(find.byType(FinancialSummaryCard));
    await tester.pump();

    // Assert
    expect(tapCount, 1);
  });
}

final ThemeData _lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  extensions: FinancialHealthDesignTheme.lightExtensions,
);

final ThemeData _darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  extensions: FinancialHealthDesignTheme.darkExtensions,
);

class _TestApp extends StatelessWidget {
  const _TestApp({required this.theme, required this.child});

  final ThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(child: SizedBox(width: 342, child: child)),
      ),
    );
  }
}

Color? _surfaceColor(WidgetTester tester) {
  final surface = tester.widget<DecoratedBox>(
    find.byKey(const ValueKey('financial_summary_card_surface')),
  );
  return (surface.decoration as BoxDecoration).color;
}

Color? _textColor(WidgetTester tester, String text) {
  return tester.widget<Text>(find.text(text)).style?.color;
}
