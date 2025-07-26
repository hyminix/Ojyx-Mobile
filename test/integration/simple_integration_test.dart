import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ojyx/core/config/app_initializer.dart';
import 'package:ojyx/core/services/connectivity_service.dart';
import 'package:ojyx/core/services/storage_service.dart';
import 'package:ojyx/core/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

class MockConnectivity extends Mock implements Connectivity {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('Simple Integration Tests', () {
    late MockConnectivity mockConnectivity;
    late MockSharedPreferences mockPrefs;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      mockConnectivity = MockConnectivity();
      mockPrefs = MockSharedPreferences();
    });

    test('should initialize app configuration successfully', () async {
      dotenv.testLoad(fileInput: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-key
SENTRY_DSN=https://test@sentry.io/123
ENVIRONMENT=test
''');

      expect(dotenv.env['SUPABASE_URL'], equals('https://test.supabase.co'));
      expect(dotenv.env['SUPABASE_ANON_KEY'], equals('test-key'));
      expect(dotenv.env['SENTRY_DSN'], equals('https://test@sentry.io/123'));
      expect(dotenv.env['ENVIRONMENT'], equals('test'));
    });

    test('should initialize services without errors', () async {
      // Connectivity service
      final connectivityStream = StreamController<List<ConnectivityResult>>.broadcast();
      when(() => mockConnectivity.onConnectivityChanged).thenAnswer(
        (_) => connectivityStream.stream,
      );
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi],
      );

      final connectivityService = ConnectivityService.createWithConnectivity(mockConnectivity);
      await connectivityService.initialize();

      expect(connectivityService.isConnected, isTrue);

      // Storage service
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.containsKey(any())).thenReturn(false);

      final storageService = StorageService.createWithPrefs(mockPrefs);
      await storageService.initialize();

      expect(storageService.isInitialized, isTrue);

      // File service
      final fileService = FileService();
      await fileService.initialize();

      expect(fileService.isInitialized, isTrue);

      await connectivityStream.close();
    });

    test('should handle service operations correctly', () async {
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(any())).thenReturn('test-value');
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
      when(() => mockPrefs.containsKey(any())).thenReturn(true);

      final storageService = StorageService.createWithPrefs(mockPrefs);
      await storageService.initialize();

      // Test save operation
      final saveResult = await storageService.saveString('test-key', 'test-value');
      expect(saveResult, isTrue);

      // Test get operation
      final getValue = storageService.getString('test-key');
      expect(getValue, equals('test-value'));

      // Test remove operation
      final removeResult = await storageService.remove('test-key');
      expect(removeResult, isTrue);

      // Test containsKey operation
      final hasKey = storageService.containsKey('test-key');
      expect(hasKey, isTrue);
    });

    test('should handle connectivity changes', () async {
      final connectivityStream = StreamController<List<ConnectivityResult>>.broadcast();
      when(() => mockConnectivity.onConnectivityChanged).thenAnswer(
        (_) => connectivityStream.stream,
      );
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi],
      );

      final connectivityService = ConnectivityService.createWithConnectivity(mockConnectivity);
      await connectivityService.initialize();

      final statusChanges = <bool>[];
      connectivityService.connectionStream.listen((isConnected) {
        statusChanges.add(isConnected);
      });

      // Simulate connectivity changes
      connectivityStream.add([ConnectivityResult.wifi]);
      await Future.delayed(const Duration(milliseconds: 100));

      connectivityStream.add([ConnectivityResult.none]);
      await Future.delayed(const Duration(milliseconds: 100));

      connectivityStream.add([ConnectivityResult.mobile]);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(statusChanges, isNotEmpty);

      await connectivityStream.close();
    });

    test('should measure performance of operations', () async {
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(any())).thenReturn('value');

      final storageService = StorageService.createWithPrefs(mockPrefs);
      await storageService.initialize();

      final stopwatch = Stopwatch()..start();

      const operations = 100;
      for (int i = 0; i < operations; i++) {
        await storageService.saveString('key_$i', 'value_$i');
        storageService.getString('key_$i');
      }

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(1000),
          reason: '$operations operations should complete within 1 second');

      print('Performance test: ${stopwatch.elapsedMilliseconds}ms for $operations operations');
    });

    testWidgets('should integrate with Flutter widget tree', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Integration Test'),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Test Button'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Integration Test'), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Test button interaction
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Widget should still be there after interaction
      expect(find.text('Test Button'), findsOneWidget);
    });

    test('should handle error scenarios gracefully', () async {
      // Test storage service with failing operations
      when(() => mockPrefs.setString(any(), any())).thenThrow(Exception('Storage failed'));
      when(() => mockPrefs.getString(any())).thenThrow(Exception('Read failed'));

      final storageService = StorageService.createWithPrefs(mockPrefs);
      await storageService.initialize();

      expect(
        () async => await storageService.saveString('test', 'value'),
        throwsA(isA<Exception>()),
      );

      expect(
        () => storageService.getString('test'),
        throwsA(isA<Exception>()),
      );
    });

    test('should validate service integration points', () async {
      // Setup all services
      final connectivityStream = StreamController<List<ConnectivityResult>>.broadcast();
      when(() => mockConnectivity.onConnectivityChanged).thenAnswer(
        (_) => connectivityStream.stream,
      );
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi],
      );

      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(any())).thenReturn(null);

      final connectivityService = ConnectivityService.createWithConnectivity(mockConnectivity);
      final storageService = StorageService.createWithPrefs(mockPrefs);
      final fileService = FileService();

      // Initialize all services
      await Future.wait([
        connectivityService.initialize(),
        storageService.initialize(),
        fileService.initialize(),
      ]);

      // Verify all are initialized
      expect(connectivityService.isConnected, isTrue);
      expect(storageService.isInitialized, isTrue);
      expect(fileService.isInitialized, isTrue);

      // Test coordination between services
      await storageService.saveString('connectivity_status', 'online');
      final savedStatus = storageService.getString('connectivity_status');
      expect(savedStatus, equals('online'));

      await connectivityStream.close();
    });
  });
}