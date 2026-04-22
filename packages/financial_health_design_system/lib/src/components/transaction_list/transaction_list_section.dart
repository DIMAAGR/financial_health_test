import 'package:financial_health_design_system/src/components/svg_icon/app_svg_icon.dart';
import 'package:financial_health_design_system/src/foundations/tokens/app_radius.dart';
import 'package:financial_health_design_system/src/foundations/tokens/app_spacing.dart';
import 'package:financial_health_design_system/src/theme/extensions/app_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/transaction_list_theme_ext.dart';
import 'package:flutter/material.dart';

/// Immutable data class representing a single transaction row.
class TransactionListItem {
  /// Creates a [TransactionListItem].
  const TransactionListItem({
    required this.name,
    required this.subtitle,
    required this.amount,
    this.paymentMethod,
    required this.icon,
    this.isExpense,
  });

  /// Primary label for the transaction (e.g., "iFood", "Salário").
  final String name;

  /// Secondary label, typically the category name (e.g., "Alimentação").
  final String subtitle;

  /// Pre-formatted monetary amount (e.g., `"R$ 84,50"`).
  final String amount;

  /// Optional payment method label (e.g., `"Crédito"`, `"Débito"`).
  final String? paymentMethod;

  /// Asset path for the category icon. Use [AppIcons] or [categoryIcon] to
  /// resolve the correct path from a category code.
  final String icon;

  /// Whether this transaction is an expense.
  ///
  /// - `true` — renders the amount in [TransactionListTheme.itemAmountExpense].
  /// - `false` — renders in [TransactionListTheme.itemAmountIncome].
  /// - `null` — renders in [TransactionListTheme.itemAmount] (neutral).
  final bool? isExpense;
}

/// Groups a set of [TransactionListItem]s under a single date label.
class TransactionGroup {
  /// Creates a [TransactionGroup].
  const TransactionGroup({required this.dateLabel, required this.items, this.isToday = false});

  /// The formatted date label shown above the group
  /// (e.g., `"HOJE, 22 ABR"` or `"19 ABR"`). Use
  /// [TransactionGroupLabelExtension.toTransactionGroupLabel] to build this
  /// string from a [DateTime].
  final String dateLabel;

  /// Transactions belonging to this date group.
  final List<TransactionListItem> items;

  /// When `true`, the date label pill is styled using
  /// [TransactionListTheme.dateBorderToday] to visually highlight today.
  final bool isToday;
}

/// Displays a full section of transactions grouped by date.
///
/// The section has a heading with [title] and a [totalItems] count badge,
/// followed by one or more [TransactionGroup]s each with their date pill and
/// transaction rows.
///
/// Colors are resolved from [TransactionListTheme] via [BuildContext].
///
/// ## Usage
/// ```dart
/// TransactionListSection(
///   title: 'Transações',
///   totalItems: groups.fold(0, (acc, g) => acc + g.items.length),
///   groups: groups,
/// )
/// ```
class TransactionListSection extends StatelessWidget {
  /// Creates a [TransactionListSection].
  const TransactionListSection({
    super.key,
    required this.title,
    required this.totalItems,
    required this.groups,
  });

  /// Section heading text (e.g., `"Transações"`).
  final String title;

  /// Total number of transactions across all groups. Displayed as a badge
  /// next to the title (e.g., `"12 itens"`).
  final int totalItems;

  /// Ordered list of transaction groups to display.
  final List<TransactionGroup> groups;

  @override
  Widget build(BuildContext context) {
    final theme = context.transactionListTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xl,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: theme.sectionTitle,
                fontSize: 20,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
                height: 1.4,
              ),
            ),
            Text(
              'Mostrando: $totalItems itens',
              style: TextStyle(
                color: theme.itemCount,
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ],
        ),
        ...groups.map((group) => _DateGroup(group: group)),
      ],
    );
  }
}

class _DateGroup extends StatelessWidget {
  const _DateGroup({required this.group});

  final TransactionGroup group;

  @override
  Widget build(BuildContext context) {
    final theme = context.transactionListTheme;
    final borderColor = group.isToday ? theme.dateBorderToday : theme.dateBorderOther;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: AppSpacing.md,
      children: [
        SizedBox(
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(width: 2, color: borderColor)),
            ),
            child: Text(
              group.dateLabel,
              style: TextStyle(
                color: theme.dateLabelText,
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                height: 1.5,
                letterSpacing: 2.2,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(width: 1, color: theme.cardBorder),
          ),
          child: Column(
            children: [
              for (int i = 0; i < group.items.length; i++) ...[
                if (i > 0)
                  SizedBox(
                    width: double.infinity,
                    height: 1,
                    child: ColoredBox(color: theme.cardBorder),
                  ),
                _TransactionTile(item: group.items[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.item});

  final TransactionListItem item;

  Color _resolveAmountColor(TransactionListTheme theme) {
    final isExpense = item.isExpense;
    if (isExpense == null) return theme.itemAmount;
    return isExpense ? theme.itemAmountExpense : theme.itemAmountIncome;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.transactionListTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: theme.itemBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: theme.iconBackground, shape: BoxShape.circle),
            child: Center(
              child: AppSvgIcon(asset: item.icon, size: 24, color: theme.itemTitle),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: theme.itemTitle,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    color: theme.itemSubtitle,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: _resolveAmountColor(theme),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
              if (item.paymentMethod != null)
                Text(
                  item.paymentMethod!,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: theme.itemPaymentMethod,
                    fontSize: 10.4,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
