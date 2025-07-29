import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/services/room_realtime_service.dart';
import '../../data/services/game_sync_service.dart';
import '../../domain/entities/lobby_player.dart';
import '../../domain/entities/room_event.dart';
import 'room_providers.dart';

part 'room_realtime_controller.g.dart';

/// Controller pour gérer le service realtime unifié d'une room
@riverpod
class RoomRealtimeController extends _$RoomRealtimeController {
  late final RoomRealtimeService _realtimeService;
  
  @override
  Future<void> build() async {
    _realtimeService = ref.watch(roomRealtimeServiceProvider.notifier);
    
    // Setup de la gestion de reconnexion
    _realtimeService.setupConnectionHandling();
  }
  
  /// S'abonner à une room
  Future<void> subscribeToRoom(String roomId) async {
    debugPrint('RoomRealtimeController: Subscribing to room $roomId');
    
    try {
      await _realtimeService.subscribeToRoom(roomId);
      
      // Démarrer le heartbeat également
      ref.read(roomHeartbeatControllerProvider.notifier).startHeartbeat(roomId);
      
      // Initialiser le service de synchronisation unifié
      await ref.read(gameSyncControllerProvider.notifier).initializeForRoom(roomId);
    } catch (e) {
      debugPrint('RoomRealtimeController: Error subscribing - $e');
      rethrow;
    }
  }
  
  /// Se désabonner de la room actuelle
  Future<void> unsubscribeFromRoom() async {
    debugPrint('RoomRealtimeController: Unsubscribing from room');
    
    // Arrêter le heartbeat
    ref.read(roomHeartbeatControllerProvider.notifier).stopHeartbeat();
    
    await _realtimeService.unsubscribeFromRoom();
  }
  
  /// Envoyer une action de jeu
  Future<void> sendGameAction({
    required String actionType,
    required Map<String, dynamic> actionData,
  }) async {
    await _realtimeService.sendGameAction(
      actionType: actionType,
      actionData: actionData,
    );
  }
  
  /// Vérifier si connecté
  bool get isConnected => _realtimeService.isConnected;
  
  /// ID de la room actuelle
  String? get currentRoomId => _realtimeService.currentRoomId;
}

/// Provider pour accéder au stream de présence
@riverpod
Stream<Map<String, LobbyPlayer>> roomPresenceStream(RoomPresenceStreamRef ref) {
  final service = ref.watch(roomRealtimeServiceProvider.notifier);
  return service.presenceStream;
}

/// Provider pour accéder au stream d'événements de room
@riverpod
Stream<RoomEvent> roomRealtimeEventStream(RoomRealtimeEventStreamRef ref) {
  final service = ref.watch(roomRealtimeServiceProvider.notifier);
  return service.roomEventStream;
}

/// Provider pour accéder au stream d'actions de jeu
@riverpod
Stream<Map<String, dynamic>> gameActionStream(GameActionStreamRef ref) {
  final service = ref.watch(roomRealtimeServiceProvider.notifier);
  return service.gameActionStream;
}

/// Provider pour obtenir l'état actuel de présence
@riverpod
Map<String, LobbyPlayer> currentPresenceState(CurrentPresenceStateRef ref) {
  final service = ref.watch(roomRealtimeServiceProvider.notifier);
  return service.presenceState;
}