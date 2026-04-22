import 'package:financial_health_design_system/src/assets/icons.dart';
import 'package:financial_health_design_system/src/components/svg_icon/app_svg_icon.dart';
import 'package:financial_health_design_system/src/foundations/tokens/app_radius.dart';
import 'package:financial_health_design_system/src/foundations/tokens/app_spacing.dart';
import 'package:financial_health_design_system/src/theme/extensions/app_theme_ext.dart';
import 'package:flutter/material.dart';

/// App bar for detail / secondary screens.
///
/// Shows a back button on the left, the screen [title] in the center-left, and
/// optional calendar + filter action buttons on the right. The back button
/// calls [onBackPressed] if provided, or falls back to `Navigator.maybePop`.
///
/// Colors are resolved from [AppSemanticColors] via [BuildContext].
///
/// ## Usage
/// ```dart
/// DetailAppBar(
///   title: 'Transações',
///   onBackPressed: () => Navigator.pop(context),
///   onFilterPressed: () => showFilterSheet(context),
/// )
/// ```
class DetailAppBar extends StatelessWidget {
  /// Creates a [DetailAppBar].
  const DetailAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.onCalendarPressed,
    this.onFilterPressed,
  });

  /// Title text shown in the app bar.
  final String title;

  /// Callback for the back button. Defaults to `Navigator.maybePop` when null.
  final VoidCallback? onBackPressed;

  /// Callback for the calendar icon button. The button is rendered disabled
  /// (but still visible) when null.
  final VoidCallback? onCalendarPressed;

  /// Callback for the filter icon button. The button is rendered disabled
  /// (but still visible) when null.
  final VoidCallback? onFilterPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.md,
            children: [
              _BackButton(
                backgroundColor: colors.headerActionBackground,
                iconColor: colors.headerActionIcon,
                onPressed:
                    onBackPressed ?? () => Navigator.of(context).maybePop(),
              ),
              Text(
                title,
                style: TextStyle(
                  color: colors.headerTitle,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.40,
                  letterSpacing: -0.50,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.sm,
            children: [
              _ActionButton(
                icon: AppIcons.calendar,
                iconColor: colors.headerActionIcon,
                onPressed: onCalendarPressed,
              ),
              _ActionButton(
                icon: AppIcons.filter,
                iconColor: colors.headerActionIcon,
                onPressed: onFilterPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({
    required this.backgroundColor,
    required this.iconColor,
    this.onPressed,
  });

  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: AppSpacing.xxl,
        height: AppSpacing.xxl,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm + 4),
          ),
        ),
        alignment: Alignment.center,
        child: AppSvgIcon(
          asset: AppIcons.arrowBack,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.iconColor,
    this.onPressed,
  });

  final String icon;
  final Color iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm + 4),
          ),
        ),
        child: AppSvgIcon(asset: icon, size: 20, color: iconColor),
      ),
    );
  }
}
