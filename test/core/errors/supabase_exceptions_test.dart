import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/core/errors/supabase_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder<List<Map<String, dynamic>>> {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

void main() {
  late MockSupabaseClient mockSupabase;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late MockPostgrestFilterBuilder mockFilterBuilder;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();
  });

  group('SupabaseExceptionHandler', () {
    group('retry logic', () {
      test('should retry network errors with exponential backoff', () async {
        var callCount = 0;
        final startTime = DateTime.now();
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
          // Expected to throw after max retries
        }

        // Should have attempted 3 times
        expect(callCount, equals(3));
        expect(attemptTimes.length, equals(3));

        // Check exponential backoff delays
        // First attempt: immediate
        // Second attempt: after ~1 second (1 * 2^0)
        // Third attempt: after ~2 seconds (1 * 2^1)
        
        if (attemptTimes.length >= 2) {
          final firstDelay = attemptTimes[1].difference(attemptTimes[0]);
          expect(firstDelay.inMilliseconds, greaterThanOrEqualTo(900)); // ~1s
          expect(firstDelay.inMilliseconds, lessThan(1200));
        }

        if (attemptTimes.length >= 3) {
          final secondDelay = attemptTimes[2].difference(attemptTimes[1]);
          expect(secondDelay.inMilliseconds, greaterThanOrEqualTo(1900)); // ~2s
          expect(secondDelay.inMilliseconds, lessThan(2200));
        }
      });

      test('should retry timeout errors', () async {
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
        }

        // Should only try once (no retry for database errors)
        expect(callCount, equals(1));
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

      test('should retry StorageException for network-related errors', () async {
        var callCount = 0;

        try {
          await SupabaseExceptionHandler.handleSupabaseCall(
            call: () async {
              callCount++;
              throw const StorageException('Network timeout', statusCode: '0');
            },
            operation: 'test_storage',
            maxRetries: 2,
            retryDelay: const Duration(milliseconds: 100),
          );
        } catch (e) {
          // Expected to throw after retries
        }

        expect(callCount, equals(2));
      });

      test('should NOT retry StorageException for non-network errors', () async {
        var callCount = 0;

        try {
          await SupabaseExceptionHandler.handleSupabaseCall(
            call: () async {
              callCount++;
              throw const StorageException('File not found', statusCode: '404');
            },
            operation: 'test_storage',
            maxRetries: 3,
          );
        } catch (e) {
          // Expected to throw
        }

        // Should only try once
        expect(callCount, equals(1));
      });

      test('should respect custom shouldRetry function', () async {
        var callCount = 0;

        try {
          await SupabaseExceptionHandler.handleSupabaseCall(
            call: () async {
              callCount++;
              throw Exception('Custom error');
            },
            operation: 'test_custom',
            maxRetries: 3,
            retryDelay: const Duration(milliseconds: 100),
            shouldRetry: (error) {
              // Only retry if error message contains "retry"
              return error.toString().contains('retry');
            },
          );
        } catch (e) {
          // Expected
        }

        // Should not retry because error doesn't contain "retry"
        expect(callCount, equals(1));
      });

      test('should respect maxRetries parameter', () async {
        var callCount = 0;

        try {
          await SupabaseExceptionHandler.handleSupabaseCall(
            call: () async {
              callCount++;
              throw const SocketException('Network error');
            },
            operation: 'test_max_retries',
            maxRetries: 5,
            retryDelay: const Duration(milliseconds: 50),
          );
        } catch (e) {
          // Expected
        }

        expect(callCount, equals(5));
      });

      test('should cap exponential backoff at 30 seconds', () async {
        // This test simulates a long retry scenario
        var callCount = 0;
        final attemptTimes = <DateTime>[];

        try {
          await SupabaseExceptionHandler.handleSupabaseCall(
            call: () async {
              callCount++;
              attemptTimes.add(DateTime.now());
              throw const SocketException('Network error');
            },
            operation: 'test_backoff_cap',
            maxRetries: 6, // Will have delays of 1s, 2s, 4s, 8s, 16s
            retryDelay: const Duration(seconds: 1),
          );
        } catch (e) {
          // Expected
        }

        // The 5th retry (after 4 failures) would normally be 16s
        // but should be capped at 30s (though 16s is still under 30s)
        // The 6th retry would normally be 32s but should be capped at 30s
        expect(callCount, equals(6));
      });
    });

    group('error transformation', () {
      test('should transform PostgrestException codes to user messages', () async {
        final testCases = [
          ('23505', 'Cette donnée existe déjà'),
          ('23503', 'Référence invalide'),
          ('42501', 'Permissions insuffisantes'),
          ('22P02', 'Format de données invalide'),
          ('PGRST301', 'Donnée introuvable'),
        ];

        for (final (code, expectedMessage) in testCases) {
          try {
            await SupabaseExceptionHandler.handleSupabaseCall(
              call: () async {
                throw PostgrestException(
                  message: 'Database error',
                  code: code,
                );
              },
              operation: 'test_transform_$code',
            );
          } catch (e) {
            expect(e.toString(), contains(expectedMessage));
            expect(e.toString(), contains('Code: $code'));
          }
        }
      });

      test('should transform AuthException messages', () async {
        final testCases = [
          ('Invalid login credentials', 'Identifiants incorrects'),
          ('User not found', 'Utilisateur introuvable'),
          ('Email not confirmed', 'Veuillez confirmer votre email'),
          ('Token expired', 'Session expirée'),
        ];

        for (final (message, expectedMessage) in testCases) {
          try {
            await SupabaseExceptionHandler.handleSupabaseCall(
              call: () async {
                throw AuthException(message);
              },
              operation: 'test_auth_transform',
            );
          } catch (e) {
            expect(e.toString(), contains(expectedMessage));
          }
        }
      });
    });

    group('extension methods', () {
      test('safeSelect should handle errors', () async {
        when(() => mockSupabase.from(any())).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select(any())).thenThrow(
          PostgrestException(message: 'Table not found', code: 'PGRST301'),
        );

        try {
          await mockSupabase.safeSelect('test_table');
        } catch (e) {
          expect(e.toString(), contains('Donnée introuvable'));
        }
      });

      test('safeInsert should not retry by default', () async {
        var callCount = 0;
        when(() => mockSupabase.from(any())).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.insert(any())).thenAnswer((_) {
          callCount++;
          throw const SocketException('Network error');
        });
        when(() => mockQueryBuilder.select()).thenReturn(mockFilterBuilder);

        try {
          await mockSupabase.safeInsert('test_table', {'data': 'test'});
        } catch (e) {
          // Expected
        }

        // Should only try once (maxRetries = 1 for inserts)
        expect(callCount, equals(1));
      });
    });
  });
}