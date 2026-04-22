/// Border-radius scale for the [FinancialSummaryCard] component.
///
/// These constants are separate from [AppRadius] so that the
/// `FinancialSummaryCard` can evolve its geometry independently from the
/// broader token scale used by the rest of the application.
///
/// Prefer [AppRadius] for all other surfaces outside of `FinancialSummaryCard`.
abstract final class FhRadius {
  /// Small radius (8 pt). Used for inner elements such as the variation-pill
  /// badge corners inside [FinancialSummaryCard].
  static const double sm = 8;

  /// Medium radius (16 pt).
  static const double md = 16;

  /// Large radius (24 pt). Applied to the outer card container border.
  static const double lg = 24;

  /// Fully-rounded pill shape (9 999 pt). Produces a stadium / capsule border
  /// regardless of the container size — used for the variation badge pill.
  static const double pill = 9999;
}
