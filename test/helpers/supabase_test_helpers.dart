import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:postgrest/postgrest.dart';
import 'package:realtime_client/realtime_client.dart' as realtime;

/// Mock implementation for SupabaseClient v3
class MockSupabaseClient extends Mock implements SupabaseClient {}

/// Mock implementation for GoTrueClient (Auth)
class MockGoTrueClient extends Mock implements GoTrueClient {}

/// Mock implementation for RealtimeClient
class MockRealtimeClient extends Mock implements RealtimeClient {}

/// Mock implementation for RealtimeChannel
class MockRealtimeChannel extends Mock implements RealtimeChannel {}

/// Mock implementation for PostgrestClient
class MockPostgrestClient extends Mock implements PostgrestClient {}

/// Mock implementation for PostgrestFilterBuilder
class MockPostgrestFilterBuilder<T> extends Mock
    implements PostgrestFilterBuilder<T> {}

/// Mock implementation for PostgrestBuilder
class MockPostgrestBuilder<T> extends Mock implements PostgrestBuilder<T> {}

/// Mock implementation for PostgrestQueryBuilder
class MockPostgrestQueryBuilder<T> extends Mock
    implements PostgrestQueryBuilder<T> {}

/// Mock implementation for User
class MockUser extends Mock implements User {
  @override
  String get id => 'test-user-id';
}

/// Mock implementation for Session
class MockSession extends Mock implements Session {}

/// Mock implementation for AuthResponse
class MockAuthResponse extends Mock implements AuthResponse {}

/// Helper to create a test SupabaseClient with all mocks configured
MockSupabaseClient createMockSupabaseClient({
  MockGoTrueClient? auth,
  MockRealtimeClient? realtime,
  MockPostgrestClient? rest,
}) {
  final client = MockSupabaseClient();
  final mockAuth = auth ?? MockGoTrueClient();
  final mockRealtime = realtime ?? MockRealtimeClient();
  final mockRest = rest ?? MockPostgrestClient();

  when(() => client.auth).thenReturn(mockAuth);
  when(() => client.realtime).thenReturn(mockRealtime);
  when(() => client.rest).thenReturn(mockRest);

  return client;
}

