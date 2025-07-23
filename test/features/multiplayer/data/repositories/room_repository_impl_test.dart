import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:ojyx/features/multiplayer/data/repositories/room_repository_impl.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_room_datasource.dart';
import 'package:ojyx/features/multiplayer/data/models/room_model.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/core/errors/failures.dart';

class MockSupabaseRoomDatasource extends Mock implements SupabaseRoomDatasource {}

void main() {
  late RoomRepositoryImpl repository;
  late MockSupabaseRoomDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockSupabaseRoomDatasource();
    repository = RoomRepositoryImpl(mockDatasource);
  });

  group('createRoom', () {
    test('should return Room when datasource call is successful', () async {
      // Arrange
      const creatorId = 'user-123';
      const maxPlayers = 4;
      final expectedRoom = Room(
        id: 'room-123',
        creatorId: creatorId,
        playerIds: [creatorId],
        status: RoomStatus.waiting,
        maxPlayers: maxPlayers,
        createdAt: DateTime.now(),
      );

      when(() => mockDatasource.createRoom(
        creatorId: any(named: 'creatorId'),
        maxPlayers: any(named: 'maxPlayers'),
      )).thenAnswer((_) async => expectedRoom.toModel());

      // Act
      final result = await repository.createRoom(creatorId, maxPlayers);

      // Assert
      expect(result, Right(expectedRoom));
      verify(() => mockDatasource.createRoom(
        creatorId: any(named: 'creatorId'),
        maxPlayers: any(named: 'maxPlayers'),
      )).called(1);
    });

    test('should return ServerFailure when datasource throws exception', () async {
      // Arrange
      const creatorId = 'user-123';
      const maxPlayers = 4;

      when(() => mockDatasource.createRoom(
        creatorId: any(named: 'creatorId'),
        maxPlayers: any(named: 'maxPlayers'),
      )).thenThrow(const ServerFailure(message: 'Server error'));

      // Act
      final result = await repository.createRoom(creatorId, maxPlayers);

      // Assert
      expect(result, const Left(ServerFailure(message: 'Server error')));
    });
  });

  group('joinRoom', () {
    test('should return updated Room when join is successful', () async {
      // Arrange
      const roomId = 'room-123';
      const playerId = 'user-456';
      final existingRoom = Room(
        id: roomId,
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );
      final updatedRoom = existingRoom.copyWith(
        playerIds: ['user-123', playerId],
      );

      when(() => mockDatasource.getRoom(roomId))
          .thenAnswer((_) async => existingRoom.toModel());
      when(() => mockDatasource.joinRoom(
        roomId: any(named: 'roomId'),
        playerId: any(named: 'playerId'),
      )).thenAnswer((_) async => updatedRoom.toModel());

      // Act
      final result = await repository.joinRoom(roomId, playerId);

      // Assert
      expect(result, Right(updatedRoom));
      verify(() => mockDatasource.getRoom(roomId)).called(1);
      verify(() => mockDatasource.joinRoom(
        roomId: any(named: 'roomId'),
        playerId: any(named: 'playerId'),
      )).called(1);
    });

    test('should return ValidationFailure when room is full', () async {
      // Arrange
      const roomId = 'room-123';
      const playerId = 'user-789';
      final fullRoom = Room(
        id: roomId,
        creatorId: 'user-123',
        playerIds: ['user-123', 'user-456'],
        status: RoomStatus.waiting,
        maxPlayers: 2,
        createdAt: DateTime.now(),
      );

      when(() => mockDatasource.getRoom(roomId))
          .thenAnswer((_) async => fullRoom);

      // Act
      final result = await repository.joinRoom(roomId, playerId);

      // Assert
      expect(result, const Left(ValidationFailure(message: 'Room is full')));
      verify(() => mockDatasource.getRoom(roomId)).called(1);
      verifyNever(() => mockDatasource.updateRoom(any()));
    });

    test('should return ValidationFailure when player already in room', () async {
      // Arrange
      const roomId = 'room-123';
      const playerId = 'user-123';
      final room = Room(
        id: roomId,
        creatorId: playerId,
        playerIds: [playerId],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      when(() => mockDatasource.getRoom(roomId))
          .thenAnswer((_) async => room);

      // Act
      final result = await repository.joinRoom(roomId, playerId);

      // Assert
      expect(result, const Left(ValidationFailure(message: 'Player already in room')));
    });
  });

  group('watchRoom', () {
    test('should return stream of room updates', () async {
      // Arrange
      const roomId = 'room-123';
      final room = Room(
        id: roomId,
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      when(() => mockDatasource.watchRoom(roomId))
          .thenAnswer((_) => Stream.value(room));

      // Act
      final stream = repository.watchRoom(roomId);

      // Assert
      await expectLater(stream, emits(room));
    });
  });

  group('watchRoomEvents', () {
    test('should return stream of room events', () async {
      // Arrange
      const roomId = 'room-123';
      const event = RoomEvent.playerJoined(
        playerId: 'user-456',
        playerName: 'Jane',
      );

      when(() => mockDatasource.watchRoomEvents(roomId))
          .thenAnswer((_) => Stream.value(event));

      // Act
      final stream = repository.watchRoomEvents(roomId);

      // Assert
      await expectLater(stream, emits(event));
    });
  });

  group('startGame', () {
    test('should return GameState when game starts successfully', () async {
      // Arrange
      const roomId = 'room-123';
      final room = Room(
        id: roomId,
        creatorId: 'user-123',
        playerIds: ['user-123', 'user-456'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      when(() => mockDatasource.getRoom(roomId))
          .thenAnswer((_) async => room);
      when(() => mockDatasource.updateRoom(any()))
          .thenAnswer((_) async => room.copyWith(
                status: RoomStatus.inGame,
                currentGameId: 'game-123',
              ));
      when(() => mockDatasource.createGameState(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.startGame(roomId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (gameState) {
          expect(gameState.roomId, roomId);
          expect(gameState.players.length, 2);
          expect(gameState.status, GameStatus.playing);
        },
      );
    });

    test('should return ValidationFailure when not enough players', () async {
      // Arrange
      const roomId = 'room-123';
      final room = Room(
        id: roomId,
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      when(() => mockDatasource.getRoom(roomId))
          .thenAnswer((_) async => room);

      // Act
      final result = await repository.startGame(roomId);

      // Assert
      expect(result, const Left(ValidationFailure(message: 'Not enough players to start')));
    });
  });

  group('getAvailableRooms', () {
    test('should return list of available rooms', () async {
      // Arrange
      final rooms = [
        Room(
          id: 'room-1',
          creatorId: 'user-1',
          playerIds: ['user-1'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
          createdAt: DateTime.now(),
        ),
        Room(
          id: 'room-2',
          creatorId: 'user-2',
          playerIds: ['user-2'],
          status: RoomStatus.waiting,
          maxPlayers: 6,
          createdAt: DateTime.now(),
        ),
      ];

      when(() => mockDatasource.getAvailableRooms())
          .thenAnswer((_) async => rooms);

      // Act
      final result = await repository.getAvailableRooms();

      // Assert
      expect(result, equals(rooms));
    });
  });
}