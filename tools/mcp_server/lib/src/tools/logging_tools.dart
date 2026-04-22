import 'dart:io';

import 'package:mcp_dart/mcp_dart.dart';
import 'package:mcp_server/src/doc_paths.dart';

/// Registers tools that append structured entries to IA documentation files.
///
/// Tools:
///   - `log_interaction`  → adds an entry to prompt_log.md
///   - `add_learning`     → adds an entry to learnings.md
void registerLoggingTools(McpServer server, {required String docsPath}) {
  // ── log_interaction ──────────────────────────────────────────────────
  server.registerTool(
    'log_interaction',
    description: 'Appends a new entry to the AI prompt log (prompt_log.md). '
        'Call this after every significant AI decision to maintain the '
        'project audit trail. Returns the formatted entry that was added.',
    inputSchema: ToolInputSchema(
      properties: {
        'date': JsonSchema.string(
          description: 'Date in YYYY-MM-DD format',
        ),
        'title': JsonSchema.string(
          description: 'Short title describing the interaction',
        ),
        'prompt': JsonSchema.string(
          description: 'The user prompt or request summary',
        ),
        'decision': JsonSchema.string(
          description: 'The architectural/implementation decision made',
        ),
        'trade_offs': JsonSchema.string(
          description: 'Trade-offs considered and rationale',
        ),
        'result': JsonSchema.string(
          description: 'Outcome: what was implemented and validated',
        ),
      },
      required: ['date', 'title', 'prompt', 'decision', 'trade_offs', 'result'],
    ),
    callback: (args, extra) async {
      final date = args['date'] as String;
      final title = args['title'] as String;
      final prompt = args['prompt'] as String;
      final decision = args['decision'] as String;
      final tradeOffs = args['trade_offs'] as String;
      final result = args['result'] as String;

      final logFile = DocPaths.resolve(docsPath, DocPaths.promptLog);
      final nextIndex = nextEntryIndex(logFile, r'### \d+\.');

      final entry = '''

### $nextIndex. $title ($date)

**Prompt:** $prompt

**Decisão:** $decision

**Trade-offs:** $tradeOffs

**Resultado:** $result''';

      logFile.writeAsStringSync(entry, mode: FileMode.append);

      return CallToolResult(
        content: [
          TextContent(
              text: 'Entry #$nextIndex added to prompt_log.md:\n$entry'),
        ],
      );
    },
  );

  // ── add_learning ─────────────────────────────────────────────────────
  server.registerTool(
    'add_learning',
    description:
        'Records a new mistake/learning in learnings.md. Call this whenever '
        'an error pattern is identified. Each learning includes root cause '
        'and prevention steps so the same mistake is not repeated.',
    inputSchema: ToolInputSchema(
      properties: {
        'date': JsonSchema.string(
          description: 'Date in YYYY-MM-DD format',
        ),
        'title': JsonSchema.string(
          description: 'Short title for the learning',
        ),
        'root_cause': JsonSchema.string(
          description: 'What caused the issue',
        ),
        'prevention': JsonSchema.string(
          description: 'How to prevent it in the future',
        ),
      },
      required: ['date', 'title', 'root_cause', 'prevention'],
    ),
    callback: (args, extra) async {
      final date = args['date'] as String;
      final title = args['title'] as String;
      final rootCause = args['root_cause'] as String;
      final prevention = args['prevention'] as String;

      final learningsFile = DocPaths.resolve(docsPath, DocPaths.learnings);
      final nextIndex = nextEntryIndex(learningsFile, r'### \d+\.');

      final entry = '''

### $nextIndex. $title | $date

**Causa raiz:** $rootCause

**Prevenção:** $prevention''';

      learningsFile.writeAsStringSync(entry, mode: FileMode.append);

      return CallToolResult(
        content: [
          TextContent(
              text: 'Learning #$nextIndex added to learnings.md:\n$entry'),
        ],
      );
    },
  );
}

// ── helpers ──────────────────────────────────────────────────────────────

/// Finds the next entry index by counting existing `### N.` headers.
int nextEntryIndex(File file, String pattern) {
  if (!file.existsSync()) return 1;
  final content = file.readAsStringSync();
  final matches = RegExp(pattern).allMatches(content);
  return matches.length + 1;
}
