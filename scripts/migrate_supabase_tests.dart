import 'dart:io';

/// Script de migration automatique pour les tests Supabase v2 vers v3
///
/// Usage: dart scripts/migrate_supabase_tests.dart

void main() async {
  print('🔄 Migration des tests Supabase vers la v3...\n');

  // Trouver tous les fichiers de test qui utilisent Supabase
  final testDir = Directory('test');
  final files = await findSupabaseTestFiles(testDir);

  print('📁 Fichiers trouvés: ${files.length}');

  int migratedCount = 0;
  int skippedCount = 0;

  for (final file in files) {
    // Skip déjà migrés ou helpers
    if (file.path.endsWith('_v3.dart') ||
        file.path.endsWith('_migrated.dart') ||
        file.path.contains('supabase_test_helpers.dart') ||
        file.path.contains('MIGRATION_GUIDE.md')) {
      skippedCount++;
      continue;
    }

    print('\n📝 Migration de: ${file.path}');

    try {
      final content = await file.readAsString();
      final migrated = migrateContent(content, file.path);

      if (migrated != content) {
        // Créer une copie v3
        final newPath = file.path.replaceAll('.dart', '_v3.dart');
        final newFile = File(newPath);
        await newFile.writeAsString(migrated);

        print('✅ Migré vers: $newPath');
        migratedCount++;
      } else {
        print('⏭️  Aucun changement nécessaire');
        skippedCount++;
      }
    } catch (e, stack) {
      print('❌ Erreur: $e');
      print(stack);
    }
  }

  print('\n\n📊 Résumé de la migration:');
  print('   ✅ Fichiers migrés: $migratedCount');
  print('   ⏭️  Fichiers ignorés: $skippedCount');
  print('   📁 Total traité: ${files.length}');
}

Future<List<File>> findSupabaseTestFiles(Directory dir) async {
  final files = <File>[];

  await for (final entity in dir.list(recursive: true)) {
    if (entity is File &&
        entity.path.endsWith('_test.dart') &&
        !entity.path.contains('generated')) {
      final content = await entity.readAsString();
      if (content.contains('supabase') ||
          content.contains('Supabase') ||
          content.contains('SupabaseClient')) {
        files.add(entity);
      }
    }
  }

  return files;
}

String migrateContent(String content, String filePath) {
  var migrated = content;

  // Ajouter l'import du helper si nécessaire
  if (!migrated.contains('supabase_test_helpers.dart') &&
      (migrated.contains('MockSupabaseClient') ||
          migrated.contains('SupabaseClient'))) {
    final importIndex = migrated.lastIndexOf('import ');
    if (importIndex != -1) {
      final endOfImport = migrated.indexOf(';\n', importIndex) + 2;
      final relativePath = calculateRelativePath(filePath);
      migrated =
          migrated.substring(0, endOfImport) +
          "import '${relativePath}helpers/supabase_test_helpers.dart';\n" +
          migrated.substring(endOfImport);
    }
  }

  // Migrations spécifiques
  final migrations = [
    // Auth migrations
    Migration(
      pattern: RegExp(r'\.signIn\s*\('),
      replacement: (match) => '.signInWithPassword(',
    ),
    Migration(
      pattern: RegExp(r'supabase\.auth\.user(?!\w)'),
      replacement: (match) => 'supabase.auth.currentUser',
    ),
    Migration(
      pattern: RegExp(
        r'\.auth\.onAuthStateChange\s*\(\s*\(event,\s*session\)\s*',
      ),
      replacement: (match) => '.auth.onAuthStateChange.listen((data) ',
    ),

    // Database query migrations
    Migration(
      pattern: RegExp(r'\.execute\s*\(\s*\)'),
      replacement: (match) => '',
    ),
    Migration(
      pattern: RegExp(r'response\.error\s*!=\s*null'),
      replacement: (match) => 'false /* Migrated: use try-catch instead */',
    ),
    Migration(
      pattern: RegExp(r'response\.data\s+as\s+List'),
      replacement: (match) => 'data /* Migrated: direct result */',
    ),

    // Single row queries
    Migration(
      pattern: RegExp(r'\.single\s*\(\s*\)\.execute\s*\(\s*\)'),
      replacement: (match) => '.single()',
    ),

    // Realtime migrations
    Migration(
      pattern: RegExp(r'SupabaseEventTypes\.all'),
      replacement: (match) => 'PostgresChangeEvent.all',
    ),
    // Skip complex realtime regex for now
    // Will handle manually in v3 files

    // Error handling
    Migration(
      pattern: RegExp(
        r'if\s*\(\s*response\.error\s*!=\s*null\s*\)\s*\{[^}]+\}',
      ),
      replacement: (match) => '''} on PostgrestException catch (error) {
      throw error;
    }
    // TODO: Wrap the query above in try { ''',
    ),

    // Mock setup
    Migration(
      pattern: RegExp(r'MockSupabaseClient\s*\(\s*\)'),
      replacement: (match) => 'createMockSupabaseClient()',
    ),
  ];

  for (final migration in migrations) {
    migrated = migrated.replaceAllMapped(
      migration.pattern,
      migration.replacement,
    );
  }

  // Ajouter des commentaires pour les changements manuels nécessaires
  if (migrated.contains('.execute()')) {
    final index = migrated.indexOf('void main()');
    if (index != -1) {
      migrated =
          migrated.substring(0, index) +
          '''// TODO: Migration Notes
// 1. Remove all .execute() calls - queries now return directly
// 2. Replace response.error checks with try-catch PostgrestException
// 3. Use .single() for single row, .maybeSingle() for optional single row
// 4. Update realtime subscriptions to use channels
// 5. Consider using test fixtures from SupabaseTestFixtures

''' +
          migrated.substring(index);
    }
  }

  // Nettoyer les imports obsolètes
  migrated = migrated.replaceAll(
    "import 'package:ojyx/core/helpers/test_helpers.dart';",
    "import '../helpers/supabase_test_helpers.dart';",
  );

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

// Exemple de migration manuelle pour référence
void printMigrationExample() {
  print('''
Exemple de migration manuelle:

AVANT (v2):
```dart
test('should fetch room', () async {
  final mockSupabase = MockSupabaseClient();
  
  when(() => mockSupabase.from('rooms'))
      .thenReturn(MockSupabaseQueryBuilder());
      
  final response = await mockSupabase
      .from('rooms')
      .select()
      .eq('code', 'TEST123')
      .execute();
      
  if (response.error != null) {
    throw response.error!;
  }
  
  final data = response.data as List;
  expect(data.first['code'], 'TEST123');
});
```

APRÈS (v3):
```dart
test('should fetch room', () async {
  final mockSupabase = createMockSupabaseClient();
  
  setupQueryBuilder(
    client: mockSupabase,
    table: 'rooms',
    response: [SupabaseTestFixtures.createRoomFixture(code: 'TEST123')],
  );
  
  try {
    final data = await mockSupabase
        .from('rooms')
        .select()
        .eq('code', 'TEST123');
        
    expect(data.first['code'], 'TEST123');
  } on PostgrestException catch (error) {
    fail('Unexpected error: \$error');
  }
});
```
''');
}
