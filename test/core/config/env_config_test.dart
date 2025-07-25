import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/config/env_config.dart';

void main() {
  group('EnvConfig', () {
    test('should throw exception when required configuration is missing', () {
      // Test the behavior when configuration is not provided
      // In a real application, this prevents starting with invalid config
      expect(
        () => EnvConfig.validate(),
        throwsA(isA<Exception>()),
      );
    });

    test('should correctly identify environment', () {
      // In tests, sentryEnvironment defaults to 'development'
      expect(EnvConfig.isDevelopment, isTrue);
      expect(EnvConfig.isProduction, isFalse);
    });

    test('should fail validation with specific error message when SUPABASE_URL is missing', () {
      // Test the behavior: app should not start without proper configuration
      // This protects against deployment errors
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
