import 'dart:io';

abstract final class DocPaths {
  static const architecture = 'architecture/architecture.md';
  static const iaInProcess = 'architecture/ia_in_process.md';
  static const rules = 'ia/rules.md';
  static const guardrails = 'ia/guardrails.toon';
  static const learnings = 'ia/learnings.md';
  static const promptLog = 'ia/prompt_log.md';

  static File resolve(String docsPath, String relativePath) {
    return File('$docsPath/$relativePath');
  }
}
