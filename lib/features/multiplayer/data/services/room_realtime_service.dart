import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../../../core/errors/supabase_exceptions.dart';
import '../../../../core/errors/multiplayer_errors.dart';
import '../../domain/entities/lobby_player.dart';
import '../../domain/entities/room_event.dart';
import '../../../game/domain/entities/game_state.dart';

part 'room_realtime_service.g.dart';

/// Service unifié pour gérer toute la synchronisation realtime d'une room
/// Utilise un seul channel room:{roomId} avec Supabase Presence
@riverpod
class RoomRealtimeService extends _$RoomRealtimeService {
  RealtimeChannel? _channel;
  String? _currentRoomId;
  
  // État de présence des joueurs
  final Map<String, LobbyPlayer> _presenceState = {};
  
  // Streams pour notifier les changements
  final _presenceStreamController = StreamController<Map<String, LobbyPlayer>>.broadcast();
  final _roomEventStreamController = StreamController<RoomEvent>.broadcast();
  final _gameActionStreamController = StreamController<Map<String, dynamic>>.broadcast();
  
  @override
  Future<void> build() async {
    // Cleanup on dispose
    ref.onDispose(() {
      _cleanup();
    });
  }
  
  /// Rejoint une room avec un channel unifié
  Future<void> subscribeToRoom(String roomId) async {
    debugPrint('RoomRealtimeService: Subscribing to room $roomId');
    
    // Quitter la room précédente si nécessaire
    if (_currentRoomId != null) {
      await unsubscribeFromRoom();
    }
    
    _currentRoomId = roomId;
    final supabase = ref.read(supabaseClientProvider);
    
    try {
      // Créer le channel unifié
      _channel = supabase.channel('room:$roomId')
        // Presence pour tracker les joueurs actifs
        .onPresenceSync((payload) {
          _handlePresenceSync(payload);
        })
        .onPresenceJoin((payload) {
          _handlePresenceJoin(payload);
        })
        .onPresenceLeave((payload) {
          _handlePresenceLeave(payload);
        })
        // Broadcast pour les événements de jeu
        .onBroadcast(
          event: 'game_action',
          callback: (payload) => _handleGameAction(payload as Map<String, dynamic>),
        )
        // Listen pour les changements de la table rooms
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'rooms',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: roomId,
          ),
          callback: (payload) => _handleRoomChange(payload),
        )
        // Listen pour les changements de game_states
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'game_states',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'room_id',
            value: roomId,
          ),
          callback: (payload) => _handleGameStateChange(payload),
        )
        // Listen pour les changements de players
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'players',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'current_room_id',
            value: roomId,
          ),
          callback: (payload) => _handlePlayerChange(payload),
        );
      
      // S'abonner au channel
      await _channel!.subscribe();
      
      // Tracker sa propre présence
      await _trackUserPresence();
      
      debugPrint('RoomRealtimeService: Successfully subscribed to room $roomId');
    } catch (e) {
      debugPrint('RoomRealtimeService: Error subscribing to room - $e');
      _currentRoomId = null;
      throw MultiplayerConnectionException(
        message: 'Failed to subscribe to room: ${e.toString()}',
        context: 'subscribe_to_room',
      );
    }
  }
  
  /// Quitte la room actuelle
  Future<void> unsubscribeFromRoom() async {
    if (_channel == null) return;
    
    debugPrint('RoomRealtimeService: Unsubscribing from room $_currentRoomId');
    
    try {
      // Arrêter de tracker sa présence
      await _channel!.untrack();
      
      // Se désabonner du channel
      await _channel!.unsubscribe();
    } catch (e) {
      debugPrint('RoomRealtimeService: Error unsubscribing - $e');
    } finally {
      _channel = null;
      _currentRoomId = null;
      _presenceState.clear();
      _notifyPresenceUpdate();
    }
  }
  
  /// Tracker la présence de l'utilisateur actuel
  Future<void> _trackUserPresence() async {
    final supabase = ref.read(supabaseClientProvider);
    final user = supabase.auth.currentUser;
    
    if (user == null || _channel == null) return;
    
    try {
      // Récupérer les infos du joueur
      final playerData = await supabase
          .from('players')
          .select()
          .eq('id', user.id)
          .single();
      
      // Tracker la présence avec toutes les infos
      await _channel!.track({
        'user_id': user.id,
        'player_name': playerData['display_name'] ?? 'Joueur',
        'avatar_url': playerData['avatar_url'],
        'joined_at': DateTime.now().toIso8601String(),
        'status': 'online',
        'connection_status': 'online',
      });
      
      debugPrint('RoomRealtimeService: Tracking presence for user ${user.id}');
    } catch (e) {
      debugPrint('RoomRealtimeService: Error tracking presence - $e');
    }
  }
  
  /// Gère la synchronisation de présence
  void _handlePresenceSync(dynamic payload) {
    // Supabase returns the presence state as a map with keys being the presence_ref
    final presenceState = payload as Map<String, dynamic>;
    debugPrint('RoomRealtimeService: Presence sync - ${presenceState.length} players');
    
    _presenceState.clear();
    
    for (final entry in presenceState.entries) {
      final presenceData = entry.value as Map<String, dynamic>;
      final userId = presenceData['user_id'] as String;
      
      _presenceState[userId] = LobbyPlayer(
        id: userId,
        name: presenceData['player_name'] ?? 'Joueur',
        avatarUrl: presenceData['avatar_url'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastSeenAt: DateTime.now(),
        connectionStatus: _parseConnectionStatus(presenceData['connection_status'] ?? 'online'),
        currentRoomId: _currentRoomId,
      );
    }
    
    _notifyPresenceUpdate();
  }
  
  /// Gère l'arrivée d'un joueur
  void _handlePresenceJoin(dynamic payload) {
    // payload contains the new presences
    final joinedPresences = payload as Map<String, dynamic>;
    
    debugPrint('RoomRealtimeService: Player(s) joined - ${joinedPresences.length}');
    
    for (final entry in joinedPresences.entries) {
      final presenceData = entry.value as Map<String, dynamic>;
      final userId = presenceData['user_id'] as String;
      
      _presenceState[userId] = LobbyPlayer(
        id: userId,
        name: presenceData['player_name'] ?? 'Joueur',
        avatarUrl: presenceData['avatar_url'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastSeenAt: DateTime.now(),
        connectionStatus: _parseConnectionStatus(presenceData['connection_status'] ?? 'online'),
        currentRoomId: _currentRoomId,
      );
    }
    
    _notifyPresenceUpdate();
    
    // Notifier l'événement
    for (final userId in joinedPresences.keys) {
      final presenceData = joinedPresences[userId] as Map<String, dynamic>;
      _roomEventStreamController.add(
        RoomEvent.playerJoined(
          playerId: userId,
          playerName: presenceData['player_name'] ?? 'Joueur',
        ),
      );
    }
  }
  
  /// Gère le départ d'un joueur
  void _handlePresenceLeave(dynamic payload) {
    // payload contains the left presences
    final leftPresences = payload as Map<String, dynamic>;
    
    debugPrint('RoomRealtimeService: Player(s) left - ${leftPresences.length}');
    
    for (final entry in leftPresences.entries) {
      final presenceData = entry.value as Map<String, dynamic>;
      final userId = presenceData['user_id'] as String;
      
      _presenceState.remove(userId);
      
      // Marquer le joueur comme déconnecté dans la BD
      _markPlayerDisconnected(userId);
      
      // Notifier l'événement
      _roomEventStreamController.add(
        RoomEvent.playerLeft(playerId: userId),
      );
    }
    
    _notifyPresenceUpdate();
  }
  
  /// Marque un joueur comme déconnecté
  Future<void> _markPlayerDisconnected(String userId) async {
    if (_currentRoomId == null) return;
    
    final supabase = ref.read(supabaseClientProvider);
    
    try {
      await supabase.rpc('mark_player_disconnected', params: {
        'p_player_id': userId,
      });
    } catch (e) {
      debugPrint('RoomRealtimeService: Error marking player disconnected - $e');
    }
  }
  
  /// Envoie une action de jeu
  Future<void> sendGameAction({
    required String actionType,
    required Map<String, dynamic> actionData,
  }) async {
    if (_channel == null) {
      throw Exception('Not connected to a room');
    }
    
    final supabase = ref.read(supabaseClientProvider);
    final userId = supabase.auth.currentUser?.id;
    
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    
    await _channel!.sendBroadcastMessage(
      event: 'game_action',
      payload: {
        'action_type': actionType,
        'player_id': userId,
        'data': actionData,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
  
  /// Gère les actions de jeu reçues
  void _handleGameAction(Map<String, dynamic> payload) {
    debugPrint('RoomRealtimeService: Game action received - ${payload['action_type']}');
    _gameActionStreamController.add(payload);
  }
  
  /// Gère les changements de room
  void _handleRoomChange(PostgresChangePayload payload) {
    debugPrint('RoomRealtimeService: Room changed - ${payload.eventType}');
    
    // For room updates, we need to map to appropriate event type
    if (payload.eventType == PostgresChangeEvent.update && payload.newRecord != null) {
      final newState = payload.newRecord!;
      if (newState['status'] == 'playing' && payload.oldRecord?['status'] != 'playing') {
        // Game started
        _roomEventStreamController.add(
          RoomEvent.gameStarted(
            gameId: newState['id'] as String,
            initialState: GameState.initial(
              roomId: _currentRoomId!,
              players: [], // This will need proper player data
            ),
          ),
        );
      }
    }
  }
  
  /// Gère les changements de game_state
  void _handleGameStateChange(PostgresChangePayload payload) {
    debugPrint('RoomRealtimeService: Game state changed - ${payload.eventType}');
    
    // For game state updates
    if (payload.eventType == PostgresChangeEvent.update && payload.newRecord != null) {
      final gameStateData = payload.newRecord!;
      // Convert the database record to GameState
      // For now, we'll use a placeholder - this should be properly deserialized
      _roomEventStreamController.add(
        RoomEvent.gameStateUpdated(
          newState: GameState.initial(
            roomId: _currentRoomId!,
            players: [], // This will need proper player data
          ),
        ),
      );
    }
  }
  
  /// Gère les changements de players
  void _handlePlayerChange(PostgresChangePayload payload) {
    debugPrint('RoomRealtimeService: Player changed - ${payload.eventType}');
    
    // Mettre à jour la présence si nécessaire
    if (payload.eventType == PostgresChangeEvent.update) {
      final playerId = payload.newRecord?['id'] as String?;
      if (playerId != null && _presenceState.containsKey(playerId)) {
        // Mettre à jour les infos du joueur
        final player = _presenceState[playerId]!;
        _presenceState[playerId] = player.copyWith(
          connectionStatus: payload.newRecord?['connection_status'] ?? player.connectionStatus,
        );
        _notifyPresenceUpdate();
      }
    }
  }
  
  /// Notifie les changements de présence
  void _notifyPresenceUpdate() {
    _presenceStreamController.add(Map.from(_presenceState));
  }
  
  /// Gère la reconnexion
  void setupConnectionHandling() {
    // The reconnection is handled automatically by Supabase
    // We just need to ensure presence is tracked when subscribing
    debugPrint('RoomRealtimeService: Connection handling setup');
  }
  
  /// Parse connection status string to enum
  ConnectionStatus _parseConnectionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return ConnectionStatus.online;
      case 'away':
        return ConnectionStatus.away;
      case 'offline':
      default:
        return ConnectionStatus.offline;
    }
  }
  
  /// Cleanup des ressources
  void _cleanup() {
    _channel?.unsubscribe();
    _channel = null;
    _currentRoomId = null;
    _presenceState.clear();
    _presenceStreamController.close();
    _roomEventStreamController.close();
    _gameActionStreamController.close();
  }
  
  // Getters pour accéder aux états et streams
  
  /// Stream de présence des joueurs
  Stream<Map<String, LobbyPlayer>> get presenceStream => _presenceStreamController.stream;
  
  /// Stream des événements de room
  Stream<RoomEvent> get roomEventStream => _roomEventStreamController.stream;
  
  /// Stream des actions de jeu
  Stream<Map<String, dynamic>> get gameActionStream => _gameActionStreamController.stream;
  
  /// État actuel de présence
  Map<String, LobbyPlayer> get presenceState => Map.unmodifiable(_presenceState);
  
  /// ID de la room actuelle
  String? get currentRoomId => _currentRoomId;
  
  /// Est connecté à une room
  bool get isConnected => _channel != null && _currentRoomId != null;
}