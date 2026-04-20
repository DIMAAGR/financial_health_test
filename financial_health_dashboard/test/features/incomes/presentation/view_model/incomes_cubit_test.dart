import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/add_income_input.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/entities/incomes_overview_data.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/repositories/incomes_repository.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/use_cases/add_income_use_case.dart';
import 'package:financial_health_dashboard/src/features/incomes/domain/use_cases/get_incomes_overview_use_case.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/view_model/incomes_cubit.dart';
import 'package:financial_health_dashboard/src/features/incomes/presentation/view_model/incomes_state.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/category_breakdown_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/entities/transaction_data.dart';
import 'package:financial_health_dashboard/src/shared/domain/enum/income_category.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeIncomesRepository implements IncomesRepository {
  _FakeIncomesRepository({required this.overviewResult, required this.addIncomeResult});

  Either<AppFailure, IncomesOverviewData> overviewResult;
  Either<AppFailure, void> addIncomeResult;
  int overviewCalls = 0;
  int addIncomeCalls = 0;
  double? lastIncomeAmount;
  String? lastIncomeTitle;
  IncomeCategory? lastIncomeCategory;

  @override
  Future<Either<AppFailure, IncomesOverviewData>> getOverview() async {
    overviewCalls++;
    return overviewResult;
  }

  @override
  Future<Either<AppFailure, void>> addIncome({
    required double amount,
    required String title,
    required IncomeCategory category,
  }) async {
    addIncomeCalls++;
    lastIncomeAmount = amount;
    lastIncomeTitle = title;
    lastIncomeCategory = category;
    return addIncomeResult;
  }
}

void main() {
  group('IncomesCubit', () {
    test('loadOverview com sucesso popula state com dados de receita', () async {
      final data = _incomesOverview();
      final repo = _FakeIncomesRepository(
        overviewResult: Right(data),
        addIncomeResult: const Right(null),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddIncomeUseCase(repo));

      await cubit.loadOverview();

      expect(cubit.state.status, IncomesViewStatus.success);
      expect(cubit.state.totalIncome, 8000);
      expect(cubit.state.monthLabel, 'Abril');
      expect(cubit.state.transactions, hasLength(2));
      expect(cubit.state.categoryBreakdown, isNotEmpty);
      await cubit.close();
    });

    test('loadOverview com falha emite estado de erro', () async {
      final repo = _FakeIncomesRepository(
        overviewResult: const Left(NetworkFailure()),
        addIncomeResult: const Left(NetworkFailure()),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddIncomeUseCase(repo));

      await cubit.loadOverview();

      expect(cubit.state.status, IncomesViewStatus.error);
      expect(cubit.state.canRetry, isTrue);
      await cubit.close();
    });

    test('emite efeito para abrir bottom sheet de receita', () async {
      final data = _incomesOverview();
      final repo = _FakeIncomesRepository(
        overviewResult: Right(data),
        addIncomeResult: const Right(null),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddIncomeUseCase(repo));

      final beforeVersion = cubit.state.effectVersion;
      cubit.onAddIncomePressed();

      expect(cubit.state.effect, IncomesEffect.showAddIncomeSheet);
      expect(cubit.state.effectVersion, beforeVersion + 1);
      await cubit.close();
    });

    test('clearEffect remove efeito ativo', () async {
      final data = _incomesOverview();
      final repo = _FakeIncomesRepository(
        overviewResult: Right(data),
        addIncomeResult: const Right(null),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddIncomeUseCase(repo))
        ..onAddIncomePressed()
        ..clearEffect();

      expect(cubit.state.effect, isNull);
      await cubit.close();
    });

    test('addIncome usa use case e recarrega overview no sucesso', () async {
      final updated = _incomesOverview(totalIncome: 9000);
      final repo = _FakeIncomesRepository(
        overviewResult: Right(updated),
        addIncomeResult: const Right(null),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddIncomeUseCase(repo));

      final success = await cubit.addIncome(
        const AddIncomeInput(amount: 1000, title: 'Freelance', category: IncomeCategory.investment),
      );

      expect(success, isTrue);
      expect(repo.addIncomeCalls, 1);
      expect(repo.lastIncomeAmount, 1000);
      // Should reload overview after adding
      expect(repo.overviewCalls, 1);
      await cubit.close();
    });

    test('addIncome retorna false e emite erro na falha', () async {
      final data = _incomesOverview();
      final repo = _FakeIncomesRepository(
        overviewResult: Right(data),
        addIncomeResult: const Left(ValidationFailure('Descrição é obrigatória.')),
      );
      final cubit = IncomesCubit(GetIncomesOverviewUseCase(repo), AddIncomeUseCase(repo));

      final success = await cubit.addIncome(
        const AddIncomeInput(amount: 500, title: '', category: IncomeCategory.salary),
      );

      expect(success, isFalse);
      await cubit.close();
    });
  });
}

IncomesOverviewData _incomesOverview({double totalIncome = 8000}) {
  final safeDivisor = totalIncome <= 0 ? 1.0 : totalIncome;
  return IncomesOverviewData(
    totalIncome: totalIncome,
    monthLabel: 'Abril',
    incomeChangePercent: 12.5,
    transactions: [
      TransactionData(
        id: '1',
        title: 'Salário',
        category: 'salary',
        value: 5000,
        type: TransactionType.income,
        date: DateTime(2026, 4, 10),
      ),
      TransactionData(
        id: '3',
        title: 'Freelance',
        category: 'services',
        value: 2000,
        type: TransactionType.income,
        date: DateTime(2026, 4, 9),
      ),
    ],
    categoryBreakdown: [
      CategoryBreakdownData(
        category: 'salary',
        amount: 5000,
        percentage: (5000 / safeDivisor) * 100,
      ),
      CategoryBreakdownData(
        category: 'services',
        amount: 2000,
        percentage: (2000 / safeDivisor) * 100,
      ),
    ],
  );
}
