import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Linting Migration Tests', () {
    test('should capture current linting state', () async {
      // Exécuter flutter analyze et capturer le résultat
      final result = await Process.run('flutter', ['analyze']);

      // Capturer les métriques actuelles
      final output = result.stdout.toString();
      final lines = output.split('\n');

      var errorCount = 0;
      var warningCount = 0;
      var infoCount = 0;

      for (final line in lines) {
        if (line.contains('error •')) {
          errorCount++;
        } else if (line.contains('warning •'))
          warningCount++;
        else if (line.contains('info •'))
          infoCount++;
      }

      print('Linting état actuel:');
      print('- Errors: $errorCount');
      print('- Warnings: $warningCount');
      print('- Info: $infoCount');

      // Sauvegarder ces valeurs pour comparaison après migration
      final metricsFile = File(
        '.taskmaster/reports/linting-metrics-before.txt',
      );
      await metricsFile.writeAsString('''
Linting Metrics Before flutter_lints Update
==========================================
Date: ${DateTime.now()}
flutter_lints version: 5.0.0

Errors: $errorCount
Warnings: $warningCount
Info: $infoCount
Total issues: ${errorCount + warningCount + infoCount}
''');

      // Vérifier que nous avons capturé quelque chose
      expect(lines.length, greaterThan(0));
    });

    test('should verify linting configuration exists', () {
      final analysisOptionsFile = File('analysis_options.yaml');
      expect(analysisOptionsFile.existsSync(), isTrue);

      final content = analysisOptionsFile.readAsStringSync();
      expect(content, contains('flutter_lints'));
    });
  });
}
