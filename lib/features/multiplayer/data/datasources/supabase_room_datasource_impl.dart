import 'package:ojyx/features/multiplayer/domain/datasources/room_datasource.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_room_datasource.dart';
import 'package:ojyx/features/multiplayer/data/models/room_model.dart';
import 'package:ojyx/features/game/data/models/game_state_model.dart';

/// Implementation of RoomDatasource using Supabase
class SupabaseRoomDatasourceImpl implements RoomDatasource {
  final SupabaseRoomDatasource _supabaseDataSource;

  SupabaseRoomDatasourceImpl(this._supabaseDataSource);

  @override
  Future<Room> createRoom({
    required String creatorId,
    required int maxPlayers,
  }) async {
    final model = await _supabaseDataSource.createRoom(
      creatorId: creatorId,
      maxPlayers: maxPlayers,
    );
    return model.toDomain();
  }

  @override
  Future<Room?> getRoom(String roomId) async {
    final model = await _supabaseDataSource.getRoom(roomId);
    return model?.toDomain();
  }

  @override
  Future<Room> updateRoom(Room room) async {
    await _supabaseDataSource.updateRoomStatus(
      roomId: room.id,
      status: _roomStatusToString(room.status),
      gameId: room.currentGameId,
    );

    // Return the updated room
    final updated = await getRoom(room.id);
    if (updated == null) {
      throw Exception('Failed to update room');
    }
    return updated;
  }

  @override
  Future<Room> joinRoom({
    required String roomId,
    required String playerId,
  }) async {
    final model = await _supabaseDataSource.joinRoom(
      roomId: roomId,
      playerId: playerId,
    );
    if (model == null) {
      throw Exception('Failed to join room');
    }
    return model.toDomain();
  }

  @override
  Future<Room> leaveRoom({
    required String roomId,
    required String playerId,
  }) async {
    await _supabaseDataSource.leaveRoom(roomId: roomId, playerId: playerId);

    final updated = await getRoom(roomId);
    if (updated == null) {
      throw Exception('Room not found after leaving');
    }
    return updated;
  }

  @override
  Stream<Room> watchRoom(String roomId) {
    return _supabaseDataSource
        .watchRoom(roomId)
        .map((model) => model.toDomain());
  }

  @override
  Stream<RoomEvent> watchRoomEvents(String roomId) {
    return _supabaseDataSource
        .watchRoomEvents(roomId)
        .where((data) => data.isNotEmpty)
        .map((data) => _mapDataToEvent(data));
  }

  @override
  Future<void> sendEvent({
    required String roomId,
    required RoomEvent event,
  }) async {
    final eventData = _mapEventToData(event);
    await _supabaseDataSource.sendEvent(roomId: roomId, eventData: eventData);
  }

  @override
  Future<List<Room>> getAvailableRooms() async {
    final models = await _supabaseDataSource.getAvailableRooms();
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<void> createGameState(GameState gameState) async {
    // This would be implemented when we have a game state table
    // For now, we store it as part of room events
    await sendEvent(
      roomId: gameState.roomId,
      event: RoomEvent.gameStarted(
        gameId: gameState.roomId,
        initialState: gameState,
      ),
    );
  }

  @override
  Future<void> updateGameState(GameState gameState) async {
    // This would be implemented when we have a game state table
    // For now, we store it as part of room events
    await sendEvent(
      roomId: gameState.roomId,
      event: RoomEvent.gameStateUpdated(newState: gameState),
    );
  }

  String _roomStatusToString(RoomStatus status) {
    switch (status) {
      case RoomStatus.waiting:
        return 'waiting';
      case RoomStatus.inGame:
        return 'in_game';
      case RoomStatus.finished:
        return 'finished';
      case RoomStatus.cancelled:
        return 'cancelled';
    }
  }

  Map<String, dynamic> _mapEventToData(RoomEvent event) {
    return event.when(
      playerJoined: (playerId, playerName) => {
        'type': 'player_joined',
        'player_id': playerId,
        'player_name': playerName,
      },
      playerLeft: (playerId) => {'type': 'player_left', 'player_id': playerId},
      gameStarted: (gameId, initialState) => {
        'type': 'game_started',
        'game_id': gameId,
        'initial_state': GameStateModel.fromDomainComplete(
          initialState,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          turnNumber: 1,
          roundNumber: 1,
          updatedAt: DateTime.now(),
        ).toJson(),
      },
      gameStateUpdated: (newState) => {
        'type': 'game_state_updated',
        'new_state': GameStateModel.fromDomainComplete(
          newState,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          turnNumber: 1,
          roundNumber: 1,
          updatedAt: DateTime.now(),
        ).toJson(),
      },
      playerAction: (playerId, actionType, actionData) => {
        'type': 'player_action',
        'player_id': playerId,
        'action_type': actionType.toString().split('.').last,
        'action_data': actionData,
      },
    );
  }

  RoomEvent _mapDataToEvent(Map<String, dynamic> data) {
    final type = data['type'] as String;

    switch (type) {
      case 'player_joined':
        return RoomEvent.playerJoined(
          playerId: data['player_id'],
          playerName: data['player_name'],
        );
      case 'player_left':
        return RoomEvent.playerLeft(playerId: data['player_id']);
      case 'game_started':
        return RoomEvent.gameStarted(
          gameId: data['game_id'],
          initialState: GameStateModel.fromJson(
            data['initial_state'],
          ).toDomainComplete(),
        );
      case 'game_state_updated':
        return RoomEvent.gameStateUpdated(
          newState: GameStateModel.fromJson(data['new_state']).toDomainComplete(),
        );
      case 'player_action':
        return RoomEvent.playerAction(
          playerId: data['player_id'],
          actionType: _parseActionType(data['action_type']),
          actionData: data['action_data'],
        );
      default:
        throw Exception('Unknown event type: $type');
    }
  }

  PlayerActionType _parseActionType(String type) {
    switch (type) {
      case 'drawCard':
        return PlayerActionType.drawCard;
      case 'discardCard':
        return PlayerActionType.discardCard;
      case 'revealCard':
        return PlayerActionType.revealCard;
      case 'playActionCard':
        return PlayerActionType.playActionCard;
      case 'endTurn':
        return PlayerActionType.endTurn;
      default:
        throw Exception('Unknown action type: $type');
    }
  }
}
