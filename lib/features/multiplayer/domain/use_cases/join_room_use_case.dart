import '../entities/room.dart';
import '../repositories/room_repository.dart';

class JoinRoomUseCase {
  final RoomRepository _repository;

  JoinRoomUseCase(this._repository);

  Future<Room?> call({required String roomId, required String playerId}) async {
    final room = await _repository.getRoom(roomId);

    if (room == null) {
      throw Exception('Room not found');
    }

    if (room.status != RoomStatus.waiting) {
      throw Exception('Room is not accepting new players');
    }

    if (room.playerIds.length >= room.maxPlayers) {
      throw Exception('Room is full');
    }

    return await _repository.joinRoom(roomId: roomId, playerId: playerId);
  }
}
