import 'package:flutter/material.dart';
import 'package:transaction_refactor/shared/presentation/design/transaction_colors.dart';
import 'package:transaction_refactor/shared/presentation/formatters/currency_formatter.dart';

/// Card que apresenta o saldo líquido da lista de transações.
///
/// Recebe o valor em centavos e delega cor/contraste ao ThemeExtension para
/// manter o suporte a tema claro e escuro sem `Colors.*` espalhado na tela.
class TransactionTotalCard extends StatelessWidget {
  const TransactionTotalCard({super.key, required this.total});

  /// Saldo líquido em centavos.
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.transactionColors;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: colors.backgroundForTotal(total),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderForTotal(total)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo líquido',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.mutedTextColor),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.format(total),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.amountColorForTotal(total),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
