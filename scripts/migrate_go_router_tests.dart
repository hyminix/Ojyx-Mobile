import 'dart:io';

/// Script de migration automatique pour les tests go_router
///
/// Usage: dart scripts/migrate_go_router_tests.dart

void main() async {
  print('🔄 Migration des tests go_router vers les nouveaux patterns...\n');

  // Trouver tous les fichiers de test qui utilisent go_router
  final testDir = Directory('test');
  final files = await findGoRouterTestFiles(testDir);

  print('📁 Fichiers trouvés: ${files.length}');

  int migratedCount = 0;
  int skippedCount = 0;

  for (final file in files) {
    // Skip déjà migrés
    if (file.path.endsWith('_migrated.dart') ||
        file.path.endsWith('_v2.dart') ||
        file.path.contains('go_router_test_helpers.dart')) {
      skippedCount++;
      continue;
    }

    print('\n📝 Migration de: ${file.path}');

    try {
      final content = await file.readAsString();
      final migrated = migrateContent(content, file.path);

      if (migrated != content) {
        // Créer une copie v2
        final newPath = file.path.replaceAll('.dart', '_v2.dart');
        final newFile = File(newPath);
        await newFile.writeAsString(migrated);

        print('✅ Migré vers: $newPath');
        migratedCount++;
      } else {
        print('⏭️  Aucun changement nécessaire');
        skippedCount++;
      }
    } catch (e) {
      print('❌ Erreur: $e');
    }
  }

  print('\n\n📊 Résumé de la migration:');
  print('   ✅ Fichiers migrés: $migratedCount');
  print('   ⏭️  Fichiers ignorés: $skippedCount');
  print('   📁 Total traité: ${files.length}');
}

Future<List<File>> findGoRouterTestFiles(Directory dir) async {
  final files = <File>[];

  await for (final entity in dir.list(recursive: true)) {
    if (entity is File &&
        entity.path.endsWith('_test.dart') &&
        !entity.path.contains('generated')) {
      final content = await entity.readAsString();
      if (content.contains('go_router') || content.contains('GoRouter')) {
        files.add(entity);
      }
    }
  }

  return files;
}

String migrateContent(String content, String filePath) {
  var migrated = content;

  // Ajouter les imports nécessaires
  if (!migrated.contains('go_router_test_helpers.dart') &&
      migrated.contains('GoRouter')) {
    final importIndex = migrated.lastIndexOf('import ');
    if (importIndex != -1) {
      final endOfImport = migrated.indexOf(';\n', importIndex) + 2;
      final relativePath = calculateRelativePath(filePath);
      migrated =
          migrated.substring(0, endOfImport) +
          "import '${relativePath}helpers/go_router_test_helpers.dart';\n" +
          migrated.substring(endOfImport);
    }
  }

  // Remplacer ProviderContainer par createTestContainer
  if (!migrated.contains('riverpod_test_helpers.dart') &&
      migrated.contains('ProviderContainer()')) {
    final importIndex = migrated.lastIndexOf('import ');
    if (importIndex != -1) {
      final endOfImport = migrated.indexOf(';\n', importIndex) + 2;
      final relativePath = calculateRelativePath(filePath);
      migrated =
          migrated.substring(0, endOfImport) +
          "import '${relativePath}helpers/riverpod_test_helpers.dart';\n" +
          migrated.substring(endOfImport);
    }
  }

  // Migrations spécifiques
  final migrations = [
    Migration(
      pattern: RegExp(r'ProviderContainer\(\)'),
      replacement: (match) => 'createTestContainer()',
    ),
    Migration(
      pattern: RegExp(r'container\.dispose\(\)'),
      replacement: (match) =>
          '// Container disposal handled by createTestContainer',
    ),
    Migration(
      pattern: RegExp(
        r'// Mock for GoRouter\s*class\s+\w+\s+extends\s+Mock\s+implements\s+GoRouter\s*\{\}',
      ),
      replacement: (match) =>
          '// Using MockGoRouter from go_router_test_helpers',
    ),
    Migration(
      pattern: RegExp(r'final\s+mockRouter\s*=\s*\w+\(\);'),
      replacement: (match) {
        if (match.group(0)!.contains('MockGoRouter')) {
          return match.group(0)!;
        }
        return 'final mockRouter = MockGoRouter();\n      setupNavigationStubs(mockRouter);';
      },
    ),
  ];

  for (final migration in migrations) {
    migrated = migrated.replaceAllMapped(
      migration.pattern,
      migration.replacement,
    );
  }

  // Ajouter des exemples de nouveaux patterns en commentaires
  if (migrated.contains('context.go(') &&
      !migrated.contains('mockRouter.verifyGo')) {
    final testIndex = migrated.indexOf('testWidgets(');
    if (testIndex != -1) {
      final comment = '''
      // TODO: Consider using MockGoRouter for better test isolation:
      // final mockRouter = MockGoRouter();
      // setupNavigationStubs(mockRouter);
      // 
      // Then verify navigation:
      // mockRouter.verifyGo('/path');
      
''';
      migrated =
          migrated.substring(0, testIndex) +
          comment +
          migrated.substring(testIndex);
    }
  }

  return migrated;
}

String calculateRelativePath(String fromPath) {
  final depth = fromPath.split('/').where((part) => part.isNotEmpty).length - 2;
  if (depth <= 1) return './';
  return '../' * depth;
}

class Migration {
  final RegExp pattern;
  final String Function(Match) replacement;

  Migration({required this.pattern, required this.replacement});
}

// Exemple d'utilisation pour migration manuelle
void printMigrationExample() {
  print('''
Exemple de migration manuelle:

AVANT:
```dart
testWidgets('should navigate', (tester) async {
  final router = GoRouter(...);
  
  await tester.pumpWidget(
    MaterialApp.router(routerConfig: router),
  );
  
  // Test navigation
});
```

APRÈS:
```dart
testWidgets('should navigate', (tester) async {
  final mockRouter = MockGoRouter();
  setupNavigationStubs(mockRouter);
  
  await tester.pumpWidget(
    createMockRouterApp(
      mockRouter: mockRouter,
      child: YourWidget(),
    ),
  );
  
  // Test navigation
  await tester.tap(find.text('Navigate'));
  
  // Verify
  mockRouter.verifyGo('/destination');
});
```
''');
}
