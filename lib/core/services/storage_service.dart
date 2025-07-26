import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for local storage using SharedPreferences
class StorageService {
  SharedPreferences? _prefs;
  
  /// Initialize the storage service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint('StorageService initialized');
  }

  /// Get SharedPreferences instance
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('StorageService not initialized. Call initialize() first.');
    }
    return _prefs!;
  }

  /// Check if service is initialized
  bool get isInitialized => _prefs != null;

  // String operations
  
  /// Get a string value
  String? getString(String key) {
    return prefs.getString(key);
  }

  /// Set a string value
  Future<bool> setString(String key, String value) {
    return prefs.setString(key, value);
  }

  // Integer operations
  
  /// Get an integer value
  int? getInt(String key) {
    return prefs.getInt(key);
  }

  /// Set an integer value
  Future<bool> setInt(String key, int value) {
    return prefs.setInt(key, value);
  }

  // Double operations
  
  /// Get a double value
  double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  /// Set a double value
  Future<bool> setDouble(String key, double value) {
    return prefs.setDouble(key, value);
  }

  // Boolean operations
  
  /// Get a boolean value
  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  /// Set a boolean value
  Future<bool> setBool(String key, bool value) {
    return prefs.setBool(key, value);
  }

  // List operations
  
  /// Get a string list
  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  /// Set a string list
  Future<bool> setStringList(String key, List<String> value) {
    return prefs.setStringList(key, value);
  }

  // JSON operations
  
  /// Get a JSON object
  Map<String, dynamic>? getJson(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error decoding JSON for key $key: $e');
      return null;
    }
  }

  /// Set a JSON object
  Future<bool> setJson(String key, Map<String, dynamic> value) {
    try {
      final jsonString = json.encode(value);
      return setString(key, jsonString);
    } catch (e) {
      debugPrint('Error encoding JSON for key $key: $e');
      return Future.value(false);
    }
  }

  /// Get a list of JSON objects
  List<Map<String, dynamic>>? getJsonList(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    
    try {
      final list = json.decode(jsonString) as List;
      return list.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error decoding JSON list for key $key: $e');
      return null;
    }
  }

  /// Set a list of JSON objects
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) {
    try {
      final jsonString = json.encode(value);
      return setString(key, jsonString);
    } catch (e) {
      debugPrint('Error encoding JSON list for key $key: $e');
      return Future.value(false);
    }
  }

  // Utility operations
  
  /// Check if a key exists
  bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  /// Remove a value
  Future<bool> remove(String key) {
    return prefs.remove(key);
  }

  /// Clear all values
  Future<bool> clear() {
    return prefs.clear();
  }

  /// Get all keys
  Set<String> getKeys() {
    return prefs.getKeys();
  }

  /// Reload values from disk
  Future<void> reload() {
    return prefs.reload();
  }
}

/// Storage keys constants
class StorageKeys {
  StorageKeys._();

  // User preferences
  static const String userPreferences = 'user_preferences';
  static const String gameSettings = 'game_settings';
  static const String lastSyncTime = 'last_sync_time';
  
  // Game data
  static const String currentGameId = 'current_game_id';
  static const String playerStats = 'player_stats';
  static const String gameHistory = 'game_history';
  
  // App settings
  static const String appTheme = 'app_theme';
  static const String languageCode = 'language_code';
  static const String onboardingCompleted = 'onboarding_completed';
  
  // Cache
  static const String cachedUserData = 'cached_user_data';
  static const String cachedGameData = 'cached_game_data';
}