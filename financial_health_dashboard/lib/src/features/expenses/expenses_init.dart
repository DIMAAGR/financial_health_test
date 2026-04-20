import 'package:financial_health_dashboard/src/core/dependencies/dependencies.dart';
import 'package:financial_health_dashboard/src/core/services/http/http_service.dart';
import 'package:financial_health_dashboard/src/core/services/network/network_info.dart';
import 'package:financial_health_dashboard/src/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:financial_health_dashboard/src/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/use_cases/add_expense_use_case.dart';
import 'package:financial_health_dashboard/src/features/expenses/domain/use_cases/get_expenses_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_cubit.dart';

class ExpensesFeatureDependencies extends FeatureDependencies {
  ExpensesFeatureDependencies(super.i);

  @override
  void data(GetIt i) {
    i
      ..registerLazySingleton<ExpensesRemoteDataSource>(
        () => ExpensesRemoteDataSourceImpl(i<HttpService>(), i<NetworkInfo>()),
      )
      ..registerLazySingleton<ExpensesRepository>(
        () => ExpensesRepositoryImpl(i<ExpensesRemoteDataSource>()),
      );
  }

  @override
  void useCases(GetIt i) {
    i
      ..registerFactory<GetExpensesOverviewUseCase>(
        () => GetExpensesOverviewUseCase(i<ExpensesRepository>()),
      )
      ..registerFactory<AddExpenseUseCase>(() => AddExpenseUseCase(i<ExpensesRepository>()));
  }

  @override
  void presentation(GetIt i) {
    i.registerFactory<ExpensesCubit>(
      () => ExpensesCubit(i<GetExpensesOverviewUseCase>(), i<AddExpenseUseCase>()),
    );
  }
}
