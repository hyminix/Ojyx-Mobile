import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/data/models/room_model.dart';
import 'package:ojyx/features/multiplayer/data/models/room_model_extensions.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';

void main() {
  group('RoomModel', () {
    test('should create RoomModel with all required fields', () {
      // Arrange
      final now = DateTime.now();

      // Act
      final model = RoomModel(
        id: 'room123',
        creatorId: 'player1',
        playerIds: ['player1', 'player2'],
        status: 'waiting',
        maxPlayers: 4,
        currentGameId: null,
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(model.id, equals('room123'));
      expect(model.creatorId, equals('player1'));
      expect(model.playerIds, equals(['player1', 'player2']));
      expect(model.status, equals('waiting'));
      expect(model.maxPlayers, equals(4));
      expect(model.currentGameId, isNull);
      expect(model.createdAt, equals(now));
      expect(model.updatedAt, equals(now));
    });

    test('should create RoomModel with optional fields', () {
      // Act
      const model = RoomModel(
        id: 'room456',
        creatorId: 'player3',
        playerIds: ['player3'],
        status: 'in_game',
        maxPlayers: 8,
        currentGameId: 'game789',
      );

      // Assert
      expect(model.id, equals('room456'));
      expect(model.currentGameId, equals('game789'));
      expect(model.createdAt, isNull);
      expect(model.updatedAt, isNull);
    });

    group('JSON serialization', () {
      test('should serialize to JSON correctly', () {
        // Arrange
        final now = DateTime.now();
        final model = RoomModel(
          id: 'room123',
          creatorId: 'player1',
          playerIds: ['player1', 'player2'],
          status: 'waiting',
          maxPlayers: 4,
          currentGameId: 'game123',
          createdAt: now,
          updatedAt: now,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['id'], equals('room123'));
        expect(json['creator_id'], equals('player1'));
        expect(json['player_ids'], equals(['player1', 'player2']));
        expect(json['status'], equals('waiting'));
        expect(json['max_players'], equals(4));
        expect(json['current_game_id'], equals('game123'));
        expect(json['created_at'], equals(now.toIso8601String()));
        expect(json['updated_at'], equals(now.toIso8601String()));
      });

      test('should deserialize from JSON correctly', () {
        // Arrange
        final now = DateTime.now();
        final json = {
          'id': 'room456',
          'creator_id': 'player3',
          'player_ids': ['player3', 'player4', 'player5'],
          'status': 'in_game',
          'max_players': 6,
          'current_game_id': 'game456',
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };

        // Act
        final model = RoomModel.fromJson(json);

        // Assert
        expect(model.id, equals('room456'));
        expect(model.creatorId, equals('player3'));
        expect(model.playerIds, equals(['player3', 'player4', 'player5']));
        expect(model.status, equals('in_game'));
        expect(model.maxPlayers, equals(6));
        expect(model.currentGameId, equals('game456'));
        expect(
          model.createdAt?.toIso8601String(),
          equals(now.toIso8601String()),
        );
        expect(
          model.updatedAt?.toIso8601String(),
          equals(now.toIso8601String()),
        );
      });
    });

    group('Domain conversion', () {
      test('should convert to domain entity correctly', () {
        // Arrange
        final now = DateTime.now();
        final model = RoomModel(
          id: 'room123',
          creatorId: 'player1',
          playerIds: ['player1', 'player2'],
          status: 'waiting',
          maxPlayers: 4,
          currentGameId: null,
          createdAt: now,
          updatedAt: now,
        );

        // Act
        final domain = model.toDomain();

        // Assert
        expect(domain.id, equals('room123'));
        expect(domain.creatorId, equals('player1'));
        expect(domain.playerIds, equals(['player1', 'player2']));
        expect(domain.status, equals(RoomStatus.waiting));
        expect(domain.maxPlayers, equals(4));
        expect(domain.currentGameId, isNull);
        expect(domain.createdAt, equals(now));
        expect(domain.updatedAt, equals(now));
      });

      test('should parse all room statuses correctly', () {
        // Test waiting status
        final waitingModel = const RoomModel(
          id: 'room1',
          creatorId: 'player1',
          playerIds: ['player1'],
          status: 'waiting',
          maxPlayers: 4,
        );
        expect(waitingModel.toDomain().status, equals(RoomStatus.waiting));

        // Test in_game status
        final inGameModel = const RoomModel(
          id: 'room2',
          creatorId: 'player1',
          playerIds: ['player1'],
          status: 'in_game',
          maxPlayers: 4,
        );
        expect(inGameModel.toDomain().status, equals(RoomStatus.inGame));

        // Test finished status
        final finishedModel = const RoomModel(
          id: 'room3',
          creatorId: 'player1',
          playerIds: ['player1'],
          status: 'finished',
          maxPlayers: 4,
        );
        expect(finishedModel.toDomain().status, equals(RoomStatus.finished));

        // Test cancelled status
        final cancelledModel = const RoomModel(
          id: 'room4',
          creatorId: 'player1',
          playerIds: ['player1'],
          status: 'cancelled',
          maxPlayers: 4,
        );
        expect(cancelledModel.toDomain().status, equals(RoomStatus.cancelled));

        // Test unknown status (should default to waiting)
        final unknownModel = const RoomModel(
          id: 'room5',
          creatorId: 'player1',
          playerIds: ['player1'],
          status: 'unknown_status',
          maxPlayers: 4,
        );
        expect(unknownModel.toDomain().status, equals(RoomStatus.waiting));
      });
    });

    test('should support equality comparison', () {
      // Arrange
      const model1 = RoomModel(
        id: 'room123',
        creatorId: 'player1',
        playerIds: ['player1', 'player2'],
        status: 'waiting',
        maxPlayers: 4,
      );

      const model2 = RoomModel(
        id: 'room123',
        creatorId: 'player1',
        playerIds: ['player1', 'player2'],
        status: 'waiting',
        maxPlayers: 4,
      );

      const model3 = RoomModel(
        id: 'room456',
        creatorId: 'player1',
        playerIds: ['player1', 'player2'],
        status: 'waiting',
        maxPlayers: 4,
      );

      // Assert
      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
    });
  });

  group('RoomExtensions', () {
    test('should convert Room entity to RoomModel correctly', () {
      // Arrange
      final now = DateTime.now();
      final room = Room(
        id: 'room789',
        creatorId: 'player5',
        playerIds: ['player5', 'player6', 'player7'],
        status: RoomStatus.inGame,
        maxPlayers: 6,
        currentGameId: 'game999',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final model = room.toModel();

      // Assert
      expect(model.id, equals('room789'));
      expect(model.creatorId, equals('player5'));
      expect(model.playerIds, equals(['player5', 'player6', 'player7']));
      expect(model.status, equals('in_game'));
      expect(model.maxPlayers, equals(6));
      expect(model.currentGameId, equals('game999'));
      expect(model.createdAt, equals(now));
      expect(model.updatedAt, equals(now));
    });

    test('should convert all RoomStatus values correctly', () {
      // Test waiting
      final waitingRoom = const Room(
        id: 'room1',
        creatorId: 'player1',
        playerIds: ['player1'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
      );
      expect(waitingRoom.toModel().status, equals('waiting'));

      // Test inGame
      final inGameRoom = const Room(
        id: 'room2',
        creatorId: 'player1',
        playerIds: ['player1'],
        status: RoomStatus.inGame,
        maxPlayers: 4,
      );
      expect(inGameRoom.toModel().status, equals('in_game'));

      // Test finished
      final finishedRoom = const Room(
        id: 'room3',
        creatorId: 'player1',
        playerIds: ['player1'],
        status: RoomStatus.finished,
        maxPlayers: 4,
      );
      expect(finishedRoom.toModel().status, equals('finished'));

      // Test cancelled
      final cancelledRoom = const Room(
        id: 'room4',
        creatorId: 'player1',
        playerIds: ['player1'],
        status: RoomStatus.cancelled,
        maxPlayers: 4,
      );
      expect(cancelledRoom.toModel().status, equals('cancelled'));
    });

    test('should maintain data integrity through round-trip conversion', () {
      // Arrange
      final now = DateTime.now();
      final originalRoom = Room(
        id: 'room123',
        creatorId: 'player1',
        playerIds: ['player1', 'player2', 'player3'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        currentGameId: null,
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final model = originalRoom.toModel();
      final convertedRoom = model.toDomain();

      // Assert
      expect(convertedRoom.id, equals(originalRoom.id));
      expect(convertedRoom.creatorId, equals(originalRoom.creatorId));
      expect(convertedRoom.playerIds, equals(originalRoom.playerIds));
      expect(convertedRoom.status, equals(originalRoom.status));
      expect(convertedRoom.maxPlayers, equals(originalRoom.maxPlayers));
      expect(convertedRoom.currentGameId, equals(originalRoom.currentGameId));
      expect(convertedRoom.createdAt, equals(originalRoom.createdAt));
      expect(convertedRoom.updatedAt, equals(originalRoom.updatedAt));
    });
  });
}
