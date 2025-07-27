import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/errors/supabase_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SupabaseExceptionHandler Retry Logic', () {
    test('should retry network errors with exponential backoff', () async {
      var callCount = 0;
      final attemptTimes = <DateTime>[];

      try {
        await SupabaseExceptionHandler.handleSupabaseCall(
          call: () async {
            callCount++;
            attemptTimes.add(DateTime.now());
            throw const SocketException('Network error');
          },
          operation: 'test_network_error',
          maxRetries: 3,
          retryDelay: const Duration(seconds: 1),
        );
      } catch (e) {
        expect(e.toString(), contains('Erreur de connexion réseau'));
      }

      // Should have attempted 3 times
      expect(callCount, equals(3));
      expect(attemptTimes.length, equals(3));

      // Check exponential backoff delays
      if (attemptTimes.length >= 2) {
        final firstDelay = attemptTimes[1].difference(attemptTimes[0]);
        expect(firstDelay.inMilliseconds, greaterThanOrEqualTo(900)); // ~1s
        expect(firstDelay.inMilliseconds, lessThan(1300));
      }

      if (attemptTimes.length >= 3) {
        final secondDelay = attemptTimes[2].difference(attemptTimes[1]);
        expect(secondDelay.inMilliseconds, greaterThanOrEqualTo(1900)); // ~2s
        expect(secondDelay.inMilliseconds, lessThan(2300));
      }
    });

    test('should NOT retry PostgrestException', () async {
      var callCount = 0;

      try {
        await SupabaseExceptionHandler.handleSupabaseCall(
          call: () async {
            callCount++;
            throw PostgrestException(
              message: 'Duplicate key',
              code: '23505',
            );
          },
          operation: 'test_postgrest',
          maxRetries: 3,
        );
      } catch (e) {
        expect(e.toString(), contains('Cette donnée existe déjà'));
        expect(e.toString(), contains('Code: 23505'));
      }

      // Should only try once (no retry for database errors)
      expect(callCount, equals(1));
    });

    test('should retry TimeoutException', () async {
      var callCount = 0;

      try {
        await SupabaseExceptionHandler.handleSupabaseCall(
          call: () async {
            callCount++;
            throw TimeoutException('Request timeout');
          },
          operation: 'test_timeout',
          maxRetries: 2,
          retryDelay: const Duration(milliseconds: 100),
        );
      } catch (e) {
        expect(e.toString(), contains('La connexion a pris trop de temps'));
      }

      expect(callCount, equals(2));
    });

    test('should NOT retry AuthException', () async {
      var callCount = 0;

      try {
        await SupabaseExceptionHandler.handleSupabaseCall(
          call: () async {
            callCount++;
            throw const AuthException('Invalid login credentials');
          },
          operation: 'test_auth',
          maxRetries: 3,
        );
      } catch (e) {
        expect(e.toString(), contains('Identifiants incorrects'));
      }

      // Should only try once (no retry for auth errors)
      expect(callCount, equals(1));
    });

    test('should return successful result after retry', () async {
      var callCount = 0;

      final result = await SupabaseExceptionHandler.handleSupabaseCall(
        call: () async {
          callCount++;
          if (callCount < 2) {
            throw const SocketException('Network error');
          }
          return {'success': true, 'attempt': callCount};
        },
        operation: 'test_eventual_success',
        maxRetries: 3,
        retryDelay: const Duration(milliseconds: 100),
      );

      expect(result['success'], isTrue);
      expect(result['attempt'], equals(2));
      expect(callCount, equals(2));
    });

    test('should respect custom shouldRetry function', () async {
      var callCount = 0;

      try {
        await SupabaseExceptionHandler.handleSupabaseCall(
          call: () async {
            callCount++;
            if (callCount == 1) {
              throw Exception('retry this');
            } else {
              throw Exception('do not retry');
            }
          },
          operation: 'test_custom',
          maxRetries: 3,
          retryDelay: const Duration(milliseconds: 100),
          shouldRetry: (error) {
            return error.toString().contains('retry this');
          },
        );
      } catch (e) {
        expect(e.toString(), contains('do not retry'));
      }

      // Should try twice: first throws "retry this", second throws "do not retry"
      expect(callCount, equals(2));
    });

    test('exponential backoff should cap at 30 seconds', () {
      // Test the backoff calculation logic
      const baseDelay = Duration(seconds: 1);
      
      // Test various attempts
      final testCases = [
        (1, 1),   // 2^0 = 1s
        (2, 2),   // 2^1 = 2s
        (3, 4),   // 2^2 = 4s
        (4, 8),   // 2^3 = 8s
        (5, 16),  // 2^4 = 16s
        (6, 30),  // 2^5 = 32s -> capped at 30s
        (7, 30),  // 2^6 = 64s -> capped at 30s
      ];

      for (final (attempt, expectedSeconds) in testCases) {
        final multiplier = 1 << (attempt - 1);
        final delay = baseDelay * multiplier;
        final actualDelay = delay.inSeconds > 30 
            ? const Duration(seconds: 30) 
            : delay;
        
        expect(actualDelay.inSeconds, equals(expectedSeconds),
            reason: 'Attempt $attempt should have delay of ${expectedSeconds}s');
      }
    });

    test('should handle mixed error types correctly', () async {
      var callCount = 0;
      final errors = [
        const SocketException('Network error'), // Will retry
        TimeoutException('Timeout'), // Will retry
        PostgrestException(message: 'DB error', code: '23505'), // Won't retry
      ];

      try {
        await SupabaseExceptionHandler.handleSupabaseCall(
          call: () async {
            if (callCount < errors.length) {
              final error = errors[callCount];
              callCount++;
              throw error;
            }
            return {'success': true};
          },
          operation: 'test_mixed_errors',
          maxRetries: 5,
          retryDelay: const Duration(milliseconds: 100),
        );
      } catch (e) {
        // Should fail with PostgrestException
        expect(e.toString(), contains('Cette donnée existe déjà'));
      }

      // Should try 3 times: network error (retry), timeout (retry), postgrest (no retry)
      expect(callCount, equals(3));
    });
  });
}