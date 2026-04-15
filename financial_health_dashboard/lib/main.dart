import 'package:financial_health_dashboard/src/core/app/app.dart';
import 'package:financial_health_dashboard/src/core/dependencies/injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  setupCoreInjection();

  runApp(App());
}
