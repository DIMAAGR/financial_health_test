import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/add_income_input.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/incomes_overview_data.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/use_cases/add_income_use_case.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/use_cases/get_incomes_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/view_model/incomes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomesCubit extends Cubit<IncomesState> {
  IncomesCubit(this._getOverviewUseCase, this._addIncomeUseCase) : super(IncomesState.initial());

  final GetIncomesOverviewUseCase _getOverviewUseCase;
  final AddIncomeUseCase _addIncomeUseCase;

  Future<void> loadOverview() async {
    emit(state.copyWith(status: IncomesViewStatus.loading, clearError: true, clearEffect: true));

    final result = await _getOverviewUseCase();
    result.fold(_setError, _updateContent);
  }

  void onAddIncomePressed() {
    emit(
      state.copyWith(
        effect: IncomesEffect.showAddIncomeSheet,
        effectVersion: state.effectVersion + 1,
      ),
    );
  }

  void clearEffect() => emit(state.copyWith(clearEffect: true));

  Future<bool> addIncome(AddIncomeInput input) async {
    final result = await _addIncomeUseCase(input);
    return result.fold(
      (failure) {
        _setError(failure);
        return false;
      },
      (_) async {
        await _silentReload();
        return true;
      },
    );
  }

  Future<void> _silentReload() async {
    final result = await _getOverviewUseCase();
    result.fold(_setError, _updateContent);
  }

  void _setError(AppFailure failure) {
    emit(
      state.copyWith(
        status: IncomesViewStatus.error,
        errorMessage: failure.message,
        canRetry: failure is NetworkFailure || failure is ServerFailure,
        clearEffect: true,
      ),
    );
  }

  void _updateContent(IncomesOverviewData data) {
    emit(
      IncomesState(
        totalIncome: data.totalIncome,
        monthLabel: data.monthLabel,
        incomeChangePercent: data.incomeChangePercent,
        transactions: data.transactions,
        categoryBreakdown: data.categoryBreakdown,
        status: IncomesViewStatus.success,
        effectVersion: state.effectVersion,
      ),
    );
  }
}
