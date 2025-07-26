import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/core/utils/resilient_supabase_service.dart';
import 'package:ojyx/core/errors/supabase_error_handling.dart';

void main() {
  group('ResilientSupabaseService', () {
    group('withRetry', () {
      test('should execute operation successfully on first attempt', () async {
        var callCount = 0;
        final result = await ResilientSupabaseService.withRetry(() async {
          callCount++;
          return 'success';
        });

        expect(result, equals('success'));
        expect(callCount, equals(1));
      });

      test('should retry on retriable PostgrestException', () async {
        var callCount = 0;
        final result = await ResilientSupabaseService.withRetry(() async {
          callCount++;
          if (callCount < 3) {
            throw const PostgrestException(
              message: 'Transaction conflict',
              code: '40001', // Retriable error
            );
          }
          return 'success after retries';
        }, delay: const Duration(milliseconds: 10));

        expect(result, equals('success after retries'));
        expect(callCount, equals(3));
      });

      test('should not retry on non-retriable PostgrestException', () async {
        var callCount = 0;

        try {
          await ResilientSupabaseService.withRetry(() async {
            callCount++;
            throw const PostgrestException(
              message: 'Duplicate key',
              code: '23505', // Non-retriable error
            );
          });
          fail('Should have thrown exception');
        } on PostgrestException catch (e) {
          expect(e.code, equals('23505'));
          expect(callCount, equals(1));
        }
      });

      test('should retry on retriable AuthException', () async {
        var callCount = 0;
        final result = await ResilientSupabaseService.withRetry(() async {
          callCount++;
          if (callCount < 2) {
            throw const AuthException('Server error', statusCode: '500');
          }
          return 'success';
        }, delay: const Duration(milliseconds: 10));

        expect(result, equals('success'));
        expect(callCount, equals(2));
      });

      test('should respect max attempts', () async {
        var callCount = 0;

        try {
          await ResilientSupabaseService.withRetry(
            () async {
              callCount++;
              throw const PostgrestException(
                message: 'Transaction conflict',
                code: '40001',
              );
            },
            maxAttempts: 2,
            delay: const Duration(milliseconds: 10),
          );
          fail('Should have thrown exception');
        } on PostgrestException {
          expect(callCount, equals(2));
        }
      });

      test('should use custom shouldRetry callback', () async {
        var callCount = 0;

        try {
          await ResilientSupabaseService.withRetry(
            () async {
              callCount++;
              throw Exception('Custom error');
            },
            shouldRetry: (error) => error.toString().contains('Custom'),
            maxAttempts: 2,
            delay: const Duration(milliseconds: 10),
          );
          fail('Should have thrown exception');
        } catch (e) {
          expect(callCount, equals(2));
        }
      });

      test('should use exponential backoff', () async {
        final delays = <Duration>[];
        var lastTime = DateTime.now();
        var callCount = 0;

        try {
          await ResilientSupabaseService.withRetry(
            () async {
              callCount++;
              if (callCount > 1) {
                final now = DateTime.now();
                delays.add(now.difference(lastTime));
                lastTime = now;
              }
              throw const PostgrestException(
                message: 'Retry me',
                code: '40001',
              );
            },
            maxAttempts: 3,
            delay: const Duration(milliseconds: 100),
          );
        } catch (_) {
          // Expected
        }

        expect(delays.length, equals(2));
        // Second delay should be approximately twice the first
        expect(
          delays[1].inMilliseconds,
          greaterThan(delays[0].inMilliseconds * 1.5),
        );
      });
    });

    group('withTimeout', () {
      test('should complete operation within timeout', () async {
        final result = await ResilientSupabaseService.withTimeout(() async {
          await Future.delayed(const Duration(milliseconds: 100));
          return 'success';
        }, timeout: const Duration(seconds: 1));

        expect(result, equals('success'));
      });

      test('should throw AppException on timeout', () async {
        try {
          await ResilientSupabaseService.withTimeout(() async {
            await Future.delayed(const Duration(seconds: 2));
            return 'should not reach here';
          }, timeout: const Duration(milliseconds: 100));
          fail('Should have thrown timeout exception');
        } on AppException catch (e) {
          expect(e.message, equals('L\'opération a pris trop de temps'));
          expect(e.code, equals('TIMEOUT'));
          expect(e.isRetriable, isTrue);
        }
      });
    });

    group('resilientExecute', () {
      test('should combine retry and timeout', () async {
        var callCount = 0;
        final result = await ResilientSupabaseService.resilientExecute(
          () async {
            callCount++;
            if (callCount < 2) {
              throw const PostgrestException(
                message: 'Retry me',
                code: '40001',
              );
            }
            await Future.delayed(const Duration(milliseconds: 50));
            return 'success';
          },
          maxAttempts: 3,
          delay: const Duration(milliseconds: 10),
          timeout: const Duration(seconds: 1),
        );

        expect(result, equals('success'));
        expect(callCount, equals(2));
      });

      test('should timeout even with retries', () async {
        try {
          await ResilientSupabaseService.resilientExecute(() async {
            await Future.delayed(const Duration(seconds: 2));
            return 'should not reach';
          }, timeout: const Duration(milliseconds: 100));
          fail('Should have thrown timeout');
        } on AppException catch (e) {
          expect(e.code, equals('TIMEOUT'));
        }
      });
    });

    group('resilientStream', () {
      test('should emit values from stream', () async {
        final controller = StreamController<int>();
        var emissionCount = 0;

        final resilientStream = ResilientSupabaseService.resilientStream(
          () => controller.stream,
        );

        final subscription = resilientStream.listen((data) {
          emissionCount++;
        });

        controller.add(1);
        controller.add(2);
        controller.add(3);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(emissionCount, equals(3));

        await subscription.cancel();
        controller.close();
      });

      test('should attempt reconnection on error', () async {
        var streamCreationCount = 0;
        var errorCount = 0;
        StreamController<int>? currentController;

        final resilientStream = ResilientSupabaseService.resilientStream(
          () {
            streamCreationCount++;
            currentController?.close();
            currentController = StreamController<int>();

            if (streamCreationCount == 1) {
              // First stream will error
              Timer(const Duration(milliseconds: 50), () {
                currentController!.addError('Connection lost');
              });
            }

            return currentController!.stream;
          },
          maxReconnectAttempts: 3,
          reconnectDelay: const Duration(milliseconds: 10),
        );

        final subscription = resilientStream.listen(
          (data) {},
          onError: (error) {
            errorCount++;
          },
        );

        await Future.delayed(const Duration(milliseconds: 200));

        expect(streamCreationCount, greaterThan(1));
        expect(errorCount, greaterThan(0));

        await subscription.cancel();
        currentController?.close();
      });

      test('should stop reconnecting after max attempts', () async {
        var streamCreationCount = 0;
        var completedWithError = false;

        final resilientStream = ResilientSupabaseService.resilientStream(
          () {
            streamCreationCount++;
            return Stream<int>.error('Always fails');
          },
          maxReconnectAttempts: 2,
          reconnectDelay: const Duration(milliseconds: 10),
        );

        final subscription = resilientStream.listen(
          (data) {},
          onError: (error) {
            if (error is AppException && error.code == 'CONNECTION_LOST') {
              completedWithError = true;
            }
          },
        );

        await Future.delayed(const Duration(milliseconds: 200));

        expect(
          streamCreationCount,
          greaterThanOrEqualTo(2),
        ); // Initial + at least 1 reconnect
        expect(completedWithError, isTrue);

        await subscription.cancel();
      });

      test('should reset reconnect attempts on successful data', () async {
        var streamCreationCount = 0;
        var dataCount = 0;
        StreamController<int>? currentController;

        final resilientStream = ResilientSupabaseService.resilientStream(() {
          streamCreationCount++;
          currentController?.close();
          currentController = StreamController<int>();

          // Emit data then error
          Timer(const Duration(milliseconds: 20), () {
            currentController!.add(streamCreationCount);
          });

          Timer(const Duration(milliseconds: 40), () {
            currentController!.addError('Connection lost');
          });

          return currentController!.stream;
        }, reconnectDelay: const Duration(milliseconds: 10));

        final subscription = resilientStream.listen((data) {
          dataCount++;
        }, onError: (_) {});

        await Future.delayed(const Duration(milliseconds: 300));

        // Should have reconnected multiple times, each time emitting data
        expect(streamCreationCount, greaterThan(2));
        expect(dataCount, equals(streamCreationCount));

        await subscription.cancel();
        currentController?.close();
      });
    });
  });
}
