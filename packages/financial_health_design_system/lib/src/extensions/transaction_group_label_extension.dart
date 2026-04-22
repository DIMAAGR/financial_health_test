import 'package:intl/intl.dart';

extension TransactionGroupLabelExtension on DateTime {
  String toTransactionGroupLabel({required DateTime referenceDate}) {
    final normalizedReferenceDate = referenceDate._dateOnly;
    final normalizedDate = _dateOnly;
    final yesterday = normalizedReferenceDate.subtract(const Duration(days: 1));
    final prefix = normalizedDate._isSameCalendarDateAs(normalizedReferenceDate)
        ? 'HOJE'
        : normalizedDate._isSameCalendarDateAs(yesterday)
        ? 'ONTEM'
        : '';
    final formattedDate = DateFormat(
      'dd MMM',
      'pt_BR',
    ).format(this).toUpperCase();

    return prefix.isEmpty ? formattedDate : '$prefix, $formattedDate';
  }

  DateTime get _dateOnly => DateTime(year, month, day);

  bool _isSameCalendarDateAs(DateTime other) => _dateOnly == other._dateOnly;
}
