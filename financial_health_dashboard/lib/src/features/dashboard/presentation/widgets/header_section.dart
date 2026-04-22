import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';

/// Header section used in the dashboard screen.
///
/// Displays a welcome message, the user's name and a circular action button
/// for quick actions or additional options.
///
/// The widget is fully theme-aware and adapts automatically to light and dark
/// themes through the app's `ThemeExtension`.
///
/// Example:
/// ```dart
/// HeaderSection(
///   userName: 'Júlio',
///   onMorePressed: () {
///     // Open quick actions
///   },
/// )
/// ```
class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
    required this.userName,
    this.onMorePressed,
    this.onEditLayoutPressed,
    this.onAddIncomePressed,
    this.onAddExpensePressed,
  });

  /// Nome exibido no cabeçalho.
  final String userName;

  /// Callback do botão circular de ações rápidas.
  ///
  /// Quando `null`, o botão permanece desabilitado.
  final VoidCallback? onMorePressed;
  final VoidCallback? onEditLayoutPressed;
  final VoidCallback? onAddIncomePressed;
  final VoidCallback? onAddExpensePressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bem-vindo de volta,',
                style: AppTextStyles.headerSubtitle.copyWith(
                  color: colors.headerSubtitle,
                ),
              ),
              Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headerTitle.copyWith(
                  color: colors.headerTitle,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<_HeaderMenuOption>(
          onOpened: onMorePressed,
          clipBehavior: Clip.antiAlias,
          position: PopupMenuPosition.under,
          offset: const Offset(0, 8),
          borderRadius: BorderRadius.circular(24),
          onSelected: (value) {
            switch (value) {
              case _HeaderMenuOption.editLayout:
                onEditLayoutPressed?.call();
                break;
              case _HeaderMenuOption.addIncome:
                onAddIncomePressed?.call();
                break;
              case _HeaderMenuOption.addExpense:
                onAddExpensePressed?.call();
                break;
            }
          },
          color: colors.headerMenuBackground,
          shadowColor: colors.headerMenuShadow,
          surfaceTintColor: Colors.transparent,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: colors.headerMenuBorder, width: 1),
          ),

          padding: EdgeInsets.zero,
          menuPadding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context) => [
            _buildMenuItem(
              context: context,
              value: _HeaderMenuOption.editLayout,
              label: 'Editar Layout',
              icon: AppIcons.edit,

              iconColor: colors.headerMenuIcon,
            ),
            _buildMenuItem(
              context: context,
              value: _HeaderMenuOption.addIncome,
              label: 'Adicionar Receita',
              icon: AppIcons.trendingUp,
              iconColor: colors.metricCardIcon,
            ),
            _buildMenuItem(
              context: context,
              value: _HeaderMenuOption.addExpense,
              label: 'Adicionar Despesa',
              icon: AppIcons.trendingDown,
              iconColor: colors.metricCardIconRed,
            ),
          ],
          child: Material(
            color: colors.headerActionBackground,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.more_vert, color: colors.headerActionIcon),
              ),
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuItem<_HeaderMenuOption> _buildMenuItem({
    required BuildContext context,
    required _HeaderMenuOption value,
    required String label,
    required String icon,
    double iconSize = 24,
    required Color iconColor,
  }) {
    final colors = context.appColors;
    return PopupMenuItem<_HeaderMenuOption>(
      value: value,
      height: 48,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        width: 192,
        child: Row(
          children: [
            AppSvgIcon(asset: icon, size: iconSize, color: iconColor),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.financialCardTitle.copyWith(
                color: colors.headerMenuText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _HeaderMenuOption { editLayout, addIncome, addExpense }
