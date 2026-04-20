import 'package:financial_health_dashboard/src/core/services/clock/clock.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/services/transaction_date_grouping_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

void main() {
  group('TransactionDateGroupingService', () {
    test('agrupa por data e ordena grupos do mais recente para o mais antigo', () {
      const service = TransactionDateGroupingService();

      final groups = service.groupByDate([
        _transaction(id: '1', date: DateTime(2026, 4, 18), title: 'Mais antigo'),
        _transaction(id: '2', date: DateTime(2026, 4, 20), title: 'Mais novo'),
        _transaction(id: '3', date: DateTime(2026, 4, 19), title: 'Intermediário'),
      ]);

      expect(groups, hasLength(3));
      expect(groups.map((group) => group.date), [
        DateTime(2026, 4, 20),
        DateTime(2026, 4, 19),
        DateTime(2026, 4, 18),
      ]);
    });

    test('usa clock como fallback e mantém transações sem data dentro do grupo esperado', () {
      final service = TransactionDateGroupingService(clock: _FixedClock(DateTime(2026, 4, 20, 15)));

      final groups = service.groupByDate([
        _transaction(id: '1', date: null, title: 'Sem data'),
        _transaction(id: '2', date: DateTime(2026, 4, 19), title: 'Ontem'),
      ]);

      expect(groups.first.date, DateTime(2026, 4, 20));
      expect(groups.first.transactions.single.id, '1');
      expect(groups.last.date, DateTime(2026, 4, 19));
    });

    test('ordena transações do mesmo dia pela data efetiva mais recente', () {
      final service = TransactionDateGroupingService(clock: _FixedClock(DateTime(2026, 4, 20, 12)));

      final groups = service.groupByDate([
        _transaction(id: '1', date: DateTime(2026, 4, 20, 8), title: 'Manhã'),
        _transaction(id: '2', date: null, title: 'Sem data'),
        _transaction(id: '3', date: DateTime(2026, 4, 20, 10), title: 'Meio-dia'),
      ]);

      expect(groups, hasLength(1));
      expect(groups.single.transactions.map((transaction) => transaction.id), ['1', '2', '3']);
    });
  });
}

TransactionData _transaction({required String id, required DateTime? date, required String title}) {
  return TransactionData(
    id: id,
    title: title,
    category: 'salary',
    value: 100,
    type: TransactionType.income,
    date: date,
  );
}
