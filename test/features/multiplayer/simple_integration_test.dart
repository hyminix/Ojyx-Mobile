import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/multiplayer/data/models/room_model.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';

void main() {
  group('Multiplayer Integration Test', () {
    test('Room model conversion works correctly', () {
      // Arrange
      final room = Room(
        id: 'room-123',
        creatorId: 'user-123',
        playerIds: ['user-123', 'user-456'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      final model = room.toModel();
      final convertedRoom = model.toDomain();

      // Assert
      expect(convertedRoom.id, room.id);
      expect(convertedRoom.creatorId, room.creatorId);
      expect(convertedRoom.playerIds, room.playerIds);
      expect(convertedRoom.status, room.status);
      expect(convertedRoom.maxPlayers, room.maxPlayers);
    });

    test('RoomEvent serialization works', () {
      // Arrange
      final event = const RoomEvent.playerJoined(
        playerId: 'user-123',
        playerName: 'John Doe',
      );

      // Act
      final json = event.toJson();
      final deserializedEvent = RoomEvent.fromJson(json);

      // Assert
      expect(deserializedEvent, equals(event));
    });

    test('GameState can be created with players', () {
      // Arrange
      final players = [
        Player(
          id: 'user-123',
          name: 'John',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        Player(
          id: 'user-456', 
          name: 'Jane',
          grid: PlayerGrid.empty(),
          isHost: false,
        ),
      ];

      // Act
      final gameState = GameState.initial(
        roomId: 'room-123',
        players: players,
      );

      // Assert
      expect(gameState.roomId, 'room-123');
      expect(gameState.players.length, 2);
      expect(gameState.status, GameStatus.waitingToStart);
      expect(gameState.currentPlayerIndex, 0);
    });

    test('PlayerActionType covers all game actions', () {
      // Assert
      expect(PlayerActionType.values.contains(PlayerActionType.drawCard), true);
      expect(PlayerActionType.values.contains(PlayerActionType.discardCard), true);
      expect(PlayerActionType.values.contains(PlayerActionType.revealCard), true);
      expect(PlayerActionType.values.contains(PlayerActionType.playActionCard), true);
      expect(PlayerActionType.values.contains(PlayerActionType.endTurn), true);
    });

    test('Room status transitions are valid', () {
      // Arrange
      var room = const Room(
        id: 'room-123',
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
      );

      // Act & Assert
      room = room.copyWith(status: RoomStatus.inGame);
      expect(room.status, RoomStatus.inGame);

      room = room.copyWith(status: RoomStatus.finished);
      expect(room.status, RoomStatus.finished);
    });
  });
}