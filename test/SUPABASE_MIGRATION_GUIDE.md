# Guide de Migration des Tests Supabase v2 vers v3

## Vue d'ensemble

Ce guide documente la migration des tests utilisant Supabase v2 vers les patterns compatibles avec la v3.

## Changements Principaux

### 1. Authentification

#### Avant (v2)
```dart
// Sign in
await supabase.auth.signIn(email: email, password: password);

// Sign out  
await supabase.auth.signOut();

// Current user
final user = supabase.auth.user;

// Auth state changes
supabase.auth.onAuthStateChange((event, session) {
  // Handle auth change
});
```

#### Après (v3)
```dart
// Sign in
await supabase.auth.signInWithPassword(email: email, password: password);

// Sign out
await supabase.auth.signOut();

// Current user
final user = supabase.auth.currentUser;

// Auth state changes
supabase.auth.onAuthStateChange.listen((data) {
  final event = data.event;
  final session = data.session;
  // Handle auth change
});
```

### 2. Database Queries

#### Avant (v2)
```dart
// Select with execute()
final response = await supabase
    .from('rooms')
    .select()
    .eq('code', roomCode)
    .execute();

if (response.error != null) {
  throw response.error!;
}

final data = response.data as List;
```

#### Après (v3)
```dart
// Select without execute()
try {
  final data = await supabase
      .from('rooms')
      .select()
      .eq('code', roomCode);
  
  // data is directly the result
} on PostgrestException catch (error) {
  // Handle error
}

// Single row
final room = await supabase
    .from('rooms')
    .select()
    .eq('id', roomId)
    .single();

// Optional single row
final room = await supabase
    .from('rooms')
    .select()
    .eq('id', roomId)
    .maybeSingle();
```

### 3. Realtime

#### Avant (v2)
```dart
// Subscribe to changes
final subscription = supabase
    .from('rooms:room_id=eq.$roomId')
    .on(SupabaseEventTypes.all, (payload) {
      // Handle change
    })
    .subscribe();

// Unsubscribe
await subscription.unsubscribe();
```

#### Après (v3)
```dart
// Create channel
final channel = supabase.channel('room:$roomId');

// Subscribe to postgres changes
channel.onPostgresChanges(
  event: PostgresChangeEvent.all,
  schema: 'public',
  table: 'rooms',
  filter: PostgresChangeFilter(
    type: PostgresChangeFilterType.eq,
    column: 'room_id',
    value: roomId,
  ),
  callback: (payload) {
    // Handle change
  },
);

// Subscribe to broadcast
channel.onBroadcast(
  event: 'game_update',
  callback: (payload) {
    // Handle broadcast
  },
);

// Subscribe to presence
channel.onPresenceSync((payload) {
  // Handle presence sync
}).onPresenceJoin((payload) {
  // Handle presence join
}).onPresenceLeave((payload) {
  // Handle presence leave
});

// Subscribe
await channel.subscribe();

// Unsubscribe
await channel.unsubscribe();
```

### 4. Edge Functions

#### Avant (v2)
```dart
final response = await supabase.functions.invoke(
  'function-name',
  body: {'key': 'value'},
);

if (response.error != null) {
  throw response.error!;
}

final data = response.data;
```

#### Après (v3)
```dart
try {
  final response = await supabase.functions.invoke(
    'function-name',
    body: {'key': 'value'},
  );
  
  final data = response.data;
} on FunctionException catch (error) {
  // Handle error
}
```

## Patterns de Test avec supabase_test_helpers.dart

### 1. Mock Basic Setup

```dart
import '../helpers/supabase_test_helpers.dart';

void main() {
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;

  setUp(() {
    mockAuth = MockGoTrueClient();
    mockSupabase = createMockSupabaseClient(auth: mockAuth);
    
    // Setup auth stubs
    setupAuthStubs(mockAuth);
  });

  test('should authenticate user', () async {
    // Test implementation
  });
}
```

### 2. Mock Database Queries

