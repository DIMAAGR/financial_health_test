import 'package:financial_health_design_system/src/components/svg_icon/app_svg_icon.dart';
import 'package:financial_health_design_system/src/foundations/tokens/app_radius.dart';
import 'package:financial_health_design_system/src/foundations/tokens/app_spacing.dart';
import 'package:financial_health_design_system/src/theme/extensions/app_theme_ext.dart';
import 'package:financial_health_design_system/src/theme/extensions/category_breakdown_theme_ext.dart';
import 'package:flutter/material.dart';

const int _maxCategories = 5;

/// Immutable data class that represents a single spending or income category.
///
/// Pass a list of these to [CategoryBreakdownSection.categories].
class CategoryItem {
  /// Creates a [CategoryItem].
  const CategoryItem({
    required this.name,
    required this.amount,
    required this.icon,
    required this.percentage,
  });

  /// Human-readable category name (e.g., "Alimentação").
  final String name;

  /// Pre-formatted monetary amount (e.g., "R$ 1.240,50").
  final String amount;

  /// Asset path for the category icon. Use [AppIcons] constants or
  /// [categoryIcon] from `category_helpers.dart` to resolve the correct path.
  final String icon;

  /// Percentage of the total that this category represents (0–100).
  final double percentage;
}

/// Displays a breakdown of spending or income categories.
///
/// The first [CategoryItem] in [categories] is rendered as a large hero card.
/// The remaining items (up to 4 more) are shown as smaller item cards below it.
/// A maximum of 5 categories is displayed.
///
/// Colors are resolved from [CategoryBreakdownTheme] via [BuildContext].
///
/// ## Usage
/// ```dart
/// CategoryBreakdownSection(
///   categories: [
///     CategoryItem(
///       name: 'Alimentação',
///       amount: 'R$ 840,00',
///       icon: AppIcons.bag,
///       percentage: 34.0,
///     ),
///     // ...
///   ],
///   totalAmount: 2470.00,
/// )
/// ```
class CategoryBreakdownSection extends StatelessWidget {
  /// Creates a [CategoryBreakdownSection].
  const CategoryBreakdownSection({super.key, required this.categories, required this.totalAmount});

  /// Ordered list of categories to display. The first entry becomes the hero
  /// card. At most 5 categories are rendered.
  final List<CategoryItem> categories;

  /// The total amount (income or expense) that [categories] are broken down
  /// from. Used to compute relative percentages if needed.
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final theme = context.categoryBreakdownTheme;
    final visible = categories.take(_maxCategories).toList();
    final hero = visible.first;
    final rest = visible.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroCard(item: hero, totalAmount: totalAmount, theme: theme),
        if (rest.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ...rest.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: entry.key < rest.length - 1 ? AppSpacing.md : 0),
              child: _ItemCard(item: entry.value, isAccent: entry.key == 0, theme: theme),
            ),
          ),
        ],
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.item, required this.totalAmount, required this.theme});

  final CategoryItem item;
  final double totalAmount;
  final CategoryBreakdownTheme theme;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 180),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.heroCardBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: theme.heroCardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.heroIconBackground,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  alignment: Alignment.center,
                  child: AppSvgIcon(asset: item.icon, size: 24, color: theme.heroTitle),
                ),
                Text(
                  '${item.percentage.toStringAsFixed(0)}% do total',
                  style: TextStyle(
                    color: theme.heroPercent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: theme.heroTitle,
                    fontSize: 20,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.40,
                  ),
                ),
                Text(
                  item.amount,
                  style: TextStyle(
                    color: theme.heroAmount,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item, required this.isAccent, required this.theme});

  final CategoryItem item;
  final bool isAccent;
  final CategoryBreakdownTheme theme;

  @override
  Widget build(BuildContext context) {
    final iconBg = isAccent ? theme.itemIconBackgroundAccent : theme.itemIconBackgroundNeutral;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.itemCardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.itemCardBorder, width: 1),
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          Container(
            width: AppSpacing.xxl,
            height: AppSpacing.xxl,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppRadius.sm + 4),
            ),
            alignment: Alignment.center,
            child: AppSvgIcon(asset: item.icon, size: 20, color: theme.itemAmount),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name.toUpperCase(),
                  style: TextStyle(
                    color: theme.itemLabel,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                    letterSpacing: -0.60,
                  ),
                ),
                Text(
                  item.amount,
                  style: TextStyle(
                    color: theme.itemAmount,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.56,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
