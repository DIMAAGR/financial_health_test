import 'package:flutter/foundation.dart';
import 'package:transaction_refactor/core/failures/app_failure.dart';
import 'package:transaction_refactor/features/transactions/domain/use_cases/get_transactions_use_case.dart';
import 'package:transaction_refactor/features/transactions/presentation/mappers/transaction_item_mapper.dart';
import 'package:transaction_refactor/features/transactions/presentation/view_model/transaction_state.dart';

/// ViewModel da tela de transações.
///
/// Expõe um [ValueNotifier<TransactionState>] para que a View observe
/// mudanças sem acoplamento ao BLoC/Cubit.
class TransactionViewModel {
  TransactionViewModel(this._getTransactionsUseCase);

  final GetTransactionsUseCase _getTransactionsUseCase;

  final ValueNotifier<TransactionState> state = ValueNotifier(
    const TransactionLoadingState(),
  );

  Future<void> loadTransactions() async {
    state.value = const TransactionLoadingState();

    final result = await _getTransactionsUseCase();

    result.fold(
      (failure) => state.value = TransactionErrorState(
        message: failure.message,
        canRetry: failure is NetworkFailure || failure is ServerFailure,
      ),
      (report) {
        if (report.isEmpty) {
          state.value = const TransactionEmptyState();
        } else {
          state.value = TransactionSuccessState(
            items: TransactionItemMapper.fromEntities(report.transactions),
            total: report.total,
          );
        }
      },
    );
  }

  void dispose() {
    state.dispose();
  }
}
