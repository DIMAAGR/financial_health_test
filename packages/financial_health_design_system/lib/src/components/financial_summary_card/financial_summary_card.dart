import 'package:financial_health_design_system/src/foundations/theme/financial_health_design_theme.dart';
import 'package:financial_health_design_system/src/foundations/tokens/fh_radius.dart';
import 'package:financial_health_design_system/src/foundations/tokens/fh_spacing.dart';
import 'package:financial_health_design_system/src/foundations/tokens/fh_text_styles.dart';
import 'package:financial_health_design_system/src/theme/extensions/financial_summary_card_theme_ext.dart';
import 'package:flutter/material.dart';

/// Reusable financial summary card for design-system surfaces.
///
/// The card receives all business-facing content from the caller: [title],
/// [value], [variationPercent], [icon], and [onTap]. It does not format money,
/// fetch data, infer categories, or depend on any feature module.
///
/// Visual state is resolved from [variationPercent]: values greater than or
/// equal to zero use the positive palette, while negative values use the
/// negative palette from [FinancialSummaryCardTheme]. A custom [themePalette]
/// can be provided when a product needs a specific themed color family.
///
/// Example:
/// ```dart
/// FinancialSummaryCard(
///   title: 'INCOME',
///   value: 'R$ 12.400,00',
///   variationPercent: 15,
///   icon: const Icon(Icons.trending_up),
///   onTap: () => debugPrint('Open income details'),
/// )
/// ```
class FinancialSummaryCard extends StatelessWidget {
  const FinancialSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.variationPercent,
    required this.icon,
    this.themePalette,
    this.onTap,
  });

  /// Short label shown above the value, for example `INCOME` or `EXPENSES`.
  final String title;

  /// Already formatted display value.
  ///
  /// The component intentionally receives a string to avoid embedding money
  /// formatting or domain rules in a design-system widget.
  final String value;

  /// Percentage variation displayed in the pill badge.
  ///
  /// Positive and zero values resolve to the positive visual state. Negative
  /// values resolve to the negative visual state.
  final double variationPercent;

  /// Leading icon displayed inside the circular accent container.
  ///
  /// [Icon] widgets inherit the accent color automatically through [IconTheme].
  final Widget icon;

  /// Optional themed palette override for product-specific color families.
  ///
  /// When omitted, the component uses [FinancialSummaryCardTheme.positive] or
  /// [FinancialSummaryCardTheme.negative] based on [variationPercent].
  final FinancialSummaryCardPalette? themePalette;

  /// Callback invoked when the card is tapped.
  ///
  /// When null, the card remains non-interactive while preserving layout.
  final VoidCallback? onTap;

  bool get _isPositive => variationPercent >= 0;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).extension<FinancialSummaryCardTheme>() ??
        (Theme.of(context).brightness == Brightness.dark
            ? FinancialHealthDesignTheme.financialSummaryDark
            : FinancialHealthDesignTheme.financialSummaryLight);
    final palette = themePalette ?? (_isPositive ? theme.positive : theme.negative);
    final borderRadius = BorderRadius.circular(FhRadius.lg);

    return Semantics(
      button: onTap != null,
      label: title,
      value: value,
      child: DecoratedBox(
        key: const ValueKey('financial_summary_card_surface'),
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: borderRadius,
          border: Border.all(color: palette.border, width: palette.border.a == 0 ? 0 : 1),
          boxShadow: [
            BoxShadow(color: palette.shadow, blurRadius: FhSpacing.xs, offset: const Offset(0, 1)),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(FhSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _IconBadge(palette: palette, icon: icon),
                      const Spacer(),
                      _VariationPill(palette: palette, variationPercent: variationPercent),
                    ],
                  ),
                  const SizedBox(height: FhSpacing.xxl),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FhTextStyles.financialSummaryTitle.copyWith(color: palette.foreground),
                  ),
                  const SizedBox(height: FhSpacing.xs),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      maxLines: 1,
                      style: FhTextStyles.financialSummaryValue.copyWith(color: palette.foreground),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.palette, required this.icon});

  final FinancialSummaryCardPalette palette;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: palette.accentBackground, shape: BoxShape.circle),
      child: SizedBox.square(
        dimension: FhSpacing.xxxl,
        child: Center(
          child: IconTheme.merge(
            data: IconThemeData(color: palette.accentForeground, size: FhSpacing.lg),
            child: icon,
          ),
        ),
      ),
    );
  }
}

class _VariationPill extends StatelessWidget {
  const _VariationPill({required this.palette, required this.variationPercent});

  final FinancialSummaryCardPalette palette;
  final double variationPercent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.accentBackground,
        borderRadius: BorderRadius.circular(FhRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FhSpacing.md, vertical: FhSpacing.xs),
        child: Text(
          _formatVariation(variationPercent),
          style: FhTextStyles.financialSummaryVariation.copyWith(color: palette.accentForeground),
        ),
      ),
    );
  }

  String _formatVariation(double value) {
    final sign = value >= 0 ? '+' : '-';
    final absoluteValue = value.abs();
    final formattedValue = absoluteValue % 1 == 0
        ? absoluteValue.toStringAsFixed(0)
        : absoluteValue.toStringAsFixed(1);
    return '$sign$formattedValue%';
  }
}
