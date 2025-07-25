import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/multiplayer/data/repositories/room_repository_impl.dart';
import 'package:ojyx/features/multiplayer/domain/datasources/room_datasource.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/use_cases/game_initialization_use_case.dart';
import '../../../../mocks/mock_room_datasource.dart';

class MockGameInitializationUseCase extends Mock
    implements GameInitializationUseCase {}

void main() {
  late RoomRepositoryImpl repository;
  late MockRoomDatasource mockDatasource;
  late MockGameInitializationUseCase mockGameInitializationUseCase;

  setUpAll(() {
    registerRoomFallbackValues();
  });

  setUp(() {
    mockDatasource = MockRoomDatasource();
    mockGameInitializationUseCase = MockGameInitializationUseCase();
    repository = RoomRepositoryImpl(
      mockDatasource,
      mockGameInitializationUseCase,
    );
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

      when(
        () => mockDatasource.createRoom(
          creatorId: any(named: 'creatorId'),
          maxPlayers: any(named: 'maxPlayers'),
        ),
      ).thenAnswer((_) async => expectedRoom);

      // Act
      final result = await repository.createRoom(
        creatorId: creatorId,
        maxPlayers: maxPlayers,
      );

      // Assert
      expect(result, equals(expectedRoom));
      verify(
        () => mockDatasource.createRoom(
          creatorId: any(named: 'creatorId'),
          maxPlayers: any(named: 'maxPlayers'),
        ),
      ).called(1);
    });

    test('should throw exception when datasource throws exception', () async {
      // Arrange
      const creatorId = 'user-123';
      const maxPlayers = 4;

      when(
        () => mockDatasource.createRoom(
          creatorId: any(named: 'creatorId'),
          maxPlayers: any(named: 'maxPlayers'),
        ),
      ).thenThrow(Exception('Server error'));

      // Act & Assert
      expect(
        () =>
            repository.createRoom(creatorId: creatorId, maxPlayers: maxPlayers),
        throwsException,
      );
    });
  });

  group('joinRoom', () {
    test('should return updated Room when join is successful', () async {
      // Arrange
      const roomId = 'room-123';
      const playerId = 'user-456';
      final updatedRoom = Room(
        id: roomId,
        creatorId: 'user-123',
        playerIds: ['user-123', playerId],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      when(
        () => mockDatasource.joinRoom(
          roomId: any(named: 'roomId'),
          playerId: any(named: 'playerId'),
        ),
      ).thenAnswer((_) async => updatedRoom);

      // Act
      final result = await repository.joinRoom(
        roomId: roomId,
        playerId: playerId,
      );

      // Assert
      expect(result, equals(updatedRoom));
      verify(
        () => mockDatasource.joinRoom(
          roomId: any(named: 'roomId'),
          playerId: any(named: 'playerId'),
        ),
      ).called(1);
    });

    test('should return null when join fails', () async {
      // Arrange
      const roomId = 'room-123';
      const playerId = 'user-789';

      when(
        () => mockDatasource.joinRoom(
          roomId: any(named: 'roomId'),
          playerId: any(named: 'playerId'),
        ),
      ).thenThrow(Exception('Room is full'));

      // Act & Assert
      expect(
        () => repository.joinRoom(roomId: roomId, playerId: playerId),
        throwsException,
      );
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

      when(
        () => mockDatasource.watchRoom(roomId),
      ).thenAnswer((_) => Stream.value(room));

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

      when(
        () => mockDatasource.watchRoomEvents(roomId),
      ).thenAnswer((_) => Stream.value(event));

      // Act
      final stream = repository.watchRoomEvents(roomId);

      // Assert
      await expectLater(stream, emits(event));
    });
  });

  group('startGame', () {
    test('should update room status to inGame', () async {
      // Arrange
      const roomId = 'room-123';
      const gameId = 'game-123';
      final room = Room(
        id: roomId,
        creatorId: 'user-123',
        playerIds: ['user-123', 'user-456'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );
      final updatedRoom = room.copyWith(
        status: RoomStatus.inGame,
        currentGameId: gameId,
      );

      when(() => mockDatasource.getRoom(roomId)).thenAnswer((_) async => room);
      when(
        () => mockDatasource.updateRoom(any()),
      ).thenAnswer((_) async => updatedRoom);
      when(
        () => mockGameInitializationUseCase.execute(
          roomId: any(named: 'roomId'),
          playerIds: any(named: 'playerIds'),
          creatorId: any(named: 'creatorId'),
        ),
      ).thenAnswer(
        (_) async => GameState(
          roomId: roomId,
          players: [],
          currentPlayerIndex: 0,
          deck: [],
          discardPile: [],
          actionDeck: [],
          actionDiscard: [],
          status: GameStatus.waitingToStart,
          turnDirection: TurnDirection.clockwise,
          lastRound: false,
          drawnCard: null,
          createdAt: DateTime.now(),
          startedAt: null,
          finishedAt: null,
          initiatorPlayerId: null,
          endRoundInitiator: null,
        ),
      );

      // Act
      await repository.startGame(roomId: roomId, gameId: gameId);

      // Assert
      verify(() => mockDatasource.getRoom(roomId)).called(1);
      verify(() => mockDatasource.updateRoom(any())).called(1);
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

      when(
        () => mockDatasource.getAvailableRooms(),
      ).thenAnswer((_) async => rooms);

      // Act
      final result = await repository.getAvailableRooms();

      // Assert
      expect(result.length, 2);
      expect(result[0].id, 'room-1');
      expect(result[1].id, 'room-2');
    });
  });
}
