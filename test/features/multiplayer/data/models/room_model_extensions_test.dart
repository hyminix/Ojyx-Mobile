import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/data/models/room_model_extensions.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';

void main() {
  group('RoomExtensions', () {
    test('should convert Room entity to RoomModel with all fields', () {
      // Arrange
      final now = DateTime.now();
      final room = Room(
        id: 'room123',
        creatorId: 'creator1',
        playerIds: ['player1', 'player2'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        currentGameId: 'game123',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final model = room.toModel();

      // Assert
      expect(model.id, equals('room123'));
      expect(model.creatorId, equals('creator1'));
      expect(model.playerIds, equals(['player1', 'player2']));
      expect(model.status, equals('waiting'));
      expect(model.maxPlayers, equals(4));
      expect(model.currentGameId, equals('game123'));
      expect(model.createdAt, equals(now));
      expect(model.updatedAt, equals(now));
    });

    test('should handle null optional fields', () {
      // Arrange
      const room = Room(
        id: 'room456',
        creatorId: 'creator2',
        playerIds: ['player3'],
        status: RoomStatus.inGame,
        maxPlayers: 6,
        currentGameId: null,
        createdAt: null,
        updatedAt: null,
      );

      // Act
      final model = room.toModel();

      // Assert
      expect(model.id, equals('room456'));
      expect(model.currentGameId, isNull);
      expect(model.createdAt, isNull);
      expect(model.updatedAt, isNull);
    });

    test('should convert all RoomStatus enum values correctly', () {
      // Test RoomStatus.waiting
      const waitingRoom = Room(
        id: 'room1',
        creatorId: 'creator',
        playerIds: ['player'],
        status: RoomStatus.waiting,
        maxPlayers: 2,
      );
      expect(waitingRoom.toModel().status, equals('waiting'));

      // Test RoomStatus.inGame
      const inGameRoom = Room(
        id: 'room2',
        creatorId: 'creator',
        playerIds: ['player'],
        status: RoomStatus.inGame,
        maxPlayers: 2,
      );
      expect(inGameRoom.toModel().status, equals('in_game'));

      // Test RoomStatus.finished
      const finishedRoom = Room(
        id: 'room3',
        creatorId: 'creator',
        playerIds: ['player'],
        status: RoomStatus.finished,
        maxPlayers: 2,
      );
      expect(finishedRoom.toModel().status, equals('finished'));

      // Test RoomStatus.cancelled
      const cancelledRoom = Room(
        id: 'room4',
        creatorId: 'creator',
        playerIds: ['player'],
        status: RoomStatus.cancelled,
        maxPlayers: 2,
      );
      expect(cancelledRoom.toModel().status, equals('cancelled'));
    });

    test('should handle room with maximum players', () {
      // Arrange
      const room = Room(
        id: 'room789',
        creatorId: 'creator3',
        playerIds: [
          'player1',
          'player2',
          'player3',
          'player4',
          'player5',
          'player6',
          'player7',
          'player8',
        ],
        status: RoomStatus.inGame,
        maxPlayers: 8,
      );

      // Act
      final model = room.toModel();

      // Assert
      expect(model.playerIds.length, equals(8));
      expect(model.maxPlayers, equals(8));
    });

    test('should handle room with single player', () {
      // Arrange
      const room = Room(
        id: 'room_single',
        creatorId: 'solo_player',
        playerIds: ['solo_player'],
        status: RoomStatus.waiting,
        maxPlayers: 2,
      );

      // Act
      final model = room.toModel();

      // Assert
      expect(model.playerIds.length, equals(1));
      expect(model.playerIds.first, equals('solo_player'));
      expect(model.creatorId, equals('solo_player'));
    });

    test('should preserve empty playerIds list', () {
      // Arrange
      const room = Room(
        id: 'empty_room',
        creatorId: 'creator',
        playerIds: [],
        status: RoomStatus.waiting,
        maxPlayers: 4,
      );

      // Act
      final model = room.toModel();

      // Assert
      expect(model.playerIds, isEmpty);
    });

    test('should correctly map finished game room', () {
      // Arrange
      final finishedTime = DateTime.now();
      final room = Room(
        id: 'finished_game',
        creatorId: 'winner',
        playerIds: ['winner', 'loser1', 'loser2'],
        status: RoomStatus.finished,
        maxPlayers: 4,
        currentGameId: 'completed_game_123',
        createdAt: finishedTime.subtract(const Duration(hours: 1)),
        updatedAt: finishedTime,
      );

      // Act
      final model = room.toModel();

      // Assert
      expect(model.status, equals('finished'));
      expect(model.currentGameId, equals('completed_game_123'));
      expect(model.updatedAt, equals(finishedTime));
    });
  });
}
