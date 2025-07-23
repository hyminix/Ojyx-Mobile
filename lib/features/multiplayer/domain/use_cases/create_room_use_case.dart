import '../entities/room.dart';
import '../repositories/room_repository.dart';

class CreateRoomUseCase {
  final RoomRepository _repository;

  CreateRoomUseCase(this._repository);

  Future<Room> call({
    required String creatorId,
    required int maxPlayers,
  }) async {
    if (maxPlayers < 2 || maxPlayers > 8) {
      throw ArgumentError('Max players must be between 2 and 8');
    }

    return await _repository.createRoom(
      creatorId: creatorId,
      maxPlayers: maxPlayers,
    );
  }
}
