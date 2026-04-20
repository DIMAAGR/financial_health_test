import 'package:financial_health_dashboard/src/shared/presentation/design/input_formatters/brl_currency_input_formatter.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/add_income_sheet_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_radius.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionFieldLabel extends StatelessWidget {
  const TransactionFieldLabel({super.key, required this.text, required this.theme});

  final String text;
  final AddIncomeSheetTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(text, style: AppTextStyles.sheetFieldLabel.copyWith(color: theme.fieldLabel)),
    );
  }
}

class TransactionAmountField extends StatelessWidget {
  const TransactionAmountField({super.key, required this.controller, required this.theme});

  final TextEditingController controller;
  final AddIncomeSheetTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
      decoration: BoxDecoration(
        color: theme.fieldBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Text(
            'R\$',
            style: AppTextStyles.financialScoreSuffix.copyWith(
              color: theme.currencySymbol,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                BrlCurrencyInputFormatter(),
              ],
              style: AppTextStyles.sheetAmount.copyWith(color: theme.fieldText),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: '0,00',
                hintStyle: AppTextStyles.sheetAmount.copyWith(color: theme.fieldPlaceholder),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionDescriptionField extends StatelessWidget {
  const TransactionDescriptionField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.theme,
  });

  final TextEditingController controller;
  final String hintText;
  final AddIncomeSheetTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: theme.fieldBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.sheetInput.copyWith(color: theme.fieldText),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: AppTextStyles.sheetInput.copyWith(color: theme.fieldPlaceholder),
        ),
      ),
    );
  }
}
