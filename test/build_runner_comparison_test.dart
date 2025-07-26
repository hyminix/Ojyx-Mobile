import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

void main() {
  group('Build Runner Update Comparison', () {
    test('should compare generated files with snapshot', () {
      // Charger le snapshot
      final snapshotFile = File('test/fixtures/generated_files_snapshot.json');
      expect(
        snapshotFile.existsSync(),
        isTrue,
        reason: 'Snapshot file should exist',
      );

      final snapshotContent = snapshotFile.readAsStringSync();
      final snapshotData = jsonDecode(snapshotContent) as Map<String, dynamic>;
      final oldChecksums = snapshotData['files'] as Map<String, dynamic>;

      // Calculer les nouveaux checksums
      final newChecksums = <String, String>{};
      final libDir = Directory('lib');
      final files = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where(
            (file) =>
                file.path.endsWith('.g.dart') ||
                file.path.endsWith('.freezed.dart'),
          )
          .toList();

      for (final file in files) {
        final content = file.readAsStringSync();
        final checksum = md5.convert(utf8.encode(content)).toString();
        newChecksums[file.path] = checksum;
      }

      // Comparer les checksums
      final differences = <String, Map<String, String>>{};

      // Vérifier les fichiers modifiés
      for (final entry in oldChecksums.entries) {
        final path = entry.key;
        final oldChecksum = entry.value as String;
        final newChecksum = newChecksums[path];

        if (newChecksum != null && newChecksum != oldChecksum) {
          differences[path] = {'old': oldChecksum, 'new': newChecksum};
        }
      }

      // Vérifier les nouveaux fichiers
      for (final entry in newChecksums.entries) {
        if (!oldChecksums.containsKey(entry.key)) {
          differences[entry.key] = {'old': 'none', 'new': entry.value};
        }
      }

      // Afficher les résultats
      if (differences.isEmpty) {
        print('✅ Aucune différence détectée dans les fichiers générés');
      } else {
        print(
          '⚠️ Différences détectées dans ${differences.length} fichier(s):',
        );
        for (final entry in differences.entries) {
          print('  - ${entry.key}');
        }
      }

      // Le test passe toujours pour permettre l'analyse
      expect(
        differences.isEmpty,
        isTrue,
        reason: 'Generated files should not change with build_runner update',
      );
    });
  });
}
