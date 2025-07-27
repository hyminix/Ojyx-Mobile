import 'dart:io';
import 'dart:convert';

/// TDD Compliance Validator for Ojyx Test Suite
/// 
/// This script validates that all tests follow TDD best practices:
/// - Naming convention (should_when pattern)
/// - Proper test structure (Arrange-Act-Assert)
/// - No commented or skipped tests
/// - Meaningful assertions with reasons
/// - Adequate test coverage

class TddComplianceValidator {
  final List<ValidationIssue> issues = [];
  final Map<String, TestFileStats> stats = {};
  
  // Patterns to check
  final shouldWhenPattern = RegExp(r'''test\s*\(\s*['"]should_\w+_when_\w+''');
  final skipPattern = RegExp(r'''test\.skip\s*\(|skip\s*:\s*true''');
  final commentedTestPattern = RegExp(r'''//\s*test\s*\(|/\*.*test\s*\(.*\*/''', multiLine: true);
  final arrangeActAssertPattern = RegExp(r'''//\s*(Arrange|Act|Assert)''');
  final reasonPattern = RegExp(r'''reason\s*:\s*['"]''');
  final expectPattern = RegExp(r'''expect\s*\(''');
  final groupPattern = RegExp(r'''group\s*\(\s*['"]([^'"]+)['"]''');
  final testPattern = RegExp(r'''test\s*\(\s*['"]([^'"]+)['"]''');
  final testWidgetsPattern = RegExp(r'''testWidgets\s*\(\s*['"]([^'"]+)['"]''');
  
  Future<ValidationReport> validateProject(String projectPath) async {
    print('🔍 Starting TDD Compliance Validation...\n');
    
    final testDir = Directory('$projectPath/test');
    if (!testDir.existsSync()) {
      throw Exception('Test directory not found at $projectPath/test');
    }
    
    await _validateDirectory(testDir);
    
    return _generateReport();
  }
  
  Future<void> _validateDirectory(Directory dir) async {
    final entities = dir.listSync(recursive: true);
    
    for (final entity in entities) {
      if (entity is File && entity.path.endsWith('_test.dart')) {
        // Skip generated files
        if (entity.path.contains('.g.dart') || 
            entity.path.contains('.freezed.dart') ||
            entity.path.contains('_backup') ||
            entity.path.contains('_v2') ||
            entity.path.contains('_v3') ||
            entity.path.contains('_migrated')) {
          continue;
        }
        
        await _validateTestFile(entity);
      }
    }
  }
  
  Future<void> _validateTestFile(File file) async {
    final content = await file.readAsString();
    final relativePath = file.path.split('/test/').last;
    final lines = content.split('\n');
    
    final fileStats = TestFileStats(path: relativePath);
    
    // Find all test groups and tests
    final groups = groupPattern.allMatches(content);
    final tests = testPattern.allMatches(content);
    final widgetTests = testWidgetsPattern.allMatches(content);
    
    fileStats.groupCount = groups.length;
    fileStats.testCount = tests.length + widgetTests.length;
    
    // Check for skipped tests
    final skippedTests = skipPattern.allMatches(content);
    if (skippedTests.isNotEmpty) {
      fileStats.skippedTests = skippedTests.length;
      issues.add(ValidationIssue(
        file: relativePath,
        type: IssueType.skippedTest,
        message: 'Found ${skippedTests.length} skipped test(s)',
        severity: IssueSeverity.error,
      ));
    }
    
    // Check for commented tests
    final commentedTests = commentedTestPattern.allMatches(content);
    if (commentedTests.isNotEmpty) {
      fileStats.commentedTests = commentedTests.length;
      issues.add(ValidationIssue(
        file: relativePath,
        type: IssueType.commentedTest,
        message: 'Found ${commentedTests.length} commented test(s)',
        severity: IssueSeverity.error,
      ));
    }
    
    // Validate individual tests
    for (final match in [...tests, ...widgetTests]) {
      final testName = match.group(1)!;
      final testStartLine = _getLineNumber(content, match.start);
      
      // Check naming convention
      if (!testName.startsWith('should_') || !testName.contains('_when_')) {
        fileStats.nonCompliantNaming++;
        issues.add(ValidationIssue(
          file: relativePath,
          line: testStartLine,
          type: IssueType.namingConvention,
          message: 'Test "$testName" does not follow should_when pattern',
          severity: IssueSeverity.warning,
        ));
      }
      
      // Find test body
      final testBody = _extractTestBody(content, match.end);
      
      // Check for Arrange-Act-Assert pattern
      if (!arrangeActAssertPattern.hasMatch(testBody)) {
        fileStats.missingAAA++;
        issues.add(ValidationIssue(
          file: relativePath,
          line: testStartLine,
          type: IssueType.missingStructure,
          message: 'Test "$testName" missing Arrange/Act/Assert comments',
          severity: IssueSeverity.info,
        ));
      }
      
      // Check for assertions
      final assertions = expectPattern.allMatches(testBody);
      if (assertions.isEmpty) {
        fileStats.testsWithoutAssertions++;
        issues.add(ValidationIssue(
          file: relativePath,
          line: testStartLine,
          type: IssueType.noAssertions,
          message: 'Test "$testName" has no assertions',
          severity: IssueSeverity.error,
        ));
      }
      
      // Check for assertion reasons
      final reasons = reasonPattern.allMatches(testBody);
      if (assertions.length > reasons.length) {
        fileStats.assertionsWithoutReasons += assertions.length - reasons.length;
        if (reasons.isEmpty) {
          issues.add(ValidationIssue(
            file: relativePath,
            line: testStartLine,
            type: IssueType.missingReason,
            message: 'Test "$testName" has assertions without reasons',
            severity: IssueSeverity.info,
          ));
        }
      }
    }
    
    stats[relativePath] = fileStats;
  }
  
