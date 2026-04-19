import 'package:financial_health_dashboard/src/features/dashboard/domain/failures/dashboard_failure.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/use_cases/get_transactions_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit(this._getOverviewUseCase) : super(TransactionsState.initial());

  final GetTransactionsOverviewUseCase _getOverviewUseCase;

  Future<void> loadOverview() async {
    emit(state.copyWith(status: TransactionsViewStatus.loading, clearError: true));

    final result = await _getOverviewUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionsViewStatus.error,
          errorMessage: failure.message,
          canRetry: failure is DashboardNetworkFailure || failure is DashboardServerFailure,
        ),
      ),
      (data) => emit(
        TransactionsState(
          balance: data.balance,
          income: data.income,
          expense: data.expense,
          monthLabel: data.monthLabel,
          balanceChangePercent: data.balanceChangePercent,
          transactions: data.transactions,
          status: TransactionsViewStatus.success,
        ),
      ),
    );
  }
}
