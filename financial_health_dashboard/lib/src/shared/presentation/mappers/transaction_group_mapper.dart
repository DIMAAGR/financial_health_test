import 'package:financial_health_dashboard/src/core/services/clock/clock.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_date_group_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/extensions/date_time_grouping_extension.dart';
import 'package:financial_health_dashboard/src/shared/domain/services/transaction_date_grouping_service.dart';
import 'package:financial_health_design_system/financial_health_design_system.dart';

final class TransactionGroupMapper {
  const TransactionGroupMapper._();

  static List<TransactionGroup> toTransactionsGroups(
    List<TransactionData> transactions, {
    TransactionDateGroupingService groupingService =
        const TransactionDateGroupingService(),
    Clock clock = const SystemClock(),
  }) {
    return _mapGroups(
      groupingService.groupByDate(transactions),
      referenceDate: clock.now(),
      itemMapper: (transaction) {
        final isExpense = transaction.type == TransactionType.expense;
        final sign = isExpense ? '-' : '+';

        return TransactionListItem(
          name: transaction.title,
          subtitle: categoryLabel(transaction.category),
          amount: '$sign${transaction.value.toBRL()}',
          icon: categoryIcon(transaction.category),
          isExpense: isExpense,
        );
      },
    );
  }

  static List<TransactionGroup> toIncomeGroups(
    List<TransactionData> transactions, {
    TransactionDateGroupingService groupingService =
        const TransactionDateGroupingService(),
    Clock clock = const SystemClock(),
  }) {
    return _mapGroups(
      groupingService.groupByDate(transactions),
      referenceDate: clock.now(),
      itemMapper: (transaction) {
        return TransactionListItem(
          name: transaction.title,
          subtitle: categoryLabel(transaction.category),
          amount: transaction.value.toBRL(),
          paymentMethod: 'PIX',
          icon: categoryIcon(transaction.category),
        );
      },
    );
  }

  static List<TransactionGroup> toExpenseGroups(
    List<TransactionData> transactions, {
    TransactionDateGroupingService groupingService =
        const TransactionDateGroupingService(),
    Clock clock = const SystemClock(),
  }) {
    return _mapGroups(
      groupingService.groupByDate(transactions),
      referenceDate: clock.now(),
      itemMapper: (transaction) {
        return TransactionListItem(
          name: transaction.title,
          subtitle: categoryLabel(transaction.category),
          amount: transaction.value.toBRL(),
          paymentMethod: 'CARTÃO',
          icon: categoryIcon(transaction.category),
        );
      },
    );
  }

  static List<TransactionGroup> _mapGroups(
    List<TransactionDateGroupData> groups, {
    required DateTime referenceDate,
    required TransactionListItem Function(TransactionData transaction)
    itemMapper,
  }) {
    final normalizedReferenceDate = referenceDate.dateOnly;

    return groups
        .map((group) {
          final isToday = group.date.isSameCalendarDateAs(
            normalizedReferenceDate,
          );

          return TransactionGroup(
            dateLabel: group.date.toTransactionGroupLabel(
              referenceDate: normalizedReferenceDate,
            ),
            isToday: isToday,
            items: group.transactions.map(itemMapper).toList(growable: false),
          );
        })
        .toList(growable: false);
  }
}
