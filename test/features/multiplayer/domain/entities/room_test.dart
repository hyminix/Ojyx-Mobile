import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';

void main() {
  group('Room Entity', () {
    test('should create a valid room with waiting status', () {
      // Arrange & Act
      final room = Room(
        id: 'room-123',
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      // Assert
      expect(room.id, 'room-123');
      expect(room.creatorId, 'user-123');
      expect(room.playerIds, contains('user-123'));
      expect(room.status, RoomStatus.waiting);
      expect(room.maxPlayers, 4);
      expect(room.currentGameId, isNull);
    });

    test('should add player to room', () {
      // Arrange
      final room = Room(
        id: 'room-123',
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      // Act
      final updatedRoom = room.copyWith(
        playerIds: [...room.playerIds, 'user-456'],
      );

      // Assert
      expect(updatedRoom.playerIds.length, 2);
      expect(updatedRoom.playerIds, contains('user-456'));
    });

    test('should change status to inGame when game starts', () {
      // Arrange
      final room = Room(
        id: 'room-123',
        creatorId: 'user-123',
        playerIds: ['user-123', 'user-456'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      // Act
      final updatedRoom = room.copyWith(
        status: RoomStatus.inGame,
        currentGameId: 'game-123',
      );

      // Assert
      expect(updatedRoom.status, RoomStatus.inGame);
      expect(updatedRoom.currentGameId, 'game-123');
    });

    test('should support value equality', () {
      // Arrange
      final now = DateTime.now();
      final room1 = Room(
        id: 'room-123',
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: now,
      );
      final room2 = Room(
        id: 'room-123',
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: now,
      );

      // Assert
      expect(room1, equals(room2));
    });

    test('should serialize to/from JSON', () {
      // Arrange
      final now = DateTime.now();
      final room = Room(
        id: 'room-123',
        creatorId: 'user-123',
        playerIds: ['user-123', 'user-456'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        currentGameId: 'game-123',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final json = room.toJson();
      final deserializedRoom = Room.fromJson(json);

      // Assert
      expect(deserializedRoom, equals(room));
    });
  });
}