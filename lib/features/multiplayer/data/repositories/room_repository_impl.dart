import '../../domain/entities/room.dart';
import '../../domain/entities/room_event.dart';
import '../../domain/repositories/room_repository.dart';
import '../../domain/datasources/room_datasource.dart';
import '../../../game/domain/use_cases/game_initialization_use_case.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomDatasource _datasource;
  final GameInitializationUseCase _gameInitializationUseCase;

  RoomRepositoryImpl(this._datasource, this._gameInitializationUseCase);

  @override
  Future<Room> createRoom({
    required String creatorId,
    required int maxPlayers,
  }) async {
    final model = await _datasource.createRoom(
      creatorId: creatorId,
      maxPlayers: maxPlayers,
    );
    return model;
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
    return model;
  }

  @override
  Future<void> leaveRoom({
    required String roomId,
    required String playerId,
  }) async {
    await _datasource.leaveRoom(roomId: roomId, playerId: playerId);
  }

  @override
  Future<Room?> getRoom(String roomId) async {
    final model = await _datasource.getRoom(roomId);
    return model;
  }

  @override
  Stream<Room> watchRoom(String roomId) {
    return _datasource.watchRoom(roomId);
  }

  @override
  Future<void> sendEvent({
    required String roomId,
    required RoomEvent event,
  }) async {
    await _datasource.sendEvent(roomId: roomId, event: event);
  }

  @override
  Stream<RoomEvent> watchRoomEvents(String roomId) {
    return _datasource.watchRoomEvents(roomId);
  }

  @override
  Future<List<Room>> getAvailableRooms() async {
    final models = await _datasource.getAvailableRooms();
    return models;
  }

  @override
  Future<void> startGame({
    required String roomId,
    required String gameId,
  }) async {
    final room = await _datasource.getRoom(roomId);
    if (room == null) {
      throw Exception('Room not found');
    }

    // Use the game initialization use case to create server-authoritative game
    await _gameInitializationUseCase.execute(
      roomId: roomId,
      playerIds: room.playerIds,
      creatorId: room.creatorId,
    );

    // Update room status to in-game
    await _datasource.updateRoom(
      room.copyWith(status: RoomStatus.inGame, currentGameId: gameId),
    );
  }

  @override
  Future<void> updateRoomStatus({
    required String roomId,
    required RoomStatus status,
  }) async {
    final room = await _datasource.getRoom(roomId);
    if (room != null) {
      await _datasource.updateRoom(room.copyWith(status: status));
    }
  }
}
