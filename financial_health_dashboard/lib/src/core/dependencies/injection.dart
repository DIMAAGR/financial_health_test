import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:financial_health_dashboard/src/core/router/app_router.dart';
import 'package:financial_health_dashboard/src/core/services/clock/clock.dart';
import 'package:financial_health_dashboard/src/core/services/http/fake_http_service.dart';
import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/core/services/router/router_service.dart';
import 'package:financial_health_dashboard/src/core/services/storage/key_value_wrapper.dart';
import 'package:financial_health_dashboard/src/features/dashboard/dashboard_init.dart';
import 'package:financial_health_dashboard/src/features/expenses/expenses_init.dart';
import 'package:financial_health_dashboard/src/features/incomes/incomes_init.dart';
import 'package:financial_health_dashboard/src/features/transactions/transactions_init.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/// Registers shared core infrastructure (Firebase, Auth, Storage, Network, Services).
/// Platform-specific dependencies (notifications, deep links, media) are registered
/// by each module's injection (client or admin).
void setupCoreInjection() {
  _registerCore();
  _registerStorage();
  _registerNetwork();
  _registerRoute();
  _registerFeatures();
}

// ---------------- CORE ----------------

void _registerCore() {
  getIt.registerLazySingleton<Clock>(() => const SystemClock());
}

// ---------------- FEATURES ----------------

void _registerFeatures() {
  DashboardFeatureDependencies(getIt);
  TransactionsFeatureDependencies(getIt);
  IncomesFeatureDependencies(getIt);
  ExpensesFeatureDependencies(getIt);
}

// ---------------- ROUTER ----------------------
void _registerRoute() {
  getIt.registerLazySingleton<RouterService>(() => RouterServiceImpl(buildRoute()));
}

// ---------------- STORAGE ----------------

void _registerStorage() {
  getIt.registerLazySingleton<KeyValueWrapper>(() => InMemoryKeyValueWrapper());
}

// ---------------- NETWORK / DIO ----------------

void _registerNetwork() {
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt<Connectivity>()));
  getIt.registerLazySingleton<HttpService>(
    () => FakeHttpService(storage: getIt<KeyValueWrapper>()),
  );
}
