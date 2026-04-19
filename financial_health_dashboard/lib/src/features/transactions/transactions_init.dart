import 'package:financial_health_dashboard/src/core/dependencies/dependencies.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/use_cases/get_transactions_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_cubit.dart';

class TransactionsFeatureDependencies extends FeatureDependencies {
  TransactionsFeatureDependencies(super.i);

  @override
  void data(GetIt i) {
    // Reuses DashboardRepository registered by DashboardFeatureDependencies.
  }

  @override
  void useCases(GetIt i) {
    i.registerFactory<GetTransactionsOverviewUseCase>(
      () => GetTransactionsOverviewUseCase(i<DashboardRepository>()),
    );
  }

  @override
  void presentation(GetIt i) {
    i.registerFactory<TransactionsCubit>(
      () => TransactionsCubit(i<GetTransactionsOverviewUseCase>()),
    );
  }
}
