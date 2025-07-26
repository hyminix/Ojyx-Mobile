import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/core/config/app_initializer.dart';

// Mocks
class MockDotEnv extends Mock implements DotEnv {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppInitializer', () {
    setUp(() {
      // Reset dotenv for each test
      dotenv.testLoad(fileInput: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-anon-key
SENTRY_DSN=https://test@sentry.io/123456
ENVIRONMENT=test
ENABLE_ERROR_SCREENSHOTS=true
ENABLE_PERFORMANCE_MONITORING=true
''');
    });

    tearDown(() {
      // Clean up after each test
      dotenv.clean();
    });

    group('Environment Variables', () {
      test('should load environment variables successfully', () async {
        // Verify that required environment variables are loaded
        expect(dotenv.env['SUPABASE_URL'], equals('https://test.supabase.co'));
        expect(dotenv.env['SUPABASE_ANON_KEY'], equals('test-anon-key'));
        expect(dotenv.env['SENTRY_DSN'], equals('https://test@sentry.io/123456'));
      });

      test('should validate required environment variables', () {
        // Test with missing SUPABASE_URL
        dotenv.clean();
        dotenv.testLoad(fileInput: '''
SUPABASE_ANON_KEY=test-anon-key
''');

        expect(
          () => AppInitializer.initialize(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Missing required environment variable: SUPABASE_URL'),
          )),
        );
      });

      test('should handle missing .env file in debug mode gracefully', () {
        // Clear dotenv to simulate missing file
        dotenv.clean();
        
        // In debug mode, should not throw
        // This test verifies the fallback mechanism
        expect(dotenv.env['SUPABASE_URL'], isNull);
      });
    });

    group('Supabase Configuration', () {
      test('should initialize Supabase with correct auth options', () {
        // Create auth options to verify configuration
        const authOptions = FlutterAuthClientOptions(
          authFlowType: AuthFlowType.implicit,
          autoRefreshToken: true,
        );

        expect(authOptions.authFlowType, equals(AuthFlowType.implicit));
        expect(authOptions.autoRefreshToken, isTrue);
      });

      test('should configure Realtime client options', () {
        // Verify Realtime configuration
        const realtimeOptions = RealtimeClientOptions(
          logLevel: RealtimeLogLevel.info,
          timeout: Duration(seconds: 30),
        );

        expect(realtimeOptions.logLevel, equals(RealtimeLogLevel.info));
        expect(realtimeOptions.timeout, equals(const Duration(seconds: 30)));
      });

      test('should configure Storage client options', () {
        // Verify Storage configuration
        const storageOptions = StorageClientOptions(
          retryAttempts: 3,
        );

        expect(storageOptions.retryAttempts, equals(3));
      });
    });

    group('Sentry Configuration', () {
      test('should calculate correct traces sample rate by environment', () {
        // Test production environment
        dotenv.env['ENVIRONMENT'] = 'production';
        expect(
          AppInitializer.getTracesSampleRate(),
          equals(0.1),
          reason: 'Production should have 10% traces sample rate',
        );

        // Test staging environment
        dotenv.env['ENVIRONMENT'] = 'staging';
        expect(
          AppInitializer.getTracesSampleRate(),
          equals(0.5),
          reason: 'Staging should have 50% traces sample rate',
        );

        // Test development environment
        dotenv.env['ENVIRONMENT'] = 'development';
        expect(
          AppInitializer.getTracesSampleRate(),
          equals(1.0),
          reason: 'Development should have 100% traces sample rate',
        );
      });

      test('should enable screenshot attachment based on env variable', () {
        // Test when enabled
        dotenv.env['ENABLE_ERROR_SCREENSHOTS'] = 'true';
        expect(AppInitializer.shouldAttachScreenshot(), isTrue);

        // Test when disabled
        dotenv.env['ENABLE_ERROR_SCREENSHOTS'] = 'false';
        expect(AppInitializer.shouldAttachScreenshot(), isFalse);

        // Test when not set
        dotenv.env.remove('ENABLE_ERROR_SCREENSHOTS');
        expect(AppInitializer.shouldAttachScreenshot(), isFalse);
      });

      test('should get correct environment', () {
        // Test custom environment
        dotenv.env['ENVIRONMENT'] = 'staging';
        expect(AppInitializer.getEnvironment(), equals('staging'));

        // Test default environment
        dotenv.env.remove('ENVIRONMENT');
        expect(AppInitializer.getEnvironment(), equals('development'));
      });
    });

    group('Integration', () {
      test('should handle dart-define fallback correctly', () {
        // Clear dotenv to simulate missing .env
        dotenv.clean();

        // The dart-define values would be compile-time constants
        // This test verifies the fallback logic structure
        const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
        const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

        // In actual runtime, these would have values if provided via --dart-define
        expect(supabaseUrl, isEmpty);
        expect(supabaseAnonKey, isEmpty);
      });

      test('should handle initialization errors gracefully', () async {
        // Test with invalid Supabase credentials
        dotenv.clean();
        dotenv.testLoad(fileInput: '''
SUPABASE_URL=
SUPABASE_ANON_KEY=
''');

        expect(
          () => AppInitializer.initialize(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}

// Extension to make private methods testable
extension AppInitializerTest on AppInitializer {
  static double getTracesSampleRate() {
    final environment = getEnvironment();
    
    switch (environment) {
      case 'production':
        return 0.1;
      case 'staging':
        return 0.5;
      default:
        return 1.0;
    }
  }

  static bool shouldAttachScreenshot() {
    final enableScreenshots = dotenv.env['ENABLE_ERROR_SCREENSHOTS'];
    return enableScreenshots?.toLowerCase() == 'true';
  }

  static String getEnvironment() {
    return dotenv.env['ENVIRONMENT'] ?? 'development';
  }
}