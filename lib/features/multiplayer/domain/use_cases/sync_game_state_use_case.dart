import '../../../game/domain/entities/game_state.dart';
import '../entities/room_event.dart';
import '../repositories/room_repository.dart';

class SyncGameStateUseCase {
  final RoomRepository _repository;

  SyncGameStateUseCase(this._repository);

  Future<void> syncGameState({
    required String roomId,
    required GameState gameState,
  }) async {
    await _repository.sendEvent(
      roomId: roomId,
      event: RoomEvent.gameStateUpdated(newState: gameState),
    );
  }

  Future<void> sendPlayerAction({
    required String roomId,
    required String playerId,
    required PlayerActionType actionType,
    Map<String, dynamic>? actionData,
  }) async {
    await _repository.sendEvent(
      roomId: roomId,
      event: RoomEvent.playerAction(
        playerId: playerId,
        actionType: actionType,
        actionData: actionData,
      ),
    );
  }

  Stream<RoomEvent> watchGameEvents(String roomId) {
    return _repository.watchRoomEvents(roomId);
  }
}
