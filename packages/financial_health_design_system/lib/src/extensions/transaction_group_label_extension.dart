import 'package:intl/intl.dart';

/// Extension on [DateTime] for generating human-readable transaction group labels.
///
/// Used by [TransactionListSection] to produce the date header above each
/// group of transactions. The label adapts based on how recent the date is
/// relative to a provided [referenceDate].
///
/// ## Examples
/// ```dart
/// final today = DateTime(2026, 4, 22);
/// today.toTransactionGroupLabel(referenceDate: today); // "HOJE, 22 ABR"
///
/// final yesterday = DateTime(2026, 4, 21);
/// yesterday.toTransactionGroupLabel(referenceDate: today); // "ONTEM, 21 ABR"
///
/// final older = DateTime(2026, 4, 10);
/// older.toTransactionGroupLabel(referenceDate: today); // "10 ABR"
/// ```
extension TransactionGroupLabelExtension on DateTime {
  /// Returns a formatted date label for use as a transaction group header.
  ///
  /// - Returns `"HOJE, DD MMM"` when this date matches [referenceDate].
  /// - Returns `"ONTEM, DD MMM"` when this date is one day before [referenceDate].
  /// - Returns `"DD MMM"` for all earlier dates.
  ///
  /// Both the prefix and the date portion are uppercased.
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
