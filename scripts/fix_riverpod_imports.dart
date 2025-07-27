import 'dart:io';

/// Script pour corriger les imports du helper Riverpod
void main() async {
  print('🔧 Correction des imports Riverpod...\n');

  final testDir = Directory('test');
  if (!testDir.existsSync()) {
    print('❌ Dossier test/ non trouvé');
    return;
  }

  final filesToFix = <File>[];

  // Trouver tous les fichiers _v2.dart
  await for (final file
      in testDir
          .list(recursive: true)
          .where((e) => e is File && e.path.endsWith('_v2.dart'))) {
    filesToFix.add(file as File);
  }

  print('📊 Fichiers à corriger: ${filesToFix.length}\n');

  for (final file in filesToFix) {
    print('📝 Correction de ${file.path}...');

    try {
      await fixImports(file);
      print('✅ Corrigé');
    } catch (e) {
      print('❌ Erreur: $e');
    }
  }
}

Future<void> fixImports(File file) async {
  var content = await file.readAsStringSync();

  // Calculer le bon chemin d'import
  final filePath = file.path.replaceAll('\\', '/');
  final segments = filePath.split('/');
  final testIndex = segments.indexOf('test');

  if (testIndex == -1) return;

  // Compter le nombre de dossiers depuis test/
  final depth =
      segments.length - testIndex - 2; // -1 pour 'test', -1 pour le fichier

  // Construire le chemin relatif correct
  String relativePath;
  if (depth == 0) {
    relativePath = './helpers/riverpod_test_helpers.dart';
  } else {
    final dots = List.filled(depth, '..').join('/');
    relativePath = '$dots/helpers/riverpod_test_helpers.dart';
  }

  // Remplacer l'import incorrect
  final importPattern = RegExp(r"import '[^']*riverpod_test_helpers\.dart';");

  if (importPattern.hasMatch(content)) {
    content = content.replaceFirst(importPattern, "import '$relativePath';");

    await file.writeAsString(content);
  }
}
