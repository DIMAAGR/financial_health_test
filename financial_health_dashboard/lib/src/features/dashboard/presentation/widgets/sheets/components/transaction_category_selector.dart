import 'package:financial_health_dashboard/src/shared/presentation/design/components/svg_icons.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/add_income_sheet_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_radius.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_text_styles.dart';
import 'package:flutter/material.dart';

class TransactionCategoryOption<T> {
  const TransactionCategoryOption({
    required this.value,
    required this.label,
    required this.iconAsset,
  });

  final T value;
  final String label;
  final String iconAsset;
}

class TransactionCategorySelector<T> extends StatelessWidget {
  const TransactionCategorySelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.theme,
    this.onAddPressed,
  });

  final List<TransactionCategoryOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final AddIncomeSheetTheme theme;
  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final option in options) ...[
            TransactionCategoryChip(
              label: option.label,
              iconAsset: option.iconAsset,
              selected: option.value == selected,
              onTap: () => onSelected(option.value),
              theme: theme,
            ),
            const SizedBox(width: 12),
          ],
          TransactionCategoryAddChip(
            onTap: onAddPressed ?? () {},
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class TransactionCategoryChip extends StatelessWidget {
  const TransactionCategoryChip({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;
  final AddIncomeSheetTheme theme;

  @override
  Widget build(BuildContext context) {
    final background = selected
        ? theme.categorySelectedBackground
        : theme.categoryUnselectedBackground;
    final textColor = selected
        ? theme.categorySelectedText
        : theme.categoryUnselectedText;
    final iconColor = selected
        ? theme.categorySelectedIcon
        : theme.categoryUnselectedIcon;
    final textStyle = selected
        ? AppTextStyles.sheetCategorySelected
        : AppTextStyles.sheetCategoryUnselected;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvgIcon(asset: iconAsset, size: 16, color: iconColor),
              const SizedBox(width: 8),
              Text(label, style: textStyle.copyWith(color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionCategoryAddChip extends StatelessWidget {
  const TransactionCategoryAddChip({
    super.key,
    required this.onTap,
    required this.theme,
  });

  final VoidCallback onTap;
  final AddIncomeSheetTheme theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.categoryAddBackground,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(Icons.add, color: theme.categoryAddIcon),
        ),
      ),
    );
  }
}
