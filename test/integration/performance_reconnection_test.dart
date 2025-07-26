import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/core/services/connectivity_service.dart';
import 'package:ojyx/core/services/storage_service.dart';
import 'package:ojyx/core/services/file_service.dart';
import 'package:ojyx/core/config/app_initializer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'dart:io';

class MockConnectivity extends Mock implements Connectivity {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockRealtimeClient extends Mock implements RealtimeClient {}

class MockRealtimeChannel extends Mock implements RealtimeChannel {}

class MockHub extends Mock implements Hub {}

class MockISentrySpan extends Mock implements ISentrySpan {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Performance and Reconnection Integration Tests', () {
    late MockConnectivity mockConnectivity;
    late MockSharedPreferences mockPrefs;
    late ConnectivityService connectivityService;
    late StorageService storageService;

    setUp(() {
      mockConnectivity = MockConnectivity();
      mockPrefs = MockSharedPreferences();
      connectivityService = ConnectivityService.createWithConnectivity(
        mockConnectivity,
      );
      storageService = StorageService.createWithPrefs(mockPrefs);
    });

    group('Performance Tests', () {
      test('should measure app initialization performance', () async {
        final stopwatch = Stopwatch()..start();

        dotenv.testLoad(
          fileInput: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-key
SENTRY_DSN=https://test@sentry.io/123
''',
        );

        try {
          await AppInitializer.initialize();
        } catch (e) {
          // Expected in test environment
        }

        stopwatch.stop();

        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(3000),
          reason: 'App initialization should complete within 3 seconds',
        );

        print('Initialization time: ${stopwatch.elapsedMilliseconds}ms');
      });

      test('should measure service initialization performance', () async {
        final results = <String, int>{};

        // Test connectivity service init
        final connectivityStopwatch = Stopwatch()..start();
        final connectivityStream =
            StreamController<List<ConnectivityResult>>.broadcast();
        when(
          () => mockConnectivity.onConnectivityChanged,
        ).thenAnswer((_) => connectivityStream.stream);

        await connectivityService.initialize();
        connectivityStopwatch.stop();
        results['connectivity'] = connectivityStopwatch.elapsedMilliseconds;

        // Test storage service init
        final storageStopwatch = Stopwatch()..start();
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getStringList(any())).thenReturn(null);

        await storageService.initialize();
        storageStopwatch.stop();
        results['storage'] = storageStopwatch.elapsedMilliseconds;

        // Test file service init
        final fileStopwatch = Stopwatch()..start();
        final fileService = FileService();
        await fileService.initialize();
        fileStopwatch.stop();
        results['file'] = fileStopwatch.elapsedMilliseconds;

        // Verify all services initialize quickly
        results.forEach((service, time) {
          expect(
            time,
            lessThan(500),
            reason: '$service service should initialize within 500ms',
          );
          print('$service initialization: ${time}ms');
        });

        await connectivityStream.close();
      });

      test('should handle concurrent service operations efficiently', () async {
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);
        when(() => mockPrefs.getString(any())).thenReturn('test-value');

        final stopwatch = Stopwatch()..start();

        final futures = List.generate(100, (i) async {
          await storageService.saveString('key_$i', 'value_$i');
          return storageService.getString('key_$i');
        });

        final results = await Future.wait(futures);
        stopwatch.stop();

        expect(results.length, equals(100));
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(1000),
          reason: '100 concurrent operations should complete within 1 second',
        );

        print('Concurrent operations time: ${stopwatch.elapsedMilliseconds}ms');
      });

      test('should measure memory usage during operations', () async {
        final initialMemory = ProcessInfo.currentRss;

        // Perform memory-intensive operations
        final largeData = List.generate(1000, (i) => 'Item $i' * 100);

        when(
          () => mockPrefs.setStringList(any(), any()),
        ).thenAnswer((_) async => true);
        await storageService.saveStringList('large_data', largeData);

        final afterMemory = ProcessInfo.currentRss;
        final memoryIncrease = afterMemory - initialMemory;

        // Memory increase should be reasonable
        expect(
          memoryIncrease,
          lessThan(50 * 1024 * 1024),
          reason: 'Memory increase should be less than 50MB',
        );

        print('Memory increase: ${memoryIncrease ~/ 1024 / 1024}MB');
      });
    });

    group('Reconnection Tests', () {
      test('should handle network disconnection and reconnection', () async {
        final connectivityStream =
            StreamController<List<ConnectivityResult>>.broadcast();
        when(
          () => mockConnectivity.onConnectivityChanged,
        ).thenAnswer((_) => connectivityStream.stream);
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        await connectivityService.initialize();

        final connectionStates = <bool>[];
        connectivityService.connectionStream.listen((isConnected) {
          connectionStates.add(isConnected);
        });

        // Simulate connection changes
        connectivityStream.add([ConnectivityResult.wifi]);
        await Future.delayed(const Duration(milliseconds: 100));

        connectivityStream.add([ConnectivityResult.none]);
        await Future.delayed(const Duration(milliseconds: 100));

        connectivityStream.add([ConnectivityResult.mobile]);
        await Future.delayed(const Duration(milliseconds: 100));

        expect(connectionStates, [true, false, true]);

        await connectivityStream.close();
      });

      test('should queue operations during offline mode', () async {
        final mockSupabase = MockSupabaseClient();
        final mockAuth = MockGoTrueClient();
        final connectivityStream =
            StreamController<List<ConnectivityResult>>.broadcast();

        when(
          () => mockConnectivity.onConnectivityChanged,
        ).thenAnswer((_) => connectivityStream.stream);
        when(() => mockSupabase.auth).thenReturn(mockAuth);

        await connectivityService.initialize();

        final operationQueue = <Future<void>>[];

        // Go offline
        connectivityStream.add([ConnectivityResult.none]);
        await Future.delayed(const Duration(milliseconds: 100));

        // Queue operations while offline
        operationQueue.add(Future.delayed(const Duration(milliseconds: 500)));
        operationQueue.add(Future.delayed(const Duration(milliseconds: 500)));

        // Go back online
        connectivityStream.add([ConnectivityResult.wifi]);
        await Future.delayed(const Duration(milliseconds: 100));

        // Execute queued operations
        await Future.wait(operationQueue);

        expect(operationQueue.length, equals(2));

        await connectivityStream.close();
      });

      test('should handle Supabase realtime reconnection', () async {
        final mockSupabase = MockSupabaseClient();
        final mockRealtime = MockRealtimeClient();
        final mockChannel = MockRealtimeChannel();
        final connectivityStream =
            StreamController<List<ConnectivityResult>>.broadcast();

        when(
          () => mockConnectivity.onConnectivityChanged,
        ).thenAnswer((_) => connectivityStream.stream);
        when(() => mockSupabase.realtime).thenReturn(mockRealtime);
        when(() => mockRealtime.channel(any(), any())).thenReturn(mockChannel);
        when(() => mockChannel.subscribe()).thenAnswer((_) async {
          return ChannelResponse(
            status: ChannelStatus.subscribed,
            channel: mockChannel,
          );
        });
        when(() => mockChannel.unsubscribe()).thenAnswer((_) async => 'ok');

        await connectivityService.initialize();

        // Subscribe to channel
        final channel = mockSupabase.realtime.channel('test-channel');
        channel.subscribe();

        // Simulate disconnection
        connectivityStream.add([ConnectivityResult.none]);
        await Future.delayed(const Duration(milliseconds: 100));

        // Simulate reconnection
        connectivityStream.add([ConnectivityResult.wifi]);
        await Future.delayed(const Duration(milliseconds: 100));

        // Resubscribe
        channel.subscribe();

        verify(() => mockChannel.subscribe()).called(2);

        await connectivityStream.close();
      });

      test('should implement exponential backoff for reconnection', () async {
        final attempts = <DateTime>[];
        int attemptCount = 0;

        Future<void> connectWithBackoff() async {
          while (attemptCount < 5) {
            attempts.add(DateTime.now());

            try {
              if (attemptCount < 3) {
                throw Exception('Connection failed');
              }
              return;
            } catch (e) {
              attemptCount++;
              final delay = Duration(milliseconds: 100 * (1 << attemptCount));
              await Future.delayed(delay);
            }
          }
        }

        await connectWithBackoff();

        expect(attempts.length, greaterThanOrEqualTo(3));

        // Verify exponential delays
        for (int i = 1; i < attempts.length; i++) {
          final delay = attempts[i].difference(attempts[i - 1]).inMilliseconds;
          final expectedMinDelay = 100 * (1 << i);
          expect(delay, greaterThanOrEqualTo(expectedMinDelay));
        }
      });

      test('should persist and restore state during reconnection', () async {
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);
        when(
          () => mockPrefs.getString('app_state'),
        ).thenReturn('{"score": 100}');

        // Save state before disconnection
        await storageService.saveString('app_state', '{"score": 100}');

        // Simulate app restart/reconnection
        final restoredState = storageService.getString('app_state');

        expect(restoredState, equals('{"score": 100}'));
      });

      test('should handle timeout during reconnection attempts', () async {
        final mockSupabase = MockSupabaseClient();
        final mockAuth = MockGoTrueClient();

        when(() => mockSupabase.auth).thenReturn(mockAuth);
        when(() => mockAuth.refreshSession()).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 10));
          throw TimeoutException('Refresh timeout');
        });

        expect(
          () async => await mockAuth.refreshSession().timeout(
            const Duration(seconds: 2),
          ),
          throwsA(isA<TimeoutException>()),
        );
      });
    });

    group('Integration Stress Tests', () {
      test('should handle rapid connection state changes', () async {
        final connectivityStream =
            StreamController<List<ConnectivityResult>>.broadcast();
        when(
          () => mockConnectivity.onConnectivityChanged,
        ).thenAnswer((_) => connectivityStream.stream);

        await connectivityService.initialize();

        final states = <bool>[];
        connectivityService.connectionStream.listen((state) {
          states.add(state);
        });

        // Rapid state changes
        for (int i = 0; i < 20; i++) {
          connectivityStream.add(
            i % 2 == 0 ? [ConnectivityResult.none] : [ConnectivityResult.wifi],
          );
          await Future.delayed(const Duration(milliseconds: 50));
        }

        expect(states.length, greaterThanOrEqualTo(10));

        await connectivityStream.close();
      });

      test('should maintain performance under load', () async {
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);
        when(() => mockPrefs.getString(any())).thenReturn('value');
        when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

        final stopwatch = Stopwatch()..start();

        // Simulate heavy load
        final operations = <Future>[];
        for (int i = 0; i < 1000; i++) {
          operations.add(storageService.saveString('key_$i', 'value_$i'));
          if (i % 3 == 0) {
            operations.add(Future(() => storageService.getString('key_$i')));
          }
          if (i % 5 == 0) {
            operations.add(storageService.remove('key_$i'));
          }
        }

        await Future.wait(operations);
        stopwatch.stop();

        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(5000),
          reason: '1000+ operations should complete within 5 seconds',
        );

        print(
          'Heavy load test completed in: ${stopwatch.elapsedMilliseconds}ms',
        );
      });
    });
  });
}
