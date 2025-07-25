import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/repositories/room_repository.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/create_room_use_case.dart';

class MockRoomRepository extends Mock implements RoomRepository {}

void main() {
  group('Room Creation Use Case for Competitive Multiplayer Gaming Coordination', () {
    late CreateRoomUseCase createRoomUseCase;
    late MockRoomRepository mockRepository;

    setUp(() {
      mockRepository = MockRoomRepository();
      createRoomUseCase = CreateRoomUseCase(mockRepository);
    });

    test(
      'should successfully establish competitive rooms for strategic multiplayer gaming experiences',
      () async {
        // Test behavior: room creation enables competitive gaming by establishing properly configured multiplayer environments

        const strategicHostId = 'competitive-host-789';
        const competitiveCapacity = 6;
        final establishedCompetitiveRoom = Room(
          id: 'strategic-tournament-arena-456',
          creatorId: strategicHostId,
          playerIds: [strategicHostId],
          status: RoomStatus.waiting,
          maxPlayers: competitiveCapacity,
          createdAt: DateTime.now(),
        );

        when(
          () => mockRepository.createRoom(
            creatorId: strategicHostId,
            maxPlayers: competitiveCapacity,
          ),
        ).thenAnswer((_) async => establishedCompetitiveRoom);

        final createdRoom = await createRoomUseCase(
          creatorId: strategicHostId,
          maxPlayers: competitiveCapacity,
        );

        expect(
          createdRoom.creatorId,
          strategicHostId,
          reason:
              'Room creation should establish proper host authority for competitive control',
        );
        expect(
          createdRoom.maxPlayers,
          competitiveCapacity,
          reason: 'Capacity should enable strategic group competitive gameplay',
        );
        expect(
          createdRoom.status,
          RoomStatus.waiting,
          reason:
              'New rooms should be ready to accept competitive participants',
        );
        expect(
          createdRoom.playerIds,
          [strategicHostId],
          reason: 'Host should be the initial participant in competitive room',
        );

        verify(
          () => mockRepository.createRoom(
            creatorId: strategicHostId,
            maxPlayers: competitiveCapacity,
          ),
        ).called(1);
      },
    );

    test(
      'should enforce competitive gaming constraints to ensure fair and strategic multiplayer experiences',
      () {
        // Test behavior: room creation validates parameters to maintain competitive gaming integrity

        const competitiveHostId = 'strategic-host-123';

        // Insufficient capacity constraint for competitive gaming
        expect(
          () => createRoomUseCase(creatorId: competitiveHostId, maxPlayers: 1),
          throwsA(isA<ArgumentError>()),
          reason:
              'Single-player rooms should be rejected to ensure multiplayer competitive experiences',
        );

        // Excessive capacity constraint for manageable competitive gaming
        expect(
          () => createRoomUseCase(creatorId: competitiveHostId, maxPlayers: 9),
          throwsA(isA<ArgumentError>()),
          reason:
              'Oversized rooms should be rejected to maintain strategic competitive balance',
        );
      },
    );
  });
}
