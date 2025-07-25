import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Linting Comparison Tests', () {
    test('should compare linting issues before and after update', () async {
      // Lire les rapports
      final beforeFile = File('.taskmaster/reports/linting-before-update.txt');
      final afterFile = File('.taskmaster/reports/linting-after-update.txt');

      expect(beforeFile.existsSync(), isTrue);
      expect(afterFile.existsSync(), isTrue);

      final beforeContent = beforeFile.readAsStringSync();
      final afterContent = afterFile.readAsStringSync();

      // Compter les issues
      int countIssues(String content, String pattern) {
        return RegExp(pattern).allMatches(content).length;
      }

      final beforeErrors = countIssues(beforeContent, r'error •');
      final beforeWarnings = countIssues(beforeContent, r'warning •');
      final beforeInfo = countIssues(beforeContent, r'info •');

      final afterErrors = countIssues(afterContent, r'error •');
      final afterWarnings = countIssues(afterContent, r'warning •');
      final afterInfo = countIssues(afterContent, r'info •');

      print('Comparaison des métriques de linting:');
      print('======================================');
      print('                  Avant    Après    Diff');
      print(
        'Errors:          $beforeErrors       $afterErrors      ${afterErrors - beforeErrors}',
      );
      print(
        'Warnings:        $beforeWarnings      $afterWarnings      ${afterWarnings - beforeWarnings}',
      );
      print(
        'Info:            $beforeInfo     $afterInfo     ${afterInfo - beforeInfo}',
      );
      print(
        'Total:           ${beforeErrors + beforeWarnings + beforeInfo}     ${afterErrors + afterWarnings + afterInfo}      ${(afterErrors + afterWarnings + afterInfo) - (beforeErrors + beforeWarnings + beforeInfo)}',
      );

      // Identifier les nouvelles règles
      final afterLines = afterContent.split('\n');
      final newRules = <String>{};

      for (final line in afterLines) {
        final match = RegExp(r'• ([a-z_]+)$').firstMatch(line);
        if (match != null) {
          final rule = match.group(1)!;
          if (!beforeContent.contains(' • $rule')) {
            newRules.add(rule);
          }
        }
      }

      if (newRules.isNotEmpty) {
        print('\nNouvelles règles détectées:');
        for (final rule in newRules) {
          print('  - $rule');
        }
      }

      // Sauvegarder le rapport de comparaison
      final comparisonReport =
          '''
Linting Migration Comparison Report
===================================
Date: ${DateTime.now()}
flutter_lints: 5.0.0 → 6.0.0

Metrics Comparison:
                  Before   After    Diff
Errors:          $beforeErrors       $afterErrors      ${afterErrors - beforeErrors}
Warnings:        $beforeWarnings      $afterWarnings      ${afterWarnings - beforeWarnings}
Info:            $beforeInfo     $afterInfo     ${afterInfo - beforeInfo}
Total:           ${beforeErrors + beforeWarnings + beforeInfo}     ${afterErrors + afterWarnings + afterInfo}      ${(afterErrors + afterWarnings + afterInfo) - (beforeErrors + beforeWarnings + beforeInfo)}

New rules detected: ${newRules.length}
${newRules.map((r) => '  - $r').join('\n')}
''';

      final reportFile = File(
        '.taskmaster/reports/linting-comparison-report.txt',
      );
      await reportFile.writeAsString(comparisonReport);
    });
  });
}
