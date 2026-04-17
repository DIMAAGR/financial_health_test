import 'package:flutter/material.dart';

@immutable
class AddIncomeSheetTheme extends ThemeExtension<AddIncomeSheetTheme> {
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

  final Color background;
  final Color dragHandle;
  final Color title;
  final Color closeButtonBackground;
  final Color closeIcon;

  final Color fieldLabel;
  final Color fieldBackground;
  final Color fieldText;
  final Color fieldPlaceholder;
  final Color currencySymbol;

  final Color categorySelectedBackground;
  final Color categorySelectedText;
  final Color categorySelectedIcon;
  final Color categoryUnselectedBackground;
  final Color categoryUnselectedText;
  final Color categoryUnselectedIcon;
  final Color categoryAddBackground;
  final Color categoryAddIcon;

  final Color primaryButtonStart;
  final Color primaryButtonEnd;
  final Color primaryButtonText;

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
      closeButtonBackground:
          closeButtonBackground ?? this.closeButtonBackground,
      closeIcon: closeIcon ?? this.closeIcon,
      fieldLabel: fieldLabel ?? this.fieldLabel,
      fieldBackground: fieldBackground ?? this.fieldBackground,
      fieldText: fieldText ?? this.fieldText,
      fieldPlaceholder: fieldPlaceholder ?? this.fieldPlaceholder,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      categorySelectedBackground:
          categorySelectedBackground ?? this.categorySelectedBackground,
      categorySelectedText: categorySelectedText ?? this.categorySelectedText,
      categorySelectedIcon: categorySelectedIcon ?? this.categorySelectedIcon,
      categoryUnselectedBackground:
          categoryUnselectedBackground ?? this.categoryUnselectedBackground,
      categoryUnselectedText:
          categoryUnselectedText ?? this.categoryUnselectedText,
      categoryUnselectedIcon:
          categoryUnselectedIcon ?? this.categoryUnselectedIcon,
      categoryAddBackground:
          categoryAddBackground ?? this.categoryAddBackground,
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
      closeButtonBackground: Color.lerp(
        closeButtonBackground,
        other.closeButtonBackground,
        t,
      )!,
      closeIcon: Color.lerp(closeIcon, other.closeIcon, t)!,
      fieldLabel: Color.lerp(fieldLabel, other.fieldLabel, t)!,
      fieldBackground: Color.lerp(fieldBackground, other.fieldBackground, t)!,
      fieldText: Color.lerp(fieldText, other.fieldText, t)!,
      fieldPlaceholder: Color.lerp(
        fieldPlaceholder,
        other.fieldPlaceholder,
        t,
      )!,
      currencySymbol: Color.lerp(currencySymbol, other.currencySymbol, t)!,
      categorySelectedBackground: Color.lerp(
        categorySelectedBackground,
        other.categorySelectedBackground,
        t,
      )!,
      categorySelectedText: Color.lerp(
        categorySelectedText,
        other.categorySelectedText,
        t,
      )!,
      categorySelectedIcon: Color.lerp(
        categorySelectedIcon,
        other.categorySelectedIcon,
        t,
      )!,
      categoryUnselectedBackground: Color.lerp(
        categoryUnselectedBackground,
        other.categoryUnselectedBackground,
        t,
      )!,
      categoryUnselectedText: Color.lerp(
        categoryUnselectedText,
        other.categoryUnselectedText,
        t,
      )!,
      categoryUnselectedIcon: Color.lerp(
        categoryUnselectedIcon,
        other.categoryUnselectedIcon,
        t,
      )!,
      categoryAddBackground: Color.lerp(
        categoryAddBackground,
        other.categoryAddBackground,
        t,
      )!,
      categoryAddIcon: Color.lerp(categoryAddIcon, other.categoryAddIcon, t)!,
      primaryButtonStart: Color.lerp(
        primaryButtonStart,
        other.primaryButtonStart,
        t,
      )!,
      primaryButtonEnd: Color.lerp(
        primaryButtonEnd,
        other.primaryButtonEnd,
        t,
      )!,
      primaryButtonText: Color.lerp(
        primaryButtonText,
        other.primaryButtonText,
        t,
      )!,
      sheetShadow: Color.lerp(sheetShadow, other.sheetShadow, t)!,
    );
  }
}
