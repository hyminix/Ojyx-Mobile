import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SDK Compatibility Tests', () {
    test('should meet minimum Dart SDK requirements', () {
      // Vérifier la version Dart
      final dartVersion = Platform.version;
      print('Current Dart version: $dartVersion');

      // Extraire la version majeure et mineure
      final versionMatch = RegExp(
        r'(\d+)\.(\d+)\.(\d+)',
      ).firstMatch(dartVersion);
      expect(versionMatch, isNotNull, reason: 'Could not parse Dart version');

      final major = int.parse(versionMatch!.group(1)!);
      final minor = int.parse(versionMatch.group(2)!);

      // Vérifier que nous avons au moins Dart 3.8.0
      expect(
        major,
        greaterThanOrEqualTo(3),
        reason: 'Dart major version should be >= 3',
      );
      if (major == 3) {
        expect(
          minor,
          greaterThanOrEqualTo(8),
          reason: 'Dart minor version should be >= 8 when major is 3',
        );
      }
    });

    test('should have correct SDK constraints in pubspec.yaml', () {
      // Lire pubspec.yaml
      final pubspecFile = File('pubspec.yaml');
      expect(
        pubspecFile.existsSync(),
        isTrue,
        reason: 'pubspec.yaml should exist',
      );

      final pubspecContent = pubspecFile.readAsStringSync();

      // Vérifier la contrainte SDK - utilisons une regex simple
      final sdkConstraintMatch = RegExp(
        r'sdk:\s*\^?(\d+\.\d+\.\d+)',
      ).firstMatch(pubspecContent);
      expect(
        sdkConstraintMatch,
        isNotNull,
        reason: 'Should find SDK constraint in pubspec.yaml',
      );

      final sdkConstraint = sdkConstraintMatch!.group(0)!;
      print('Current SDK constraint: $sdkConstraint');

      // La contrainte devrait commencer par sdk: et contenir 3.8
      expect(
        sdkConstraint,
        contains('3.8'),
        reason: 'SDK constraint should be compatible with Dart 3.8.x',
      );
    });

    test('should have Flutter environment properly configured', () {
      // Vérifier que Flutter est dans le PATH
      final flutterResult = Process.runSync('flutter', ['--version']);
      expect(
        flutterResult.exitCode,
        equals(0),
        reason: 'Flutter should be available in PATH',
      );

      // Vérifier la version Flutter
      final flutterOutput = flutterResult.stdout.toString();
      expect(
        flutterOutput,
        contains('Flutter'),
        reason: 'Should get Flutter version info',
      );
      expect(
        flutterOutput,
        contains('3.'),
        reason: 'Should be using Flutter 3.x',
      );
    });
  });
}
