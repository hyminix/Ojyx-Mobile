import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/storage_service.dart';

part 'storage_provider.g.dart';

/// Provider for StorageService instance
@Riverpod(keepAlive: true)
StorageService storageService(Ref ref) {
  final service = StorageService();
  return service;
}

/// Provider to initialize storage service
@Riverpod(keepAlive: true)
Future<void> storageInitializer(Ref ref) async {
  final service = ref.watch(storageServiceProvider);
  await service.initialize();
}

/// Provider for user preferences
@riverpod
class UserPreferences extends _$UserPreferences {
  late final StorageService _storage;

  @override
  Map<String, dynamic> build() {
    _storage = ref.watch(storageServiceProvider);

    // Load preferences from storage
    final prefs = _storage.getJson(StorageKeys.userPreferences);
    return prefs ?? _getDefaultPreferences();
  }

  /// Get default preferences
  Map<String, dynamic> _getDefaultPreferences() {
    return {
      'soundEnabled': true,
      'vibrationEnabled': true,
      'autoSave': true,
      'theme': 'light',
      'language': 'fr',
    };
  }

  /// Update a preference
  Future<void> updatePreference(String key, dynamic value) async {
    final newPrefs = {...state, key: value};

    // Save to storage
    await _storage.setJson(StorageKeys.userPreferences, newPrefs);

    // Update state
    state = newPrefs;
  }

  /// Reset to default preferences
  Future<void> resetToDefaults() async {
    final defaults = _getDefaultPreferences();

    // Save to storage
    await _storage.setJson(StorageKeys.userPreferences, defaults);

    // Update state
    state = defaults;
  }

  /// Get a specific preference
  T? getPreference<T>(String key) {
    return state[key] as T?;
  }
}

/// Provider for game settings
@riverpod
class GameSettings extends _$GameSettings {
  late final StorageService _storage;

  @override
  Map<String, dynamic> build() {
    _storage = ref.watch(storageServiceProvider);

    // Load settings from storage
    final settings = _storage.getJson(StorageKeys.gameSettings);
    return settings ?? _getDefaultSettings();
  }

  /// Get default game settings
  Map<String, dynamic> _getDefaultSettings() {
    return {
      'difficulty': 'normal',
      'timeLimit': 30,
      'maxPlayers': 8,
      'allowSpectators': true,
      'autoMatchmaking': true,
    };
  }

  /// Update a setting
  Future<void> updateSetting(String key, dynamic value) async {
    final newSettings = {...state, key: value};

    // Save to storage
    await _storage.setJson(StorageKeys.gameSettings, newSettings);

    // Update state
    state = newSettings;
  }

  /// Get a specific setting
  T? getSetting<T>(String key) {
    return state[key] as T?;
  }
}

/// Provider for checking if onboarding is completed
@riverpod
class OnboardingStatus extends _$OnboardingStatus {
  late final StorageService _storage;

  @override
  bool build() {
    _storage = ref.watch(storageServiceProvider);
    return _storage.getBool(StorageKeys.onboardingCompleted) ?? false;
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    await _storage.setBool(StorageKeys.onboardingCompleted, true);
    state = true;
  }

  /// Reset onboarding status
  Future<void> resetOnboarding() async {
    await _storage.remove(StorageKeys.onboardingCompleted);
    state = false;
  }
}

/// Provider for app theme
@riverpod
class AppTheme extends _$AppTheme {
  late final StorageService _storage;

  @override
  String build() {
    _storage = ref.watch(storageServiceProvider);
    return _storage.getString(StorageKeys.appTheme) ?? 'light';
  }

  /// Update theme
  Future<void> setTheme(String theme) async {
    await _storage.setString(StorageKeys.appTheme, theme);
    state = theme;
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newTheme = state == 'light' ? 'dark' : 'light';
    await setTheme(newTheme);
  }
}

/// Provider for clearing all storage
@riverpod
Future<void> clearAllStorage(Ref ref) async {
  final storage = ref.read(storageServiceProvider);
  await storage.clear();

  // Invalidate all storage-dependent providers
  ref.invalidate(userPreferencesProvider);
  ref.invalidate(gameSettingsProvider);
  ref.invalidate(onboardingStatusProvider);
  ref.invalidate(appThemeProvider);
}
