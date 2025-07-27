import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../helpers/supabase_test_helpers.dart';

/// Exemple de test utilisant les patterns Supabase v3
void main() {
  group('Supabase v3 Test Examples', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;

    setUp(() {
      mockAuth = MockGoTrueClient();
      mockSupabase = createMockSupabaseClient(auth: mockAuth);

      // Setup auth stubs
      setupAuthStubs(mockAuth);
    });

    test('should fetch room by code - SELECT query', () async {
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

      // Execute query
      final result = await mockSupabase
          .from('rooms')
          .select()
          .eq('code', 'TEST123');

      // Verify
      expect(result, isA<List>());
      expect(result.first['code'], 'TEST123');
    });

    test('should fetch single room - SINGLE query', () async {
      // Prepare test data
      final roomData = SupabaseTestFixtures.createRoomFixture(
        id: 'room-123',
        code: 'SINGLE',
      );

      // Setup query builder mock
      final filterBuilder = setupQueryBuilder(
        client: mockSupabase,
        table: 'rooms',
        response: [roomData], // Will return first item for single()
      );

      // Execute query with single()
      final result = await mockSupabase
          .from('rooms')
          .select()
          .eq('id', 'room-123')
          .single();

      // Verify
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], 'room-123');
    });

    test('should handle optional single - MAYBE SINGLE query', () async {
      // Setup query builder mock for empty result
      setupQueryBuilder(
        client: mockSupabase,
        table: 'rooms',
        response: [], // Empty list will return null for maybeSingle()
      );

      // Execute query with maybeSingle()
      final result = await mockSupabase
          .from('rooms')
          .select()
          .eq('code', 'NOTFOUND')
          .maybeSingle();

      // Verify
      expect(result, isNull);
    });

    test('should insert new room - INSERT query', () async {
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
      final result = await mockSupabase
          .from('rooms')
          .insert(newRoom)
          .select()
          .single();

      // Verify
      expect(result['id'], 'generated-id');
      expect(result['code'], 'NEW123');
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
        mockSupabase.from('rooms').insert({'code': 'DUP'}).select(),
        throwsPostgrestException(code: '23505', message: 'duplicate key'),
      );
    });

    test('should handle realtime subscription', () async {
      // Create mock channel
      final channel = setupRealtimeChannel(topic: 'room:room-123');

      // Setup channel return
      when(() => mockSupabase.channel(any())).thenReturn(channel);

      // Capture callbacks
      void Function(dynamic)? capturedCallback;
      when(
        () => channel.onPostgresChanges(
          event: any(named: 'event'),
          schema: any(named: 'schema'),
          table: any(named: 'table'),
          filter: any(named: 'filter'),
          callback: any(named: 'callback'),
        ),
      ).thenAnswer((invocation) {
        capturedCallback = invocation.namedArguments[#callback];
        return channel;
      });

      // Subscribe to changes
      final subscription = mockSupabase
          .channel('room:room-123')
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'rooms',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'id',
              value: 'room-123',
            ),
            callback: (payload) {
              // Handle update
            },
          )
          .subscribe();

      // Simulate an update
      capturedCallback?.call({
        'eventType': 'UPDATE',
        'table': 'rooms',
        'new': {'id': 'room-123', 'status': 'playing'},
        'old': {'id': 'room-123', 'status': 'waiting'},
      });

      // Verify subscription
      verify(() => channel.subscribe()).called(1);
    });

    test('should handle auth state changes', () async {
      // Create auth state stream
      final authStateController = StreamController<AuthState>.broadcast();

      when(
        () => mockAuth.onAuthStateChange,
      ).thenAnswer((_) => authStateController.stream);

      // Listen to auth changes
      final states = <AuthChangeEvent>[];
      mockAuth.onAuthStateChange.listen((data) {
        states.add(data.event);
      });

      // Simulate sign in
      authStateController.add(
        AuthState(event: AuthChangeEvent.signedIn, session: MockSession()),
      );

      // Wait for async processing
      await Future.delayed(Duration.zero);

      // Verify
      expect(states, contains(AuthChangeEvent.signedIn));

      // Clean up
      await authStateController.close();
    });

    test('should use RealtimeTestHelper for complex scenarios', () async {
      final realtimeHelper = RealtimeTestHelper();

      // Setup channel to use helper's stream
      final channel = MockRealtimeChannel();
      final stream = realtimeHelper.getController('test-channel').stream;

      // Capture events
      final events = <Map<String, dynamic>>[];
      stream.listen(events.add);

      // Simulate postgres change
      realtimeHelper.simulatePostgresChange(
        channel: 'test-channel',
        table: 'rooms',
        eventType: 'INSERT',
        newRecord: {'id': 'new-room', 'code': 'NEW456', 'status': 'waiting'},
      );

      // Simulate broadcast
      realtimeHelper.simulateBroadcast(
        channel: 'test-channel',
        event: 'game_update',
        payload: {'action': 'player_joined', 'playerId': 'player-123'},
      );

      // Wait for async processing
      await Future.delayed(Duration.zero);

      // Verify events
      expect(events, hasLength(2));
      expect(events[0]['table'], 'rooms');
      expect(events[1]['event'], 'game_update');

      // Clean up
      realtimeHelper.dispose();
    });
  });
}