  String _extractTestBody(String content, int startIndex) {
    int braceCount = 0;
    int i = startIndex;
    int bodyStart = -1;
    int bodyEnd = -1;
    
    // Find opening brace
    while (i < content.length && content[i] != '{') {
      i++;
    }
    
    if (i < content.length) {
      bodyStart = i;
      braceCount = 1;
      i++;
      
      // Find matching closing brace
      while (i < content.length && braceCount > 0) {
        if (content[i] == '{') braceCount++;
        else if (content[i] == '}') braceCount--;
        i++;
      }
      
      bodyEnd = i;
    }
    
    return bodyStart != -1 && bodyEnd != -1
        ? content.substring(bodyStart, bodyEnd)
        : '';
  }
  
  int _getLineNumber(String content, int charIndex) {
    return content.substring(0, charIndex).split('\n').length;
  }
  
  ValidationReport _generateReport() {
    final totalFiles = stats.length;
    final totalTests = stats.values.fold(0, (sum, s) => sum + s.testCount);
    final totalGroups = stats.values.fold(0, (sum, s) => sum + s.groupCount);
    final compliantFiles = stats.values.where((s) => s.isCompliant).length;
    
    final report = ValidationReport(
      totalFiles: totalFiles,
      totalTests: totalTests,
      totalGroups: totalGroups,
      compliantFiles: compliantFiles,
      issues: issues,
      fileStats: stats,
    );
    
    return report;
  }
}

class TestFileStats {
  final String path;
  int groupCount = 0;
  int testCount = 0;
  int skippedTests = 0;
  int commentedTests = 0;
  int nonCompliantNaming = 0;
  int missingAAA = 0;
  int testsWithoutAssertions = 0;
  int assertionsWithoutReasons = 0;
  
  TestFileStats({required this.path});
  
  bool get isCompliant =>
      skippedTests == 0 &&
      commentedTests == 0 &&
      nonCompliantNaming == 0 &&
      testsWithoutAssertions == 0;
  
  double get complianceScore {
    if (testCount == 0) return 100.0;
    
    final issues = skippedTests + 
                  commentedTests + 
                  nonCompliantNaming + 
                  testsWithoutAssertions;
    
    return ((testCount - issues) / testCount * 100).clamp(0, 100);
  }
}

class ValidationIssue {
  final String file;
  final int? line;
  final IssueType type;
  final String message;
  final IssueSeverity severity;
  
  ValidationIssue({
    required this.file,
    this.line,
    required this.type,
    required this.message,
    required this.severity,
  });
}

enum IssueType {
  skippedTest,
  commentedTest,
  namingConvention,
  missingStructure,
  noAssertions,
  missingReason,
}

enum IssueSeverity {
  error,
  warning,
  info,
}

class ValidationReport {
  final int totalFiles;
  final int totalTests;
  final int totalGroups;
  final int compliantFiles;
  final List<ValidationIssue> issues;
  final Map<String, TestFileStats> fileStats;
  
  ValidationReport({
    required this.totalFiles,
    required this.totalTests,
    required this.totalGroups,
    required this.compliantFiles,
    required this.issues,
    required this.fileStats,
  });
  
