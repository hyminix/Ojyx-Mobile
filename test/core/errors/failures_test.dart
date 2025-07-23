import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/errors/failures.dart';

void main() {
  group('Failure', () {
    test('should create ServerFailure with error details', () {
      // Arrange
      const message = 'Server error occurred';
      final error = Exception('Connection failed');
      final stackTrace = StackTrace.current;

      // Act
      final failure = Failure.server(
        message: message,
        error: error,
        stackTrace: stackTrace,
      );

      // Assert
      expect(failure, isA<ServerFailure>());
      failure.when(
        server: (msg, err, stack) {
          expect(msg, equals(message));
          expect(err, equals(error));
          expect(stack, equals(stackTrace));
        },
        network: (_, __, ___) => fail('Should be ServerFailure'),
        validation: (_, __) => fail('Should be ServerFailure'),
        gameLogic: (_, __) => fail('Should be ServerFailure'),
        authentication: (_, __) => fail('Should be ServerFailure'),
        timeout: (_, __) => fail('Should be ServerFailure'),
        unknown: (_, __, ___) => fail('Should be ServerFailure'),
      );
    });

    test('should create NetworkFailure', () {
      // Arrange
      const message = 'Network connection lost';
      final error = Exception('No internet');

      // Act
      final failure = Failure.network(
        message: message,
        error: error,
      );

      // Assert
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).message, equals(message));
      expect(failure.error, equals(error));
    });

    test('should create ValidationFailure with field errors', () {
      // Arrange
      const message = 'Validation failed';
      final errors = {
        'username': 'Username is required',
        'password': 'Password too short',
      };

      // Act
      final failure = Failure.validation(
        message: message,
        errors: errors,
      );

      // Assert
      expect(failure, isA<ValidationFailure>());
      expect((failure as ValidationFailure).message, equals(message));
      expect(failure.errors, equals(errors));
    });

    test('should create GameLogicFailure with code', () {
      // Arrange
      const message = 'Invalid move';
      const code = 'INVALID_CARD_PLACEMENT';

      // Act
      final failure = Failure.gameLogic(
        message: message,
        code: code,
      );

      // Assert
      expect(failure, isA<GameLogicFailure>());
      expect((failure as GameLogicFailure).message, equals(message));
      expect(failure.code, equals(code));
    });

    test('should create AuthenticationFailure', () {
      // Arrange
      const message = 'Authentication failed';
      const code = 'INVALID_CREDENTIALS';

      // Act
      final failure = Failure.authentication(
        message: message,
        code: code,
      );

      // Assert
      expect(failure, isA<AuthenticationFailure>());
      expect((failure as AuthenticationFailure).message, equals(message));
      expect(failure.code, equals(code));
    });

    test('should create TimeoutFailure with duration', () {
      // Arrange
      const message = 'Request timed out';
      const duration = Duration(seconds: 30);

      // Act
      final failure = Failure.timeout(
        message: message,
        duration: duration,
      );

      // Assert
      expect(failure, isA<TimeoutFailure>());
      expect((failure as TimeoutFailure).message, equals(message));
      expect(failure.duration, equals(duration));
    });

    test('should create UnknownFailure', () {
      // Arrange
      const message = 'An unknown error occurred';
      final error = 'Something went wrong';
      final stackTrace = StackTrace.current;

      // Act
      final failure = Failure.unknown(
        message: message,
        error: error,
        stackTrace: stackTrace,
      );

      // Assert
      expect(failure, isA<UnknownFailure>());
      expect((failure as UnknownFailure).message, equals(message));
      expect(failure.error, equals(error));
      expect(failure.stackTrace, equals(stackTrace));
    });

    test('should support equality', () {
      // Arrange
      const failure1 = Failure.gameLogic(
        message: 'Invalid move',
        code: 'INVALID_MOVE',
      );
      const failure2 = Failure.gameLogic(
        message: 'Invalid move',
        code: 'INVALID_MOVE',
      );
      const failure3 = Failure.gameLogic(
        message: 'Different message',
        code: 'INVALID_MOVE',
      );

      // Assert
      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
    });
  });
}