import 'package:financial_health_dashboard/src/core/dependencies/dependencies.dart';
import 'package:financial_health_dashboard/src/core/services/clock/clock.dart';
import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/add_dashboard_expense_use_case.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/add_dashboard_income_use_case.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/get_dashboard_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_sheet_type.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/add_transaction/add_transaction_cubit.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/dashboard/dashboard_cubit.dart';

class DashboardFeatureDependencies extends FeatureDependencies {
  DashboardFeatureDependencies(super.i);

  @override
  void data(GetIt i) {
    i
      ..registerLazySingleton<DashboardRemoteDataSource>(
        () => DashboardRemoteDataSourceImpl(i<HttpService>(), i<NetworkInfo>()),
      )
      ..registerLazySingleton<DashboardRepository>(
        () => DashboardRepositoryImpl(i<DashboardRemoteDataSource>(), i<Clock>()),
      );
  }

  @override
  void useCases(GetIt i) {
    i
      ..registerFactory<GetDashboardOverviewUseCase>(
        () => GetDashboardOverviewUseCase(i<DashboardRepository>()),
      )
      ..registerFactory<AddDashboardIncomeUseCase>(
        () => AddDashboardIncomeUseCase(i<DashboardRepository>()),
      )
      ..registerFactory<AddDashboardExpenseUseCase>(
        () => AddDashboardExpenseUseCase(i<DashboardRepository>()),
      );
  }

  @override
  void presentation(GetIt i) {
    i
      ..registerFactory<DashboardCubit>(
        () => DashboardCubit(
          i<AddDashboardExpenseUseCase>(),
          i<AddDashboardIncomeUseCase>(),
          i<GetDashboardOverviewUseCase>(),
        ),
      )
      ..registerFactoryParam<AddTransactionCubit, SheetType, void>(
        (sheetType, _) => AddTransactionCubit(sheetType),
      );
  }
}
