import 'package:financial_health_dashboard/src/core/dependencies/dependencies.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/add_dashboard_expense_use_case.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/use_cases/get_expenses_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_cubit.dart';

class ExpensesFeatureDependencies extends FeatureDependencies {
  ExpensesFeatureDependencies(super.i);

  @override
  void data(GetIt i) {
    // Reuses DashboardRepository registered by DashboardFeatureDependencies.
  }

  @override
  void useCases(GetIt i) {
    i.registerFactory<GetExpensesOverviewUseCase>(
      () => GetExpensesOverviewUseCase(i<DashboardRepository>()),
    );
  }

  @override
  void presentation(GetIt i) {
    i.registerFactory<ExpensesCubit>(
      () => ExpensesCubit(i<GetExpensesOverviewUseCase>(), i<AddDashboardExpenseUseCase>()),
    );
  }
}
