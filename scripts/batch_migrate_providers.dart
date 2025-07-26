import 'dart:io';

/// Script to batch migrate legacy Riverpod providers to modern syntax
/// Usage: dart scripts/batch_migrate_providers.dart
void main() async {
  print('🚀 Starting batch migration of legacy Riverpod providers...\n');

  // List of files identified as using legacy syntax from the audit
  final legacyFiles = [
    'lib/core/config/router_config.dart',
    'lib/core/providers/supabase_provider.dart',
    'lib/features/end_game/presentation/providers/end_game_provider.dart',
    'lib/features/game/presentation/providers/direction_observer_provider.dart',
    'lib/features/global_scores/presentation/providers/global_score_providers.dart',
    // Add more files as needed
  ];

  var migratedCount = 0;
  var skippedCount = 0;

  for (final filePath in legacyFiles) {
    final file = File(filePath);
    if (!await file.exists()) {
      print('⚠️  File not found: $filePath');
      skippedCount++;
      continue;
    }

    print('📄 Processing: $filePath');

    try {
      final content = await file.readAsString();
      final migrated = migrateProviderContent(content, filePath);

      if (migrated != null) {
        // Create backup
        final backupPath = filePath.replaceAll('.dart', '.backup.dart');
        await File(backupPath).writeAsString(content);

        // Write migrated content
        await file.writeAsString(migrated);
        print('✅ Migrated successfully');
        migratedCount++;
      } else {
        print('⏭️  Skipped - already modern or no providers found');
        skippedCount++;
      }
    } catch (e) {
      print('❌ Error: $e');
      skippedCount++;
    }

    print('');
  }

  print('\n📊 Migration Summary:');
  print('   ✅ Migrated: $migratedCount files');
  print('   ⏭️  Skipped: $skippedCount files');
  print('\n🎯 Next steps:');
  print(
    '   1. Run: flutter pub run build_runner build --delete-conflicting-outputs',
  );
  print('   2. Run: flutter test');
  print('   3. Review and test migrated providers');
}

String? migrateProviderContent(String content, String filePath) {
  // Skip if already using modern syntax
  if (content.contains('@riverpod')) {
    return null;
  }

  var modified = content;
  var hasChanges = false;

  // Pattern 1: Simple Provider
  // final myProvider = Provider<MyType>((ref) => MyType());
  final simpleProviderPattern = RegExp(
    r'final\s+(\w+)\s*=\s*Provider<([^>]+)>\s*\(\s*\(ref\)\s*=>\s*(.+?)\);',
    multiLine: true,
  );

  modified = modified.replaceAllMapped(simpleProviderPattern, (match) {
    hasChanges = true;
    final providerName = match.group(1)!;
    final type = match.group(2)!;
    final implementation = match.group(3)!;

    // Convert to @riverpod function
    final functionName = providerName.replaceAll('Provider', '');
    return '''@riverpod
$type $functionName(${_capitalize(functionName)}Ref ref) {
  return $implementation;
}''';
  });

  // Pattern 2: FutureProvider
  // final myProvider = FutureProvider<MyType>((ref) async => await something());
  final futureProviderPattern = RegExp(
    r'final\s+(\w+)\s*=\s*FutureProvider<([^>]+)>\s*\(\s*\(ref\)\s*async\s*=>\s*(.+?)\);',
    multiLine: true,
  );

  modified = modified.replaceAllMapped(futureProviderPattern, (match) {
    hasChanges = true;
    final providerName = match.group(1)!;
    final type = match.group(2)!;
    final implementation = match.group(3)!;

    final functionName = providerName.replaceAll('Provider', '');
    return '''@riverpod
Future<$type> $functionName(${_capitalize(functionName)}Ref ref) async {
  return $implementation;
}''';
  });

  // Add import if we made changes
  if (hasChanges && !modified.contains('riverpod_annotation')) {
    // Find the last import
    final lastImportIndex = modified.lastIndexOf('import ');
    if (lastImportIndex != -1) {
      final endOfImport = modified.indexOf(';', lastImportIndex) + 1;
      modified =
          "${modified.substring(0, endOfImport)}\nimport 'package:riverpod_annotation/riverpod_annotation.dart';${modified.substring(endOfImport)}";
    }

    // Add part directive after imports
    final fileName = filePath.split('/').last.replaceAll('.dart', '');
    final partDirective = "\npart '$fileName.g.dart';";

    if (!modified.contains(partDirective)) {
      // Find position after last import
      final imports = RegExp(r'import .+?;', multiLine: true);
      final matches = imports.allMatches(modified).toList();
      if (matches.isNotEmpty) {
        final lastMatch = matches.last;
        final insertPos = lastMatch.end;
        modified =
            modified.substring(0, insertPos) +
            partDirective +
            modified.substring(insertPos);
      }
    }
  }

  return hasChanges ? modified : null;
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
