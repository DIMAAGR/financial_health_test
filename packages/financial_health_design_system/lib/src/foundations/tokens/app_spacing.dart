/// Application-wide spacing scale based on a 4 pt grid.
///
/// Use these constants for margins, paddings, gaps and icon sizes to maintain
/// visual rhythm across the app. A single change here propagates everywhere.
///
/// For the [FinancialSummaryCard]-specific scale see [FhSpacing].
abstract class AppSpacing {
  /// 2 pt — hairline separation.
  static const double xxs = 2;

  /// 4 pt — tight inline gap.
  static const double xs = 4;

  /// 8 pt — standard inline gap between sibling elements.
  static const double sm = 8;

  /// 16 pt — standard component padding.
  static const double md = 16;

  /// 24 pt — large section gap; also used as the icon container size.
  static const double lg = 24;

  /// 32 pt — extra-large padding for card bodies and sheets.
  static const double xl = 32;

  /// 40 pt — extra-extra-large; used for icon badges in detail cards.
  static const double xxl = 40;

  /// 48 pt — component heights and large icon containers.
  static const double xxxl = 48;

  /// 56 pt — large section padding.
  static const double huge = 56;

  /// 64 pt — maximum standard spacing; used for hero sections.
  static const double giant = 64;
}
