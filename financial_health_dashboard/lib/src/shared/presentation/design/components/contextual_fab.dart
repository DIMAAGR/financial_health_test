import 'package:financial_health_dashboard/src/shared/presentation/design/assets/icons.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/components/svg_icons.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/theme/app_theme_ext.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_radius.dart';
import 'package:financial_health_dashboard/src/shared/presentation/design/tokens/app_spacing.dart';
import 'package:flutter/material.dart';

class ContextualFab extends StatelessWidget {
  const ContextualFab({super.key, required this.label, required this.onPressed});

  final String label;
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
