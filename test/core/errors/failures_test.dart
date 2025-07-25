import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/errors/failures.dart';

void main() {
  group('Failure', () {
    test('should create all Failure types correctly', () {
      // Define test cases for all failure types
      final testCases = [
        // ServerFailure
        () {
          const message = 'Server error occurred';
          final error = Exception('Connection failed');
          final stackTrace = StackTrace.current;
          final failure = Failure.server(
            message: message,
            error: error,
            stackTrace: stackTrace,
          );
          
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, equals(message));
          expect(failure.error, equals(error));
          expect(failure.stackTrace, equals(stackTrace));
        },
        // NetworkFailure
        () {
          const message = 'Network connection lost';
          final error = Exception('No internet');
          final failure = Failure.network(message: message, error: error);
          
          expect(failure, isA<NetworkFailure>());
          expect((failure as NetworkFailure).message, equals(message));
          expect(failure.error, equals(error));
        },
        // ValidationFailure
        () {
          const message = 'Validation failed';
          final errors = {
            'username': 'Username is required',
            'password': 'Password too short',
          };
          final failure = Failure.validation(message: message, errors: errors);
          
          expect(failure, isA<ValidationFailure>());
          expect((failure as ValidationFailure).message, equals(message));
          expect(failure.errors, equals(errors));
        },
        // GameLogicFailure
        () {
          const message = 'Invalid move';
          const code = 'INVALID_CARD_PLACEMENT';
          final failure = Failure.gameLogic(message: message, code: code);
          
          expect(failure, isA<GameLogicFailure>());
          expect((failure as GameLogicFailure).message, equals(message));
          expect(failure.code, equals(code));
        },
        // AuthenticationFailure
        () {
          const message = 'Authentication failed';
          const code = 'INVALID_CREDENTIALS';
          final failure = Failure.authentication(message: message, code: code);
          
          expect(failure, isA<AuthenticationFailure>());
          expect((failure as AuthenticationFailure).message, equals(message));
          expect(failure.code, equals(code));
        },
        // TimeoutFailure
        () {
          const message = 'Request timed out';
          const duration = Duration(seconds: 30);
          final failure = Failure.timeout(message: message, duration: duration);
          
          expect(failure, isA<TimeoutFailure>());
          expect((failure as TimeoutFailure).message, equals(message));
          expect(failure.duration, equals(duration));
        },
        // UnknownFailure
        () {
          const message = 'An unknown error occurred';
          final error = 'Something went wrong';
          final stackTrace = StackTrace.current;
          final failure = Failure.unknown(
            message: message,
            error: error,
            stackTrace: stackTrace,
          );
          
          expect(failure, isA<UnknownFailure>());
          expect((failure as UnknownFailure).message, equals(message));
          expect(failure.error, equals(error));
          expect(failure.stackTrace, equals(stackTrace));
        },
      ];

      // Execute all test cases
      for (final testCase in testCases) {
        testCase();
      }
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
