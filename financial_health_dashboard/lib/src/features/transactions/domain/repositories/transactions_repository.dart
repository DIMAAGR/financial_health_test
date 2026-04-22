import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/transactions/domain/entities/transactions_overview_data.dart';

abstract class TransactionsRepository {
  Future<Either<AppFailure, TransactionsOverviewData>> getOverview();
}
