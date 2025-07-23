import '../../domain/entities/room.dart';
import 'room_model.dart';

extension RoomExtensions on Room {
  RoomModel toModel() {
    return RoomModel(
      id: id,
      creatorId: creatorId,
      playerIds: playerIds,
      status: _roomStatusToString(status),
      maxPlayers: maxPlayers,
      currentGameId: currentGameId,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
}