/// Spacing scale for the [FinancialSummaryCard] component.
///
/// Values follow a 4 pt grid and are intentionally separate from [AppSpacing]
/// so the card's layout can be changed without side effects on the rest of
/// the design system.
///
/// Prefer [AppSpacing] for all other surfaces outside of `FinancialSummaryCard`.
abstract final class FhSpacing {
  /// 2 pt — hairline separation between tightly coupled elements.
  static const double xxs = 2;

  /// 4 pt — minimal inline gap; also used as the shadow blur radius.
  static const double xs = 4;

  /// 8 pt — standard inline gap.
  static const double sm = 8;

  /// 16 pt — horizontal padding for the variation badge pill.
  static const double md = 16;

  /// 24 pt — large gap; also the icon size drawn inside the accent circle.
  static const double lg = 24;

  /// 32 pt — uniform content padding applied to all sides of the card body.
  static const double xl = 32;

  /// 40 pt — vertical gap between the icon row and the title/value section.
  static const double xxl = 40;

  /// 48 pt — outer dimension of the circular icon container.
  static const double xxxl = 48;
}
