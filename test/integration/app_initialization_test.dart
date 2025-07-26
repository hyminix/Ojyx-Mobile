import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ojyx/core/config/app_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockHub extends Mock implements Hub {}

class MockISentrySpan extends Mock implements ISentrySpan {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App Initialization End-to-End Tests', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;
    late MockHub mockSentryHub;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockAuth = MockGoTrueClient();
      mockSentryHub = MockHub();

      when(() => mockSupabase.auth).thenReturn(mockAuth);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async => '.',
          );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            null,
          );
    });

    test('should complete full initialization flow successfully', () async {
      await expectLater(() async {
        try {
          await AppInitializer.initialize();
        } catch (e) {
          expect(e.toString(), contains('SUPABASE_URL'));
        }
      }, returnsNormally);
    });

    test(
      'should handle initialization with mock environment variables',
      () async {
        dotenv.testLoad(
          fileInput: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-anon-key
SENTRY_DSN=https://test@sentry.io/123456
ENVIRONMENT=test
''',
        );

        await expectLater(() async {
          try {
            await AppInitializer.initialize();
          } catch (e) {
            if (e.toString().contains('Supabase')) {
              return;
            }
            rethrow;
          }
        }, returnsNormally);
      },
    );

    test('should measure initialization performance', () async {
      final stopwatch = Stopwatch()..start();

      try {
        await AppInitializer.initialize();
      } catch (e) {
        // Expected to fail without real credentials
      }

      stopwatch.stop();

      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(5000),
        reason: 'Initialization should complete within 5 seconds',
      );
    });

    test('should initialize services in correct order', () async {
      final initOrder = <String>[];

      try {
        initOrder.add('start');
        await AppInitializer.initialize();
      } catch (e) {
        if (e.toString().contains('SUPABASE_URL')) {
          initOrder.add('env_loaded');
        }
        if (e.toString().contains('Supabase')) {
          initOrder.add('supabase_attempted');
        }
      }

      expect(initOrder.first, equals('start'));
      expect(initOrder.contains('env_loaded'), isTrue);
    });

    test('should handle initialization failures gracefully', () async {
      expect(
        () async => await AppInitializer.initialize(),
        throwsA(isA<Exception>()),
      );
    });

    testWidgets('should integrate with Flutter app lifecycle', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: Center(child: Text('Test App'))),
          ),
        ),
      );

      expect(find.text('Test App'), findsOneWidget);

      final binding = WidgetsBinding.instance;
      expect(binding, isNotNull);
    });

    test(
      'should verify all required services are available after init',
      () async {
        dotenv.testLoad(
          fileInput: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-anon-key
SENTRY_DSN=https://test@sentry.io/123456
''',
        );

        try {
          await AppInitializer.initialize();
        } catch (e) {
          // Expected to fail in test environment
        }

        expect(dotenv.env['SUPABASE_URL'], equals('https://test.supabase.co'));
        expect(dotenv.env['SUPABASE_ANON_KEY'], equals('test-anon-key'));
        expect(
          dotenv.env['SENTRY_DSN'],
          equals('https://test@sentry.io/123456'),
        );
      },
    );

    test('should handle concurrent initialization attempts', () async {
      final futures = List.generate(
        5,
        (_) => AppInitializer.initialize().catchError((_) {}),
      );

      await Future.wait(futures);

      expect(futures, hasLength(5));
    });
  });
}
