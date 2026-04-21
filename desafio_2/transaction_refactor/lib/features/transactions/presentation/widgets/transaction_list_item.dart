import 'package:flutter/material.dart';
import 'package:transaction_refactor/features/transactions/presentation/models/transaction_item_view_data.dart';
import 'package:transaction_refactor/shared/presentation/design/transaction_colors.dart';

/// Widget reutilizável que exibe uma única transação em forma de tile.
///
/// Recebe [TransactionItemViewData] — todos os dados já transformados
/// pela camada de apresentação (problema #5, #13, #25).
/// Não sabe nada sobre entidades de domínio, chaves da API ou tipos brutos.
class TransactionListItem extends StatelessWidget {
  const TransactionListItem({super.key, required this.item});

  final TransactionItemViewData item;

  @override
  Widget build(BuildContext context) {
    final color = context.transactionColors.colorFor(item.type);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(item.icon, color: color, size: 20),
      ),
      title: Text(
        item.description,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        item.typeLabel,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        item.formattedAmount,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
