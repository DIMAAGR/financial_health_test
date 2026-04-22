import 'package:financial_health_design_system/src/assets/icons.dart';
import 'package:financial_health_design_system/src/components/svg_icon/app_svg_icon.dart';
import 'package:financial_health_design_system/src/foundations/tokens/app_radius.dart';
import 'package:financial_health_design_system/src/foundations/tokens/app_spacing.dart';
import 'package:financial_health_design_system/src/theme/extensions/app_theme_ext.dart';
import 'package:flutter/material.dart';

/// A pill-shaped floating action button with a text label.
///
/// Floats over the dashboard content and lets the user trigger a
/// primary action such as adding a new transaction.
///
/// Colors are resolved from [ContextualFabTheme] via [BuildContext].
///
/// ## Usage
/// ```dart
/// ContextualFab(
///   label: 'Adicionar',
///   onPressed: () => openAddIncomeSheet(context),
/// )
/// ```
class ContextualFab extends StatelessWidget {
  /// Creates a [ContextualFab].
  const ContextualFab({super.key, required this.label, required this.onPressed});

  /// Text displayed next to the add icon inside the FAB.
  final String label;

  /// Callback invoked when the FAB is tapped.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.contextualFabTheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: [BoxShadow(color: theme.shadow, blurRadius: 32, offset: const Offset(0, 8))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            AppSvgIcon(asset: AppIcons.add, size: 24, color: theme.foreground),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.foreground,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
