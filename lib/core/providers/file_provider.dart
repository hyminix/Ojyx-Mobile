import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/file_service.dart';

part 'file_provider.g.dart';

/// Provider for FileService instance
@Riverpod(keepAlive: true)
FileService fileService(Ref ref) {
  final service = FileService();
  return service;
}

/// Provider to initialize file service
@Riverpod(keepAlive: true)
Future<void> fileServiceInitializer(Ref ref) async {
  final service = ref.watch(fileServiceProvider);
  await service.initialize();
}

/// Provider for game data directory
@riverpod
Future<Directory> gameDataDirectory(Ref ref) async {
  final fileService = ref.watch(fileServiceProvider);
  final appDir = await fileService.getAppDocumentsDirectory();
  return fileService.createSubdirectory(appDir, FilePaths.gameData);
}

/// Provider for user files directory
@riverpod
Future<Directory> userFilesDirectory(Ref ref) async {
  final fileService = ref.watch(fileServiceProvider);
  final appDir = await fileService.getAppDocumentsDirectory();
  return fileService.createSubdirectory(appDir, FilePaths.userFiles);
}

/// Provider for exports directory
@riverpod
Future<Directory> exportsDirectory(Ref ref) async {
  final fileService = ref.watch(fileServiceProvider);
  final appDir = await fileService.getAppDocumentsDirectory();
  return fileService.createSubdirectory(appDir, FilePaths.exports);
}

/// Provider for logs directory
@riverpod
Future<Directory> logsDirectory(Ref ref) async {
  final fileService = ref.watch(fileServiceProvider);
  final appDir = await fileService.getAppSupportDirectory();
  return fileService.createSubdirectory(appDir, FilePaths.logs);
}

/// Provider for storage info
@riverpod
Future<Map<String, dynamic>> storageInfo(Ref ref) async {
  final fileService = ref.watch(fileServiceProvider);
  return fileService.getStorageInfo();
}

/// Provider for game state persistence
@riverpod
class GameStatePersistence extends _$GameStatePersistence {
  late final FileService _fileService;

  @override
  Future<Map<String, dynamic>?> build() async {
    _fileService = ref.watch(fileServiceProvider);
    
    // Load game state from file
    final gameDir = await ref.watch(gameDataDirectoryProvider.future);
    final content = await _fileService.readStringFromFile(
      FilePaths.gameState,
      directory: gameDir,
    );
    
    if (content != null) {
      try {
        return Map<String, dynamic>.from(
          (content as Map).cast<String, dynamic>(),
        );
      } catch (e) {
        // Invalid JSON, return null
        return null;
      }
    }
    
    return null;
  }

  /// Save game state
  Future<void> saveGameState(Map<String, dynamic> gameState) async {
    final gameDir = await ref.read(gameDataDirectoryProvider.future);
    
    await _fileService.writeStringToFile(
      FilePaths.gameState,
      gameState.toString(),
      directory: gameDir,
    );
    
    // Update state
    state = AsyncData(gameState);
  }

  /// Clear game state
  Future<void> clearGameState() async {
    final gameDir = await ref.read(gameDataDirectoryProvider.future);
    
    await _fileService.deleteFile(
      FilePaths.gameState,
      directory: gameDir,
    );
    
    // Update state
    state = const AsyncData(null);
  }
}

/// Provider for error logging
@riverpod
class ErrorLogger extends _$ErrorLogger {
  late final FileService _fileService;

  @override
  void build() {
    _fileService = ref.watch(fileServiceProvider);
  }

  /// Log an error to file
  Future<void> logError(String error, {String? stackTrace}) async {
    try {
      final logsDir = await ref.read(logsDirectoryProvider.future);
      
      final timestamp = DateTime.now().toIso8601String();
      final logEntry = '''
================================================================================
Timestamp: $timestamp
Error: $error
${stackTrace != null ? 'Stack Trace:\n$stackTrace' : ''}
================================================================================

''';

      // Read existing log
      String existingLog = await _fileService.readStringFromFile(
        FilePaths.errorLog,
        directory: logsDir,
      ) ?? '';
      
      // Append new entry
      final updatedLog = existingLog + logEntry;
      
      // Write back to file
      await _fileService.writeStringToFile(
        FilePaths.errorLog,
        updatedLog,
        directory: logsDir,
      );
    } catch (e) {
      // Fail silently to avoid recursive errors
    }
  }

  /// Clear error logs
  Future<void> clearLogs() async {
    final logsDir = await ref.read(logsDirectoryProvider.future);
    await _fileService.deleteFile(
      FilePaths.errorLog,
      directory: logsDir,
    );
  }

  /// Get error logs
  Future<String?> getLogs() async {
    final logsDir = await ref.read(logsDirectoryProvider.future);
    return _fileService.readStringFromFile(
      FilePaths.errorLog,
      directory: logsDir,
    );
  }
}

/// Provider for clearing temporary files
@riverpod
Future<void> clearTempFiles(Ref ref) async {
  final fileService = ref.read(fileServiceProvider);
  await fileService.clearTempFiles();
}

/// Provider for clearing cache
@riverpod
Future<void> clearCache(Ref ref) async {
  final fileService = ref.read(fileServiceProvider);
  await fileService.clearCache();
}

/// Provider for exporting data
@riverpod
class DataExporter extends _$DataExporter {
  late final FileService _fileService;

  @override
  void build() {
    _fileService = ref.watch(fileServiceProvider);
  }

  /// Export data to file
  Future<File?> exportData(String fileName, String data) async {
    try {
      final exportDir = await ref.read(exportsDirectoryProvider.future);
      
      final file = await _fileService.writeStringToFile(
        fileName,
        data,
        directory: exportDir,
      );
      
      return file;
    } catch (e) {
      return null;
    }
  }

  /// Export binary data to file
  Future<File?> exportBinaryData(String fileName, Uint8List data) async {
    try {
      final exportDir = await ref.read(exportsDirectoryProvider.future);
      
      final file = await _fileService.writeBytesToFile(
        fileName,
        data,
        directory: exportDir,
      );
      
      return file;
    } catch (e) {
      return null;
    }
  }

  /// List exported files
  Future<List<FileSystemEntity>> listExports() async {
    final exportDir = await ref.read(exportsDirectoryProvider.future);
    return _fileService.listFiles(exportDir);
  }
}