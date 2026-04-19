import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/failures/dashboard_failure.dart';
import 'package:financial_health_dashboard/src/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/entities/transactions_overview_data.dart';

class GetTransactionsOverviewUseCase {
  const GetTransactionsOverviewUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<DashboardFailure, TransactionsOverviewData>> call() async {
    final result = await _repository.getOverview();
    return result.map(
      (overview) => TransactionsOverviewData(
        balance: overview.balance,
        income: overview.income,
        expense: overview.expense,
        monthLabel: overview.monthlyGoal.monthLabel,
        balanceChangePercent: overview.balanceChangePercent,
        transactions: List.unmodifiable(overview.transactions),
      ),
    );
  }
}
