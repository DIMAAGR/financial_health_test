import 'package:transaction_refactor/features/transactions/domain/entities/transaction_entity.dart';
import 'package:transaction_refactor/features/transactions/presentation/models/transaction_item_view_data.dart';
import 'package:transaction_refactor/shared/presentation/extensions/transaction_type_ext.dart';
import 'package:transaction_refactor/shared/presentation/formatters/currency_formatter.dart';

/// Mapper de apresentação: converte [TransactionEntity] → [TransactionItemViewData].
///
/// Centraliza toda a lógica de transformação para a UI:
/// formatação de valor, ícone e label. A cor é omitida por ser
/// context-sensitive (ThemeExtension), ficando no widget.
abstract final class TransactionItemMapper {
  /// Converte uma única entidade de domínio em view data pronta para renderização.
  static TransactionItemViewData fromEntity(TransactionEntity entity) {
    return TransactionItemViewData(
      id: entity.id,
      description: entity.description,
      formattedAmount: CurrencyFormatter.format(entity.amount),
      icon: entity.type.icon,
      typeLabel: entity.type.label,
      type: entity.type,
    );
  }

  /// Converte uma lista de entidades em uma lista de view data.
  static List<TransactionItemViewData> fromEntities(List<TransactionEntity> entities) =>
      entities.map(fromEntity).toList(growable: false);
}
