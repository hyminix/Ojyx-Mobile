// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storageServiceHash() => r'8456a4c9362a461cc8bff74fbf063f10929190ec';

/// Provider for StorageService instance
///
/// Copied from [storageService].
@ProviderFor(storageService)
final storageServiceProvider = Provider<StorageService>.internal(
  storageService,
  name: r'storageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StorageServiceRef = ProviderRef<StorageService>;
String _$storageInitializerHash() =>
    r'01fb56bd55e03472450988fc7c7db370a781a06a';

/// Provider to initialize storage service
///
/// Copied from [storageInitializer].
@ProviderFor(storageInitializer)
final storageInitializerProvider = FutureProvider<void>.internal(
  storageInitializer,
  name: r'storageInitializerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageInitializerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StorageInitializerRef = FutureProviderRef<void>;
String _$clearAllStorageHash() => r'34da250790503d56c239f73f6078bff13107385f';

/// Provider for clearing all storage
///
/// Copied from [clearAllStorage].
@ProviderFor(clearAllStorage)
final clearAllStorageProvider = AutoDisposeFutureProvider<void>.internal(
  clearAllStorage,
  name: r'clearAllStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clearAllStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClearAllStorageRef = AutoDisposeFutureProviderRef<void>;
String _$userPreferencesHash() => r'f662bbfa4f62ff718e29ff109ef34c643f024d6e';

/// Provider for user preferences
///
/// Copied from [UserPreferences].
@ProviderFor(UserPreferences)
final userPreferencesProvider =
    AutoDisposeNotifierProvider<UserPreferences, Map<String, dynamic>>.internal(
      UserPreferences.new,
      name: r'userPreferencesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userPreferencesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserPreferences = AutoDisposeNotifier<Map<String, dynamic>>;
String _$gameSettingsHash() => r'33072738afd9fe8d8f6c6a03fe5b3efe8e55fc2c';

/// Provider for game settings
///
/// Copied from [GameSettings].
@ProviderFor(GameSettings)
final gameSettingsProvider =
    AutoDisposeNotifierProvider<GameSettings, Map<String, dynamic>>.internal(
      GameSettings.new,
      name: r'gameSettingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gameSettingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GameSettings = AutoDisposeNotifier<Map<String, dynamic>>;
String _$onboardingStatusHash() => r'd5a33c8640b27cb06cc016109a1ea6b2c2c9ba02';

/// Provider for checking if onboarding is completed
///
/// Copied from [OnboardingStatus].
@ProviderFor(OnboardingStatus)
final onboardingStatusProvider =
    AutoDisposeNotifierProvider<OnboardingStatus, bool>.internal(
      OnboardingStatus.new,
      name: r'onboardingStatusProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OnboardingStatus = AutoDisposeNotifier<bool>;
String _$appThemeHash() => r'a1912e4db4b3eeadb8d1197f44721a0566a82f1e';

/// Provider for app theme
///
/// Copied from [AppTheme].
@ProviderFor(AppTheme)
final appThemeProvider = AutoDisposeNotifierProvider<AppTheme, String>.internal(
  AppTheme.new,
  name: r'appThemeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppTheme = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
