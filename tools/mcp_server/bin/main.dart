import 'dart:io';

import 'package:mcp_dart/mcp_dart.dart';

import '../lib/src/tools/context_tools.dart';
import '../lib/src/tools/generation_tools.dart';
import '../lib/src/tools/logging_tools.dart';

Future<void> main(List<String> arguments) async {
  final projectRoot = _resolveProjectRoot(arguments);

  final docsPath = '$projectRoot/docs';
  final flutterRoot = '$projectRoot/financial_health_dashboard';

  if (!Directory(docsPath).existsSync()) {
    stderr.writeln('docs/ not found at $docsPath');
    exit(1);
  }

  final server = McpServer(
    Implementation(name: 'financial-health-mcp', version: '1.0.0'),
    options: McpServerOptions(
      capabilities: ServerCapabilities(
        tools: ServerCapabilitiesTools(),
      ),
    ),
  );

  registerContextTools(server, docsPath: docsPath);
  registerLoggingTools(server, docsPath: docsPath);
  registerGenerationTools(server, flutterRoot: flutterRoot);

  final transport = StdioServerTransport();
  await server.connect(transport);
}

String _resolveProjectRoot(List<String> arguments) {
  // 1. Explicit argument: --project-root /path
  for (var i = 0; i < arguments.length - 1; i++) {
    if (arguments[i] == '--project-root') return arguments[i + 1];
  }

  // 2. Environment variable
  final env = Platform.environment['PROJECT_ROOT'];
  if (env != null && env.isNotEmpty) return env;

  // 3. Default: two levels up from tools/mcp_server/
  return '${Directory.current.path}/../..';
}
