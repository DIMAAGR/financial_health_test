import 'package:financial_health_dashboard/src/core/dependencies/injection.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_sheet_type.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/add_transaction/add_transaction_cubit.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/add_transaction_bottom_sheet.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerFactoryParam<AddTransactionCubit, SheetType, void>(
      (sheetType, _) => AddTransactionCubit(sheetType),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('sheet de income fecha após submit', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appLightTheme,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () => showTransactionBottomSheet(
                  context,
                  sheetType: SheetType.income,
                  onSubmit: (_) async => true,
                ),
                child: const Text('open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '1000');
    await tester.enterText(find.byType(TextField).at(1), 'Salário');
    await tester.pump();

    await tester.tap(find.text('Salvar Receita'));
    await tester.pumpAndSettle();

    expect(find.text('Adicionar Receita'), findsNothing);
  });

  testWidgets('sheet de expense fecha após submit', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appLightTheme,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () => showTransactionBottomSheet(
                  context,
                  sheetType: SheetType.expense,
                  onSubmit: (_) async => true,
                ),
                child: const Text('open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '1000');
    await tester.enterText(find.byType(TextField).at(1), 'Mercado');
    await tester.pump();

    await tester.tap(find.text('Salvar Despesa'));
    await tester.pumpAndSettle();

    expect(find.text('Adicionar Despesa'), findsNothing);
  });

  testWidgets(
    'sheet de expense permanece aberto e libera retry quando submit falha',
    (tester) async {
      var submitCalls = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: appLightTheme,
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: TextButton(
                  onPressed: () => showTransactionBottomSheet(
                    context,
                    sheetType: SheetType.expense,
                    onSubmit: (_) async {
                      submitCalls += 1;
                      return false;
                    },
                  ),
                  child: const Text('open'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), '1000');
      await tester.enterText(find.byType(TextField).at(1), 'Mercado');
      await tester.pump();

      await tester.tap(find.text('Salvar Despesa'));
      await tester.pumpAndSettle();

      expect(submitCalls, 1);
      expect(find.text('Adicionar Despesa'), findsOneWidget);
      expect(find.text('Salvar Despesa'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.text('Salvar Despesa'));
      await tester.pumpAndSettle();

      expect(submitCalls, 2);
    },
  );
}
