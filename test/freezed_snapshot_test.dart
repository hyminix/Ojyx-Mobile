import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

void main() {
  group('Freezed Update Snapshot', () {
    test('should create snapshot before freezed update', () {
      // Snapshot des fichiers freezed avant mise à jour
      final freezedFiles = <String, String>{};
      final libDir = Directory('lib');

      final files = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.freezed.dart'))
          .toList();

      for (final file in files) {
        final content = file.readAsStringSync();
        final checksum = md5.convert(utf8.encode(content)).toString();
        freezedFiles[file.path] = checksum;
      }

      // Sauvegarder le snapshot
      final snapshotFile = File('test/fixtures/freezed_files_snapshot.json');
      final snapshotData = {
        'timestamp': DateTime.now().toIso8601String(),
        'freezedVersion': '2.5.7',
        'files': freezedFiles,
      };

      snapshotFile.writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(snapshotData),
      );

      expect(snapshotFile.existsSync(), isTrue);
      expect(freezedFiles, isNotEmpty);
      print('Found ${freezedFiles.length} freezed files');
    });
  });
}
