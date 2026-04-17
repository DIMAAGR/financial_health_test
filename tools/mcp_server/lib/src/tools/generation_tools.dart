import 'dart:io';

import 'package:mcp_dart/mcp_dart.dart';
import 'package:path/path.dart' as p;

/// Registers tools that automate code scaffolding.
///
/// Tools:
///   - `generate_feature_structure`  → creates feature folder hierarchy
///   - `generate_cubit_test`         → generates test from a cubit source file
void registerGenerationTools(McpServer server, {required String flutterRoot}) {
  // ── generate_feature_structure ───────────────────────────────────────
  server.registerTool(
    'generate_feature_structure',
    description: 'Scaffolds the full folder hierarchy for a new feature following '
        'the project architecture: data (datasources, models, repositories), '
        'domain (entities, enum, failures, policies, repositories, use_cases), '
        'and presentation (mappers, models, view, view_model, widgets). '
        'Also generates the feature init file and a base failure class.',
    inputSchema: ToolInputSchema(
      properties: {
        'feature_name': JsonSchema.string(
          description: 'Snake_case name of the feature (e.g. "transaction_detail")',
        ),
        'dry_run': JsonSchema.boolean(
          description: 'If true, returns what would be created without '
              'creating files. Defaults to false.',
        ),
      },
      required: ['feature_name'],
    ),
    callback: (args, extra) async {
      final featureName = args['feature_name'] as String;
      final dryRun = args['dry_run'] as bool? ?? false;

      final featureDir = '$flutterRoot/lib/src/features/$featureName';
      final testDir = '$flutterRoot/test/features/$featureName';

      final dirs = featureDirectories(featureDir, testDir);
      final files = featureFiles(featureName, featureDir);

      if (dryRun) {
        final dirList = dirs.map((d) => '  📁 ${p.relative(d, from: flutterRoot)}').join('\n');
        final fileList =
            files.keys.map((f) => '  📄 ${p.relative(f, from: flutterRoot)}').join('\n');
        return CallToolResult(
          content: [
            TextContent(
              text: '# Dry Run — feature "$featureName"\n\n'
                  '## Directories:\n$dirList\n\n'
                  '## Files:\n$fileList',
            ),
          ],
        );
      }

      // Create directories
      for (final dir in dirs) {
        Directory(dir).createSync(recursive: true);
      }

      // Create files (only if they don't exist)
      var created = 0;
      var skipped = 0;
      for (final entry in files.entries) {
        final file = File(entry.key);
        if (file.existsSync()) {
          skipped++;
        } else {
          file.writeAsStringSync(entry.value);
          created++;
        }
      }

      return CallToolResult(
        content: [
          TextContent(
            text: '✅ Feature "$featureName" scaffolded.\n'
                '   Created: $created files, ${dirs.length} directories\n'
                '   Skipped: $skipped files (already existed)',
          ),
        ],
      );
    },
  );

  // ── generate_cubit_test ──────────────────────────────────────────────
  server.registerTool(
    'generate_cubit_test',
    description: 'Reads a Cubit source file and generates a complete test scaffold '
        'following the project patterns: fake dependencies, group structure, '
        'AAA pattern, and one test per public method. '
        'Returns the generated test code as text.',
    inputSchema: ToolInputSchema(
      properties: {
        'cubit_file_path': JsonSchema.string(
          description: 'Path to the cubit .dart file, relative to the Flutter project root '
              '(e.g. "lib/src/features/dashboard/presentation/view_model/dashboard/dashboard_cubit.dart")',
        ),
      },
      required: ['cubit_file_path'],
    ),
    callback: (args, extra) async {
      final relativePath = args['cubit_file_path'] as String;
      final absolutePath = '$flutterRoot/$relativePath';
      final file = File(absolutePath);

      if (!file.existsSync()) {
        return CallToolResult(
          isError: true,
          content: [TextContent(text: 'File not found: $absolutePath')],
        );
      }

      final content = file.readAsStringSync();
      final analysis = analyzeCubit(content);

      if (analysis == null) {
        return CallToolResult(
          isError: true,
          content: [
            TextContent(
              text: 'Could not parse a Cubit class from the file. '
                  'Expected: class XxxCubit extends Cubit<XxxState>',
            ),
          ],
        );
      }

      final testCode = generateCubitTest(
        analysis: analysis,
        cubitImportPath: relativePath.replaceFirst('lib/', ''),
        packageName: readPackageName(flutterRoot),
      );

      // Suggest output path
      final suggestedPath =
          relativePath.replaceFirst('lib/src/', 'test/').replaceFirst('.dart', '_test.dart');

      return CallToolResult(
        content: [
          TextContent(
            text: '# Generated test for ${analysis.cubitName}\n\n'
                'Suggested path: `$suggestedPath`\n\n'
                '```dart\n$testCode\n```',
          ),
        ],
      );
    },
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// Feature structure generation
// ═══════════════════════════════════════════════════════════════════════════

List<String> featureDirectories(String featureDir, String testDir) {
  final subDirs = [
    'data/datasources',
    'data/models',
    'data/repositories',
    'domain/entities',
    'domain/enum',
    'domain/failures',
    'domain/policies',
    'domain/repositories',
    'domain/use_cases',
    'presentation/mappers',
    'presentation/models',
    'presentation/view',
    'presentation/view_model',
    'presentation/widgets',
  ];

  final testSubDirs = [
    'data/datasources',
    'data/models',
    'data/repositories',
    'domain/entities',
    'domain/policies',
    'domain/use_cases',
    'presentation/view',
    'presentation/view_model',
    'presentation/widgets',
  ];

  return [
    ...subDirs.map((d) => '$featureDir/$d'),
    ...testSubDirs.map((d) => '$testDir/$d'),
  ];
}

Map<String, String> featureFiles(String featureName, String featureDir) {
  final className = snakeToPascal(featureName);

  return {
    // Feature init (DI registration)
    '$featureDir/${featureName}_init.dart': '''
import 'package:get_it/get_it.dart';

void ${snakeToCamel(featureName)}Init(GetIt i) {
  // Register datasources, repositories, use cases, and cubits here.
}
''',

    // Failure base class
    '$featureDir/domain/failures/${featureName}_failure.dart': '''
class ${className}Failure {
  const ${className}Failure(this.message);
  final String message;

  @override
  String toString() => '${className}Failure(\$message)';
}

class ${className}NetworkFailure extends ${className}Failure {
  const ${className}NetworkFailure(super.message);
}

class ${className}ServerFailure extends ${className}Failure {
  const ${className}ServerFailure(super.message);
}
''',

    // Repository contract
    '$featureDir/domain/repositories/${featureName}_repository.dart': '''
abstract interface class ${className}Repository {
  // Define repository contract methods here.
}
''',

    // Repository implementation
    '$featureDir/data/repositories/${featureName}_repository_impl.dart': '''
import '../../domain/repositories/${featureName}_repository.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  const ${className}RepositoryImpl();

  // Implement repository methods here.
}
''',

    // Datasource contract + implementation
    '$featureDir/data/datasources/${featureName}_remote_data_source.dart': '''
abstract interface class ${className}RemoteDataSource {
  // Define datasource methods here.
}

class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  const ${className}RemoteDataSourceImpl();

  // Implement datasource methods here.
}
''',
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// Cubit test generation
// ═══════════════════════════════════════════════════════════════════════════

class CubitAnalysis {
  CubitAnalysis({
    required this.cubitName,
    required this.stateName,
    required this.constructorParams,
    required this.publicMethods,
    required this.imports,
  });

  final String cubitName;
  final String stateName;
  final List<CtorParam> constructorParams;
  final List<PublicMethod> publicMethods;
  final List<String> imports;
}

class CtorParam {
  CtorParam({required this.type, required this.name});
  final String type;
  final String name;
}

class PublicMethod {
  PublicMethod({
    required this.name,
    required this.returnType,
    required this.params,
  });

  final String name;
  final String returnType;
  final String params;

  bool get isAsync => returnType.startsWith('Future');
  bool get returnsBool => returnType == 'Future<bool>' || returnType == 'bool';
}

CubitAnalysis? analyzeCubit(String content) {
  // 1. Extract class declaration
  final classRe = RegExp(r'class\s+(\w+)\s+extends\s+Cubit<(\w+)>');
  final classMatch = classRe.firstMatch(content);
  if (classMatch == null) return null;

  final cubitName = classMatch.group(1)!;
  final stateName = classMatch.group(2)!;

  // 2. Extract constructor parameters
  final ctorRe = RegExp(
    '$cubitName\\(([^)]*?)\\)',
    dotAll: true,
  );
  final ctorMatch = ctorRe.firstMatch(content);
  final ctorParams = <CtorParam>[];

  if (ctorMatch != null) {
    final paramsStr = ctorMatch.group(1)!;
    // Match `this._fieldName` or `Type name`
    final paramRe = RegExp(r'this\.(_\w+)');
    for (final m in paramRe.allMatches(paramsStr)) {
      final fieldName = m.group(1)!;
      // Find the field declaration to get the type
      final fieldRe = RegExp('final\\s+(\\w+)\\s+$fieldName;');
      final fieldMatch = fieldRe.firstMatch(content);
      final type = fieldMatch?.group(1) ?? 'dynamic';
      ctorParams.add(CtorParam(type: type, name: fieldName));
    }
  }

  // 3. Extract public methods (not starting with _)
  final methodRe = RegExp(
    r'(Future<[\w<>,\s]+>|void|bool|int|double|String)\s+([a-z]\w*)\s*\(([^)]*)\)\s*(async\s*)?{',
  );
  final publicMethods = <PublicMethod>[];
  for (final m in methodRe.allMatches(content)) {
    final methodName = m.group(2)!;
    if (methodName.startsWith('_')) continue;
    publicMethods.add(PublicMethod(
      name: methodName,
      returnType: m.group(1)!.replaceAll(RegExp(r'\s+'), ''),
      params: m.group(3)!.trim(),
    ));
  }

  // 4. Extract imports
  final importRe = RegExp(r"^import\s+'([^']+)';", multiLine: true);
  final imports = importRe.allMatches(content).map((m) => m.group(1)!).toList();

  return CubitAnalysis(
    cubitName: cubitName,
    stateName: stateName,
    constructorParams: ctorParams,
    publicMethods: publicMethods,
    imports: imports,
  );
}

String generateCubitTest({
  required CubitAnalysis analysis,
  required String cubitImportPath,
  required String packageName,
}) {
  final buf = StringBuffer();

  // Imports
  buf.writeln("import 'package:$packageName/$cubitImportPath';");

  // Add state import (infer from cubit import path)
  final stateImport = cubitImportPath.replaceFirst(
    '${pascalToSnake(analysis.cubitName)}.dart',
    '${pascalToSnake(analysis.stateName)}.dart',
  );
  buf.writeln("import 'package:$packageName/$stateImport';");

  // Import dependencies (use cases)
  for (final import in analysis.imports) {
    if (import.contains('use_case') || import.contains('entities')) {
      buf.writeln("import '$import';");
    }
  }
  buf.writeln("import 'package:flutter_test/flutter_test.dart';");
  buf.writeln();

  // Generate fake dependencies
  if (analysis.constructorParams.isNotEmpty) {
    buf.writeln('// TODO: Implement fake dependencies for testing');
    buf.writeln('// Suggested: create a _Fake class that implements the repository interface,');
    buf.writeln('// then inject use cases with the fake repository.');
    buf.writeln();
  }

  // Main test function
  buf.writeln('void main() {');
  buf.writeln("  group('${analysis.cubitName}', () {");

  // Helper to create cubit
  buf.writeln('    // TODO: Create a helper function to build the cubit with its dependencies');
  buf.writeln('    // Example:');
  buf.writeln('    // ${analysis.cubitName} _createCubit() {');
  buf.writeln('    //   final repo = _FakeRepository(/* ... */);');

  if (analysis.constructorParams.isNotEmpty) {
    buf.writeln('    //   return ${analysis.cubitName}(');
    for (final p in analysis.constructorParams) {
      buf.writeln('    //     ${p.type}(repo),');
    }
    buf.writeln('    //   );');
  } else {
    buf.writeln('    //   return ${analysis.cubitName}();');
  }
  buf.writeln('    // }');
  buf.writeln();

  // Generate a test for each public method
  for (final method in analysis.publicMethods) {
    final asyncPrefix = method.isAsync ? 'async ' : '';
    final awaitPrefix = method.isAsync ? 'await ' : '';

    buf.writeln("    test('${method.name} — happy path', () $asyncPrefix{");
    buf.writeln('      // Arrange');
    buf.writeln('      // final cubit = _createCubit();');
    buf.writeln();
    buf.writeln('      // Act');

    if (method.params.isNotEmpty) {
      buf.writeln('      // ${awaitPrefix}cubit.${method.name}(/* TODO: provide args */);');
    } else {
      buf.writeln('      // ${awaitPrefix}cubit.${method.name}();');
    }

    buf.writeln();
    buf.writeln('      // Assert');

    if (method.returnsBool) {
      buf.writeln('      // expect(result, isTrue);');
    }
    buf.writeln('      // expect(cubit.state.status, /* expected status */);');
    buf.writeln();
    buf.writeln('      // await cubit.close();');
    buf.writeln('    });');
    buf.writeln();

    // Error path test
    buf.writeln("    test('${method.name} — error path', () $asyncPrefix{");
    buf.writeln('      // Arrange — configure dependency to return failure');
    buf.writeln('      // final cubit = _createCubit();');
    buf.writeln();
    buf.writeln('      // Act');

    if (method.params.isNotEmpty) {
      buf.writeln('      // ${awaitPrefix}cubit.${method.name}(/* TODO: provide args */);');
    } else {
      buf.writeln('      // ${awaitPrefix}cubit.${method.name}();');
    }

    buf.writeln();
    buf.writeln('      // Assert');

    if (method.returnsBool) {
      buf.writeln('      // expect(result, isFalse);');
    }
    buf.writeln('      // expect(cubit.state.status, /* error status */);');
    buf.writeln();
    buf.writeln('      // await cubit.close();');
    buf.writeln('    });');
    buf.writeln();
  }

  buf.writeln('  });');
  buf.writeln('}');

  return buf.toString();
}

// ═══════════════════════════════════════════════════════════════════════════
// String utilities
// ═══════════════════════════════════════════════════════════════════════════

String snakeToPascal(String s) =>
    s.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join();

String snakeToCamel(String s) {
  final pascal = snakeToPascal(s);
  return pascal[0].toLowerCase() + pascal.substring(1);
}

String pascalToSnake(String s) => s
    .replaceAllMapped(
      RegExp(r'[A-Z]'),
      (m) => '_${m.group(0)!.toLowerCase()}',
    )
    .substring(1); // remove leading underscore

String readPackageName(String flutterRoot) {
  final pubspec = File('$flutterRoot/pubspec.yaml');
  if (!pubspec.existsSync()) return 'financial_health_dashboard';
  final content = pubspec.readAsStringSync();
  final match = RegExp(r'^name:\s*(\S+)', multiLine: true).firstMatch(content);
  return match?.group(1) ?? 'financial_health_dashboard';
}
