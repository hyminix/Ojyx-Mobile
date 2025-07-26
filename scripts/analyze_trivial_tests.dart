import 'dart:io';

void main() async {
  final testFiles = await findTestFiles();
  final trivialTests = <String, List<String>>{};

  for (final file in testFiles) {
    final content = await File(file).readAsString();
    final issues = analyzeTrivialPatterns(file, content);
    if (issues.isNotEmpty) {
      trivialTests[file] = issues;
    }
  }

  printReport(trivialTests);
}

Future<List<String>> findTestFiles() async {
  final result = await Process.run('find', [
    'test',
    '-name',
    '*_test.dart',
    '-type',
    'f',
  ]);
  return result.stdout
      .toString()
      .trim()
      .split('\n')
      .where((f) => f.isNotEmpty)
      .toList();
}

List<String> analyzeTrivialPatterns(String filePath, String content) {
  final issues = <String>[];

  // Pattern 1: Tests with only null checks
  if (RegExp(r'expect\s*\(\s*\w+\s*,\s*isNotNull\s*\)\s*;').hasMatch(content) &&
          !content.contains('expect(') ||
      RegExp(
            r'expect\s*\(\s*\w+\s*,\s*isNotNull\s*\)\s*;',
          ).allMatches(content).length >
          5) {
    issues.add('Excessive isNotNull checks');
  }

  // Pattern 2: Tests that only check types
  if (RegExp(
            r'expect\s*\(\s*\w+\s*,\s*isA<[^>]+>\(\)\s*\)\s*;',
          ).hasMatch(content) &&
          !content.contains('expect(') ||
      RegExp(
            r'expect\s*\(\s*\w+\s*,\s*isA<[^>]+>\(\)\s*\)\s*;',
          ).allMatches(content).length >
          3) {
    issues.add('Tests only checking types');
  }

  // Pattern 3: Empty test groups
  if (RegExp(r'group\s*\([^)]+\)\s*\{\s*\}\s*;?').hasMatch(content)) {
    issues.add('Empty test groups');
  }

  // Pattern 4: Tests without assertions
  final testBlocks = RegExp(r'test\s*\([^{]+\{[^}]+\}').allMatches(content);
  for (final block in testBlocks) {
    if (!block.group(0)!.contains('expect') &&
        !block.group(0)!.contains('verify') &&
        !block.group(0)!.contains('assert')) {
      issues.add('Test without assertions');
      break;
    }
  }

  // Pattern 5: Very small test files (less than 30 lines)
  final lineCount = content.split('\n').length;
  if (lineCount < 30 && !filePath.contains('migration')) {
    issues.add('Very small test file ($lineCount lines)');
  }

  // Pattern 6: Migration tests (now obsolete)
  if (filePath.contains('migration_test') || filePath.contains('_v2_test')) {
    issues.add('Obsolete migration test');
  }

  return issues;
}

void printReport(Map<String, List<String>> trivialTests) {
  print('=== Trivial Tests Analysis Report ===\n');
  print('Found ${trivialTests.length} files with potential issues:\n');

  trivialTests.forEach((file, issues) {
    print('$file:');
    for (final issue in issues) {
      print('  - $issue');
    }
    print('');
  });

  print('\nRecommendations:');
  print('- Remove empty test files and groups');
  print('- Combine small test files with related tests');
  print('- Add meaningful assertions to tests');
  print('- Remove obsolete migration tests');
}
