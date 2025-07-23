import '../entities/room.dart';
import '../entities/room_event.dart';

abstract class RoomRepository {
  Future<Room> createRoom({required String creatorId, required int maxPlayers});

  Future<Room?> joinRoom({required String roomId, required String playerId});

  Future<void> leaveRoom({required String roomId, required String playerId});

  Future<Room?> getRoom(String roomId);

  Stream<Room> watchRoom(String roomId);

  Future<void> sendEvent({required String roomId, required RoomEvent event});

  Stream<RoomEvent> watchRoomEvents(String roomId);

  Future<List<Room>> getAvailableRooms();

  Future<void> startGame({required String roomId, required String gameId});

  Future<void> updateRoomStatus({
    required String roomId,
    required RoomStatus status,
  });
}
