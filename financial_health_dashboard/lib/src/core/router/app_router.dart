import 'package:financial_health_dashboard/src/core/router/app_routes.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:go_router/go_router.dart';

GoRouter buildRoute() {
  return GoRouter(
    routes: [
      GoRoute(
        path: AppRoutesPath.main,
        name: AppRouteName.main,
        builder: (context, state) => DashboardView(),
      ),
    ],
  );
}