/// Setup common auth stubs for testing
void setupAuthStubs(MockGoTrueClient auth, {User? currentUser}) {
  final user = currentUser ?? MockUser();
  final session = MockSession();

  when(() => auth.currentUser).thenReturn(user);
  when(() => auth.currentSession).thenReturn(session);

  // Auth state changes stream
  final authStateController = StreamController<AuthState>.broadcast();
  when(() => auth.onAuthStateChange).thenAnswer((_) => authStateController.stream);

  // Sign in methods
  when(
    () => auth.signInWithPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenAnswer((_) async => MockAuthResponse());

  when(() => auth.signInAnonymously()).thenAnswer(
    (_) async => MockAuthResponse(),
  );

  // Sign out
  when(() => auth.signOut()).thenAnswer((_) async {});

  // Refresh session
  when(() => auth.refreshSession()).thenAnswer((_) async => MockAuthResponse());
}

/// Setup Realtime channel stubs
MockRealtimeChannel setupRealtimeChannel({
  required String topic,
  Map<String, dynamic>? params,
}) {
  final channel = MockRealtimeChannel();
  final presenceController = StreamController<RealtimePresencePayload>.broadcast();
  final broadcastController = StreamController<Map<String, dynamic>>.broadcast();
  final postgresController = StreamController<Map<String, dynamic>>.broadcast();

  // Basic channel properties
  when(() => channel.topic).thenReturn(topic);
  when(() => channel.params).thenReturn(params ?? {});

  // Subscribe
  when(() => channel.subscribe()).thenAnswer((_) async => channel);

  // Unsubscribe
  when(() => channel.unsubscribe()).thenAnswer((_) async => 'ok');

  // Presence
  when(
    () => channel.onPresenceSync(any()),
  ).thenReturn(channel);

  when(
    () => channel.onPresenceJoin(any()),
  ).thenReturn(channel);

  when(
    () => channel.onPresenceLeave(any()),
  ).thenReturn(channel);

  // Broadcast
  when(
    () => channel.onBroadcast(
      event: any(named: 'event'),
      callback: any(named: 'callback'),
    ),
  ).thenReturn(channel);

  when(
    () => channel.sendBroadcastMessage(
      event: any(named: 'event'),
      payload: any(named: 'payload'),
    ),
  ).thenAnswer((_) async => 'ok');

  // Postgres changes
  when(
    () => channel.onPostgresChanges(
      event: any(named: 'event'),
      schema: any(named: 'schema'),
      table: any(named: 'table'),
      filter: any(named: 'filter'),
      callback: any(named: 'callback'),
    ),
  ).thenReturn(channel);

  return channel;
}

/// Setup database query builder mocks
MockPostgrestFilterBuilder<T> setupQueryBuilder<T>({
  required MockSupabaseClient client,
  required String table,
  T? response,
  PostgrestException? error,
}) {
  final queryBuilder = MockPostgrestQueryBuilder<T>();
  final filterBuilder = MockPostgrestFilterBuilder<T>();

  // Setup client.from()
  when(() => client.from(table)).thenReturn(queryBuilder);

  // Setup query builder methods
  when(() => queryBuilder.select(any())).thenReturn(filterBuilder);
  when(() => queryBuilder.insert(any())).thenReturn(filterBuilder);
  when(() => queryBuilder.update(any())).thenReturn(filterBuilder);
  when(() => queryBuilder.delete()).thenReturn(filterBuilder);
  when(() => queryBuilder.upsert(any())).thenReturn(filterBuilder);

  // Setup filter builder methods
  setupFilterBuilderStubs(filterBuilder, response: response, error: error);

  return filterBuilder;
}

/// Setup filter builder stubs
void setupFilterBuilderStubs<T>(
  MockPostgrestFilterBuilder<T> filterBuilder, {
  T? response,
  PostgrestException? error,
}) {
  // Chainable filter methods
  when(() => filterBuilder.eq(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.neq(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.gt(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.gte(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.lt(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.lte(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.like(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.ilike(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.is_(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.in_(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.contains(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.containedBy(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.rangeGt(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.rangeGte(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.rangeLt(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.rangeLte(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.rangeAdjacent(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.overlaps(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.textSearch(any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.match(any())).thenReturn(filterBuilder);
  when(() => filterBuilder.not(any(), any(), any())).thenReturn(filterBuilder);
  when(() => filterBuilder.or(any())).thenReturn(filterBuilder);
  when(() => filterBuilder.filter(any(), any(), any())).thenReturn(filterBuilder);

  // Order and limit
  when(() => filterBuilder.order(any(), ascending: any(named: 'ascending')))
      .thenReturn(filterBuilder);
  when(() => filterBuilder.limit(any())).thenReturn(filterBuilder);
  when(() => filterBuilder.range(any(), any())).thenReturn(filterBuilder);

  // Terminal methods
  if (error != null) {
    when(() => filterBuilder.then(any())).thenThrow(error);
    when(() => filterBuilder.single()).thenThrow(error);
    when(() => filterBuilder.maybeSingle()).thenThrow(error);
  } else {
    final future = Future.value(response);
    when(() => filterBuilder.then(any())).thenAnswer((invocation) {
      final callback = invocation.positionalArguments[0] as Function;
      return future.then((value) => callback(value));
    });

    // Special handling for single() and maybeSingle()
    if (response is List && (response as List).isNotEmpty) {
      when(() => filterBuilder.single()).thenAnswer((_) async => (response as List).first);
      when(() => filterBuilder.maybeSingle()).thenAnswer((_) async => (response as List).first);
    } else if (response is List && (response as List).isEmpty) {
      when(() => filterBuilder.single()).thenThrow(
        PostgrestException(
          message: 'Row not found',
          code: 'PGRST116',
        ),
      );
      when(() => filterBuilder.maybeSingle()).thenAnswer((_) async => null);
    } else {
      when(() => filterBuilder.single()).thenAnswer((_) async => response);
      when(() => filterBuilder.maybeSingle()).thenAnswer((_) async => response);
    }
  }
}

/// Helper to create test fixtures for Supabase responses
class SupabaseTestFixtures {
  /// Create a test room response
  static Map<String, dynamic> createRoomFixture({
    String? id,
    String? code,
    String? creatorId,
    List<String>? playerIds,
    String? status,
    DateTime? createdAt,
  }) {
    return {
      'id': id ?? 'test-room-id',
      'code': code ?? 'TEST123',
      'creator_id': creatorId ?? 'test-creator-id',
      'player_ids': playerIds ?? ['test-player-1', 'test-player-2'],
      'status': status ?? 'waiting',
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
    };
  }

  /// Create a test game state response
  static Map<String, dynamic> createGameStateFixture({
    String? roomId,
    List<Map<String, dynamic>>? players,
    List<int>? deck,
    List<int>? discardPile,
    int? currentPlayerIndex,
    String? turnDirection,
    bool? lastRound,
    String? initiatorPlayerId,
    String? status,
  }) {
    return {
      'room_id': roomId ?? 'test-room-id',
      'players': players ?? [],
      'deck': deck ?? List.generate(100, (i) => i % 13 - 2),
      'discard_pile': discardPile ?? [5],
      'current_player_index': currentPlayerIndex ?? 0,
      'turn_direction': turnDirection ?? 'clockwise',
      'last_round': lastRound ?? false,
      'initiator_player_id': initiatorPlayerId,
      'status': status ?? 'playing',
    };
  }

  /// Create a test player response
  static Map<String, dynamic> createPlayerFixture({
    String? id,
    String? name,
    String? roomId,
    bool? isHost,
    int? position,
  }) {
    return {
      'id': id ?? 'test-player-id',
      'name': name ?? 'Test Player',
      'room_id': roomId ?? 'test-room-id',
      'is_host': isHost ?? false,
      'position': position ?? 0,
    };
  }
}

/// Extension to add async error matchers
extension AsyncErrorMatchers on Future {
  /// Verify that a future throws a PostgrestException
  Future<void> throwsPostgrestException({
    String? code,
    String? message,
  }) async {
    try {
      await this;
      fail('Expected PostgrestException but no exception was thrown');
    } on PostgrestException catch (e) {
      if (code != null) {
        expect(e.code, code);
      }
      if (message != null) {
        expect(e.message, contains(message));
      }
    }
  }

  /// Verify that a future throws an AuthException
  Future<void> throwsAuthException({
    String? message,
    String? statusCode,
  }) async {
    try {
      await this;
      fail('Expected AuthException but no exception was thrown');
    } on AuthException catch (e) {
      if (message != null) {
        expect(e.message, contains(message));
      }
      if (statusCode != null) {
        expect(e.statusCode, statusCode);
      }
    }
  }
}

/// Test helper to simulate realtime events
class RealtimeTestHelper {
  final Map<String, StreamController<Map<String, dynamic>>> _controllers = {};

  /// Get or create a stream controller for a channel
  StreamController<Map<String, dynamic>> getController(String channel) {
    return _controllers.putIfAbsent(
      channel,
      () => StreamController<Map<String, dynamic>>.broadcast(),
    );
  }

  /// Simulate a postgres change event
  void simulatePostgresChange({
    required String channel,
    required String table,
    required String eventType,
    Map<String, dynamic>? newRecord,
    Map<String, dynamic>? oldRecord,
  }) {
    final controller = getController(channel);
    controller.add({
      'table': table,
      'eventType': eventType,
      'new': newRecord,
      'old': oldRecord,
    });
  }

  /// Simulate a broadcast event
  void simulateBroadcast({
    required String channel,
    required String event,
    required Map<String, dynamic> payload,
  }) {
    final controller = getController(channel);
    controller.add({
      'event': event,
      'payload': payload,
    });
  }

  /// Simulate presence sync
  void simulatePresenceSync({
    required String channel,
    required Map<String, dynamic> state,
  }) {
    final controller = getController(channel);
    controller.add({
      'type': 'sync',
      'state': state,
    });
  }

  /// Clean up all controllers
  void dispose() {
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}