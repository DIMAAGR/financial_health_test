import 'package:financial_health_dashboard/src/features/dashboard/presentation/mappers/add_transaction_input_mapper.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/add_transaction_sheet_result.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_sheet_type.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/dashboard/dashboard_cubit.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/dashboard/dashboard_state.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/add_transaction_bottom_sheet.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/financial_health_score.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/flow_analysis_section.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/header_section.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/metrics_overview_section.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/monthly_goal_card.dart';
import 'package:financial_health_dashboard/src/core/router/app_routes.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardCubit, DashboardState>(
      listenWhen: (previous, current) => previous.effectVersion != current.effectVersion,
      listener: _onDashboardEffect,
      child: const _DashboardContent(),
    );
  }

  Future<void> _onDashboardEffect(BuildContext context, DashboardState state) async {
    final dashCubit = context.read<DashboardCubit>();

    switch (state.effect) {
      case DashboardEffect.showAddIncomeSheet:
        await _handleIncomeSheet(context, dashCubit);
        return;

      case DashboardEffect.showAddExpenseSheet:
        await _handleExpenseSheet(context, dashCubit);
        return;

      case null:
        return;
    }
  }

  Future<void> _handleIncomeSheet(BuildContext context, DashboardCubit dashCubit) async {
    await showTransactionBottomSheet(
      context,
      sheetType: SheetType.income,
      onSubmit: (result) async {
        if (result is! AddIncomeSheetResult) return false;
        return dashCubit.addIncome(AddTransactionInputMapper.toIncomeInput(result));
      },
    );
    dashCubit.clearEffect();
  }

  Future<void> _handleExpenseSheet(BuildContext context, DashboardCubit dashCubit) async {
    await showTransactionBottomSheet(
      context,
      sheetType: SheetType.expense,
      onSubmit: (result) async {
        if (result is! AddExpenseSheetResult) return false;
        return dashCubit.addExpense(AddTransactionInputMapper.toExpenseInput(result));
      },
    );
    dashCubit.clearEffect();
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state.status == DashboardViewStatus.initial ||
                state.status == DashboardViewStatus.loading) {
              return const DashboardSkeleton();
            }

            if (state.status == DashboardViewStatus.error) {
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
                          onPressed: () => context.read<DashboardCubit>().loadOverview(),
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            final cubit = context.read<DashboardCubit>();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    HeaderSection(
                      userName: state.userName,
                      onEditLayoutPressed: () {},
                      onAddIncomePressed: cubit.onAddIncomePressed,
                      onAddExpensePressed: cubit.onAddExpensePressed,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    FinancialHealthScoreCard(data: state.financialHealthScore, onTap: () {}),
                    const SizedBox(height: AppSpacing.lg),
                    MetricsOverviewSection(
                      balance: state.balance,
                      income: state.income,
                      expenses: state.expense,
                      onBalanceTap: () async {
                        await context.pushNamed(AppRouteName.transactions);
                        if (context.mounted) {
                          context.read<DashboardCubit>().loadOverview();
                        }
                      },
                      onIncomeTap: () async {
                        await context.pushNamed(AppRouteName.incomes);
                        if (context.mounted) {
                          context.read<DashboardCubit>().loadOverview();
                        }
                      },
                      onExpensesTap: () async {
                        await context.pushNamed(AppRouteName.receipts);
                        if (context.mounted) {
                          context.read<DashboardCubit>().loadOverview();
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FlowAnalysisSection(data: state.flowAnalysis, onTap: () {}),
                    const SizedBox(height: AppSpacing.xl),
                    MonthlyGoalCard(data: state.monthlyGoal, onTap: () {}),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
