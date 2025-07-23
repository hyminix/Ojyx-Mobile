import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';

/// Interface for room-related data operations
/// This abstracts the data source implementation (e.g., Supabase)
abstract class RoomDatasource {
  /// Creates a new room
  Future<Room> createRoom({
    required String creatorId,
    required int maxPlayers,
  });

  /// Gets a room by ID
  Future<Room?> getRoom(String roomId);

  /// Updates an existing room
  Future<Room> updateRoom(Room room);

  /// Joins a room
  Future<Room> joinRoom({
    required String roomId,
    required String playerId,
  });

  /// Leaves a room
  Future<Room> leaveRoom({
    required String roomId,
    required String playerId,
  });

  /// Watches room updates in real-time
  Stream<Room> watchRoom(String roomId);

  /// Watches room events in real-time
  Stream<RoomEvent> watchRoomEvents(String roomId);

  /// Sends an event to a room
  Future<void> sendEvent({
    required String roomId,
    required RoomEvent event,
  });

  /// Gets all available rooms
  Future<List<Room>> getAvailableRooms();

  /// Creates a new game state
  Future<void> createGameState(GameState gameState);

  /// Updates an existing game state
  Future<void> updateGameState(GameState gameState);
}