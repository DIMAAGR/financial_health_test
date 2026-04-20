import 'package:financial_health_dashboard/src/core/services/clock/clock.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/services/transaction_date_grouping_service.dart';
import 'package:financial_health_dashboard/src/shared/presentation/mappers/transaction_group_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  group('TransactionGroupMapper', () {
    test('gera label de hoje e sinal por tipo na lista geral', () {
      final groups = TransactionGroupMapper.toTransactionsGroups(
        [
          _transaction(id: '1', title: 'Salário', value: 2500, type: TransactionType.income),
          _transaction(
            id: '2',
            title: 'Mercado',
            value: 180,
            type: TransactionType.expense,
            category: 'food',
          ),
        ],
        groupingService: TransactionDateGroupingService(
          clock: _FixedClock(DateTime(2026, 4, 20, 9)),
        ),
        clock: _FixedClock(DateTime(2026, 4, 20, 9)),
      );

      expect(groups, hasLength(1));
      expect(groups.single.dateLabel, 'HOJE, 20 ABR.');
      expect(groups.single.isToday, isTrue);
      expect(groups.single.items.first.amount, '+R\$ 2.500,00');
      expect(groups.single.items.first.isExpense, isFalse);
      expect(groups.single.items.last.amount, '-R\$ 180,00');
      expect(groups.single.items.last.isExpense, isTrue);
    });

    test('gera payment method fixo para receitas e despesas', () {
      final incomeGroups = TransactionGroupMapper.toIncomeGroups([
        _transaction(id: '1', title: 'Freela', value: 500, type: TransactionType.income),
      ], clock: _FixedClock(DateTime(2026, 4, 20, 9)));
      final expenseGroups = TransactionGroupMapper.toExpenseGroups([
        _transaction(
          id: '2',
          title: 'Assinatura',
          value: 39.9,
          type: TransactionType.expense,
          category: 'shopping',
          date: DateTime(2026, 4, 19, 14),
        ),
      ], clock: _FixedClock(DateTime(2026, 4, 20, 9)));

      expect(incomeGroups.single.items.single.paymentMethod, 'PIX');
      expect(expenseGroups.single.dateLabel, 'ONTEM, 19 ABR.');
      expect(expenseGroups.single.items.single.paymentMethod, 'CARTÃO');
      expect(expenseGroups.single.items.single.amount, 'R\$ 39,90');
    });
  });
}

TransactionData _transaction({
  required String id,
  required String title,
  required double value,
  required TransactionType type,
  String category = 'salary',
  DateTime? date,
}) {
  return TransactionData(
    id: id,
    title: title,
    category: category,
    value: value,
    type: type,
    date: date ?? DateTime(2026, 4, 20, 8),
  );
}
