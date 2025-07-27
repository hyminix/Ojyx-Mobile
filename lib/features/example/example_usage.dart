import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/extensions/supabase_extensions.dart';

/// Example usage of Supabase extensions with automatic error handling
class ExampleUsage {
  final _supabase = Supabase.instance.client;

  // ===== Database Examples =====
  
  /// Example: Get all rooms with automatic retry on network errors
  Future<List<Map<String, dynamic>>> getAllRooms() async {
    return await _supabase.safeSelect(
      'rooms',
      columns: 'id, status, player_ids, max_players',
      context: {'operation': 'list_rooms'},
    );
  }

  /// Example: Get a single user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      return await _supabase.safeSelectSingle(
        'profiles',
        context: {'user_id': userId},
      );
    } catch (e) {
      // Handle not found gracefully
      debugPrint('Profile not found: $e');
      return null;
    }
  }

  /// Example: Find rooms with available slots
  Future<List<Map<String, dynamic>>> getAvailableRooms() async {
    return await _supabase.safeSelectWhere(
      'rooms',
      column: 'status',
      value: 'waiting',
      columns: 'id, player_ids, max_players, created_at',
    );
  }

  /// Example: Create a new game room
  Future<Map<String, dynamic>?> createRoom({
    required String creatorId,
    required int maxPlayers,
  }) async {
    try {
      final result = await _supabase.safeInsert(
        'rooms',
        {
          'creator_id': creatorId,
          'player_ids': [creatorId],
          'status': 'waiting',
          'max_players': maxPlayers,
          'created_at': DateTime.now().toIso8601String(),
        },
        context: {
          'action': 'create_room',
          'creator': creatorId,
        },
      );
      return result.firstOrNull;
    } catch (e) {
      debugPrint('Failed to create room: $e');
      return null;
    }
  }

  /// Example: Update room status
  Future<bool> updateRoomStatus(String roomId, String newStatus) async {
    try {
      await _supabase.safeUpdate(
        'rooms',
        {
          'status': newStatus,
          'updated_at': DateTime.now().toIso8601String(),
        },
        match: {'id': roomId},
      );
      return true;
    } catch (e) {
      debugPrint('Failed to update room status: $e');
      return false;
    }
  }

  /// Example: Batch insert game events
  Future<bool> logGameEvents(List<Map<String, dynamic>> events) async {
    try {
      await _supabase.safeInsertMany(
        'game_events',
        events,
        context: {'event_count': events.length},
      );
      return true;
    } catch (e) {
      debugPrint('Failed to log events: $e');
      return false;
    }
  }

  /// Example: Delete old game sessions
  Future<int> cleanupOldSessions() async {
    try {
      final deleted = await _supabase.safeDelete(
        'game_sessions',
        match: {
          'status': 'ended',
          // Would need to use RPC for date comparison
        },
      );
      return deleted.length;
    } catch (e) {
      debugPrint('Cleanup failed: $e');
      return 0;
    }
  }

  /// Example: Call a database function
  Future<Map<String, dynamic>?> calculateGameStats(String gameId) async {
    try {
      return await _supabase.safeRpc<Map<String, dynamic>>(
        'calculate_game_stats',
        params: {'game_id': gameId},
        context: {'operation': 'stats_calculation'},
      );
    } catch (e) {
      debugPrint('Stats calculation failed: $e');
      return null;
    }
  }

  // ===== Auth Examples =====
  
  /// Example: User login with error handling
  Future<User?> loginUser(String email, String password) async {
    try {
      final response = await _supabase.safeSignInWithPassword(
        email: email,
        password: password,
        context: {'login_method': 'email'},
      );
      return response.user;
    } catch (e) {
      // Error is already user-friendly from the handler
      debugPrint('Login failed: $e');
      return null;
    }
  }

  /// Example: Register new user with profile
  Future<User?> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _supabase.safeSignUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      return response.user;
    } catch (e) {
      debugPrint('Registration failed: $e');
      return null;
    }
  }

  /// Example: Get current user safely
  User? getCurrentUser() {
    return _supabase.safeCurrentUser;
  }

  /// Example: Logout with cleanup
  Future<void> logout() async {
    try {
      await _supabase.safeSignOut();
      // Additional cleanup...
    } catch (e) {
      debugPrint('Logout error (non-critical): $e');
    }
  }

  // ===== Storage Examples =====
  
  /// Example: Upload avatar image
  Future<String?> uploadAvatar(String userId, List<int> imageBytes) async {
    try {
      final path = 'avatars/$userId.jpg';
      await _supabase.safeUploadFile(
        'user-content',
        path,
        imageBytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );
      
      // Get public URL
      return _supabase.safeGetPublicUrl('user-content', path);
    } catch (e) {
      debugPrint('Avatar upload failed: $e');
      return null;
    }
  }

  /// Example: Download game replay
  Future<List<int>?> downloadReplay(String gameId) async {
    try {
      return await _supabase.safeDownloadFile(
        'game-replays',
        '$gameId.replay',
        context: {'game_id': gameId},
      );
    } catch (e) {
      debugPrint('Replay download failed: $e');
      return null;
    }
  }

  /// Example: List user's uploaded files
  Future<List<String>> getUserFiles(String userId) async {
    try {
      final files = await _supabase.safeListFiles(
        'user-content',
        path: userId,
        searchOptions: const SearchOptions(
          limit: 100,
          sortBy: const SortBy(column: 'created_at', order: 'desc'),
        ),
      );
      
      return files.map((f) => f.name).toList();
    } catch (e) {
      debugPrint('Failed to list files: $e');
      return [];
    }
  }

  // ===== Realtime Examples =====
  
  /// Example: Subscribe to room changes
  RealtimeChannel? subscribeToRoom(String roomId) {
    try {
      final channel = _supabase.safeFromTable(
        'rooms',
        filter: {'id': roomId},
      );
      
      channel
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'rooms',
          filter: 'id=eq.$roomId',
          callback: (payload) {
            debugPrint('Room updated: ${payload.newRecord}');
          },
        )
        .safeSubscribe(
          onSuccess: () => debugPrint('Subscribed to room $roomId'),
          onError: (error) => debugPrint('Subscription error: $error'),
        );
      
      return channel;
    } catch (e) {
      debugPrint('Failed to create channel: $e');
      return null;
    }
  }

  // ===== Transaction-like Operations =====
  
  /// Example: Complex operation that should be atomic
  Future<bool> joinRoomWithValidation(String roomId, String playerId) async {
    try {
      return await _supabase.safeTransaction(
        () async {
          // 1. Get room details
          final room = await _supabase.safeSelectSingle('rooms');
          
          // 2. Validate room has space
          final playerIds = List<String>.from(room['player_ids'] ?? []);
          if (playerIds.length >= room['max_players']) {
            throw Exception('Room is full');
          }
          
          // 3. Add player to room
          playerIds.add(playerId);
          await _supabase.safeUpdate(
            'rooms',
            {'player_ids': playerIds},
            match: {'id': roomId},
          );
          
          // 4. Create player session
          await _supabase.safeInsert(
            'player_sessions',
            {
              'player_id': playerId,
              'room_id': roomId,
              'joined_at': DateTime.now().toIso8601String(),
            },
          );
          
          return true;
        },
        operationName: 'join_room',
        context: {
          'room_id': roomId,
          'player_id': playerId,
        },
      );
    } catch (e) {
      debugPrint('Failed to join room: $e');
      return false;
    }
  }

  /// Example: Check if connected to Supabase
  Future<bool> isConnected() async {
    return await _supabase.checkConnection();
  }
}