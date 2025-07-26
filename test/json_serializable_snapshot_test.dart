import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

void main() {
  group('JSON Serializable Update Snapshot', () {
    test('should create snapshot before json_serializable update', () {
      // Snapshot des fichiers .g.dart avant mise à jour
      final gFiles = <String, String>{};
      final libDir = Directory('lib');

      final files = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.g.dart'))
          .toList();

      for (final file in files) {
        final content = file.readAsStringSync();
        final checksum = md5.convert(utf8.encode(content)).toString();
        gFiles[file.path] = checksum;
      }

      // Sauvegarder le snapshot
      final snapshotFile = File(
        'test/fixtures/json_serializable_snapshot.json',
      );
      final snapshotData = {
        'timestamp': DateTime.now().toIso8601String(),
        'jsonSerializableVersion': '6.8.0',
        'files': gFiles,
      };

      snapshotFile.writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(snapshotData),
      );

      expect(snapshotFile.existsSync(), isTrue);
      expect(gFiles, isNotEmpty);
      print('Found ${gFiles.length} .g.dart files');
    });
  });
}
