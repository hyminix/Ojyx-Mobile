import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/repositories/room_repository.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/create_room_use_case.dart';

class MockRoomRepository extends Mock implements RoomRepository {}

void main() {
  late CreateRoomUseCase createRoomUseCase;
  late MockRoomRepository mockRepository;

  setUp(() {
    mockRepository = MockRoomRepository();
    createRoomUseCase = CreateRoomUseCase(mockRepository);
  });

  group('CreateRoomUseCase', () {
    test('should create room with valid parameters', () async {
      // Arrange
      const creatorId = 'user123';
      const maxPlayers = 4;
      final expectedRoom = Room(
        id: 'room123',
        creatorId: creatorId,
        playerIds: [creatorId],
        status: RoomStatus.waiting,
        maxPlayers: maxPlayers,
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepository.createRoom(
          creatorId: creatorId,
          maxPlayers: maxPlayers,
        ),
      ).thenAnswer((_) async => expectedRoom);

      // Act
      final result = await createRoomUseCase(
        creatorId: creatorId,
        maxPlayers: maxPlayers,
      );

      // Assert
      expect(result, equals(expectedRoom));
      verify(
        () => mockRepository.createRoom(
          creatorId: creatorId,
          maxPlayers: maxPlayers,
        ),
      ).called(1);
    });

    test('should throw error when maxPlayers is less than 2', () {
      // Arrange
      const creatorId = 'user123';
      const maxPlayers = 1;

      // Act & Assert
      expect(
        () => createRoomUseCase(creatorId: creatorId, maxPlayers: maxPlayers),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw error when maxPlayers is more than 8', () {
      // Arrange
      const creatorId = 'user123';
      const maxPlayers = 9;

      // Act & Assert
      expect(
        () => createRoomUseCase(creatorId: creatorId, maxPlayers: maxPlayers),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
