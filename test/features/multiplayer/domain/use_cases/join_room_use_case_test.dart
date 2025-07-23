import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/repositories/room_repository.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/join_room_use_case.dart';

class MockRoomRepository extends Mock implements RoomRepository {}

void main() {
  late JoinRoomUseCase joinRoomUseCase;
  late MockRoomRepository mockRepository;
  
  setUp(() {
    mockRepository = MockRoomRepository();
    joinRoomUseCase = JoinRoomUseCase(mockRepository);
  });
  
  group('JoinRoomUseCase', () {
    test('should join room successfully when room is available', () async {
      // Arrange
      const roomId = 'room123';
      const playerId = 'user456';
      final existingRoom = Room(
        id: roomId,
        creatorId: 'user123',
        playerIds: ['user123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );
      final updatedRoom = existingRoom.copyWith(
        playerIds: ['user123', playerId],
      );
      
      when(() => mockRepository.getRoom(roomId))
          .thenAnswer((_) async => existingRoom);
      when(() => mockRepository.joinRoom(
        roomId: roomId,
        playerId: playerId,
      )).thenAnswer((_) async => updatedRoom);
      
      // Act
      final result = await joinRoomUseCase(
        roomId: roomId,
        playerId: playerId,
      );
      
      // Assert
      expect(result, equals(updatedRoom));
      verify(() => mockRepository.getRoom(roomId)).called(1);
      verify(() => mockRepository.joinRoom(
        roomId: roomId,
        playerId: playerId,
      )).called(1);
    });
    
    test('should throw exception when room not found', () async {
      // Arrange
      const roomId = 'nonexistent';
      const playerId = 'user456';
      
      when(() => mockRepository.getRoom(roomId))
          .thenAnswer((_) async => null);
      
      // Act & Assert
      expect(
        () => joinRoomUseCase(
          roomId: roomId,
          playerId: playerId,
        ),
        throwsException,
      );
    });
    
    test('should throw exception when room is not waiting', () async {
      // Arrange
      const roomId = 'room123';
      const playerId = 'user456';
      final room = Room(
        id: roomId,
        creatorId: 'user123',
        playerIds: ['user123', 'user789'],
        status: RoomStatus.inGame,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );
      
      when(() => mockRepository.getRoom(roomId))
          .thenAnswer((_) async => room);
      
      // Act & Assert
      expect(
        () => joinRoomUseCase(
          roomId: roomId,
          playerId: playerId,
        ),
        throwsException,
      );
    });
    
    test('should throw exception when room is full', () async {
      // Arrange
      const roomId = 'room123';
      const playerId = 'user456';
      final room = Room(
        id: roomId,
        creatorId: 'user123',
        playerIds: ['user123', 'user789'],
        status: RoomStatus.waiting,
        maxPlayers: 2,
        createdAt: DateTime.now(),
      );
      
      when(() => mockRepository.getRoom(roomId))
          .thenAnswer((_) async => room);
      
      // Act & Assert
      expect(
        () => joinRoomUseCase(
          roomId: roomId,
          playerId: playerId,
        ),
        throwsException,
      );
    });
  });
}