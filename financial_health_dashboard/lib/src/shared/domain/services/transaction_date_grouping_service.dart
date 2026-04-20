import 'package:financial_health_dashboard/src/core/services/clock/clock.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_date_group_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/extensions/date_time_grouping_extension.dart';

final class TransactionDateGroupingService {
  const TransactionDateGroupingService({this.clock = const SystemClock()});

  final Clock clock;

  List<TransactionDateGroupData> groupByDate(List<TransactionData> transactions) {
    final grouped = <String, List<TransactionData>>{};
    final datesByKey = <String, DateTime>{};

    for (final transaction in transactions) {
      final effectiveDate = _resolveDate(transaction);
      final key = effectiveDate.dateGroupKey;

      grouped.putIfAbsent(key, () => []).add(transaction);
      datesByKey.putIfAbsent(key, () => effectiveDate);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => datesByKey[b]!.compareTo(datesByKey[a]!));

    return sortedKeys
        .map((key) {
          final sortedTransactions = [...grouped[key]!]
            ..sort((a, b) => _resolveDate(b).compareTo(_resolveDate(a)));

          return TransactionDateGroupData(date: datesByKey[key]!, transactions: sortedTransactions);
        })
        .toList(growable: false);
  }

  DateTime _resolveDate(TransactionData transaction) {
    return (transaction.date ?? clock.now()).dateOnly;
  }
}
