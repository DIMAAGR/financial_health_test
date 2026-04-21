import 'package:mcp_dart/mcp_dart.dart';
import 'package:mcp_server/src/doc_paths.dart';

/// Registers tools that provide read-only access to project documentation.
///
/// Tools:
///   - `get_project_context`  → architecture + conventions
///   - `get_rules`            → IA governance rules + TOON guardrails
///   - `get_learnings`        → documented mistakes and prevention patterns
///   - `search_prompt_log`    → search past AI interaction entries
void registerContextTools(McpServer server, {required String docsPath}) {
  // ── get_project_context ──────────────────────────────────────────────
  server.registerTool(
    'get_project_context',
    description:
        'Returns the full project architecture documentation including '
        'folder conventions, state management rules, DI setup, '
        'and design trade-offs. Use this before making any structural change.',
    annotations: ToolAnnotations(readOnlyHint: true),
    inputSchema: ToolInputSchema(properties: {}),
    callback: (args, extra) async {
      final architecture = readDoc(docsPath, DocPaths.architecture);
      final iaProcess = readDoc(docsPath, DocPaths.iaInProcess);

      return CallToolResult(
        content: [
          TextContent(
            text: '# Project Architecture\n\n$architecture'
                '\n\n---\n\n# IA in Development Process\n\n$iaProcess',
          ),
        ],
      );
    },
  );

  // ── get_rules ────────────────────────────────────────────────────────
  server.registerTool(
    'get_rules',
    description: 'Returns the IA governance rules for this project. '
        'Includes mandatory logging rules, TDD rules, widget creation '
        'rules, architectural guardrails, and the pre-implementation checklist.',
    annotations: ToolAnnotations(readOnlyHint: true),
    inputSchema: ToolInputSchema(properties: {}),
    callback: (args, extra) async {
      final rules = buildRulesContext(docsPath);
      return CallToolResult(content: [TextContent(text: rules)]);
    },
  );

  // ── get_learnings ────────────────────────────────────────────────────
  server.registerTool(
    'get_learnings',
    description:
        'Returns all documented mistakes and lessons learned from past '
        'AI interactions. Each entry has root cause and prevention steps. '
        'Check this BEFORE implementing to avoid known pitfalls.',
    annotations: ToolAnnotations(readOnlyHint: true),
    inputSchema: ToolInputSchema(properties: {}),
    callback: (args, extra) async {
      final learnings = readDoc(docsPath, DocPaths.learnings);
      return CallToolResult(content: [TextContent(text: learnings)]);
    },
  );

  // ── search_prompt_log ────────────────────────────────────────────────
  server.registerTool(
    'search_prompt_log',
    description: 'Searches the AI prompt log for entries matching a query. '
        'Returns matching entries with their full context (decision, '
        'trade-offs, result). Useful for finding past decisions about '
        'a specific topic.',
    annotations: ToolAnnotations(readOnlyHint: true),
    inputSchema: ToolInputSchema(
      properties: {
        'query': JsonSchema.string(
          description: 'Search term to look for in prompt log entries',
        ),
      },
      required: ['query'],
    ),
    callback: (args, extra) async {
      final query = (args['query'] as String).toLowerCase();
      final content = readDoc(docsPath, DocPaths.promptLog);

      final entries = splitLogEntries(content);
      final matches =
          entries.where((e) => e.toLowerCase().contains(query)).toList();

      if (matches.isEmpty) {
        return CallToolResult(
          content: [
            TextContent(text: 'No entries found matching "$query".'),
          ],
        );
      }

      return CallToolResult(
        content: [
          TextContent(
            text: '# Prompt Log — ${matches.length} match(es) for "$query"'
                '\n\n${matches.join('\n\n---\n\n')}',
          ),
        ],
      );
    },
  );
}

// ── helpers ──────────────────────────────────────────────────────────────

String readDoc(String docsPath, String relativePath) {
  final file = DocPaths.resolve(docsPath, relativePath);
  if (!file.existsSync()) return '⚠ File not found: $relativePath';
  return file.readAsStringSync();
}

String buildRulesContext(String docsPath) {
  final rules = readDoc(docsPath, DocPaths.rules);
  final guardrails = readDoc(docsPath, DocPaths.guardrails);

  return '# IA Governance Rules\n\n$rules'
      '\n\n---\n\n# AI Operational Guardrails (TOON)\n\n```toon\n$guardrails\n```';
}

/// Splits prompt_log.md into individual entries (each starts with `### `).
List<String> splitLogEntries(String content) {
  final lines = content.split('\n');
  final entries = <String>[];
  final buffer = StringBuffer();

  for (final line in lines) {
    if (line.startsWith('### ') && buffer.isNotEmpty) {
      final text = buffer.toString().trim();
      if (text.startsWith('### ')) entries.add(text);
      buffer.clear();
    }
    buffer.writeln(line);
  }

  if (buffer.isNotEmpty) {
    final text = buffer.toString().trim();
    if (text.startsWith('### ')) entries.add(text);
  }

  return entries;
}
