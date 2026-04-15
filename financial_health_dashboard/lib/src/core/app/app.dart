import 'package:financial_health_dashboard/src/core/services/router/router_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _getIt = GetIt.I;

  @override
  Widget build(BuildContext context) {
    final RouterService router = _getIt.get();
    return MaterialApp.router(
      title: 'Financial Health Dashboard',
      routerConfig: router(),
      debugShowCheckedModeBanner: false,
    );
  }
}
