/// Application-wide border-radius scale.
///
/// Use these constants instead of hardcoded values to keep corner radii
/// consistent across the entire app. A single change here propagates to
/// every surface that references the token.
///
/// For the [FinancialSummaryCard]-specific scale see [FhRadius].
abstract class AppRadius {
  /// Small radius (8 pt). Used for inner chips, badges and small containers.
  static const double sm = 8;

  /// Medium radius (16 pt). Used for cards and sheet handles.
  static const double md = 16;

  /// Large radius (24 pt). Used for main cards and bottom sheets.
  static const double lg = 24;

  /// Fully-rounded pill / stadium shape (9 999 pt).
  static const double pill = 9999;
}
