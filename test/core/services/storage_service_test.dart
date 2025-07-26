import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ojyx/core/services/storage_service.dart';

void main() {
  group('StorageService', () {
    late StorageService storageService;

    setUp(() async {
      // Initialize SharedPreferences with test values
      SharedPreferences.setMockInitialValues({
        'test_string': 'hello',
        'test_int': 42,
        'test_double': 3.14,
        'test_bool': true,
        'test_list': ['item1', 'item2'],
        'test_json': '{"key":"value","number":123}',
        'test_json_list': '[{"id":1,"name":"Item 1"},{"id":2,"name":"Item 2"}]',
      });

      storageService = StorageService();
      await storageService.initialize();
    });

    group('initialization', () {
      test('should initialize successfully', () {
        expect(storageService.isInitialized, isTrue);
      });

      test('should throw error when accessing prefs before initialization', () {
        final uninitializedService = StorageService();
        
        expect(
          () => uninitializedService.prefs,
          throwsStateError,
        );
      });
    });

    group('string operations', () {
      test('should get string value', () {
        final value = storageService.getString('test_string');
        expect(value, equals('hello'));
      });

      test('should return null for non-existent string', () {
        final value = storageService.getString('non_existent');
        expect(value, isNull);
      });

      test('should set string value', () async {
        final result = await storageService.setString('new_string', 'world');
        expect(result, isTrue);
        
        final value = storageService.getString('new_string');
        expect(value, equals('world'));
      });
    });

    group('integer operations', () {
      test('should get integer value', () {
        final value = storageService.getInt('test_int');
        expect(value, equals(42));
      });

      test('should set integer value', () async {
        final result = await storageService.setInt('new_int', 100);
        expect(result, isTrue);
        
        final value = storageService.getInt('new_int');
        expect(value, equals(100));
      });
    });

    group('double operations', () {
      test('should get double value', () {
        final value = storageService.getDouble('test_double');
        expect(value, equals(3.14));
      });

      test('should set double value', () async {
        final result = await storageService.setDouble('new_double', 2.718);
        expect(result, isTrue);
        
        final value = storageService.getDouble('new_double');
        expect(value, equals(2.718));
      });
    });

    group('boolean operations', () {
      test('should get boolean value', () {
        final value = storageService.getBool('test_bool');
        expect(value, isTrue);
      });

      test('should set boolean value', () async {
        final result = await storageService.setBool('new_bool', false);
        expect(result, isTrue);
        
        final value = storageService.getBool('new_bool');
        expect(value, isFalse);
      });
    });

    group('list operations', () {
      test('should get string list', () {
        final value = storageService.getStringList('test_list');
        expect(value, equals(['item1', 'item2']));
      });

      test('should set string list', () async {
        final list = ['a', 'b', 'c'];
        final result = await storageService.setStringList('new_list', list);
        expect(result, isTrue);
        
        final value = storageService.getStringList('new_list');
        expect(value, equals(list));
      });
    });

    group('JSON operations', () {
      test('should get JSON object', () {
        final value = storageService.getJson('test_json');
        expect(value, isNotNull);
        expect(value!['key'], equals('value'));
        expect(value['number'], equals(123));
      });

      test('should return null for invalid JSON', () async {
        await storageService.setString('invalid_json', 'not a json');
        final value = storageService.getJson('invalid_json');
        expect(value, isNull);
      });

      test('should set JSON object', () async {
        final json = {'name': 'test', 'value': 456};
        final result = await storageService.setJson('new_json', json);
        expect(result, isTrue);
        
        final value = storageService.getJson('new_json');
        expect(value, equals(json));
      });

      test('should get JSON list', () {
        final value = storageService.getJsonList('test_json_list');
        expect(value, isNotNull);
        expect(value!.length, equals(2));
        expect(value[0]['id'], equals(1));
        expect(value[1]['name'], equals('Item 2'));
      });

      test('should set JSON list', () async {
        final list = [
          {'id': 3, 'name': 'Item 3'},
          {'id': 4, 'name': 'Item 4'},
        ];
        final result = await storageService.setJsonList('new_json_list', list);
        expect(result, isTrue);
        
        final value = storageService.getJsonList('new_json_list');
        expect(value, equals(list));
      });
    });

    group('utility operations', () {
      test('should check if key exists', () {
        expect(storageService.containsKey('test_string'), isTrue);
        expect(storageService.containsKey('non_existent'), isFalse);
      });

      test('should remove value', () async {
        await storageService.setString('to_remove', 'value');
        expect(storageService.containsKey('to_remove'), isTrue);
        
        final result = await storageService.remove('to_remove');
        expect(result, isTrue);
        expect(storageService.containsKey('to_remove'), isFalse);
      });

      test('should get all keys', () {
        final keys = storageService.getKeys();
        expect(keys.contains('test_string'), isTrue);
        expect(keys.contains('test_int'), isTrue);
        expect(keys.contains('test_bool'), isTrue);
      });

      test('should clear all values', () async {
        final result = await storageService.clear();
        expect(result, isTrue);
        
        final keys = storageService.getKeys();
        expect(keys.isEmpty, isTrue);
      });

      test('should reload values', () async {
        await storageService.reload();
        // Reload should complete without errors
        expect(true, isTrue);
      });
    });

    group('StorageKeys constants', () {
      test('should have correct key values', () {
        expect(StorageKeys.userPreferences, equals('user_preferences'));
        expect(StorageKeys.gameSettings, equals('game_settings'));
        expect(StorageKeys.lastSyncTime, equals('last_sync_time'));
        expect(StorageKeys.currentGameId, equals('current_game_id'));
        expect(StorageKeys.playerStats, equals('player_stats'));
        expect(StorageKeys.gameHistory, equals('game_history'));
        expect(StorageKeys.appTheme, equals('app_theme'));
        expect(StorageKeys.languageCode, equals('language_code'));
        expect(StorageKeys.onboardingCompleted, equals('onboarding_completed'));
        expect(StorageKeys.cachedUserData, equals('cached_user_data'));
        expect(StorageKeys.cachedGameData, equals('cached_game_data'));
      });
    });
  });
}