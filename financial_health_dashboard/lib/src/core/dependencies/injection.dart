import 'package:financial_health_dashboard/src/core/router/app_router.dart';
import 'package:financial_health_dashboard/src/core/services/router/router_service.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/// Registers shared core infrastructure (Firebase, Auth, Storage, Network, Services).
/// Platform-specific dependencies (notifications, deep links, media) are registered
/// by each module's injection (client or admin).
void setupCoreInjection() {
  _registerCore();
  _registerSession();
  _registerStorage();
  _registerNetwork();
  _registerServices();
  _registerRoute();
}

// ---------------- CORE ----------------

void _registerCore() {}

// ---------------- ROUTER ----------------------
void _registerRoute() {
  getIt.registerLazySingleton<RouterService>(() => RouterServiceImpl(buildRoute()));
}

// ---------------- SESSION & AUTH ----------------

void _registerSession() {}

// ---------------- STORAGE ----------------

void _registerStorage() {}

// ---------------- NETWORK / DIO ----------------

void _registerNetwork() {}

// ---------------- SERVICES ----------------

void _registerServices() {}
