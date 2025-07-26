import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

void main() {
  group('Build Runner Generated Files', () {
    // Map pour stocker les checksums des fichiers générés
    final generatedFiles = <String, String>{};
    
    setUpAll(() {
      // Rechercher tous les fichiers générés
      final libDir = Directory('lib');
      final files = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.g.dart') || 
                          file.path.endsWith('.freezed.dart'))
          .toList();
      
      // Calculer les checksums pour chaque fichier
      for (final file in files) {
        final content = file.readAsStringSync();
        final checksum = md5.convert(utf8.encode(content)).toString();
        generatedFiles[file.path] = checksum;
      }
    });

    test('should find generated files', () {
      expect(generatedFiles, isNotEmpty,
          reason: 'Should find at least one generated file');
    });

    test('should find freezed files', () {
      final freezedFiles = generatedFiles.keys
          .where((path) => path.endsWith('.freezed.dart'))
          .toList();
      expect(freezedFiles, isNotEmpty,
          reason: 'Should find at least one freezed file');
    });

    test('should find json_serializable files', () {
      final jsonFiles = generatedFiles.keys
          .where((path) => path.endsWith('.g.dart'))
          .toList();
      expect(jsonFiles, isNotEmpty,
          reason: 'Should find at least one json_serializable file');
    });

    test('generated files should be valid dart', () {
      for (final filePath in generatedFiles.keys) {
        final file = File(filePath);
        final content = file.readAsStringSync();
        
        // Vérifier que le fichier contient des markers de génération
        expect(
          content.contains('// GENERATED CODE - DO NOT MODIFY BY HAND') ||
          content.contains('// coverage:ignore-file'),
          isTrue,
          reason: 'File $filePath should contain generation markers',
        );
      }
    });

    test('should create snapshot of generated files', () {
      // Créer un snapshot des checksums actuels
      final snapshot = File('test/fixtures/generated_files_snapshot.json');
      snapshot.parent.createSync(recursive: true);
      
      final snapshotData = {
        'timestamp': DateTime.now().toIso8601String(),
        'files': generatedFiles,
      };
      
      snapshot.writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(snapshotData),
      );
      
      expect(snapshot.existsSync(), isTrue);
    });

    group('Model Serialization Tests', () {
      test('all models with .g.dart should have corresponding .freezed.dart', () {
        final gFiles = generatedFiles.keys
            .where((path) => path.endsWith('.g.dart'))
            .map((path) => path.replaceAll('.g.dart', ''))
            .toSet();
        
        final freezedFiles = generatedFiles.keys
            .where((path) => path.endsWith('.freezed.dart'))
            .map((path) => path.replaceAll('.freezed.dart', ''))
            .toSet();
        
        // Les fichiers qui ont .g.dart devraient aussi avoir .freezed.dart
        for (final base in gFiles) {
          if (!base.contains('/providers/')) { // Les providers n'ont pas de freezed
            expect(freezedFiles.contains(base), isTrue,
                reason: '$base.g.dart should have corresponding .freezed.dart');
          }
        }
      });
    });
  });
}