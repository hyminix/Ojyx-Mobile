import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

void main() {
  group('Providers Audit', () {
    test('should document all providers in the codebase', () async {
      final providers = <String, List<String>>{};

      // Search for provider files
      final libDir = Directory('lib');
      await for (final entity in libDir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final content = await entity.readAsString();

          // Check for different provider types
          final providerTypes = <String>[];

          if (content.contains('StateNotifierProvider')) {
            providerTypes.add('StateNotifierProvider');
          }
          if (content.contains('StateProvider')) {
            providerTypes.add('StateProvider');
          }
          if (content.contains('Provider')) {
            providerTypes.add('Provider');
          }
          if (content.contains('FutureProvider')) {
            providerTypes.add('FutureProvider');
          }
          if (content.contains('StreamProvider')) {
            providerTypes.add('StreamProvider');
          }
          if (content.contains('@riverpod')) {
            providerTypes.add('@riverpod annotation');
          }

          if (providerTypes.isNotEmpty) {
            providers[entity.path] = providerTypes;
          }
        }
      }

      // Output audit results
      print('\n=== RIVERPOD PROVIDERS AUDIT ===\n');
      print('Total files with providers: ${providers.length}\n');

      for (final entry in providers.entries) {
        print('File: ${entry.key}');
        print('Provider types: ${entry.value.join(', ')}');
        print('---');
      }

      // Verify we found providers
      expect(providers, isNotEmpty);
    });

    test('should check for StateNotifier usage', () async {
      final stateNotifiers = <String>[];

      final libDir = Directory('lib');
      await for (final entity in libDir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final content = await entity.readAsString();

          if (content.contains('extends StateNotifier')) {
            stateNotifiers.add(entity.path);
          }
        }
      }

      print('\n=== STATE NOTIFIERS FOUND ===\n');
      for (final path in stateNotifiers) {
        print('- $path');
      }

      // Note: StateNotifier is still valid in Riverpod 2.x
      // but Notifier is the recommended approach
      if (stateNotifiers.isNotEmpty) {
        print(
          '\nNote: Consider migrating StateNotifier to Notifier for better performance',
        );
      }
    });

    test('should check current Riverpod syntax usage', () async {
      final modernSyntax = <String>[];
      final legacySyntax = <String>[];

      final libDir = Directory('lib');
      await for (final entity in libDir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final content = await entity.readAsString();

          if (content.contains('@riverpod')) {
            modernSyntax.add(entity.path);
          }

          if (content.contains('final ') &&
              content.contains('Provider') &&
              !content.contains('@riverpod')) {
            legacySyntax.add(entity.path);
          }
        }
      }

      print('\n=== RIVERPOD SYNTAX ANALYSIS ===\n');
      print('Files using modern @riverpod syntax: ${modernSyntax.length}');
      print('Files using legacy provider syntax: ${legacySyntax.length}');

      if (legacySyntax.isNotEmpty) {
        print('\nLegacy syntax files:');
        for (final path in legacySyntax) {
          print('- $path');
        }
      }
    });
  });
}
