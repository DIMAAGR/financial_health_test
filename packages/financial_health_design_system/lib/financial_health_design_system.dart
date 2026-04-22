/// Financial Health Design System — public API.
///
/// Import this single file to access all components, tokens, theme extensions,
/// helpers and input formatters provided by the package:
///
/// ```dart
/// import 'package:financial_health_design_system/financial_health_design_system.dart';
/// ```
///
/// ## Package contents
/// - **Tokens**: [AppSpacing], [AppRadius], [AppTextStyles], [FhSpacing], [FhRadius], [FhTextStyles]
/// - **Theme**: [FinancialHealthDesignTheme], [AppThemeExtension]
/// - **ThemeExtensions**: [AppSemanticColors], [FinancialSummaryCardTheme], [AddIncomeSheetTheme],
///   [CategoryBreakdownTheme], [ContextualFabTheme], [FinancialHealthScoreTheme],
///   [FlowAnalysisTheme], [MonthSummaryTheme], [MonthlyGoalTheme], [TransactionListTheme]
/// - **Components**: [FinancialSummaryCard], [CategoryBreakdownSection], [ContextualFab],
///   [DetailAppBar], [MonthSummaryCard], [ShimmerSkeleton], [AppSvgIcon], [TransactionListSection]
/// - **Helpers**: [categoryLabel], [categoryIcon]
/// - **Extensions**: [CurrencyFormatExtension], [TransactionGroupLabelExtension]
/// - **Input formatters**: [BrlCurrencyInputFormatter]
/// - **Assets**: [AppIcons]
library;

export 'src/assets/icons.dart';
export 'src/components/category_breakdown/category_breakdown_section.dart';
export 'src/components/contextual_fab/contextual_fab.dart';
export 'src/components/detail_app_bar/detail_app_bar.dart';
export 'src/components/financial_summary_card/financial_summary_card.dart';
export 'src/components/month_summary_card/month_summary_card.dart';
export 'src/components/shimmer_skeleton/shimmer_skeleton.dart';
export 'src/components/svg_icon/app_svg_icon.dart';
export 'src/components/transaction_list/transaction_list_section.dart';
export 'src/extensions/currency_format_extension.dart';
export 'src/extensions/transaction_group_label_extension.dart';
export 'src/foundations/theme/financial_health_design_theme.dart';
export 'src/foundations/tokens/app_radius.dart';
export 'src/foundations/tokens/app_spacing.dart';
export 'src/foundations/tokens/app_text_styles.dart';
export 'src/foundations/tokens/fh_radius.dart';
export 'src/foundations/tokens/fh_spacing.dart';
export 'src/foundations/tokens/fh_text_styles.dart';
export 'src/helpers/category_helpers.dart';
export 'src/input_formatters/brl_currency_input_formatter.dart';
export 'src/theme/extensions/add_income_sheet_theme_ext.dart';
export 'src/theme/extensions/app_semantic_colors.dart';
export 'src/theme/extensions/app_theme_ext.dart';
export 'src/theme/extensions/category_breakdown_theme_ext.dart';
export 'src/theme/extensions/contextual_fab_theme_ext.dart';
export 'src/theme/extensions/financial_health_score_theme_ext.dart';
export 'src/theme/extensions/financial_summary_card_theme_ext.dart';
export 'src/theme/extensions/flow_analysis_theme_ext.dart';
export 'src/theme/extensions/month_summary_theme_ext.dart';
export 'src/theme/extensions/monthly_goal_theme_ext.dart';
export 'src/theme/extensions/transaction_list_theme_ext.dart';
