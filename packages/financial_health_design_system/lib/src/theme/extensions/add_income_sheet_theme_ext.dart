import 'package:flutter/material.dart';

/// [ThemeExtension] that carries the color scheme for the add-income /
/// add-expense bottom sheet.
///
/// Registered on [ThemeData] by [FinancialHealthDesignTheme] and accessed
/// in widgets via [AppThemeExtension.addIncomeSheetTheme]:
///
/// ```dart
/// final theme = context.addIncomeSheetTheme;
/// Container(color: theme.background)
/// ```
@immutable
class AddIncomeSheetTheme extends ThemeExtension<AddIncomeSheetTheme> {
  /// Creates an [AddIncomeSheetTheme] with all color roles required.
  const AddIncomeSheetTheme({
    required this.background,
    required this.dragHandle,
    required this.title,
    required this.closeButtonBackground,
    required this.closeIcon,
    required this.fieldLabel,
    required this.fieldBackground,
    required this.fieldText,
    required this.fieldPlaceholder,
    required this.currencySymbol,
    required this.categorySelectedBackground,
    required this.categorySelectedText,
    required this.categorySelectedIcon,
    required this.categoryUnselectedBackground,
    required this.categoryUnselectedText,
    required this.categoryUnselectedIcon,
    required this.categoryAddBackground,
    required this.categoryAddIcon,
    required this.primaryButtonStart,
    required this.primaryButtonEnd,
    required this.primaryButtonText,
    required this.sheetShadow,
  });

  /// Background fill for the sheet container.
  final Color background;

  /// Color of the drag-handle indicator at the top of the sheet.
  final Color dragHandle;

  /// Color of the sheet's heading text.
  final Color title;

  /// Background fill for the circular close button.
  final Color closeButtonBackground;

  /// Tint for the X icon inside the close button.
  final Color closeIcon;

  /// Color of the uppercase field labels (e.g., "VALOR", "DESCRIÇÃO").
  final Color fieldLabel;

  /// Background fill for text input fields.
  final Color fieldBackground;

  /// Color of the typed text inside input fields.
  final Color fieldText;

  /// Placeholder/hint text color in input fields.
  final Color fieldPlaceholder;

  /// Color of the currency symbol prefix ("R$") in the amount field.
  final Color currencySymbol;

  /// Background fill for the currently selected category chip.
  final Color categorySelectedBackground;

  /// Label color for the currently selected category chip.
  final Color categorySelectedText;

  /// Icon tint for the currently selected category chip.
  final Color categorySelectedIcon;

  /// Background fill for unselected category chips.
  final Color categoryUnselectedBackground;

  /// Label color for unselected category chips.
  final Color categoryUnselectedText;

  /// Icon tint for unselected category chips.
  final Color categoryUnselectedIcon;

  /// Background of the "+" add-category chip.
  final Color categoryAddBackground;

  /// Icon tint for the "+" add-category chip.
  final Color categoryAddIcon;

  /// Start color of the primary button gradient (left edge).
  final Color primaryButtonStart;

  /// End color of the primary button gradient (right edge).
  final Color primaryButtonEnd;

  /// Text color on the primary action button.
  final Color primaryButtonText;

  /// Drop-shadow color for the sheet container.
  final Color sheetShadow;

