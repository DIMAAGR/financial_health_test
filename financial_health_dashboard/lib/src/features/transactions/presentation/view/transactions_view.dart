import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_cubit.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/view_model/transactions_state.dart';
import 'package:financial_health_dashboard/src/features/transactions/presentation/widgets/transactions_skeleton.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/detail_app_bar.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/month_summary_card.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/transaction_list_section.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/extensions/currency_format_extension.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/app_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:financial_health_dashboard/src/shared/presentation/mappers/transaction_group_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

                  final groups = TransactionGroupMapper.toTransactionsGroups(state.transactions);

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
}
