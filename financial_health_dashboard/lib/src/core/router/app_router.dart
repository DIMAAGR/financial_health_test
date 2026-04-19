import 'package:financial_health_dashboard/src/core/dependencies/injection.dart';
import 'package:financial_health_dashboard/src/core/router/app_routes.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/dashboard/dashboard_cubit.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view/expenses_view.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_cubit.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/view/incomes_view.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/view_model/incomes_cubit.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/view/transactions_view.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter buildRoute() {
  return GoRouter(
    routes: [
      GoRoute(
        path: AppRoutesPath.main,
        name: AppRouteName.main,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<DashboardCubit>()..loadOverview(),
          child: const DashboardView(),
        ),
      ),
      GoRoute(
        path: AppRoutesPath.transactions,
        name: AppRouteName.transactions,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<TransactionsCubit>()..loadOverview(),
          child: const TransactionsView(),
        ),
      ),
      GoRoute(
        path: AppRoutesPath.incomes,
        name: AppRouteName.incomes,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<IncomesCubit>()..loadOverview(),
          child: const IncomesView(),
        ),
      ),
      GoRoute(
        path: AppRoutesPath.receipts,
        name: AppRouteName.receipts,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<ExpensesCubit>()..loadOverview(),
          child: const ExpensesView(),
        ),
      ),
    ],
  );
}
