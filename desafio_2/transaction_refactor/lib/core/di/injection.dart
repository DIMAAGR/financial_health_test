import 'package:get_it/get_it.dart';
import 'package:transaction_refactor/core/services/auth/auth_token_provider.dart';
import 'package:transaction_refactor/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:transaction_refactor/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:transaction_refactor/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:transaction_refactor/features/transactions/domain/use_cases/get_transactions_use_case.dart';
import 'package:transaction_refactor/features/transactions/presentation/view_model/transaction_view_model.dart';

/// Instância global do GetIt — acessada por toda a aplicação.
final GetIt getIt = GetIt.instance;

/// Registra todas as dependências da aplicação.
///
/// Singletons para infraestrutura compartilhada.
/// Factory para o ViewModel (novo por tela, facilita teste e dispose).
void setupInjection() {
  // ── Auth ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthTokenProvider>(
    () => const DemoAuthTokenProvider(),
  );

  // ── Data ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<TransactionRemoteDataSource>(
    () => DemoTransactionRemoteDataSource(getIt<AuthTokenProvider>()),
  );

  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(getIt<TransactionRemoteDataSource>()),
  );

  // ── Domain ────────────────────────────────────────────────────────────────
  getIt.registerFactory<GetTransactionsUseCase>(
    () => GetTransactionsUseCase(getIt<TransactionRepository>()),
  );

  // ── Presentation ──────────────────────────────────────────────────────────
  getIt.registerFactory<TransactionViewModel>(
    () => TransactionViewModel(getIt<GetTransactionsUseCase>()),
  );
}
