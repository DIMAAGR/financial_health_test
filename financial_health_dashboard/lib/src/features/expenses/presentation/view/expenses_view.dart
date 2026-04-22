import 'package:financial_health_dashboard/src/features/expenses/presentation/mappers/add_expense_input_mapper.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_cubit.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/view_model/expenses_state.dart';
import 'package:financial_health_dashboard/src/features/expenses/presentation/widgets/expenses_skeleton.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/models/add_transaction_sheet_result.dart';
import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/models/transaction_sheet_type.dart';
import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/widgets/add_transaction_bottom_sheet.dart';
import 'package:financial_health_dashboard/src/shared/presentation/mappers/transaction_group_mapper.dart';
import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpensesCubit, ExpensesState>(
      listenWhen: (previous, current) =>
          previous.effectVersion != current.effectVersion,
      listener: _onExpensesEffect,
      child: const _ExpensesContent(),
    );
  }

  Future<void> _onExpensesEffect(
    BuildContext context,
    ExpensesState state,
  ) async {
    final cubit = context.read<ExpensesCubit>();

    switch (state.effect) {
      case ExpensesEffect.showAddExpenseSheet:
        await showTransactionBottomSheet(
          context,
          sheetType: SheetType.expense,
          onSubmit: (result) async {
            if (result is! AddExpenseSheetResult) return false;
            return cubit.addExpense(
              AddExpenseInputMapper.fromSheetResult(result),
            );
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
            DetailAppBar(
              title: 'Despesas',
              onCalendarPressed: () {},
              onFilterPressed: () {},
            ),
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
                            Text(
                              state.errorMessage ??
                                  'Não foi possível carregar os dados.',
                            ),
                            if (state.canRetry) ...[
                              const SizedBox(height: AppSpacing.md),
                              TextButton(
                                onPressed: () => context
                                    .read<ExpensesCubit>()
                                    .loadOverview(),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  final groups = TransactionGroupMapper.toExpenseGroups(
                    state.transactions,
                  );
                  final categories = _buildCategoryItems(
                    state.categoryBreakdown,
                  );

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Column(
                      children: [
                        MonthSummaryCard(
                          type: MonthSummaryType.expense,
                          amount:
                              'R\$\n${state.totalExpense.toBRL(true).trim()}',
                          monthYear:
                              '${state.monthLabel} ${DateTime.now().year}',
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

  List<CategoryItem> _buildCategoryItems(
    List<CategoryBreakdownData> breakdown,
  ) {
    return breakdown.map((b) {
      return CategoryItem(
        name: categoryLabel(b.category),
        amount: b.amount.toBRL(),
        icon: categoryIcon(b.category),
        percentage: b.percentage,
      );
    }).toList();
  }
}
