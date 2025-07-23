import '../../domain/entities/room.dart';
import '../../domain/entities/room_event.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/supabase_room_datasource.dart';
import '../models/room_model.dart';
import '../../../game/data/models/game_state_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  final SupabaseRoomDatasource _datasource;
  
  RoomRepositoryImpl(this._datasource);
  
  @override
  Future<Room> createRoom({
    required String creatorId,
    required int maxPlayers,
  }) async {
    final model = await _datasource.createRoom(
      creatorId: creatorId,
      maxPlayers: maxPlayers,
    );
    return model.toDomain();
  }
  
  @override
  Future<Room?> joinRoom({
    required String roomId,
    required String playerId,
  }) async {
    final model = await _datasource.joinRoom(
      roomId: roomId,
      playerId: playerId,
    );
    return model?.toDomain();
  }
  
  @override
  Future<void> leaveRoom({
    required String roomId,
    required String playerId,
  }) async {
    await _datasource.leaveRoom(
      roomId: roomId,
      playerId: playerId,
    );
  }
  
  @override
  Future<Room?> getRoom(String roomId) async {
    final model = await _datasource.getRoom(roomId);
    return model?.toDomain();
  }
  
  @override
  Stream<Room> watchRoom(String roomId) {
    return _datasource.watchRoom(roomId).map((model) => model.toDomain());
  }
  
  @override
  Future<void> sendEvent({
    required String roomId,
    required RoomEvent event,
  }) async {
    final eventData = _mapEventToData(event);
    await _datasource.sendEvent(
      roomId: roomId,
      eventData: eventData,
    );
  }
  
  @override
  Stream<RoomEvent> watchRoomEvents(String roomId) {
    return _datasource.watchRoomEvents(roomId)
        .where((data) => data.isNotEmpty)
        .map((data) => _mapDataToEvent(data));
  }
  
  @override
  Future<List<Room>> getAvailableRooms() async {
    final models = await _datasource.getAvailableRooms();
    return models.map((model) => model.toDomain()).toList();
  }
  
  @override
  Future<void> startGame({
    required String roomId,
    required String gameId,
  }) async {
    await _datasource.updateRoomStatus(
      roomId: roomId,
      status: 'in_game',
      gameId: gameId,
    );
  }
  
  @override
  Future<void> updateRoomStatus({
    required String roomId,
    required RoomStatus status,
  }) async {
    await _datasource.updateRoomStatus(
      roomId: roomId,
      status: _roomStatusToString(status),
    );
  }
  
  Map<String, dynamic> _mapEventToData(RoomEvent event) {
    return event.when(
      playerJoined: (playerId, playerName) => {
        'type': 'player_joined',
        'player_id': playerId,
        'player_name': playerName,
      },
      playerLeft: (playerId) => {
        'type': 'player_left',
        'player_id': playerId,
      },
      gameStarted: (gameId, initialState) => {
        'type': 'game_started',
        'game_id': gameId,
        'initial_state': GameStateModel.fromDomain(initialState).toJson(),
      },
      gameStateUpdated: (newState) => {
        'type': 'game_state_updated',
        'new_state': GameStateModel.fromDomain(newState).toJson(),
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
        return RoomEvent.playerLeft(
          playerId: data['player_id'],
        );
      case 'game_started':
        return RoomEvent.gameStarted(
          gameId: data['game_id'],
          initialState: GameStateModel.fromJson(data['initial_state']).toDomain(),
        );
      case 'game_state_updated':
        return RoomEvent.gameStateUpdated(
          newState: GameStateModel.fromJson(data['new_state']).toDomain(),
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
}