  @override
  AddIncomeSheetTheme copyWith({
    Color? background,
    Color? dragHandle,
    Color? title,
    Color? closeButtonBackground,
    Color? closeIcon,
    Color? fieldLabel,
    Color? fieldBackground,
    Color? fieldText,
    Color? fieldPlaceholder,
    Color? currencySymbol,
    Color? categorySelectedBackground,
    Color? categorySelectedText,
    Color? categorySelectedIcon,
    Color? categoryUnselectedBackground,
    Color? categoryUnselectedText,
    Color? categoryUnselectedIcon,
    Color? categoryAddBackground,
    Color? categoryAddIcon,
    Color? primaryButtonStart,
    Color? primaryButtonEnd,
    Color? primaryButtonText,
    Color? sheetShadow,
  }) {
    return AddIncomeSheetTheme(
      background: background ?? this.background,
      dragHandle: dragHandle ?? this.dragHandle,
      title: title ?? this.title,
      closeButtonBackground: closeButtonBackground ?? this.closeButtonBackground,
      closeIcon: closeIcon ?? this.closeIcon,
      fieldLabel: fieldLabel ?? this.fieldLabel,
      fieldBackground: fieldBackground ?? this.fieldBackground,
      fieldText: fieldText ?? this.fieldText,
      fieldPlaceholder: fieldPlaceholder ?? this.fieldPlaceholder,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      categorySelectedBackground: categorySelectedBackground ?? this.categorySelectedBackground,
      categorySelectedText: categorySelectedText ?? this.categorySelectedText,
      categorySelectedIcon: categorySelectedIcon ?? this.categorySelectedIcon,
      categoryUnselectedBackground:
          categoryUnselectedBackground ?? this.categoryUnselectedBackground,
      categoryUnselectedText: categoryUnselectedText ?? this.categoryUnselectedText,
      categoryUnselectedIcon: categoryUnselectedIcon ?? this.categoryUnselectedIcon,
      categoryAddBackground: categoryAddBackground ?? this.categoryAddBackground,
      categoryAddIcon: categoryAddIcon ?? this.categoryAddIcon,
      primaryButtonStart: primaryButtonStart ?? this.primaryButtonStart,
      primaryButtonEnd: primaryButtonEnd ?? this.primaryButtonEnd,
      primaryButtonText: primaryButtonText ?? this.primaryButtonText,
      sheetShadow: sheetShadow ?? this.sheetShadow,
    );
  }

  @override
  ThemeExtension<AddIncomeSheetTheme> lerp(
    covariant ThemeExtension<AddIncomeSheetTheme>? other,
    double t,
  ) {
    if (other is! AddIncomeSheetTheme) return this;

    return AddIncomeSheetTheme(
      background: Color.lerp(background, other.background, t)!,
      dragHandle: Color.lerp(dragHandle, other.dragHandle, t)!,
      title: Color.lerp(title, other.title, t)!,
      closeButtonBackground: Color.lerp(closeButtonBackground, other.closeButtonBackground, t)!,
      closeIcon: Color.lerp(closeIcon, other.closeIcon, t)!,
      fieldLabel: Color.lerp(fieldLabel, other.fieldLabel, t)!,
      fieldBackground: Color.lerp(fieldBackground, other.fieldBackground, t)!,
      fieldText: Color.lerp(fieldText, other.fieldText, t)!,
      fieldPlaceholder: Color.lerp(fieldPlaceholder, other.fieldPlaceholder, t)!,
      currencySymbol: Color.lerp(currencySymbol, other.currencySymbol, t)!,
      categorySelectedBackground: Color.lerp(
        categorySelectedBackground,
        other.categorySelectedBackground,
        t,
      )!,
      categorySelectedText: Color.lerp(categorySelectedText, other.categorySelectedText, t)!,
      categorySelectedIcon: Color.lerp(categorySelectedIcon, other.categorySelectedIcon, t)!,
      categoryUnselectedBackground: Color.lerp(
        categoryUnselectedBackground,
        other.categoryUnselectedBackground,
        t,
      )!,
      categoryUnselectedText: Color.lerp(categoryUnselectedText, other.categoryUnselectedText, t)!,
      categoryUnselectedIcon: Color.lerp(categoryUnselectedIcon, other.categoryUnselectedIcon, t)!,
      categoryAddBackground: Color.lerp(categoryAddBackground, other.categoryAddBackground, t)!,
      categoryAddIcon: Color.lerp(categoryAddIcon, other.categoryAddIcon, t)!,
      primaryButtonStart: Color.lerp(primaryButtonStart, other.primaryButtonStart, t)!,
      primaryButtonEnd: Color.lerp(primaryButtonEnd, other.primaryButtonEnd, t)!,
      primaryButtonText: Color.lerp(primaryButtonText, other.primaryButtonText, t)!,
      sheetShadow: Color.lerp(sheetShadow, other.sheetShadow, t)!,
    );
  }
}
