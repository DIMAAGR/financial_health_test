import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_transaction_data.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_cubit.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_state.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/widgets/transactions_skeleton.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/detail_app_bar.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/month_summary_card.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/transaction_list_section.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/extensions/currency_format_extension.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/helpers/category_helpers.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/app_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            DetailAppBar(title: 'Movimentações', onCalendarPressed: () {}, onFilterPressed: () {}),
            Expanded(
              child: BlocBuilder<TransactionsCubit, TransactionsState>(
                builder: (context, state) {
                  if (state.status == TransactionsViewStatus.initial ||
                      state.status == TransactionsViewStatus.loading) {
                    return const TransactionsSkeleton();
                  }

                  if (state.status == TransactionsViewStatus.error) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.errorMessage ?? 'Não foi possível carregar os dados.'),
                            if (state.canRetry) ...[
                              const SizedBox(height: AppSpacing.md),
                              TextButton(
                                onPressed: () => context.read<TransactionsCubit>().loadOverview(),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  final groups = _buildTransactionGroups(state.transactions);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      children: [
                        MonthSummaryCard(
                          type: MonthSummaryType.balance,
                          amount: 'R\$\n${state.balance.toBRL(true).trim()}',
                          monthYear: '${state.monthLabel} ${DateTime.now().year}',
                          changePercent: state.balanceChangePercent,
                          trendDirection: state.balanceChangePercent > 0
                              ? TrendDirection.up
                              : state.balanceChangePercent < 0
                              ? TrendDirection.down
                              : TrendDirection.neutral,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        TransactionListSection(
                          title: 'Histórico Detalhado',
                          totalItems: state.transactions.length,
                          groups: groups,
                        ),
                        const SizedBox(height: AppSpacing.huge),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TransactionGroup> _buildTransactionGroups(List<DashboardTransactionData> transactions) {
    final grouped = <String, List<DashboardTransactionData>>{};
    final dateLabels = <String, DateTime>{};
    final dateFormat = DateFormat('dd MMM', 'pt_BR');

    for (final t in transactions) {
      final date = t.date ?? DateTime.now();
      final key = '${date.year}-${date.month}-${date.day}';
      grouped.putIfAbsent(key, () => []).add(t);
      dateLabels.putIfAbsent(key, () => date);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => dateLabels[b]!.compareTo(dateLabels[a]!));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return sortedKeys.map((key) {
      final date = dateLabels[key]!;
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final isToday = normalizedDate == today;
      final isYesterday = normalizedDate == today.subtract(const Duration(days: 1));
      final prefix = isToday
          ? 'HOJE'
          : isYesterday
          ? 'ONTEM'
          : '';
      final formattedDate = dateFormat.format(date).toUpperCase();
      final label = prefix.isEmpty ? formattedDate : '$prefix, $formattedDate';

      final sortedItems = grouped[key]!
        ..sort((a, b) => (b.date ?? DateTime(0)).compareTo(a.date ?? DateTime(0)));

      return TransactionGroup(
        dateLabel: label,
        isToday: isToday,
        items: sortedItems.map((t) {
          final isExpense = t.type == DashboardTransactionType.expense;
          final sign = isExpense ? '-' : '+';
          return TransactionListItem(
            name: t.title,
            subtitle: categoryLabel(t.category),
            amount: '$sign${t.value.toBRL()}',
            icon: categoryIcon(t.category),
            isExpense: isExpense,
          );
        }).toList(),
      );
    }).toList();
  }
}
