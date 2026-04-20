import 'package:financial_health_dashboard/src/core/dependencies/dependencies.dart';
import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/use_cases/get_transactions_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_cubit.dart';

class TransactionsFeatureDependencies extends FeatureDependencies {
  TransactionsFeatureDependencies(super.i);

  @override
  void data(GetIt i) {
    i
      ..registerLazySingleton<TransactionsRemoteDataSource>(
        () => TransactionsRemoteDataSourceImpl(i<HttpService>(), i<NetworkInfo>()),
      )
      ..registerLazySingleton<TransactionsRepository>(
        () => TransactionsRepositoryImpl(i<TransactionsRemoteDataSource>()),
      );
  }

  @override
  void useCases(GetIt i) {
    i.registerFactory<GetTransactionsOverviewUseCase>(
      () => GetTransactionsOverviewUseCase(i<TransactionsRepository>()),
    );
  }

  @override
  void presentation(GetIt i) {
    i.registerFactory<TransactionsCubit>(
      () => TransactionsCubit(i<GetTransactionsOverviewUseCase>()),
    );
  }
}
