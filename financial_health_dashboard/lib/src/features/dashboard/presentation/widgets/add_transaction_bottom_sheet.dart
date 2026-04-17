import 'package:financial_health_dashboard/src/core/dependencies/injection.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/add_transaction_sheet_result.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_category.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/models/transaction_sheet_type.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/add_transaction/add_transaction_cubit.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/view_model/add_transaction/add_transaction_state.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/sheets/components/transaction_category_selector.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/sheets/components/transaction_sheet_fields.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/sheets/components/transaction_sheet_scaffold.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/widgets/sheets/components/transaction_submit_button.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/assets/icons.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/app_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<AddTransactionSheetResult?> showTransactionBottomSheet(
  BuildContext context, {
  required SheetType sheetType,
  required Future<bool> Function(AddTransactionSheetResult result) onSubmit,
}) {
  return showModalBottomSheet<AddTransactionSheetResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) => BlocProvider(
      create: (_) => getIt<AddTransactionCubit>(param1: sheetType),
      child: _AddTransactionBottomSheet(type: sheetType, onSubmit: onSubmit),
    ),
  );
}

class _AddTransactionBottomSheet extends StatefulWidget {
  final SheetType type;
  final Future<bool> Function(AddTransactionSheetResult result) onSubmit;
  const _AddTransactionBottomSheet({required this.type, required this.onSubmit});

  @override
  State<_AddTransactionBottomSheet> createState() => _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<_AddTransactionBottomSheet> {
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(text: '0,00');
    _descriptionController = TextEditingController();

    _amountController.addListener(() {
      context.read<AddTransactionCubit>().onAmountChanged(_amountController.text);
    });
    _descriptionController.addListener(() {
      context.read<AddTransactionCubit>().onDescriptionChanged(_descriptionController.text);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.addIncomeSheetTheme;

    return TransactionSheetScaffold(
      title: widget.type.title,
      theme: theme,
      children: [
        TransactionFieldLabel(text: 'VALOR DO LANÇAMENTO', theme: theme),
        const SizedBox(height: AppSpacing.sm),
        TransactionAmountField(controller: _amountController, theme: theme),
        const SizedBox(height: AppSpacing.lg),
        TransactionFieldLabel(text: 'DESCRIÇÃO', theme: theme),
        const SizedBox(height: AppSpacing.sm),
        TransactionDescriptionField(
          controller: _descriptionController,
          hintText: widget.type.descriptionHintText,
          theme: theme,
        ),
        const SizedBox(height: AppSpacing.lg),
        TransactionFieldLabel(text: 'CATEGORIA', theme: theme),
        const SizedBox(height: AppSpacing.sm),
        BlocBuilder<AddTransactionCubit, AddTransactionState>(
          builder: (context, state) {
            return TransactionCategorySelector<TransactionCategory>(
              options: widget.type == SheetType.income
                  ? _incomeCategoryOptions
                  : _expenseCategoryOptions,
              selected: state.category,
              onSelected: context.read<AddTransactionCubit>().onCategorySelected,
              theme: theme,
            );
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        BlocBuilder<AddTransactionCubit, AddTransactionState>(
          builder: (context, state) {
            return TransactionSubmitButton(
              label: widget.type.buttonTitle,
              enabled: state.canSubmit,
              isSubmitting: state.isSubmitting,
              onTap: () => _submit(),
              theme: theme,
            );
          },
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!mounted) return;
    final cubit = context.read<AddTransactionCubit>();
    final result = await cubit.submit();
    if (!mounted || result == null) return;

    final success = await widget.onSubmit(result);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(result);
    } else {
      cubit.resetSubmitting();
    }
  }
}

final _incomeCategoryOptions = [
  TransactionCategoryOption<TransactionCategory>(
    value: TransactionCategory.salary,
    label: TransactionCategory.salary.label,
    iconAsset: AppIcons.money,
  ),
  TransactionCategoryOption<TransactionCategory>(
    value: TransactionCategory.gift,
    label: TransactionCategory.gift.label,
    iconAsset: AppIcons.gift,
  ),
  TransactionCategoryOption<TransactionCategory>(
    value: TransactionCategory.investment,
    label: TransactionCategory.investment.label,
    iconAsset: AppIcons.doneCircle,
  ),
];

final _expenseCategoryOptions = [
  TransactionCategoryOption<TransactionCategory>(
    value: TransactionCategory.food,
    label: TransactionCategory.food.label,
    iconAsset: AppIcons.wallet,
  ),
  TransactionCategoryOption<TransactionCategory>(
    value: TransactionCategory.transport,
    label: TransactionCategory.transport.label,
    iconAsset: AppIcons.money,
  ),
  TransactionCategoryOption<TransactionCategory>(
    value: TransactionCategory.shopping,
    label: TransactionCategory.shopping.label,
    iconAsset: AppIcons.bag,
  ),
];