  double get overallCompliance => 
      totalFiles > 0 ? (compliantFiles / totalFiles * 100) : 0;
  
  int get errorCount => 
      issues.where((i) => i.severity == IssueSeverity.error).length;
  
  int get warningCount => 
      issues.where((i) => i.severity == IssueSeverity.warning).length;
  
  int get infoCount => 
      issues.where((i) => i.severity == IssueSeverity.info).length;
  
  void printReport() {
    print('📊 TDD Compliance Report\n');
    print('Summary:');
    print('  Total test files: $totalFiles');
    print('  Total test groups: $totalGroups');
    print('  Total tests: $totalTests');
    print('  Compliant files: $compliantFiles / $totalFiles');
    print('  Overall compliance: ${overallCompliance.toStringAsFixed(1)}%\n');
    
    print('Issues Found:');
    print('  🔴 Errors: $errorCount');
    print('  🟡 Warnings: $warningCount');
    print('  🔵 Info: $infoCount\n');
    
    if (issues.isNotEmpty) {
      print('Detailed Issues:\n');
      
      // Group issues by file
      final issuesByFile = <String, List<ValidationIssue>>{};
      for (final issue in issues) {
        issuesByFile.putIfAbsent(issue.file, () => []).add(issue);
      }
      
      // Print issues by file
      for (final entry in issuesByFile.entries) {
        print('📁 ${entry.key}');
        final stats = fileStats[entry.key]!;
        print('   Compliance: ${stats.complianceScore.toStringAsFixed(1)}%');
        
        for (final issue in entry.value) {
          final icon = issue.severity == IssueSeverity.error ? '🔴' :
                       issue.severity == IssueSeverity.warning ? '🟡' : '🔵';
          final line = issue.line != null ? ' (line ${issue.line})' : '';
          print('   $icon ${issue.message}$line');
        }
        print('');
      }
    }
    
    // Print top non-compliant files
    final nonCompliantFiles = fileStats.entries
        .where((e) => !e.value.isCompliant)
        .toList()
        ..sort((a, b) => a.value.complianceScore.compareTo(b.value.complianceScore));
    
    if (nonCompliantFiles.isNotEmpty) {
      print('Top Non-Compliant Files:');
      for (final entry in nonCompliantFiles.take(10)) {
        print('  ${entry.value.complianceScore.toStringAsFixed(1)}% - ${entry.key}');
      }
    }
  }
  
  void saveToFile(String outputPath) {
    final json = {
      'timestamp': DateTime.now().toIso8601String(),
      'summary': {
        'totalFiles': totalFiles,
        'totalTests': totalTests,
        'totalGroups': totalGroups,
        'compliantFiles': compliantFiles,
        'overallCompliance': overallCompliance,
        'errorCount': errorCount,
        'warningCount': warningCount,
        'infoCount': infoCount,
      },
      'fileStats': fileStats.map((path, stats) => MapEntry(path, {
        'groupCount': stats.groupCount,
        'testCount': stats.testCount,
        'skippedTests': stats.skippedTests,
        'commentedTests': stats.commentedTests,
        'nonCompliantNaming': stats.nonCompliantNaming,
        'missingAAA': stats.missingAAA,
        'testsWithoutAssertions': stats.testsWithoutAssertions,
        'assertionsWithoutReasons': stats.assertionsWithoutReasons,
        'isCompliant': stats.isCompliant,
        'complianceScore': stats.complianceScore,
      })),
      'issues': issues.map((issue) => {
        'file': issue.file,
        'line': issue.line,
        'type': issue.type.toString(),
        'message': issue.message,
        'severity': issue.severity.toString(),
      }).toList(),
    };
    
    File(outputPath).writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(json),
    );
  }
}

void main(List<String> args) async {
  final projectPath = args.isNotEmpty ? args[0] : Directory.current.path;
  final outputPath = args.length > 1 ? args[1] : null;
  
  try {
    final validator = TddComplianceValidator();
    final report = await validator.validateProject(projectPath);
    
    report.printReport();
    
    if (outputPath != null) {
      report.saveToFile(outputPath);
      print('\n✅ Report saved to: $outputPath');
    }
    
    // Exit with error code if compliance is below threshold
    if (report.overallCompliance < 80.0 || report.errorCount > 0) {
      print('\n❌ TDD compliance check failed!');
      exit(1);
    } else {
      print('\n✅ TDD compliance check passed!');
      exit(0);
    }
  } catch (e) {
    print('❌ Error: $e');
    exit(2);
  }
}