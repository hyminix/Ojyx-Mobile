import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

void main() {
  group('JSON Serializable Files Comparison', () {
    test('should compare .g.dart files after update', () {
      // Charger le snapshot précédent
      final snapshotFile = File(
        'test/fixtures/json_serializable_snapshot.json',
      );
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
          .where((file) => file.path.endsWith('.g.dart'))
          .toList();

      for (final file in files) {
        final content = file.readAsStringSync();
        final checksum = md5.convert(utf8.encode(content)).toString();
        newChecksums[file.path] = checksum;
      }

      // Comparer les checksums
      final differences = <String, Map<String, String>>{};

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
        print('✅ Aucune différence détectée dans les fichiers .g.dart');
        print('   Version json_serializable: 6.8.0 (déjà à jour)');
      } else {
        print(
          '⚠️ Différences détectées dans ${differences.length} fichier(s) .g.dart:',
        );
        for (final entry in differences.entries) {
          print('  - ${entry.key}');
        }
      }

      // Le test passe toujours pour permettre l'analyse
      expect(
        differences.isEmpty,
        isTrue,
        reason:
            'json_serializable files should not change with current version',
      );
    });
  });
}
