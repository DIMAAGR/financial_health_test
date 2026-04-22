import 'package:flutter/material.dart';

abstract final class FhTextStyles {
  static const TextStyle financialSummaryTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.35,
  );

  static const TextStyle financialSummaryValue = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    height: 1.11,
  );

  static const TextStyle financialSummaryVariation = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.33,
  );
}
