import 'package:financial_health_dashboard/src/shared/presentation/design/assets/icons.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/svg_icons.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/add_income_sheet_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_radius.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_text_styles.dart';
import 'package:flutter/material.dart';

class TransactionSheetScaffold extends StatelessWidget {
  const TransactionSheetScaffold({
    super.key,
    required this.title,
    required this.theme,
    required this.children,
  });

  final String title;
  final AddIncomeSheetTheme theme;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 576),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(color: theme.sheetShadow, blurRadius: 40, offset: const Offset(0, -10)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.xl,
                  AppSpacing.xxl,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TransactionSheetDragHandle(theme: theme),
                    const SizedBox(height: AppSpacing.lg),
                    TransactionSheetHeader(title: title, theme: theme),
                    const SizedBox(height: AppSpacing.xl),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionSheetDragHandle extends StatelessWidget {
  const TransactionSheetDragHandle({super.key, required this.theme});

  final AddIncomeSheetTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 48,
        height: 6,
        decoration: BoxDecoration(
          color: theme.dragHandle,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );
  }
}

class TransactionSheetHeader extends StatelessWidget {
  const TransactionSheetHeader({super.key, required this.title, required this.theme});

  final String title;
  final AddIncomeSheetTheme theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: AppTextStyles.sheetTitle.copyWith(color: theme.title)),
        ),
        Material(
          color: theme.closeButtonBackground,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(context).pop(),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: AppSvgIcon(asset: AppIcons.close, size: 16, color: theme.closeIcon),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
