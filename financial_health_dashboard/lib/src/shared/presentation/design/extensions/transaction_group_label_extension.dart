import 'package:financial_health_dashboard/src/shared/domain/extensions/date_time_grouping_extension.dart';
import 'package:intl/intl.dart';

extension TransactionGroupLabelExtension on DateTime {
  String toTransactionGroupLabel({required DateTime referenceDate}) {
    final normalizedReferenceDate = referenceDate.dateOnly;
    final normalizedDate = dateOnly;
    final yesterday = normalizedReferenceDate.subtract(const Duration(days: 1));
    final prefix = normalizedDate.isSameCalendarDateAs(normalizedReferenceDate)
        ? 'HOJE'
        : normalizedDate.isSameCalendarDateAs(yesterday)
        ? 'ONTEM'
        : '';
    final formattedDate = DateFormat('dd MMM', 'pt_BR').format(this).toUpperCase();

    return prefix.isEmpty ? formattedDate : '$prefix, $formattedDate';
  }
}
