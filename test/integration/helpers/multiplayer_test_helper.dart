import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:uuid/uuid.dart';

/// Helper class for multiplayer integration tests
class MultiplayerTestHelper {
  static const _uuid = Uuid();
  
  // Test Supabase clients for simulating multiple users
  final Map<String, SupabaseClient> _testClients = {};
  final Map<String, String> _userIds = {};
  final List<String> _createdRoomIds = [];
  final List<String> _createdGameIds = [];
  
  /// Initialize test helper with Supabase URL and anon key
  MultiplayerTestHelper({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) {
    // Initialize base client
    _initializeBaseClient(supabaseUrl, supabaseAnonKey);
  }
  
  void _initializeBaseClient(String url, String anonKey) {
    // Base client is initialized in Supabase.initialize
    // We'll create additional clients for each test user
  }
  
  /// Create a test user and return their client
  Future<SupabaseClient> createTestUser({
    required String username,
    String? email,
  }) async {
    email ??= '${username}_${_uuid.v4()}@test.ojyx.com';
    
    try {
      // Create new client for this user
      final client = SupabaseClient(
        Supabase.instance.client.supabaseUrl,
        Supabase.instance.client.supabaseKey,
      );
      
      // Sign in anonymously
      final response = await client.auth.signInAnonymously();
      
      if (response.user == null) {
        throw Exception('Failed to create anonymous user');
      }
      
      final userId = response.user!.id;
      
      // Create player record
      await client.from('players').upsert({
        'id': userId,
        'username': username,
        'email': email,
        'connection_status': 'online',
        'last_seen': DateTime.now().toIso8601String(),
      });
      
      _testClients[username] = client;
      _userIds[username] = userId;
      
      return client;
    } catch (e) {
      throw Exception('Failed to create test user $username: $e');
    }
  }
  
  /// Create a test room
  Future<Room> createTestRoom({
    required String creatorUsername,
    required String roomName,
    int maxPlayers = 4,
    String roomType = 'public',
  }) async {
    final client = _testClients[creatorUsername];
    if (client == null) {
      throw Exception('User $creatorUsername not found');
    }
    
    final roomId = _uuid.v4();
    final creatorId = _userIds[creatorUsername]!;
    
    try {
      final response = await client.from('rooms').insert({
        'id': roomId,
        'name': roomName,
        'code': _generateRoomCode(),
        'max_players': maxPlayers,
        'room_type': roomType,
        'creator_id': creatorId,
        'player_ids': [creatorId],
        'player_count': 1,
        'status': 'waiting',
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();
      
      _createdRoomIds.add(roomId);
      
      // Join player to room
      await client.from('players').update({
        'current_room_id': roomId,
      }).eq('id', creatorId);
      
      return Room(
        id: response['id'],
        name: response['name'],
        code: response['code'],
        maxPlayers: response['max_players'],
        playerCount: response['player_count'],
        status: response['status'],
        creatorId: response['creator_id'],
        createdAt: DateTime.parse(response['created_at']),
      );
    } catch (e) {
      throw Exception('Failed to create room: $e');
    }
  }
  
  /// Join a user to a room
  Future<void> joinRoom({
    required String username,
    required String roomId,
  }) async {
    final client = _testClients[username];
    if (client == null) {
      throw Exception('User $username not found');
    }
    
    final userId = _userIds[username]!;
    
    try {
      // Get current room state
      final roomResponse = await client
          .from('rooms')
          .select()
          .eq('id', roomId)
          .single();
      
      final currentPlayerIds = List<String>.from(roomResponse['player_ids'] ?? []);
      
      if (currentPlayerIds.contains(userId)) {
        return; // Already in room
      }
      
      if (currentPlayerIds.length >= roomResponse['max_players']) {
        throw Exception('Room is full');
      }
      
      // Update room
      currentPlayerIds.add(userId);
      await client.from('rooms').update({
        'player_ids': currentPlayerIds,
        'player_count': currentPlayerIds.length,
      }).eq('id', roomId);
      
      // Update player
      await client.from('players').update({
        'current_room_id': roomId,
      }).eq('id', userId);
    } catch (e) {
      throw Exception('Failed to join room: $e');
    }
  }
  
  /// Leave a room
  Future<void> leaveRoom({
    required String username,
    required String roomId,
  }) async {
    final client = _testClients[username];
    if (client == null) {
      throw Exception('User $username not found');
    }
    
    final userId = _userIds[username]!;
    
    try {
      // Get current room state
      final roomResponse = await client
          .from('rooms')
          .select()
          .eq('id', roomId)
          .single();
      
      final currentPlayerIds = List<String>.from(roomResponse['player_ids'] ?? []);
      currentPlayerIds.remove(userId);
      
      // Update room
      await client.from('rooms').update({
        'player_ids': currentPlayerIds,
        'player_count': currentPlayerIds.length,
      }).eq('id', roomId);
      
      // Update player
      await client.from('players').update({
        'current_room_id': null,
      }).eq('id', userId);
    } catch (e) {
      throw Exception('Failed to leave room: $e');
    }
  }
  
  /// Start a game in a room
  Future<GameState> startGame({
    required String roomId,
  }) async {
    // Get room info
    final client = Supabase.instance.client;
    final roomResponse = await client
        .from('rooms')
        .select()
        .eq('id', roomId)
        .single();
    
    final playerIds = List<String>.from(roomResponse['player_ids'] ?? []);
    
    if (playerIds.length < 2) {
      throw Exception('Not enough players to start game');
    }
    
    final gameId = _uuid.v4();
    
    try {
      // Create game state
      final gameResponse = await client.from('game_states').insert({
        'id': gameId,
        'room_id': roomId,
        'status': 'playing',
        'game_phase': 'playing',
        'current_player_index': 0,
        'turn_number': 1,
        'round_number': 1,
        'direction': 'clockwise',
        'deck_count': 52,
        'action_cards_deck_count': 20,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();
      
      _createdGameIds.add(gameId);
      
      // Update room status
      await client.from('rooms').update({
        'status': 'in_game',
        'current_game_id': gameId,
      }).eq('id', roomId);
      
      // Create player grids
      for (int i = 0; i < playerIds.length; i++) {
        await client.from('player_grids').insert({
          'id': _uuid.v4(),
          'game_state_id': gameId,
          'player_id': playerIds[i],
          'cards': _generateInitialCards(),
          'revealed_cards': List.filled(12, false),
          'action_cards': [],
        });
      }
      
      return GameState(
        id: gameResponse['id'],
        roomId: gameResponse['room_id'],
        status: GameStatus.playing,
        currentPlayerIndex: gameResponse['current_player_index'],
        turnNumber: gameResponse['turn_number'],
        roundNumber: gameResponse['round_number'],
        turnDirection: TurnDirection.clockwise,
        players: [],
        deckCount: gameResponse['deck_count'],
        actionCardsDeckCount: gameResponse['action_cards_deck_count'],
      );
    } catch (e) {
      throw Exception('Failed to start game: $e');
    }
  }
  
  /// Simulate a player disconnection
  Future<void> simulateDisconnection({
    required String username,
  }) async {
    final client = _testClients[username];
    if (client == null) {
      throw Exception('User $username not found');
    }
    
    final userId = _userIds[username]!;
    
    // Update connection status
    await client.from('players').update({
      'connection_status': 'offline',
      'last_seen': DateTime.now().toIso8601String(),
    }).eq('id', userId);
    
    // Close the client's realtime connection
    await client.realtime.disconnect();
  }
  
  /// Simulate a player reconnection
  Future<void> simulateReconnection({
    required String username,
  }) async {
    final client = _testClients[username];
    if (client == null) {
      throw Exception('User $username not found');
    }
    
    final userId = _userIds[username]!;
    
    // Reconnect realtime
    await client.realtime.connect();
    
    // Update connection status
    await client.from('players').update({
      'connection_status': 'online',
      'last_seen': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }
  
  /// Wait for a condition with timeout
  Future<void> waitForCondition({
    required Future<bool> Function() condition,
    Duration timeout = const Duration(seconds: 10),
    Duration checkInterval = const Duration(milliseconds: 100),
  }) async {
    final endTime = DateTime.now().add(timeout);
    
    while (DateTime.now().isBefore(endTime)) {
      if (await condition()) {
        return;
      }
      await Future.delayed(checkInterval);
    }
    
    throw TimeoutException('Condition not met within timeout');
  }
  
  /// Get room state
  Future<Map<String, dynamic>> getRoomState(String roomId) async {
    final response = await Supabase.instance.client
        .from('rooms')
        .select()
        .eq('id', roomId)
        .single();
    
    return response;
  }
  
  /// Get game state
  Future<Map<String, dynamic>> getGameState(String gameId) async {
    final response = await Supabase.instance.client
        .from('game_states')
        .select()
        .eq('id', gameId)
        .single();
    
    return response;
  }
  
  /// Clean up all test data
  Future<void> cleanup() async {
    try {
      // Delete game states and related data
      for (final gameId in _createdGameIds) {
        await Supabase.instance.client
            .from('player_grids')
            .delete()
            .eq('game_state_id', gameId);
        
        await Supabase.instance.client
            .from('game_states')
            .delete()
            .eq('id', gameId);
      }
      
      // Delete rooms
      for (final roomId in _createdRoomIds) {
        await Supabase.instance.client
            .from('rooms')
            .delete()
            .eq('id', roomId);
      }
      
      // Delete test users
      for (final userId in _userIds.values) {
        await Supabase.instance.client
            .from('players')
            .delete()
            .eq('id', userId);
      }
      
      // Close all client connections
      for (final client in _testClients.values) {
        await client.dispose();
      }
      
      _testClients.clear();
      _userIds.clear();
      _createdRoomIds.clear();
      _createdGameIds.clear();
    } catch (e) {
      print('Cleanup error: $e');
    }
  }
  
  /// Generate a room code
  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    
    for (int i = 0; i < 6; i++) {
      code += chars[(random + i) % chars.length];
    }
    
    return code;
  }
  
  /// Generate initial cards for a player
  List<Map<String, dynamic>> _generateInitialCards() {
    final cards = <Map<String, dynamic>>[];
    final values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    
    for (int i = 0; i < 12; i++) {
      cards.add({
        'id': _uuid.v4(),
        'value': values[i % values.length],
        'suit': ['hearts', 'diamonds', 'clubs', 'spades'][i % 4],
        'position': i,
      });
    }
    
    return cards;
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => 'TimeoutException: $message';
}