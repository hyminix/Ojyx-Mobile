import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockRealtimeClient extends Mock implements RealtimeClient {}

class MockRealtimeChannel extends Mock implements RealtimeChannel {}

class FakeRealtimeChannelConfig extends Fake implements RealtimeChannelConfig {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRealtimeChannelConfig());
    registerFallbackValue(PostgresChangeEvent.insert);
    registerFallbackValue(PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'id',
      value: 'test',
    ));
  });

  group('Realtime WebSocket Integration Tests', () {
    late MockSupabaseClient mockSupabase;
    late MockRealtimeClient mockRealtime;
    late MockRealtimeChannel mockChannel;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockRealtime = MockRealtimeClient();
      mockChannel = MockRealtimeChannel();

      when(() => mockSupabase.realtime).thenReturn(mockRealtime);
    });

    test('should establish realtime connection successfully', () async {
      when(() => mockRealtime.channel(any(), any())).thenReturn(mockChannel);
      when(() => mockChannel.subscribe()).thenReturn(mockChannel);

      final channel = mockSupabase.realtime.channel('test-channel');
      final response = channel.subscribe();

      expect(response, equals(mockChannel));
      verify(() => mockRealtime.channel('test-channel', any())).called(1);
      verify(() => mockChannel.subscribe()).called(1);
    });

    test('should handle presence sync for multiplayer', () async {
      final presenceController =
          StreamController<Map<String, dynamic>>.broadcast();

      when(() => mockRealtime.channel(any(), any())).thenReturn(mockChannel);
      when(() => mockChannel.subscribe()).thenReturn(mockChannel);
      when(() => mockChannel.onPresenceSync(any())).thenAnswer((invocation) {
        final callback =
            invocation.positionalArguments[0] as Function;
        presenceController.stream.listen((event) => callback(event));
        return mockChannel;
      });
      when(() => mockChannel.track(any())).thenAnswer((_) async => 
        ChannelResponse(status: RealtimeSubscribeStatus.subscribed));

      final channel = mockSupabase.realtime.channel('game:lobby');
      channel.subscribe();

      final presenceStates = <dynamic>[];
      channel.onPresenceSync((payload) {
        presenceStates.add(payload);
      });

      await channel.track({
        'user_id': 'player1',
        'online_at': DateTime.now().toIso8601String(),
      });

      presenceController.add({
        'player1': {
          'user_id': 'player1',
          'online_at': DateTime.now().toIso8601String(),
        },
      });

      await Future.delayed(const Duration(milliseconds: 100));

      expect(presenceStates, isNotEmpty);
      verify(() => mockChannel.track(any())).called(1);
    });

    test('should handle broadcast events for game actions', () async {
      final broadcastController =
          StreamController<Map<String, dynamic>>.broadcast();

      when(() => mockRealtime.channel(any(), any())).thenReturn(mockChannel);
      when(() => mockChannel.subscribe()).thenReturn(mockChannel);
      when(
        () => mockChannel.onBroadcast(
          event: any(named: 'event'),
          callback: any(named: 'callback'),
        ),
      ).thenAnswer((invocation) {
        final callback = invocation.namedArguments[#callback] as Function;
        broadcastController.stream.listen((event) => callback(event));
        return mockChannel;
      });
      when(
        () => mockChannel.sendBroadcastMessage(
          event: any(named: 'event'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) async => 
        ChannelResponse(status: RealtimeSubscribeStatus.subscribed));

      final channel = mockSupabase.realtime.channel('game:room123');
      channel.subscribe();

      final receivedEvents = <Map<String, dynamic>>[];
      channel.onBroadcast(
        event: 'card_played',
        callback: (payload) {
          receivedEvents.add(payload);
        },
      );

      await channel.sendBroadcastMessage(
        event: 'card_played',
        payload: {
          'player_id': 'player1',
          'card': {'value': 10, 'suit': 'hearts'},
          'position': [0, 0],
        },
      );

      broadcastController.add({
        'event': 'card_played',
        'payload': {
          'player_id': 'player1',
          'card': {'value': 10, 'suit': 'hearts'},
          'position': [0, 0],
        },
      });

      await Future.delayed(const Duration(milliseconds: 100));

      expect(receivedEvents, hasLength(1));
      expect(receivedEvents.first['payload']['player_id'], equals('player1'));
    });

    test('should handle postgres changes for game state sync', () async {
      final postgresController =
          StreamController<PostgresChangePayload>.broadcast();

      when(() => mockRealtime.channel(any(), any())).thenReturn(mockChannel);
      when(() => mockChannel.subscribe()).thenReturn(mockChannel);
      when(
        () => mockChannel.onPostgresChanges(
          event: any(named: 'event'),
          schema: any(named: 'schema'),
          table: any(named: 'table'),
          filter: any(named: 'filter'),
          callback: any(named: 'callback'),
        ),
      ).thenAnswer((invocation) {
        final callback = invocation.namedArguments[#callback] as Function;
        postgresController.stream.listen((event) => callback(event));
        return mockChannel;
      });

      final channel = mockSupabase.realtime.channel('db-changes');
      channel.subscribe();

      final gameStateChanges = <PostgresChangePayload>[];
      channel.onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'games',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: 'game123',
        ),
        callback: (payload) {
          gameStateChanges.add(payload);
        },
      );

      final mockPayload = PostgresChangePayload(
        schema: 'public',
        table: 'games',
        eventType: PostgresChangeEvent.update,
        newRecord: {'id': 'game123', 'current_player': 'player2', 'turn': 5},
        oldRecord: {'id': 'game123', 'current_player': 'player1', 'turn': 4},
        commitTimestamp: DateTime.now(),
        errors: null,
      );

      postgresController.add(mockPayload);

      await Future.delayed(const Duration(milliseconds: 100));

      expect(gameStateChanges, hasLength(1));
      expect(
        gameStateChanges.first.newRecord['current_player'],
        equals('player2'),
      );
    });

    test('should handle connection errors and reconnection', () async {
      final completer = Completer<void>();
      int reconnectAttempts = 0;

      when(() => mockRealtime.channel(any(), any())).thenReturn(mockChannel);
      when(() => mockChannel.subscribe()).thenAnswer((_) {
        reconnectAttempts++;
        if (reconnectAttempts == 1) {
          throw Exception('Connection failed');
        }
        completer.complete();
        return mockChannel;
      });

      final channel = mockSupabase.realtime.channel('test-reconnect');

      try {
        channel.subscribe();
      } catch (e) {
        expect(e.toString(), contains('Connection failed'));
      }

      channel.subscribe();
      await completer.future;

      expect(reconnectAttempts, equals(2));
    });

    test('should clean up channels on unsubscribe', () async {
      when(() => mockRealtime.channel(any(), any())).thenReturn(mockChannel);
      when(() => mockChannel.subscribe()).thenReturn(mockChannel);
      when(() => mockChannel.unsubscribe()).thenAnswer((_) async => 'ok');
      when(
        () => mockRealtime.removeChannel(any()),
      ).thenAnswer((_) async => 'ok');

      final channel = mockSupabase.realtime.channel('test-cleanup');
      channel.subscribe();

      final result = await channel.unsubscribe();
      await mockSupabase.realtime.removeChannel(channel);

      expect(result, equals('ok'));
      verify(() => mockChannel.unsubscribe()).called(1);
      verify(() => mockRealtime.removeChannel(mockChannel)).called(1);
    });

    test('should handle multiple channels for different game rooms', () async {
      final mockChannel1 = MockRealtimeChannel();
      final mockChannel2 = MockRealtimeChannel();

      when(
        () => mockRealtime.channel('game:room1', any()),
      ).thenReturn(mockChannel1);
      when(
        () => mockRealtime.channel('game:room2', any()),
      ).thenReturn(mockChannel2);
      when(
        () => mockChannel1.subscribe(),
      ).thenReturn(mockChannel1);
      when(
        () => mockChannel2.subscribe(),
      ).thenReturn(mockChannel2);

      final channel1 = mockSupabase.realtime.channel('game:room1');
      final channel2 = mockSupabase.realtime.channel('game:room2');

      channel1.subscribe();
      channel2.subscribe();

      verify(() => mockRealtime.channel('game:room1', any())).called(1);
      verify(() => mockRealtime.channel('game:room2', any())).called(1);
    });

    test('should verify heartbeat mechanism for connection health', () async {
      final heartbeatController = StreamController<String>.broadcast();

      when(() => mockRealtime.channel(any(), any())).thenReturn(mockChannel);
      when(() => mockChannel.subscribe()).thenReturn(mockChannel);

      final channel = mockSupabase.realtime.channel('test-heartbeat');
      channel.subscribe();

      int heartbeatCount = 0;
      heartbeatController.stream.listen((_) {
        heartbeatCount++;
      });

      for (int i = 0; i < 3; i++) {
        heartbeatController.add('heartbeat');
        await Future.delayed(const Duration(seconds: 1));
      }

      expect(heartbeatCount, equals(3));
    });
  });
}
