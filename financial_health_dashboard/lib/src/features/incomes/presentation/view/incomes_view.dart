import 'package:financial_health_dashboard/src/features/incomes/presentation/mappers/add_income_input_mapper.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/view_model/incomes_cubit.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/view_model/incomes_state.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/widgets/incomes_skeleton.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/models/add_transaction_sheet_result.dart';
import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/models/transaction_sheet_type.dart';
import 'package:financial_health_dashboard/src/shared/presentation/add_transaction/widgets/add_transaction_bottom_sheet.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/category_breakdown_section.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/contextual_fab.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/detail_app_bar.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/month_summary_card.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/transaction_list_section.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/extensions/currency_format_extension.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/helpers/category_helpers.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/app_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:financial_health_dashboard/src/shared/presentation/mappers/transaction_group_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomesView extends StatelessWidget {
  const IncomesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<IncomesCubit, IncomesState>(
      listenWhen: (previous, current) => previous.effectVersion != current.effectVersion,
      listener: _onIncomesEffect,
      child: const _IncomesContent(),
    );
  }

  Future<void> _onIncomesEffect(BuildContext context, IncomesState state) async {
    final cubit = context.read<IncomesCubit>();

    switch (state.effect) {
      case IncomesEffect.showAddIncomeSheet:
        await showTransactionBottomSheet(
          context,
          sheetType: SheetType.income,
          onSubmit: (result) async {
            if (result is! AddIncomeSheetResult) return false;
            return cubit.addIncome(AddIncomeInputMapper.fromSheetResult(result));
          },
        );
        cubit.clearEffect();
        return;
      case null:
        return;
    }
  }
}

class _IncomesContent extends StatelessWidget {
  const _IncomesContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backgroundPrimary,
      floatingActionButton: ContextualFab(
        label: 'Adicionar Receita',
        onPressed: () => context.read<IncomesCubit>().onAddIncomePressed(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          children: [
            DetailAppBar(title: 'Receitas', onCalendarPressed: () {}, onFilterPressed: () {}),
            Expanded(
              child: BlocBuilder<IncomesCubit, IncomesState>(
                builder: (context, state) {
                  if (state.status == IncomesViewStatus.initial ||
                      state.status == IncomesViewStatus.loading) {
                    return const IncomesSkeleton();
                  }

                  if (state.status == IncomesViewStatus.error) {
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
                                onPressed: () => context.read<IncomesCubit>().loadOverview(),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  final groups = TransactionGroupMapper.toIncomeGroups(state.transactions);
                  final categories = _buildCategoryItems(state.categoryBreakdown);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      children: [
                        MonthSummaryCard(
                          type: MonthSummaryType.income,
                          amount: 'R\$\n${state.totalIncome.toBRL(true).trim()}',
                          monthYear: '${state.monthLabel} ${DateTime.now().year}',
                          changePercent: state.incomeChangePercent,
                          trendDirection: state.incomeChangePercent > 0
                              ? TrendDirection.up
                              : state.incomeChangePercent < 0
                              ? TrendDirection.down
                              : TrendDirection.neutral,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        CategoryBreakdownSection(
                          totalAmount: state.totalIncome,
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
}
