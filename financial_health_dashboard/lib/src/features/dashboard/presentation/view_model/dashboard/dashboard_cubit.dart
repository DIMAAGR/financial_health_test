import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_expense_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/add_dashboard_income_input.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_overview_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/add_dashboard_expense_use_case.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/add_dashboard_income_use_case.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/use_cases/get_dashboard_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/dashboard/dashboard_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._addExpenseUseCase, this._addIncomeUseCase, this._getOverviewUseCase)
    : super(DashboardState.initial());

  final GetDashboardOverviewUseCase _getOverviewUseCase;
  final AddDashboardIncomeUseCase _addIncomeUseCase;
  final AddDashboardExpenseUseCase _addExpenseUseCase;

  void _setLoading() {
    emit(state.copyWith(status: DashboardViewStatus.loading, clearError: true, clearEffect: true));
  }

  void _setError(AppFailure failure) {
    emit(
      state.copyWith(
        status: DashboardViewStatus.error,
        errorMessage: failure.message,
        canRetry: failure is NetworkFailure || failure is ServerFailure,
        clearEffect: true,
      ),
    );
  }

  void _updateOverviewContent(DashboardOverviewData overview) {
    emit(DashboardState.fromOverview(overview, effectVersion: state.effectVersion));
  }

  Future<void> loadOverview() async {
    _setLoading();
    await _handleOverviewResult(_getOverviewUseCase());
  }

  void _showBottomSheet(DashboardEffect effect) {
    emit(state.copyWith(effect: effect, effectVersion: state.effectVersion + 1));
  }

  void onAddIncomePressed() => _showBottomSheet(DashboardEffect.showAddIncomeSheet);
  void onAddExpensePressed() => _showBottomSheet(DashboardEffect.showAddExpenseSheet);

  void clearEffect() => emit(state.copyWith(clearEffect: true));

  Future<void> _handleOverviewResult(
    Future<Either<AppFailure, DashboardOverviewData>> future,
  ) async {
    final result = await future;
    result.fold(_setError, _updateOverviewContent);
  }

  Future<bool> addIncome(AddDashboardIncomeInput input) async {
    final result = await _addIncomeUseCase(input);
    return result.fold(
      (failure) {
        _setError(failure);
        return false;
      },
      (overview) {
        _updateOverviewContent(overview);
        return true;
      },
    );
  }

  Future<bool> addExpense(AddDashboardExpenseInput input) async {
    final result = await _addExpenseUseCase(input);
    return result.fold(
      (failure) {
        _setError(failure);
        return false;
      },
      (overview) {
        _updateOverviewContent(overview);
        return true;
      },
    );
  }
}
