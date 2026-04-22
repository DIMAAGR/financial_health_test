import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';

class TransactionSubmitButton extends StatelessWidget {
  const TransactionSubmitButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.isSubmitting,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final bool enabled;
  final bool isSubmitting;
  final VoidCallback onTap;
  final AddIncomeSheetTheme theme;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled || isSubmitting ? 1 : 0.5,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Material(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.46, -0.46),
                end: const Alignment(0.54, 1.46),
                colors: [theme.primaryButtonStart, theme.primaryButtonEnd],
              ),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: isSubmitting
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: theme.primaryButtonText,
                        ),
                      )
                    : Text(
                        label,
                        style: AppTextStyles.sheetPrimaryButton.copyWith(
                          color: theme.primaryButtonText,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
