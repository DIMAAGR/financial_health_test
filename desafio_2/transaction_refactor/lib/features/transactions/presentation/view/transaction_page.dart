import 'package:flutter/material.dart';
import 'package:transaction_refactor/features/transactions/presentation/models/transaction_item_view_data.dart';
import 'package:transaction_refactor/features/transactions/presentation/view_model/transaction_state.dart';
import 'package:transaction_refactor/features/transactions/presentation/view_model/transaction_view_model.dart';
import 'package:transaction_refactor/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:transaction_refactor/shared/presentation/formatters/currency_formatter.dart';

/// Tela de transações refatorada.
///
/// Responsabilidades desta classe:
/// - observar o [TransactionViewModel] via [ValueListenableBuilder]
/// - delegar render de cada estado a um widget filho
/// - chamar `loadTransactions()` no ciclo correto de montagem
///
/// NÃO contém: chamada HTTP, token, cálculo de total, parse de JSON.
class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key, required this.viewModel});

  final TransactionViewModel viewModel;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movimentações'), centerTitle: true),
      body: ValueListenableBuilder<TransactionState>(
        valueListenable: widget.viewModel.state,
        builder: (context, state, _) {
          return switch (state) {
            TransactionLoadingState() => const _LoadingView(),
            TransactionEmptyState() => const _EmptyView(),
            TransactionErrorState(:final message, :final canRetry) => _ErrorView(
              message: message,
              canRetry: canRetry,
              onRetry: widget.viewModel.loadTransactions,
            ),
            TransactionSuccessState(:final items, :final total) => _SuccessView(
              items: items,
              total: total,
            ),
          };
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Sub-widgets de estado — cada estado tem sua view
// Resolve problema #22: estados visuais organizados e nomeados
// ──────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Nenhuma transação encontrada.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.canRetry, required this.onRetry});

  final String message;
  final bool canRetry;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (canRetry) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.items, required this.total});

  final List<TransactionItemViewData> items;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TotalCard(total: total),
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) => TransactionListItem(item: items[i]),
          ),
        ),
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total});

  /// Saldo líquido em centavos.
  final int total;

  @override
  Widget build(BuildContext context) {
    final isPositive = total >= 0;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: isPositive ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPositive ? Colors.green.shade200 : Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo líquido',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.format(total),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
