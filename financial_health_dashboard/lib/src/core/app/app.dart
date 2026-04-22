import 'package:financial_health_dashboard/src/core/services/router/router_service.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final RouterService router = GetIt.I.get();
    return MaterialApp.router(
      title: 'Financial Health Dashboard',
      routerConfig: router(),
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
