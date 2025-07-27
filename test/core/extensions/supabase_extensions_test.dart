import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/core/extensions/supabase_extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mocks
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockSupabaseStorageClient extends Mock implements SupabaseStorageClient {}
class MockStorageBucket extends Mock implements StorageBucket {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder {}
class MockAuthResponse extends Mock implements AuthResponse {}
class MockUser extends Mock implements User {}
class MockFileObject extends Mock implements FileObject {}

// Fakes for Mocktail
class FakeFileOptions extends Fake implements FileOptions {}
class FakeTransformOptions extends Fake implements TransformOptions {}
class FakeSearchOptions extends Fake implements SearchOptions {}

void main() {
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;
  late MockSupabaseStorageClient mockStorage;
  late MockStorageBucket mockBucket;

  setUpAll(() {
    registerFallbackValue(FakeFileOptions());
    registerFallbackValue(FakeTransformOptions());
    registerFallbackValue(FakeSearchOptions());
  });

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockStorage = MockSupabaseStorageClient();
    mockBucket = MockStorageBucket();

    when(() => mockSupabase.auth).thenReturn(mockAuth);
    when(() => mockSupabase.storage).thenReturn(mockStorage);
  });

  group('Database Extensions', () {
    test('safeSelect should handle successful query', () async {
      final mockBuilder = MockSupabaseQueryBuilder();
      final expectedData = [
        {'id': 1, 'name': 'Test 1'},
        {'id': 2, 'name': 'Test 2'},
      ];

      when(() => mockSupabase.from(any())).thenReturn(mockBuilder);
      when(() => mockBuilder.select(any())).thenAnswer((_) async => expectedData);

      final result = await mockSupabase.safeSelect('test_table');

      expect(result, equals(expectedData));
      verify(() => mockSupabase.from('test_table')).called(1);
      verify(() => mockBuilder.select('*')).called(1);
    });

    test('safeSelect with custom columns', () async {
      final mockBuilder = MockSupabaseQueryBuilder();
      final expectedData = [
        {'id': 1, 'title': 'Test Title'},
      ];

      when(() => mockSupabase.from(any())).thenReturn(mockBuilder);
      when(() => mockBuilder.select(any())).thenAnswer((_) async => expectedData);

      final result = await mockSupabase.safeSelect(
        'posts',
        columns: 'id, title',
      );

      expect(result, equals(expectedData));
      verify(() => mockBuilder.select('id, title')).called(1);
    });

    test('safeInsert should not retry by default', () async {
      final mockBuilder = MockSupabaseQueryBuilder();
      final mockFilter = MockPostgrestFilterBuilder();
      var callCount = 0;

      when(() => mockSupabase.from(any())).thenReturn(mockBuilder);
      when(() => mockBuilder.insert(any())).thenAnswer((_) {
        callCount++;
        if (callCount == 1) {
          throw const SocketException('Network error');
        }
        return mockFilter;
      });
      when(() => mockFilter.select()).thenAnswer((_) async => [{'id': 1}]);

      try {
        await mockSupabase.safeInsert('test_table', {'name': 'Test'});
      } catch (e) {
        // Expected to fail
      }

      expect(callCount, equals(1)); // Should not retry
    });

    test('safeUpdate should work with match parameter', () async {
      final mockBuilder = MockSupabaseQueryBuilder();
      final mockFilter = MockPostgrestFilterBuilder();
      final updatedData = [{'id': 1, 'name': 'Updated'}];

      when(() => mockSupabase.from(any())).thenReturn(mockBuilder);
      when(() => mockBuilder.update(any())).thenReturn(mockFilter);
      when(() => mockFilter.match(any())).thenReturn(mockFilter);
      when(() => mockFilter.select()).thenAnswer((_) async => updatedData);

      final result = await mockSupabase.safeUpdate(
        'test_table',
        {'name': 'Updated'},
        match: {'id': 1},
      );

      expect(result, equals(updatedData));
      verify(() => mockBuilder.update({'name': 'Updated'})).called(1);
      verify(() => mockFilter.match({'id': 1})).called(1);
    });

    test('safeRpc should retry by default', () async {
      var callCount = 0;
      final expectedResult = {'result': 'success'};

      when(() => mockSupabase.rpc(any(), params: any(named: 'params')))
          .thenAnswer((_) async {
        callCount++;
        if (callCount < 2) {
          throw const SocketException('Temporary network error');
        }
        return expectedResult;
      });

      final result = await mockSupabase.safeRpc<Map<String, dynamic>>(
        'test_function',
        params: {'input': 'test'},
      );

      expect(result, equals(expectedResult));
      expect(callCount, greaterThan(1)); // Should have retried
    });
  });

  group('Auth Extensions', () {
    test('safeSignInWithPassword should handle auth errors', () async {
      when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow(const AuthException('Invalid credentials'));

      try {
        await mockSupabase.safeSignInWithPassword(
          email: 'test@example.com',
          password: 'wrong_password',
        );
        fail('Should throw exception');
      } catch (e) {
        expect(e.toString(), contains('Identifiants incorrects'));
      }
    });

    test('safeCurrentUser should return null on error', () {
      when(() => mockAuth.currentUser).thenThrow(Exception('Auth error'));

      final user = mockSupabase.safeCurrentUser;
      expect(user, isNull);
    });

    test('safeSignUp should not retry', () async {
      var callCount = 0;

      when(() => mockAuth.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        data: any(named: 'data'),
      )).thenAnswer((_) async {
        callCount++;
        throw const AuthException('Email already exists');
      });

      try {
        await mockSupabase.safeSignUp(
          email: 'test@example.com',
          password: 'password123',
        );
      } catch (e) {
        // Expected
      }

      expect(callCount, equals(1)); // Should not retry auth operations
    });
  });

  group('Storage Extensions', () {
    test('safeUploadFile should handle upload with retry', () async {
      final testBytes = [1, 2, 3, 4, 5];
      var callCount = 0;

      when(() => mockStorage.from(any())).thenReturn(mockBucket);
      when(() => mockBucket.uploadBinary(
        any(),
        any(),
        fileOptions: any(named: 'fileOptions'),
      )).thenAnswer((_) async {
        callCount++;
        if (callCount < 2) {
          throw const StorageException('Network timeout', statusCode: '0');
        }
        return 'path/to/file.jpg';
      });

      final result = await mockSupabase.safeUploadFile(
        'avatars',
        'user123.jpg',
        testBytes,
      );

      expect(result, equals('path/to/file.jpg'));
      expect(callCount, equals(2)); // Should have retried once
    });

    test('safeGetPublicUrl should return empty string on error', () {
      when(() => mockStorage.from(any())).thenThrow(Exception('Storage error'));

      final url = mockSupabase.safeGetPublicUrl('avatars', 'test.jpg');
      expect(url, equals(''));
    });

    test('safeListFiles should retry on failure', () async {
      var callCount = 0;
      final mockFiles = [MockFileObject()];

      when(() => mockStorage.from(any())).thenReturn(mockBucket);
      when(() => mockBucket.list(
        path: any(named: 'path'),
        searchOptions: any(named: 'searchOptions'),
      )).thenAnswer((_) async {
        callCount++;
        if (callCount < 2) {
          throw const SocketException('Network error');
        }
        return mockFiles;
      });

      final result = await mockSupabase.safeListFiles('avatars');

      expect(result, equals(mockFiles));
      expect(callCount, equals(2));
    });
  });

  group('Utility Extensions', () {
    test('safeTransaction should wrap multiple operations', () async {
      final result = await mockSupabase.safeTransaction(
        () async {
          // Simulate multiple operations
          await Future.delayed(const Duration(milliseconds: 10));
          return {'success': true, 'id': 123};
        },
        operationName: 'create_user_with_profile',
      );

      expect(result['success'], isTrue);
      expect(result['id'], equals(123));
    });

    test('checkConnection should return false on error', () async {
      final mockBuilder = MockSupabaseQueryBuilder();
      final mockFilter = MockPostgrestFilterBuilder();

      when(() => mockSupabase.from(any())).thenReturn(mockBuilder);
      when(() => mockBuilder.select()).thenReturn(mockFilter);
      when(() => mockFilter.limit(any())).thenAnswer((_) async {
        throw PostgrestException(message: 'Table not found', code: 'PGRST301');
      });

      final isConnected = await mockSupabase.checkConnection();
      expect(isConnected, isFalse);
    });
  });

  group('Complex Scenarios', () {
    test('should handle upsert operations', () async {
      final mockBuilder = MockSupabaseQueryBuilder();
      final mockFilter = MockPostgrestFilterBuilder();
      final upsertedData = [{'id': 1, 'name': 'Upserted', 'count': 1}];

      when(() => mockSupabase.from(any())).thenReturn(mockBuilder);
      when(() => mockBuilder.upsert(any())).thenReturn(mockFilter);
      when(() => mockFilter.select()).thenAnswer((_) async => upsertedData);

      final result = await mockSupabase.safeInsert(
        'stats',
        {'id': 1, 'name': 'Upserted', 'count': 1},
        upsert: true,
      );

      expect(result, equals(upsertedData));
      verify(() => mockBuilder.upsert({'id': 1, 'name': 'Upserted', 'count': 1})).called(1);
    });

    test('should handle batch insert', () async {
      final mockBuilder = MockSupabaseQueryBuilder();
      final mockFilter = MockPostgrestFilterBuilder();
      final rows = [
        {'name': 'Item 1'},
        {'name': 'Item 2'},
        {'name': 'Item 3'},
      ];
      final insertedData = [
        {'id': 1, 'name': 'Item 1'},
        {'id': 2, 'name': 'Item 2'},
        {'id': 3, 'name': 'Item 3'},
      ];

      when(() => mockSupabase.from(any())).thenReturn(mockBuilder);
      when(() => mockBuilder.insert(any())).thenReturn(mockFilter);
      when(() => mockFilter.select()).thenAnswer((_) async => insertedData);

      final result = await mockSupabase.safeInsertMany('items', rows);

      expect(result, equals(insertedData));
      expect(result.length, equals(3));
    });
  });
}