```dart
test('should fetch room by code', () async {
  // Setup query builder
  final roomData = SupabaseTestFixtures.createRoomFixture(
    code: 'TEST123',
    playerIds: ['player1', 'player2'],
  );
  
  setupQueryBuilder(
    client: mockSupabase,
    table: 'rooms',
    response: [roomData], // List for select
  );

  // Execute query
  final result = await repository.findRoomByCode('TEST123');
  
  // Verify
  expect(result.code, 'TEST123');
});

test('should handle single row', () async {
  final roomData = SupabaseTestFixtures.createRoomFixture();
  
  setupQueryBuilder(
    client: mockSupabase,
    table: 'rooms',
    response: [roomData], // Will return first item for single()
  );

  final result = await repository.getRoomById('room-id');
  expect(result, isNotNull);
});

test('should handle database errors', () async {
  setupQueryBuilder(
    client: mockSupabase,
    table: 'rooms',
    error: PostgrestException(
      message: 'Room not found',
      code: 'PGRST116',
    ),
  );

  expect(
    () => repository.getRoomById('invalid-id'),
    throwsPostgrestException(code: 'PGRST116'),
  );
});
```

### 3. Mock Realtime

```dart
test('should handle realtime updates', () async {
  final channel = setupRealtimeChannel(
    topic: 'room:test-room-id',
  );
  
  when(() => mockSupabase.channel(any())).thenReturn(channel);

  // Setup callback capture
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

  // Subscribe
  await repository.subscribeToRoomUpdates('test-room-id');

  // Simulate update
  capturedCallback?.call({
    'eventType': 'UPDATE',
    'new': {'status': 'playing'},
    'old': {'status': 'waiting'},
  });

  // Verify handling
  verify(() => channel.subscribe()).called(1);
});
```

### 4. Mock Auth State Changes

```dart
test('should react to auth state changes', () async {
  final authStateController = StreamController<AuthState>.broadcast();
  
  when(() => mockAuth.onAuthStateChange).thenAnswer(
    (_) => authStateController.stream,
  );

  // Listen to auth changes
  final states = <AuthChangeEvent>[];
  repository.authStateChanges.listen((event) {
    states.add(event);
  });

  // Simulate sign in
  authStateController.add(
    AuthState(
      event: AuthChangeEvent.signedIn,
      session: MockSession(),
    ),
  );

  await Future.delayed(Duration.zero);
  expect(states, contains(AuthChangeEvent.signedIn));
});
```

### 5. Test Helpers Usage

```dart
test('should use realtime test helper', () async {
  final realtimeHelper = RealtimeTestHelper();
  
  // Setup channel to use helper's stream
  final channel = MockRealtimeChannel();
  final stream = realtimeHelper.getController('test-channel').stream;
  
  // Simulate events
  realtimeHelper.simulatePostgresChange(
    channel: 'test-channel',
    table: 'rooms',
    eventType: 'INSERT',
    newRecord: {'id': '123', 'status': 'waiting'},
  );

  realtimeHelper.simulateBroadcast(
    channel: 'test-channel',
    event: 'game_update',
    payload: {'action': 'start_game'},
  );

  // Clean up
  addTearDown(() => realtimeHelper.dispose());
});
```

## Migration Checklist

- [ ] Remplacer `signIn()` par `signInWithPassword()`
- [ ] Remplacer `.execute()` par direct await
- [ ] Remplacer `response.error` checks par try/catch PostgrestException
- [ ] Remplacer `supabase.auth.user` par `supabase.auth.currentUser`
- [ ] Migrer subscriptions Realtime vers channels
- [ ] Utiliser `single()` et `maybeSingle()` appropriés
- [ ] Adapter error handling pour les nouvelles exceptions typées
- [ ] Utiliser les nouveaux test helpers de `supabase_test_helpers.dart`

## Exemples de Tests Migrés

Voir les fichiers suivants pour des exemples complets :
- `test/features/multiplayer/data/datasources/supabase_room_datasource_impl_test_v3.dart`
- `test/features/auth/presentation/providers/auth_provider_test_v3.dart`
- `test/integration/supabase_auth_flow_test_v3.dart`