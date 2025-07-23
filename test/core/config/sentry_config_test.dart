import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ojyx/core/config/sentry_config.dart';
import 'package:flutter/foundation.dart';

void main() {
  group('SentryConfig', () {
    test('should initialize Sentry in debug mode without DSN', () async {
      // Arrange
      bool appRunnerCalled = false;
      Future<void> appRunner() async {
        appRunnerCalled = true;
      }

      // Act
      // In debug mode with empty DSN, it should run the app without Sentry
      await SentryConfig.initialize(appRunner: appRunner);

      // Assert
      expect(appRunnerCalled, isTrue);
    });

    test('should capture exception with extra data', () {
      // Arrange
      final exception = Exception('Test exception');
      final stackTrace = StackTrace.current;
      final extra = {'userId': '123', 'action': 'test'};

      // Act & Assert
      // This tests that the method can be called without errors
      // Actual Sentry integration would require mocking
      expect(
        () => SentryConfig.captureException(
          exception,
          stackTrace: stackTrace,
          extra: extra,
        ),
        returnsNormally,
      );
    });

    test('should capture message with level and extra data', () {
      // Arrange
      const message = 'Test message';
      const level = SentryLevel.warning;
      final extra = {'context': 'test'};

      // Act & Assert
      expect(
        () => SentryConfig.captureMessage(
          message,
          level: level,
          extra: extra,
        ),
        returnsNormally,
      );
    });

    test('should start transaction', () {
      // Arrange
      const name = 'test-transaction';
      const operation = 'test-operation';

      // Act
      final transaction = SentryConfig.startTransaction(name, operation);

      // Assert
      // In test environment without Sentry init, this returns null
      expect(transaction, isNull);
    });

    test('should set user with data', () {
      // Arrange
      const userId = 'test-user-123';
      final userData = {'email': 'test@example.com'};

      // Act & Assert
      expect(
        () => SentryConfig.setUser(userId, data: userData),
        returnsNormally,
      );
    });

    test('should clear user when null', () {
      // Act & Assert
      expect(
        () => SentryConfig.setUser(null),
        returnsNormally,
      );
    });
  });
}