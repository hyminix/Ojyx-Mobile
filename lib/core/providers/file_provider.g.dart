// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fileServiceHash() => r'188982a5049ac95c583e75359e65a3b262848b5d';

/// Provider for FileService instance
///
/// Copied from [fileService].
@ProviderFor(fileService)
final fileServiceProvider = Provider<FileService>.internal(
  fileService,
  name: r'fileServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fileServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FileServiceRef = ProviderRef<FileService>;
String _$fileServiceInitializerHash() =>
    r'39871422a498cc769d6b97d847a48450ae5455c4';

/// Provider to initialize file service
///
/// Copied from [fileServiceInitializer].
@ProviderFor(fileServiceInitializer)
final fileServiceInitializerProvider = FutureProvider<void>.internal(
  fileServiceInitializer,
  name: r'fileServiceInitializerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fileServiceInitializerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FileServiceInitializerRef = FutureProviderRef<void>;
String _$gameDataDirectoryHash() => r'5a8d7511226c78941cb919d27b94d0efbd847c3a';

/// Provider for game data directory
///
/// Copied from [gameDataDirectory].
@ProviderFor(gameDataDirectory)
final gameDataDirectoryProvider = AutoDisposeFutureProvider<Directory>.internal(
  gameDataDirectory,
  name: r'gameDataDirectoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameDataDirectoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameDataDirectoryRef = AutoDisposeFutureProviderRef<Directory>;
String _$userFilesDirectoryHash() =>
    r'b61a23daee72e22c428967191cf6ce373b46c962';

/// Provider for user files directory
///
/// Copied from [userFilesDirectory].
@ProviderFor(userFilesDirectory)
final userFilesDirectoryProvider =
    AutoDisposeFutureProvider<Directory>.internal(
      userFilesDirectory,
      name: r'userFilesDirectoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userFilesDirectoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserFilesDirectoryRef = AutoDisposeFutureProviderRef<Directory>;
String _$exportsDirectoryHash() => r'78dc1f7acd2325fb4de84d5de0797927298fb7e2';

/// Provider for exports directory
///
/// Copied from [exportsDirectory].
@ProviderFor(exportsDirectory)
final exportsDirectoryProvider = AutoDisposeFutureProvider<Directory>.internal(
  exportsDirectory,
  name: r'exportsDirectoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exportsDirectoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExportsDirectoryRef = AutoDisposeFutureProviderRef<Directory>;
String _$logsDirectoryHash() => r'905c3316d0d35229e9ee2f58b954a53b1a166201';

/// Provider for logs directory
///
/// Copied from [logsDirectory].
@ProviderFor(logsDirectory)
final logsDirectoryProvider = AutoDisposeFutureProvider<Directory>.internal(
  logsDirectory,
  name: r'logsDirectoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$logsDirectoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LogsDirectoryRef = AutoDisposeFutureProviderRef<Directory>;
String _$storageInfoHash() => r'a6c8eb6073466d0f2458ecf141ae193eb471e2bb';

/// Provider for storage info
///
/// Copied from [storageInfo].
@ProviderFor(storageInfo)
final storageInfoProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
      storageInfo,
      name: r'storageInfoProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$storageInfoHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StorageInfoRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$clearTempFilesHash() => r'19512e464bfb814f726e0d3b8a4f745d14d529eb';

/// Provider for clearing temporary files
///
/// Copied from [clearTempFiles].
@ProviderFor(clearTempFiles)
final clearTempFilesProvider = AutoDisposeFutureProvider<void>.internal(
  clearTempFiles,
  name: r'clearTempFilesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clearTempFilesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClearTempFilesRef = AutoDisposeFutureProviderRef<void>;
String _$clearCacheHash() => r'93000dc57b04eb47092b91cec5764b80703553f8';

/// Provider for clearing cache
///
/// Copied from [clearCache].
@ProviderFor(clearCache)
final clearCacheProvider = AutoDisposeFutureProvider<void>.internal(
  clearCache,
  name: r'clearCacheProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clearCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClearCacheRef = AutoDisposeFutureProviderRef<void>;
String _$gameStatePersistenceHash() =>
    r'5e00190827d121e0ce5fe43be16883fd9eb8863b';

/// Provider for game state persistence
///
/// Copied from [GameStatePersistence].
@ProviderFor(GameStatePersistence)
final gameStatePersistenceProvider =
    AutoDisposeAsyncNotifierProvider<
      GameStatePersistence,
      Map<String, dynamic>?
    >.internal(
      GameStatePersistence.new,
      name: r'gameStatePersistenceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gameStatePersistenceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GameStatePersistence =
    AutoDisposeAsyncNotifier<Map<String, dynamic>?>;
String _$errorLoggerHash() => r'40da7811d10af26ff1b5b5967dfc25c01e12e622';

/// Provider for error logging
///
/// Copied from [ErrorLogger].
@ProviderFor(ErrorLogger)
final errorLoggerProvider =
    AutoDisposeNotifierProvider<ErrorLogger, void>.internal(
      ErrorLogger.new,
      name: r'errorLoggerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$errorLoggerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ErrorLogger = AutoDisposeNotifier<void>;
String _$dataExporterHash() => r'f3ca8ca54307d63b6c496f29a0dad20d74d1f548';

/// Provider for exporting data
///
/// Copied from [DataExporter].
@ProviderFor(DataExporter)
final dataExporterProvider =
    AutoDisposeNotifierProvider<DataExporter, void>.internal(
      DataExporter.new,
      name: r'dataExporterProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dataExporterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DataExporter = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
