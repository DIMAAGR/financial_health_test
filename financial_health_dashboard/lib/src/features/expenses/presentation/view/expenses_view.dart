import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/dashboard_transaction_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/mappers/add_transaction_input_mapper.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/add_transaction_sheet_result.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_sheet_type.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/add_transaction_bottom_sheet.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_cubit.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_state.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/widgets/expenses_skeleton.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/category_breakdown_section.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/contextual_fab.dart';
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

class ExpensesView extends StatelessWidget {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpensesCubit, ExpensesState>(
      listenWhen: (previous, current) => previous.effectVersion != current.effectVersion,
      listener: _onExpensesEffect,
      child: const _ExpensesContent(),
    );
  }

  Future<void> _onExpensesEffect(BuildContext context, ExpensesState state) async {
    final cubit = context.read<ExpensesCubit>();

    switch (state.effect) {
      case ExpensesEffect.showAddExpenseSheet:
        await showTransactionBottomSheet(
          context,
          sheetType: SheetType.expense,
          onSubmit: (result) async {
            if (result is! AddExpenseSheetResult) return false;
            return cubit.addExpense(AddTransactionInputMapper.toExpenseInput(result));
          },
        );
        cubit.clearEffect();
        return;
      case null:
        return;
    }
  }
}

class _ExpensesContent extends StatelessWidget {
  const _ExpensesContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backgroundPrimary,
      floatingActionButton: ContextualFab(
        label: 'Adicionar Despesa',
        onPressed: () => context.read<ExpensesCubit>().onAddExpensePressed(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          children: [
            DetailAppBar(title: 'Despesas', onCalendarPressed: () {}, onFilterPressed: () {}),
            Expanded(
              child: BlocBuilder<ExpensesCubit, ExpensesState>(
                builder: (context, state) {
                  if (state.status == ExpensesViewStatus.initial ||
                      state.status == ExpensesViewStatus.loading) {
                    return const ExpensesSkeleton();
                  }

                  if (state.status == ExpensesViewStatus.error) {
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
                                onPressed: () => context.read<ExpensesCubit>().loadOverview(),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  final groups = _buildTransactionGroups(state.transactions);
                  final categories = _buildCategoryItems(state.categoryBreakdown);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      children: [
                        MonthSummaryCard(
                          type: MonthSummaryType.expense,
                          amount: 'R\$\n${state.totalExpense.toBRL(true).trim()}',
                          monthYear: '${state.monthLabel} ${DateTime.now().year}',
                          changePercent: state.expenseChangePercent,
                          trendDirection: state.expenseChangePercent > 0
                              ? TrendDirection.up
                              : state.expenseChangePercent < 0
                              ? TrendDirection.down
                              : TrendDirection.neutral,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        CategoryBreakdownSection(
                          totalAmount: state.totalExpense,
                          categories: categories,
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

  List<CategoryItem> _buildCategoryItems(List<CategoryBreakdownData> breakdown) {
    return breakdown.map((b) {
      return CategoryItem(
        name: categoryLabel(b.category),
        amount: b.amount.toBRL(),
        icon: categoryIcon(b.category),
        percentage: b.percentage,
      );
    }).toList();
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
          return TransactionListItem(
            name: t.title,
            subtitle: categoryLabel(t.category),
            amount: t.value.toBRL(),
            paymentMethod: 'CARTÃO',
            icon: categoryIcon(t.category),
          );
        }).toList(),
      );
    }).toList();
  }
}
