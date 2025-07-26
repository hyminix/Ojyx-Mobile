import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for file system operations using path_provider
class FileService {
  // Cache directories to avoid repeated platform calls
  Directory? _tempDir;
  Directory? _appDocumentsDir;
  Directory? _appSupportDir;
  Directory? _appCacheDir;

  /// Initialize the file service
  Future<void> initialize() async {
    // Pre-cache commonly used directories
    _tempDir = await getTemporaryDirectory();
    _appDocumentsDir = await getApplicationDocumentsDirectory();
    _appSupportDir = await getApplicationSupportDirectory();

    // Cache directory is not available on all platforms
    try {
      _appCacheDir = await getApplicationCacheDirectory();
    } catch (e) {
      debugPrint('Cache directory not available on this platform');
    }

    debugPrint('FileService initialized');
  }

  /// Check if service is initialized
  bool get isInitialized =>
      _tempDir != null && _appDocumentsDir != null && _appSupportDir != null;

  /// Get temporary directory
  Future<Directory> getTempDirectory() async {
    _tempDir ??= await getTemporaryDirectory();
    return _tempDir!;
  }

  /// Get application documents directory
  Future<Directory> getAppDocumentsDirectory() async {
    _appDocumentsDir ??= await getApplicationDocumentsDirectory();
    return _appDocumentsDir!;
  }

  /// Get application support directory
  Future<Directory> getAppSupportDirectory() async {
    _appSupportDir ??= await getApplicationSupportDirectory();
    return _appSupportDir!;
  }

  /// Get application cache directory
  Future<Directory?> getAppCacheDirectory() async {
    if (_appCacheDir == null) {
      try {
        _appCacheDir = await getApplicationCacheDirectory();
      } catch (e) {
        debugPrint('Cache directory not available: $e');
        return null;
      }
    }
    return _appCacheDir;
  }

  /// Create a subdirectory in the given parent directory
  Future<Directory> createSubdirectory(Directory parent, String name) async {
    final subDir = Directory(path.join(parent.path, name));
    if (!await subDir.exists()) {
      await subDir.create(recursive: true);
    }
    return subDir;
  }

  /// Write string to file
  Future<File> writeStringToFile(
    String fileName,
    String content, {
    Directory? directory,
  }) async {
    directory ??= await getAppDocumentsDirectory();
    final file = File(path.join(directory.path, fileName));
    return await file.writeAsString(content);
  }

  /// Read string from file
  Future<String?> readStringFromFile(
    String fileName, {
    Directory? directory,
  }) async {
    try {
      directory ??= await getAppDocumentsDirectory();
      final file = File(path.join(directory.path, fileName));
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      debugPrint('Error reading file $fileName: $e');
      return null;
    }
  }

  /// Write bytes to file
  Future<File> writeBytesToFile(
    String fileName,
    Uint8List bytes, {
    Directory? directory,
  }) async {
    directory ??= await getAppDocumentsDirectory();
    final file = File(path.join(directory.path, fileName));
    return await file.writeAsBytes(bytes);
  }

  /// Read bytes from file
  Future<Uint8List?> readBytesFromFile(
    String fileName, {
    Directory? directory,
  }) async {
    try {
      directory ??= await getAppDocumentsDirectory();
      final file = File(path.join(directory.path, fileName));
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      debugPrint('Error reading file $fileName: $e');
      return null;
    }
  }

  /// Check if file exists
  Future<bool> fileExists(String fileName, {Directory? directory}) async {
    directory ??= await getAppDocumentsDirectory();
    final file = File(path.join(directory.path, fileName));
    return await file.exists();
  }

  /// Delete file
  Future<bool> deleteFile(String fileName, {Directory? directory}) async {
    try {
      directory ??= await getAppDocumentsDirectory();
      final file = File(path.join(directory.path, fileName));
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting file $fileName: $e');
      return false;
    }
  }

  /// List files in directory
  Future<List<FileSystemEntity>> listFiles(
    Directory directory, {
    bool recursive = false,
  }) async {
    try {
      return await directory.list(recursive: recursive).toList();
    } catch (e) {
      debugPrint('Error listing files: $e');
      return [];
    }
  }

  /// Get file size
  Future<int?> getFileSize(String fileName, {Directory? directory}) async {
    try {
      directory ??= await getAppDocumentsDirectory();
      final file = File(path.join(directory.path, fileName));
      if (await file.exists()) {
        return await file.length();
      }
      return null;
    } catch (e) {
      debugPrint('Error getting file size: $e');
      return null;
    }
  }

  /// Clear temporary files
  Future<void> clearTempFiles() async {
    try {
      final tempDir = await getTempDirectory();
      final files = await listFiles(tempDir);

      for (final file in files) {
        if (file is File) {
          await file.delete();
        }
      }

      debugPrint('Temporary files cleared');
    } catch (e) {
      debugPrint('Error clearing temp files: $e');
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    try {
      final cacheDir = await getAppCacheDirectory();
      if (cacheDir != null) {
        final files = await listFiles(cacheDir);

        for (final file in files) {
          if (file is File) {
            await file.delete();
          } else if (file is Directory) {
            await file.delete(recursive: true);
          }
        }

        debugPrint('Cache cleared');
      }
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  /// Get storage info
  Future<Map<String, dynamic>> getStorageInfo() async {
    final info = <String, dynamic>{};

    try {
      // Get directory paths
      final tempDir = await getTempDirectory();
      final docsDir = await getAppDocumentsDirectory();
      final supportDir = await getAppSupportDirectory();
      final cacheDir = await getAppCacheDirectory();

      info['tempPath'] = tempDir.path;
      info['documentsPath'] = docsDir.path;
      info['supportPath'] = supportDir.path;
      if (cacheDir != null) {
        info['cachePath'] = cacheDir.path;
      }

      // Calculate directory sizes (simplified)
      info['tempSize'] = await _getDirectorySize(tempDir);
      info['documentsSize'] = await _getDirectorySize(docsDir);
      info['supportSize'] = await _getDirectorySize(supportDir);
      if (cacheDir != null) {
        info['cacheSize'] = await _getDirectorySize(cacheDir);
      }
    } catch (e) {
      debugPrint('Error getting storage info: $e');
    }

    return info;
  }

  /// Get directory size
  Future<int> _getDirectorySize(Directory dir) async {
    int size = 0;

    try {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          size += await entity.length();
        }
      }
    } catch (e) {
      debugPrint('Error calculating directory size: $e');
    }

    return size;
  }
}

/// File paths constants
class FilePaths {
  FilePaths._();

  // Subdirectories
  static const String gameData = 'game_data';
  static const String userFiles = 'user_files';
  static const String exports = 'exports';
  static const String logs = 'logs';

  // File names
  static const String gameState = 'game_state.json';
  static const String playerProfile = 'player_profile.json';
  static const String gameHistory = 'game_history.json';
  static const String errorLog = 'error_log.txt';
}
