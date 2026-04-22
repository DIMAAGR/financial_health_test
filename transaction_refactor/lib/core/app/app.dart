import 'package:flutter/material.dart';
import 'package:transaction_refactor/core/di/injection.dart';
import 'package:transaction_refactor/features/transactions/presentation/view/transaction_page.dart';
import 'package:transaction_refactor/shared/presentation/design/transaction_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction Refactor — Desafio 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        extensions: const [TransactionColors.light],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
        useMaterial3: true,
        extensions: const [TransactionColors.dark],
      ),
      home: TransactionPage(viewModel: getIt()),
    );
  }
}
