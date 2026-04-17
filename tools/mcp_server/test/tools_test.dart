import 'dart:io';

import 'package:test/test.dart';

import '../lib/src/tools/context_tools.dart';
import '../lib/src/tools/generation_tools.dart';
import '../lib/src/tools/logging_tools.dart';

void main() {
  late Directory tempDir;
  late String docsPath;
  late String flutterRoot;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('mcp_test_');
    docsPath = '${tempDir.path}/docs';
    flutterRoot = '${tempDir.path}/financial_health_dashboard';

    // Create docs structure
    Directory('$docsPath/ia').createSync(recursive: true);
    Directory('$docsPath/architecture').createSync(recursive: true);

    File('$docsPath/architecture/architecture.md')
        .writeAsStringSync('# Architecture\nFeature-first with DDD.');

    File('$docsPath/architecture/ia_in_process.md')
        .writeAsStringSync('# IA in Process\nLog every decision.');

    File('$docsPath/ia/rules.md').writeAsStringSync('# Rules\n1. Always log.\n2. TDD for domain.');

    File('$docsPath/ia/learnings.md').writeAsStringSync(
      '# Learnings\n\n### 1. State flags | 2026-04-14\n\n'
      '**Causa raiz:** Ambiguity.\n\n**Prevenção:** Use enums.',
    );

    File('$docsPath/ia/prompt_log.md').writeAsStringSync(
      '# Prompt Log\n\n'
      '### 1. Skeleton layout (2026-04-15)\n\n'
      '**Prompt:** Fix skeleton.\n\n'
      '**Decisão:** Match dashboard.\n\n'
      '**Trade-offs:** Complexity.\n\n'
      '**Resultado:** Done.\n\n'
      '### 2. Shimmer animation (2026-04-16)\n\n'
      '**Prompt:** Add shimmer.\n\n'
      '**Decisão:** AnimationController.\n\n'
      '**Trade-offs:** No package.\n\n'
      '**Resultado:** Implemented.',
    );

    // Create Flutter project structure
    Directory(flutterRoot).createSync(recursive: true);
    File('$flutterRoot/pubspec.yaml').writeAsStringSync('name: test_app\nversion: 1.0.0');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  // ═══════════════════════════════════════════════════════════════════════
  // Context Tools
  // ═══════════════════════════════════════════════════════════════════════

  group('readDoc', () {
    test('returns file content when file exists', () {
      final content = readDoc(docsPath, 'ia/rules.md');
      expect(content, contains('Always log'));
      expect(content, contains('TDD for domain'));
    });

    test('returns warning when file does not exist', () {
      final content = readDoc(docsPath, 'nonexistent.md');
      expect(content, contains('File not found'));
    });
  });

  group('splitLogEntries', () {
    test('splits prompt log into individual entries', () {
      final content = File('$docsPath/ia/prompt_log.md').readAsStringSync();
      final entries = splitLogEntries(content);

      expect(entries, hasLength(2));
      expect(entries[0], contains('Skeleton layout'));
      expect(entries[1], contains('Shimmer animation'));
    });

    test('each entry contains full context', () {
      final content = File('$docsPath/ia/prompt_log.md').readAsStringSync();
      final entries = splitLogEntries(content);

      expect(entries[0], contains('Fix skeleton'));
      expect(entries[0], contains('Match dashboard'));
      expect(entries[1], contains('AnimationController'));
    });

    test('returns empty list for content without entries', () {
      final entries = splitLogEntries('# Just a title\nNo entries here.');
      expect(entries, isEmpty);
    });
  });

  group('search_prompt_log filtering', () {
    test('case-insensitive search finds matching entries', () {
      final content = File('$docsPath/ia/prompt_log.md').readAsStringSync();
      final entries = splitLogEntries(content);
      final query = 'shimmer';
      final matches = entries.where((e) => e.toLowerCase().contains(query)).toList();

      expect(matches, hasLength(1));
      expect(matches.first, contains('Shimmer animation'));
    });

    test('returns empty when no match', () {
      final content = File('$docsPath/ia/prompt_log.md').readAsStringSync();
      final entries = splitLogEntries(content);
      final matches = entries.where((e) => e.toLowerCase().contains('nonexistent_xyz')).toList();

      expect(matches, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // Logging Tools
  // ═══════════════════════════════════════════════════════════════════════

  group('nextEntryIndex', () {
    test('returns 1 for non-existent file', () {
      final file = File('${tempDir.path}/missing.md');
      expect(nextEntryIndex(file, r'### \d+\.'), equals(1));
    });

    test('counts existing entries and returns next index', () {
      final file = File('$docsPath/ia/prompt_log.md');
      expect(nextEntryIndex(file, r'### \d+\.'), equals(3));
    });

    test('returns 2 for file with one entry', () {
      final file = File('$docsPath/ia/learnings.md');
      expect(nextEntryIndex(file, r'### \d+\.'), equals(2));
    });
  });

  group('log_interaction file operations', () {
    test('appends formatted entry to prompt_log.md', () {
      final logFile = File('$docsPath/ia/prompt_log.md');
      final index = nextEntryIndex(logFile, r'### \d+\.');

      final entry = '\n\n### $index. Test entry (2026-04-17)\n\n'
          '**Prompt:** Test prompt\n\n'
          '**Decisão:** Test decision\n\n'
          '**Trade-offs:** Test trade-offs\n\n'
          '**Resultado:** Test result';
      logFile.writeAsStringSync(entry, mode: FileMode.append);

      final content = logFile.readAsStringSync();
      expect(content, contains('### 3. Test entry (2026-04-17)'));
      expect(content, contains('Test prompt'));
    });
  });

  group('add_learning file operations', () {
    test('appends formatted entry to learnings.md', () {
      final file = File('$docsPath/ia/learnings.md');
      final index = nextEntryIndex(file, r'### \d+\.');

      final entry = '\n\n### $index. Test learning | 2026-04-17\n\n'
          '**Causa raiz:** Root cause here\n\n'
          '**Prevenção:** Prevention here';
      file.writeAsStringSync(entry, mode: FileMode.append);

      final content = file.readAsStringSync();
      expect(content, contains('### 2. Test learning | 2026-04-17'));
      expect(content, contains('Root cause here'));
      expect(content, contains('Prevention here'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // Generation Tools — Feature Structure
  // ═══════════════════════════════════════════════════════════════════════

  group('featureDirectories', () {
    test('generates correct directory list for a feature', () {
      final dirs = featureDirectories('/lib/feat', '/test/feat');

      expect(dirs, contains('/lib/feat/data/datasources'));
      expect(dirs, contains('/lib/feat/domain/entities'));
      expect(dirs, contains('/lib/feat/domain/use_cases'));
      expect(dirs, contains('/lib/feat/presentation/view'));
      expect(dirs, contains('/lib/feat/presentation/widgets'));
      expect(dirs, contains('/test/feat/presentation/view_model'));
    });
  });

  group('featureFiles', () {
    test('generates init file with correct function name', () {
      final files = featureFiles('transaction_detail', '/base/transaction_detail');

      final initPath = '/base/transaction_detail/transaction_detail_init.dart';
      expect(files.containsKey(initPath), isTrue);
      expect(files[initPath], contains('transactionDetailInit'));
      expect(files[initPath], contains('GetIt'));
    });

    test('generates failure class with PascalCase name', () {
      final files = featureFiles('transaction_detail', '/base/transaction_detail');

      final failurePath =
          '/base/transaction_detail/domain/failures/transaction_detail_failure.dart';
      expect(files.containsKey(failurePath), isTrue);
      expect(files[failurePath], contains('TransactionDetailFailure'));
      expect(files[failurePath], contains('TransactionDetailNetworkFailure'));
    });

    test('generates repository contract and implementation', () {
      final files = featureFiles('my_feature', '/base/my_feature');

      final repoPath = '/base/my_feature/domain/repositories/my_feature_repository.dart';
      final implPath = '/base/my_feature/data/repositories/my_feature_repository_impl.dart';

      expect(files.containsKey(repoPath), isTrue);
      expect(files[repoPath], contains('MyFeatureRepository'));

      expect(files.containsKey(implPath), isTrue);
      expect(files[implPath], contains('MyFeatureRepositoryImpl'));
      expect(files[implPath], contains('implements MyFeatureRepository'));
    });
  });

  group('generate_feature_structure end-to-end', () {
    test('creates directories and files on disk', () {
      final featureDir = '$flutterRoot/lib/src/features/detail';
      final testDir = '$flutterRoot/test/features/detail';

      final dirs = featureDirectories(featureDir, testDir);
      final files = featureFiles('detail', featureDir);

      for (final dir in dirs) {
        Directory(dir).createSync(recursive: true);
      }
      for (final entry in files.entries) {
        File(entry.key).writeAsStringSync(entry.value);
      }

      expect(
        Directory('$featureDir/data/datasources').existsSync(),
        isTrue,
      );
      expect(
        Directory('$featureDir/domain/use_cases').existsSync(),
        isTrue,
      );
      expect(
        File('$featureDir/detail_init.dart').existsSync(),
        isTrue,
      );
      expect(
        File('$featureDir/domain/failures/detail_failure.dart').existsSync(),
        isTrue,
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // Generation Tools — Cubit Test
  // ═══════════════════════════════════════════════════════════════════════

  group('analyzeCubit', () {
    test('extracts cubit and state class names', () {
      final analysis = analyzeCubit(_sampleCubitSource);

      expect(analysis, isNotNull);
      expect(analysis!.cubitName, 'SampleCubit');
      expect(analysis.stateName, 'SampleState');
    });

    test('extracts constructor dependencies', () {
      final analysis = analyzeCubit(_sampleCubitSource)!;

      expect(analysis.constructorParams, hasLength(1));
      expect(analysis.constructorParams.first.type, 'GetDataUseCase');
      expect(analysis.constructorParams.first.name, '_getDataUseCase');
    });

    test('extracts public methods', () {
      final analysis = analyzeCubit(_sampleCubitSource)!;

      final methodNames = analysis.publicMethods.map((m) => m.name).toList();
      expect(methodNames, contains('loadData'));
      expect(methodNames, contains('onRefresh'));
      expect(methodNames, contains('submitForm'));
      // Should NOT contain private methods
      expect(methodNames, isNot(contains('_handleResult')));
    });

    test('identifies async and return types', () {
      final analysis = analyzeCubit(_sampleCubitSource)!;

      final loadData = analysis.publicMethods.firstWhere((m) => m.name == 'loadData');
      expect(loadData.isAsync, isTrue);
      expect(loadData.returnsBool, isFalse);

      final submitForm = analysis.publicMethods.firstWhere((m) => m.name == 'submitForm');
      expect(submitForm.isAsync, isTrue);
      expect(submitForm.returnsBool, isTrue);

      final onRefresh = analysis.publicMethods.firstWhere((m) => m.name == 'onRefresh');
      expect(onRefresh.isAsync, isFalse);
    });

    test('returns null for non-cubit class', () {
      final analysis = analyzeCubit('class NotACubit { }');
      expect(analysis, isNull);
    });
  });

  group('generateCubitTest', () {
    test('produces test scaffold with imports and groups', () {
      final analysis = analyzeCubit(_sampleCubitSource)!;
      final code = generateCubitTest(
        analysis: analysis,
        cubitImportPath: 'src/features/sample/presentation/view_model/sample/sample_cubit.dart',
        packageName: 'test_app',
      );

      expect(code, contains("import 'package:test_app/"));
      expect(code, contains('sample_state.dart'));
      expect(code, contains("group('SampleCubit'"));
      expect(code, contains("test('loadData"));
      expect(code, contains("test('submitForm"));
      expect(code, contains('happy path'));
      expect(code, contains('error path'));
    });

    test('includes all public methods as test cases', () {
      final analysis = analyzeCubit(_sampleCubitSource)!;
      final code = generateCubitTest(
        analysis: analysis,
        cubitImportPath: 'src/sample_cubit.dart',
        packageName: 'app',
      );

      // 3 public methods × 2 paths (happy + error) = 6 test blocks
      expect('test('.allMatches(code).length, equals(6));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // String Utilities
  // ═══════════════════════════════════════════════════════════════════════

  group('snakeToPascal', () {
    test('converts snake_case to PascalCase', () {
      expect(snakeToPascal('transaction_detail'), 'TransactionDetail');
      expect(snakeToPascal('dashboard'), 'Dashboard');
      expect(snakeToPascal('my_long_feature_name'), 'MyLongFeatureName');
    });
  });

  group('pascalToSnake', () {
    test('converts PascalCase to snake_case', () {
      expect(pascalToSnake('SampleCubit'), 'sample_cubit');
      expect(pascalToSnake('DashboardState'), 'dashboard_state');
    });
  });

  group('readPackageName', () {
    test('reads name from pubspec.yaml', () {
      final name = readPackageName(flutterRoot);
      expect(name, 'test_app');
    });

    test('returns default when pubspec missing', () {
      final name = readPackageName('${tempDir.path}/nonexistent');
      expect(name, 'financial_health_dashboard');
    });
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// Test fixtures
// ═══════════════════════════════════════════════════════════════════════════

const _sampleCubitSource = '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/src/features/sample/domain/use_cases/get_data_use_case.dart';
import 'sample_state.dart';

class SampleCubit extends Cubit<SampleState> {
  SampleCubit(this._getDataUseCase) : super(SampleState.initial());

  final GetDataUseCase _getDataUseCase;

  Future<void> loadData() async {
    emit(state.copyWith(status: SampleStatus.loading));
    final result = await _getDataUseCase();
    _handleResult(result);
  }

  void _handleResult(dynamic result) {
    emit(state.copyWith(status: SampleStatus.success));
  }

  void onRefresh() {
    emit(state.copyWith(status: SampleStatus.loading));
  }

  Future<bool> submitForm(String value) async {
    return true;
  }
}
''';
