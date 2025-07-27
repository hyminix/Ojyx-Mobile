import 'dart:io';

/// Script pour migrer automatiquement les tests Riverpod vers les nouveaux patterns
void main() async {
  print('🔄 Migration des tests Riverpod...\n');

  final testDir = Directory('test');
  if (!testDir.existsSync()) {
    print('❌ Dossier test/ non trouvé');
    return;
  }

  final filesToMigrate = <File>[];
  final migratedFiles = <String>[];

  // Trouver tous les fichiers de test utilisant Riverpod
  await for (final file
      in testDir
          .list(recursive: true)
          .where((e) => e is File && e.path.endsWith('_test.dart'))) {
    final content = await (file as File).readAsStringSync();

    // Vérifier si le fichier utilise Riverpod et n'est pas déjà migré
    if (content.contains('ProviderContainer') &&
        !content.contains('riverpod_test_helpers.dart') &&
        !file.path.endsWith('_v2.dart')) {
      filesToMigrate.add(file);
    }
  }

  print('📊 Fichiers à migrer: ${filesToMigrate.length}\n');

  for (final file in filesToMigrate) {
    print('📝 Migration de ${file.path}...');

    try {
      final migrated = await migrateFile(file);
      if (migrated) {
        migratedFiles.add(file.path);
        print('✅ Migré avec succès');
      } else {
        print('⏭️  Pas de changements nécessaires');
      }
    } catch (e) {
      print('❌ Erreur: $e');
    }
  }

  print('\n📊 Résumé:');
  print('✅ Fichiers migrés: ${migratedFiles.length}');
  print(
    '📋 Fichiers restants: ${filesToMigrate.length - migratedFiles.length}',
  );

  if (migratedFiles.isNotEmpty) {
    print('\n📝 Fichiers migrés:');
    for (final path in migratedFiles) {
      print('  - $path');
    }
  }
}

Future<bool> migrateFile(File file) async {
  var content = await file.readAsStringSync();
  var modified = false;

  // Patterns de migration
  final migrations = [
    // 1. Ajouter l'import du helper
    Migration(
      pattern: RegExp(
        r"import 'package:flutter_riverpod/flutter_riverpod\.dart';",
      ),
      replacement: (match) {
        final relativePath = _getRelativeImportPath(file.path);
        return "${match.group(0)}\nimport '$relativePath/helpers/riverpod_test_helpers.dart';";
      },
      condition: (content) => !content.contains('riverpod_test_helpers.dart'),
    ),

    // 2. Remplacer ProviderContainer() simple
    Migration(
      pattern: RegExp(r'container = ProviderContainer\(\);\s*\n'),
      replacement: (match) => 'container = createTestContainer();\n',
    ),

    // 3. Remplacer ProviderContainer avec overrides
    Migration(
      pattern: RegExp(
        r'container = ProviderContainer\(\s*overrides:\s*\[([\s\S]*?)\],?\s*\);',
      ),
      replacement: (match) {
        final overrides = match.group(1)!;
        return 'container = createTestContainer(\n  overrides: [$overrides],\n);';
      },
    ),

    // 4. Supprimer tearDown qui ne fait que dispose
    Migration(
      pattern: RegExp(
        r'tearDown\(\(\)\s*{\s*container\.dispose\(\);\s*}\);?\s*\n',
      ),
      replacement: (match) => '',
    ),

    // 5. Remplacer ProviderScope.containerOf
    Migration(
      pattern: RegExp(
        r'ProviderScope\.containerOf\(\s*tester\.element\([^)]+\)\s*\)',
      ),
      replacement: (match) => 'tester.container()',
    ),

    // 6. Migrer pumpWidget avec ProviderScope
    Migration(
      pattern: RegExp(
        r'await tester\.pumpWidget\(\s*ProviderScope\(\s*child:\s*MaterialApp\(\s*home:\s*(.*?)\),\s*\),\s*\);',
        multiLine: true,
      ),
      replacement: (match) {
        final child = match.group(1)!;
        return 'await tester.pumpRiverpodApp(\n  child: $child,\n);';
      },
    ),
  ];

  // Appliquer les migrations
  for (final migration in migrations) {
    if (migration.shouldApply(content)) {
      content = content.replaceAllMapped(
        migration.pattern,
        migration.replacement,
      );
      modified = true;
    }
  }

  // Sauvegarder le fichier migré avec suffixe _v2
  if (modified) {
    final newPath = file.path.replaceAll('.dart', '_v2.dart');
    final newFile = File(newPath);
    await newFile.writeAsString(content);
  }

  return modified;
}

/// Calcule le chemin relatif pour l'import
String _getRelativeImportPath(String filePath) {
  final segments = filePath.split('/');
  final depth = segments.length - 2; // -1 pour 'test', -1 pour le fichier

  if (depth <= 1) {
    return '.';
  }

  return List.filled(depth - 1, '..').join('/');
}

class Migration {
  final RegExp pattern;
  final String Function(Match) replacement;
  final bool Function(String)? condition;

  Migration({required this.pattern, required this.replacement, this.condition});

  bool shouldApply(String content) {
    if (condition != null) {
      return condition!(content);
    }
    return pattern.hasMatch(content);
  }
}
