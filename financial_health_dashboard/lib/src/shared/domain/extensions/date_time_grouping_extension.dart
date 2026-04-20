extension DateTimeGroupingExtension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  String get dateGroupKey => '$year-$month-$day';

  bool isSameCalendarDateAs(DateTime other) => dateOnly == other.dateOnly;
}
