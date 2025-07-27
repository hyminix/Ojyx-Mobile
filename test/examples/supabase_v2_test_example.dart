import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../helpers/supabase_v2_test_helpers.dart';

/// Exemple de test utilisant les patterns Supabase v2 actuels
void main() {
  group('Supabase v2 Test Examples', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;

    setUp(() {
      mockAuth = MockGoTrueClient();
      mockSupabase = createMockSupabaseClient(auth: mockAuth);

      // Setup auth stubs
      setupAuthStubs(mockAuth);
    });

    test('should fetch room by code - SELECT query with execute()', () async {
      // Prepare test data
      final roomData = SupabaseTestFixtures.createRoomFixture(
        code: 'TEST123',
        playerIds: ['player1', 'player2'],
      );

      // Setup query builder mock
      setupQueryBuilder(
        client: mockSupabase,
        table: 'rooms',
        response: [roomData], // Return as list for select
      );

      // Execute query with v2 pattern (.execute())
      final response = await mockSupabase
          .from('rooms')
          .select()
          .eq('code', 'TEST123')
          .execute();

      // Verify
      expect(response.data, isA<List>());
      expect((response.data as List).first['code'], 'TEST123');
    });

    test('should fetch single room - SINGLE query with execute()', () async {
      // Prepare test data
      final roomData = SupabaseTestFixtures.createRoomFixture(
        id: 'room-123',
        code: 'SINGLE',
      );

      // Setup query builder mock
      setupQueryBuilder(
        client: mockSupabase,
        table: 'rooms',
        response: roomData, // Return as single object for single()
      );

      // Execute query with single() and execute()
      final response = await mockSupabase
          .from('rooms')
          .select()
          .eq('id', 'room-123')
          .single()
          .execute();

      // Verify
      expect(response.data, isA<Map<String, dynamic>>());
      expect(response.data['id'], 'room-123');
    });

    test('should insert new room - INSERT query with execute()', () async {
      // Prepare test data
      final newRoom = {
        'code': 'NEW123',
        'creator_id': 'user-123',
        'status': 'waiting',
      };

      final insertedRoom = SupabaseTestFixtures.createRoomFixture(
        id: 'generated-id',
        code: 'NEW123',
        creatorId: 'user-123',
      );

      // Setup query builder mock
      setupQueryBuilder(
        client: mockSupabase,
        table: 'rooms',
        response: [insertedRoom],
      );

      // Execute insert
      final response = await mockSupabase
          .from('rooms')
          .insert(newRoom)
          .execute();

      // Verify
      expect(response.data, isA<List>());
      expect((response.data as List).first['id'], 'generated-id');
    });

    test('should handle database errors - PostgrestException', () async {
      // Setup query builder to throw error
      setupQueryBuilder(
        client: mockSupabase,
        table: 'rooms',
        error: PostgrestException(
          message: 'duplicate key value violates unique constraint',
          code: '23505',
        ),
      );

      // Execute and expect error
      expect(
        () => mockSupabase.from('rooms').insert({'code': 'DUP'}).execute(),
        throwsA(isA<PostgrestException>()),
      );
    });

    test('should handle auth flow', () async {
      // Test current user
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      expect(mockSupabase.auth.currentUser, isNotNull);
      expect(mockSupabase.auth.currentUser!.id, 'test-user-id');

      // Test anonymous sign in
      final mockAuthResponse = MockAuthResponse();
      final mockSession = MockSession();

      when(() => mockAuthResponse.user).thenReturn(mockUser);
      when(() => mockAuthResponse.session).thenReturn(mockSession);
      when(
        () => mockAuth.signInAnonymously(),
      ).thenAnswer((_) async => mockAuthResponse);

      final authResponse = await mockSupabase.auth.signInAnonymously();
      expect(authResponse.user, isNotNull);
    });

    test('should test v2 to v3 migration pattern', () async {
      // V2 pattern with execute()
      final roomDataV2 = [SupabaseTestFixtures.createRoomFixture()];

      setupQueryBuilder(
        client: mockSupabase,
        table: 'rooms',
        response: roomDataV2,
      );

      // V2 way
      final responseV2 = await mockSupabase
          .from('rooms')
          .select()
          .eq('code', 'TEST')
          .execute();

      expect(responseV2.data, roomDataV2);

      // V3 way (using then() which is also stubbed)
      final responseV3 = await mockSupabase
          .from('rooms')
          .select()
          .eq('code', 'TEST');

      expect(responseV3, roomDataV2);
    });

    test('should handle error checking patterns', () async {
      // V2 pattern - check response.error
      final mockResponse = MockPostgrestResponse();
      when(
        () => mockResponse.error,
      ).thenReturn(PostgrestException(message: 'Not found', code: '404'));
      when(() => mockResponse.data).thenReturn(null);

      // In real v2 code, you would check:
      // if (response.error != null) {
      //   throw response.error!;
      // }

      expect(mockResponse.error, isNotNull);
      expect(mockResponse.error!.message, 'Not found');
    });
  });
}
