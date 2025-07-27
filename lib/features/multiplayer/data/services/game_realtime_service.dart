import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/core/providers/supabase_provider_v2.dart';
import 'package:ojyx/core/errors/supabase_error_handling.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_realtime_service.g.dart';

/// Service moderne pour gérer le realtime des parties avec Supabase v2
@riverpod
class GameRealtimeService extends _$GameRealtimeService {
  RealtimeChannel? _channel;
  final Map<String, dynamic> _presenceState = {};

  @override
  FutureOr<void> build() {
    // Cleanup on dispose
    ref.onDispose(() {
      _channel?.unsubscribe();
    });
  }

  /// Rejoint une room de jeu avec toutes les fonctionnalités realtime
  Future<void> joinGameRoom(String roomId) async {
    final client = ref.read(supabaseClientProvider);

    // Quitter la room précédente si nécessaire
    await leaveCurrentRoom();

    try {
      _channel = client
          .channel('game:$roomId')
          // Écouter les changements de la table game_states
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'game_states',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'room_id',
              value: roomId,
            ),
            callback: (payload) => _handleGameStateChange(payload, roomId),
          )
          // Écouter les actions des joueurs en broadcast
          .onBroadcast(
            event: 'player_action',
            callback: (payload) => _handlePlayerAction(payload, roomId),
          )
          // Gérer la présence des joueurs
          .onPresenceSync(
            (payload) => _handlePresenceSync(payload as Map<String, dynamic>),
          )
          .onPresenceJoin(
            (payload) => _handlePresenceJoin(payload as Map<String, dynamic>),
          )
          .onPresenceLeave(
            (payload) => _handlePresenceLeave(payload as Map<String, dynamic>),
          );

      // S'abonner au channel
      _channel!.subscribe();

      // Tracker la présence du joueur actuel
      final userId = client.auth.currentUser?.id;
      if (userId != null) {
        await _channel!.track({
          'player_id': userId,
          'joined_at': DateTime.now().toIso8601String(),
          'status': 'online',
        });
      }
    } catch (e) {
      throw AppException(
        message: 'Impossible de rejoindre la partie',
        originalException: e,
      );
    }
  }

  /// Quitte la room actuelle
  Future<void> leaveCurrentRoom() async {
    if (_channel != null) {
      await _channel!.untrack();
      await _channel!.unsubscribe();
      _channel = null;
      _presenceState.clear();
    }
  }

  /// Envoie une action de joueur
  Future<void> sendPlayerAction({
    required String actionType,
    required Map<String, dynamic> actionData,
  }) async {
    if (_channel == null) {
      throw const AppException(
        message: 'Vous devez rejoindre une partie d\'abord',
        code: 'NO_CHANNEL',
      );
    }

    final client = ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw const AppException(
        message: 'Vous devez être connecté',
        code: 'NOT_AUTHENTICATED',
      );
    }

    try {
      await _channel!.sendBroadcastMessage(
        event: 'player_action',
        payload: {
          'player_id': userId,
          'action_type': actionType,
          'action_data': actionData,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      throw AppException(
        message: 'Impossible d\'envoyer l\'action',
        originalException: e,
      );
    }
  }

  /// Met à jour le statut de présence du joueur
  Future<void> updatePresenceStatus(String status) async {
    if (_channel == null) return;

    final client = ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;

    if (userId != null) {
      await _channel!.track({
        'player_id': userId,
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Gère les changements d'état de jeu
  void _handleGameStateChange(PostgresChangePayload payload, String roomId) {
    // Notifier les listeners des changements
    // Les providers qui écoutent ce service peuvent réagir
    // Game state changed for room $roomId: ${payload.eventType}
  }

  /// Gère les actions des joueurs
  void _handlePlayerAction(Map<String, dynamic> payload, String roomId) {
    // Player action in room $roomId: $payload
  }

  /// Gère la synchronisation de présence
  void _handlePresenceSync(Map<String, dynamic> payload) {
    _presenceState.clear();
    _presenceState.addAll(payload);
    // Presence synced: $_presenceState
  }

  /// Gère l'arrivée d'un joueur
  void _handlePresenceJoin(Map<String, dynamic> payload) {
    // Player joined: $payload
  }

  /// Gère le départ d'un joueur
  void _handlePresenceLeave(Map<String, dynamic> payload) {
    // Player left: $payload
  }

  /// Récupère l'état de présence actuel
  Map<String, dynamic> get presenceState => Map.unmodifiable(_presenceState);

  /// Vérifie si connecté à une room
  bool get isConnected => _channel != null;

  /// Envoie un message de chat
  Future<void> sendChatMessage(String message) async {
    await sendPlayerAction(
      actionType: 'chat',
      actionData: {
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Envoie une action de jeu (jouer une carte, révéler, etc.)
  Future<void> sendGameAction({
    required String action,
    Map<String, dynamic>? data,
  }) async {
    await sendPlayerAction(
      actionType: 'game_action',
      actionData: {'action': action, ...?data},
    );
  }
}
