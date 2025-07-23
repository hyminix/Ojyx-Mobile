import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/config/env_config.dart';

void main() {
  group('EnvConfig', () {
    test('should have default values', () {
      // Since we can't test String.fromEnvironment directly in unit tests,
      // we test the expected behavior and document the contract
      
      // These will be empty in tests but populated via --dart-define in builds
      expect(EnvConfig.supabaseUrl, isEmpty);
      expect(EnvConfig.supabaseAnonKey, isEmpty);
      expect(EnvConfig.sentryDsn, isEmpty);
      expect(EnvConfig.sentryEnvironment, equals('development'));
    });

    test('should correctly identify environment', () {
      // In tests, sentryEnvironment defaults to 'development'
      expect(EnvConfig.isDevelopment, isTrue);
      expect(EnvConfig.isProduction, isFalse);
    });

    test('should validate required configuration', () {
      // Since values are empty in tests, validation should fail
      expect(
        () => EnvConfig.validate(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('SUPABASE_URL is not configured'),
          ),
        ),
      );
    });

    test('should validate in order of priority', () {
      // This test documents the validation order
      // 1. SUPABASE_URL (always required)
      // 2. SUPABASE_ANON_KEY (always required)  
      // 3. SENTRY_DSN (only in production)
      
      // Since we can't mock String.fromEnvironment,
      // we document the expected behavior
      expect(EnvConfig.validate, throwsException);
    });
  });
}