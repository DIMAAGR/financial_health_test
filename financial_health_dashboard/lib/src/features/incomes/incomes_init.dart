import 'package:financial_health_dashboard/src/core/dependencies/dependencies.dart';
import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/features/incomes/data/datasources/incomes_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/incomes/data/repositories/incomes_repository_impl.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/repositories/incomes_repository.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/use_cases/add_income_use_case.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/use_cases/get_incomes_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/view_model/incomes_cubit.dart';

class IncomesFeatureDependencies extends FeatureDependencies {
  IncomesFeatureDependencies(super.i);

  @override
  void data(GetIt i) {
    i
      ..registerLazySingleton<IncomesRemoteDataSource>(
        () => IncomesRemoteDataSourceImpl(i<HttpService>(), i<NetworkInfo>()),
      )
      ..registerLazySingleton<IncomesRepository>(
        () => IncomesRepositoryImpl(i<IncomesRemoteDataSource>()),
      );
  }

  @override
  void useCases(GetIt i) {
    i
      ..registerFactory<GetIncomesOverviewUseCase>(
        () => GetIncomesOverviewUseCase(i<IncomesRepository>()),
      )
      ..registerFactory<AddIncomeUseCase>(() => AddIncomeUseCase(i<IncomesRepository>()));
  }

  @override
  void presentation(GetIt i) {
    i.registerFactory<IncomesCubit>(
      () => IncomesCubit(i<GetIncomesOverviewUseCase>(), i<AddIncomeUseCase>()),
    );
  }
}
