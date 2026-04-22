/// Asset path constants for all SVG icons bundled in the design system.
///
/// All paths are prefixed with the package identifier so they resolve correctly
/// when the package is consumed as a path dependency from another Flutter app.
///
/// ## Usage
/// ```dart
/// AppSvgIcon(
///   asset: AppIcons.wallet,
///   size: 24,
///   color: theme.iconColor,
/// )
/// ```
abstract class AppIcons {
  static const _basePath = 'packages/financial_health_design_system/assets/icons';

  /// Financial health score icon.
  static const financialScore = '$_basePath/ic_financial_score.svg';

  /// Shopping bag icon — used for shopping and investment categories.
  static const bag = '$_basePath/ic_bag.svg';

  /// Money / banknote icon — used for freelance, transport and default categories.
  static const money = '$_basePath/ic_money.svg';

  /// Wallet icon — used for salary and housing categories.
  static const wallet = '$_basePath/ic_wallet.svg';

  /// Attention / warning triangle icon.
  static const attention = '$_basePath/ic_attention.svg';

  /// Rocket icon — used for positive goal achievement states.
  static const rocket = '$_basePath/ic_rocket.svg';

  /// Flow / chart icon — used for the cash-flow analysis section.
  static const flow = '$_basePath/ic_flow.svg';

  /// Trending-up arrow icon — used for positive trend indicators.
  static const trendingUp = '$_basePath/ic_trending_up.svg';

  /// Trending-down arrow icon — used for negative trend indicators.
  static const trendingDown = '$_basePath/ic_trending_down.svg';

  /// Edit / pencil icon.
  static const edit = '$_basePath/ic_edit.svg';

  /// Close / X icon — used to dismiss sheets and dialogs.
  static const close = '$_basePath/ic_close.svg';

  /// Gift icon — used for the gift income category.
  static const gift = '$_basePath/ic_gift.svg';

  /// Done / checkmark circle icon — used for success states.
  static const doneCircle = '$_basePath/ic_done_circle.svg';

  /// Left-arrow / back icon — used by [DetailAppBar].
  static const arrowBack = '$_basePath/ic_arrow_back.svg';

  /// Calendar icon — used by the date-filter action in [DetailAppBar].
  static const calendar = '$_basePath/ic_calendar.svg';

  /// Filter / funnel icon — used by the filter action in [DetailAppBar].
  static const filter = '$_basePath/ic_filter.svg';

  /// Plus / add icon — used by [ContextualFab].
  static const add = '$_basePath/ic_add.svg';
}
