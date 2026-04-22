import 'package:transaction_refactor/features/transactions/presentation/models/transaction_item_view_data.dart';

/// Estado selado da tela de transações.
///
/// Substitui as três variáveis soltas (`isLoading`, `error`, `transactions`)
/// que geravam combinações inválidas de estado (problema #3).
/// Cada subtipo representa exatamente um estado possível — sem ambiguidade.
sealed class TransactionState {
  const TransactionState();
}

class TransactionLoadingState extends TransactionState {
  const TransactionLoadingState();
}

class TransactionSuccessState extends TransactionState {
  const TransactionSuccessState({required this.items, required this.total});

  /// Lista de itens já mapeados para exibição pela UI (#5, #13).
  final List<TransactionItemViewData> items;

  /// Total líquido em centavos, para o card de saldo.
  final int total;
}

/// Estado de lista vazia — distinto de erro e de carregamento (problema #20).
class TransactionEmptyState extends TransactionState {
  const TransactionEmptyState();
}

class TransactionErrorState extends TransactionState {
  const TransactionErrorState({required this.message, this.canRetry = true});

  final String message;
  final bool canRetry;
}
