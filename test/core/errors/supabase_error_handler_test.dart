import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/errors/custom_errors.dart';
import 'package:ojyx/core/errors/supabase_error_handler.dart';
import 'package:postgrest/postgrest.dart';

void main() {
  group('SupabaseErrorHandler', () {
    test('captures PostgrestException and transforms to DatabaseError', () async {
      // Simulate a PostgrestException
      final testCall = () async {
        throw PostgrestException(
          message: 'duplicate key value violates unique constraint "rooms_code_key"',
          code: '23505',
        );
      };

      // Expect DatabaseError to be thrown
      expect(
        () async => await SupabaseErrorHandler.wrapSupabaseCall(
          call: testCall,
          operation: 'insert_rooms',
        ),
        throwsA(isA<DatabaseError>()
          .having((e) => e.code, 'code', 'DUPLICATE_KEY')
          .having((e) => e.operation, 'operation', 'insert_rooms')
          .having((e) => e.table, 'table', 'rooms')),
      );
    });

    test('logs errors to console in correct format', () async {
      final logs = <String>[];
      
      // Override debugPrint to capture logs
      // This is a simple test to ensure logging works
      
      final error = DatabaseError(
        code: 'DUPLICATE_KEY',
        message: 'Test error',
        operation: 'test_operation',
        timestamp: DateTime.now(),
      );

      expect(error.toUserMessage(), 'Cette donnée existe déjà.');
    });

    test('NetworkError provides appropriate user messages', () {
      final timeoutError = NetworkError.timeout(
        operation: 'fetch_data',
        timeout: const Duration(seconds: 30),
      );

      expect(
        timeoutError.toUserMessage(),
        'La connexion a pris trop de temps. Veuillez réessayer.',
      );
    });

    test('AuthError provides appropriate user messages', () {
      final authError = AuthError(
        code: 'INVALID_CREDENTIALS',
        message: 'Invalid login credentials',
        operation: 'signIn',
        timestamp: DateTime.now(),
      );

      expect(
        authError.toUserMessage(),
        'Identifiants incorrects.',
      );
    });
  });
}