import 'package:financial_health_dashboard/src/shared/presentation/design/components/svg_icons.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/app_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/transaction_list_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_radius.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:flutter/material.dart';

class TransactionListItem {
  const TransactionListItem({
    required this.name,
    required this.subtitle,
    required this.amount,
    this.paymentMethod,
    required this.icon,
    this.isExpense,
  });

  final String name;
  final String subtitle;
  final String amount;
  final String? paymentMethod;
  final String icon;
  final bool? isExpense;
}

class TransactionGroup {
  const TransactionGroup({required this.dateLabel, required this.items, this.isToday = false});

  final String dateLabel;
  final List<TransactionListItem> items;
  final bool isToday;
}

class TransactionListSection extends StatelessWidget {
  const TransactionListSection({
    super.key,
    required this.title,
    required this.totalItems,
    required this.groups,
  });

  final String title;
  final int totalItems;
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
