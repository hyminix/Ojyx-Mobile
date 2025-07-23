import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/multiplayer/domain/repositories/room_repository.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';

class MockRoomRepository extends Mock implements RoomRepository {}
class FakeRoom extends Fake implements Room {}
class FakeRoomEvent extends Fake implements RoomEvent {}

void main() {
  late MockRoomRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeRoom());
    registerFallbackValue(FakeRoomEvent());
    registerFallbackValue(RoomStatus.waiting);
  });

  setUp(() {
    mockRepository = MockRoomRepository();
  });

  group('RoomRepository interface', () {
    test('should define createRoom method', () async {
      // Arrange
      const creatorId = 'creator123';
      const maxPlayers = 4;
      final expectedRoom = Room(
        id: 'room123',
        creatorId: creatorId,
        playerIds: [creatorId],
        status: RoomStatus.waiting,
        maxPlayers: maxPlayers,
      );

      when(() => mockRepository.createRoom(
        creatorId: creatorId,
        maxPlayers: maxPlayers,
      )).thenAnswer((_) async => expectedRoom);

      // Act
      final result = await mockRepository.createRoom(
        creatorId: creatorId,
        maxPlayers: maxPlayers,
      );

      // Assert
      expect(result, equals(expectedRoom));
      verify(() => mockRepository.createRoom(
        creatorId: creatorId,
        maxPlayers: maxPlayers,
      )).called(1);
    });

    test('should define joinRoom method', () async {
      // Arrange
      const roomId = 'room123';
      const playerId = 'player456';
      final expectedRoom = Room(
        id: roomId,
        creatorId: 'creator123',
        playerIds: ['creator123', playerId],
        status: RoomStatus.waiting,
        maxPlayers: 4,
      );

      when(() => mockRepository.joinRoom(
        roomId: roomId,
        playerId: playerId,
      )).thenAnswer((_) async => expectedRoom);

      // Act
      final result = await mockRepository.joinRoom(
        roomId: roomId,
        playerId: playerId,
      );

      // Assert
      expect(result, equals(expectedRoom));
      verify(() => mockRepository.joinRoom(
        roomId: roomId,
        playerId: playerId,
      )).called(1);
    });

    test('should handle null return from joinRoom', () async {
      // Arrange
      const roomId = 'room123';
      const playerId = 'player456';

      when(() => mockRepository.joinRoom(
        roomId: roomId,
        playerId: playerId,
      )).thenAnswer((_) async => null);

      // Act
      final result = await mockRepository.joinRoom(
        roomId: roomId,
        playerId: playerId,
      );

      // Assert
      expect(result, isNull);
    });

    test('should define leaveRoom method', () async {
      // Arrange
      const roomId = 'room123';
      const playerId = 'player456';

      when(() => mockRepository.leaveRoom(
        roomId: roomId,
        playerId: playerId,
      )).thenAnswer((_) async => null);

      // Act & Assert
      await expectLater(
        mockRepository.leaveRoom(roomId: roomId, playerId: playerId),
        completes,
      );
      verify(() => mockRepository.leaveRoom(
        roomId: roomId,
        playerId: playerId,
      )).called(1);
    });

    test('should define getRoom method', () async {
      // Arrange
      const roomId = 'room123';
      final expectedRoom = Room(
        id: roomId,
        creatorId: 'creator123',
        playerIds: ['creator123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
      );

      when(() => mockRepository.getRoom(roomId))
          .thenAnswer((_) async => expectedRoom);

      // Act
      final result = await mockRepository.getRoom(roomId);

      // Assert
      expect(result, equals(expectedRoom));
      verify(() => mockRepository.getRoom(roomId)).called(1);
    });

    test('should handle null return from getRoom', () async {
      // Arrange
      const roomId = 'nonexistent';

      when(() => mockRepository.getRoom(roomId))
          .thenAnswer((_) async => null);

      // Act
      final result = await mockRepository.getRoom(roomId);

      // Assert
      expect(result, isNull);
    });

    test('should define watchRoom method', () {
      // Arrange
      const roomId = 'room123';
      final roomStream = Stream<Room>.value(
        const Room(
          id: roomId,
          creatorId: 'creator123',
          playerIds: ['creator123'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
        ),
      );

      when(() => mockRepository.watchRoom(roomId)).thenAnswer((_) => roomStream);

      // Act
      final result = mockRepository.watchRoom(roomId);

      // Assert
      expect(result, isA<Stream<Room>>());
      verify(() => mockRepository.watchRoom(roomId)).called(1);
    });

    test('should define sendEvent method', () async {
      // Arrange
      const roomId = 'room123';
      final event = RoomEvent.playerJoined(
        playerId: 'player456',
        playerName: 'Player 456',
      );

      when(() => mockRepository.sendEvent(
        roomId: roomId,
        event: any(named: 'event'),
      )).thenAnswer((_) async => null);

      // Act & Assert
      await expectLater(
        mockRepository.sendEvent(roomId: roomId, event: event),
        completes,
      );
      verify(() => mockRepository.sendEvent(
        roomId: roomId,
        event: any(named: 'event'),
      )).called(1);
    });

    test('should define watchRoomEvents method', () {
      // Arrange
      const roomId = 'room123';
      final eventStream = Stream<RoomEvent>.value(
        RoomEvent.playerJoined(
          playerId: 'player456',
          playerName: 'Player 456',
        ),
      );

      when(() => mockRepository.watchRoomEvents(roomId))
          .thenAnswer((_) => eventStream);

      // Act
      final result = mockRepository.watchRoomEvents(roomId);

      // Assert
      expect(result, isA<Stream<RoomEvent>>());
      verify(() => mockRepository.watchRoomEvents(roomId)).called(1);
    });

    test('should define getAvailableRooms method', () async {
      // Arrange
      final expectedRooms = [
        const Room(
          id: 'room1',
          creatorId: 'creator1',
          playerIds: ['creator1'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
        ),
        const Room(
          id: 'room2',
          creatorId: 'creator2',
          playerIds: ['creator2'],
          status: RoomStatus.waiting,
          maxPlayers: 6,
        ),
      ];

      when(() => mockRepository.getAvailableRooms())
          .thenAnswer((_) async => expectedRooms);

      // Act
      final result = await mockRepository.getAvailableRooms();

      // Assert
      expect(result, equals(expectedRooms));
      expect(result.length, equals(2));
      verify(() => mockRepository.getAvailableRooms()).called(1);
    });

    test('should define startGame method', () async {
      // Arrange
      const roomId = 'room123';
      const gameId = 'game456';

      when(() => mockRepository.startGame(
        roomId: roomId,
        gameId: gameId,
      )).thenAnswer((_) async => null);

      // Act & Assert
      await expectLater(
        mockRepository.startGame(roomId: roomId, gameId: gameId),
        completes,
      );
      verify(() => mockRepository.startGame(
        roomId: roomId,
        gameId: gameId,
      )).called(1);
    });

    test('should define updateRoomStatus method', () async {
      // Arrange
      const roomId = 'room123';
      const status = RoomStatus.inGame;

      when(() => mockRepository.updateRoomStatus(
        roomId: roomId,
        status: status,
      )).thenAnswer((_) async => null);

      // Act & Assert
      await expectLater(
        mockRepository.updateRoomStatus(roomId: roomId, status: status),
        completes,
      );
      verify(() => mockRepository.updateRoomStatus(
        roomId: roomId,
        status: status,
      )).called(1);
    });

    test('should handle all RoomStatus values', () async {
      // Arrange
      const roomId = 'room123';
      
      for (final status in RoomStatus.values) {
        when(() => mockRepository.updateRoomStatus(
          roomId: roomId,
          status: status,
        )).thenAnswer((_) async => null);

        // Act & Assert
        await expectLater(
          mockRepository.updateRoomStatus(roomId: roomId, status: status),
          completes,
        );
        verify(() => mockRepository.updateRoomStatus(
          roomId: roomId,
          status: status,
        )).called(1);
      }
    });

    test('should handle room full scenario', () async {
      // Arrange
      const roomId = 'room123';
      const playerId = 'player789';

      when(() => mockRepository.joinRoom(
        roomId: roomId,
        playerId: playerId,
      )).thenAnswer((_) async => null);

      when(() => mockRepository.getRoom(roomId))
          .thenAnswer((_) async => const Room(
        id: roomId,
        creatorId: 'creator123',
        playerIds: ['creator123', 'player456', 'player567', 'player678'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
      ));

      // Act
      final joinResult = await mockRepository.joinRoom(
        roomId: roomId,
        playerId: playerId,
      );
      final roomInfo = await mockRepository.getRoom(roomId);

      // Assert
      expect(joinResult, isNull);
      expect(roomInfo!.playerIds.length, equals(roomInfo.maxPlayers));
    });
  });
}