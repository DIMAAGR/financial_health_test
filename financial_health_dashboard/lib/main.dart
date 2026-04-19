import 'package:financial_health_dashboard/src/core/app/app.dart';
import 'package:financial_health_dashboard/src/core/dependencies/injection.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');
  setupCoreInjection();

  runApp(App());
}
