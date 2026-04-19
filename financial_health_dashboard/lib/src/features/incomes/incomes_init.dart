import 'package:financial_health_dashboard/src/core/dependencies/dependencies.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/add_dashboard_income_use_case.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/use_cases/get_incomes_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/view_model/incomes_cubit.dart';

class IncomesFeatureDependencies extends FeatureDependencies {
  IncomesFeatureDependencies(super.i);

  @override
  void data(GetIt i) {
    // Reuses DashboardRepository registered by DashboardFeatureDependencies.
  }

  @override
  void useCases(GetIt i) {
    i.registerFactory<GetIncomesOverviewUseCase>(
      () => GetIncomesOverviewUseCase(i<DashboardRepository>()),
    );
  }

  @override
  void presentation(GetIt i) {
    i.registerFactory<IncomesCubit>(
      () => IncomesCubit(i<GetIncomesOverviewUseCase>(), i<AddDashboardIncomeUseCase>()),
    );
  }
}
