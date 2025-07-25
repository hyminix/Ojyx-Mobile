import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/repositories/room_repository.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/join_room_use_case.dart';

class MockRoomRepository extends Mock implements RoomRepository {}

void main() {
  group('Room Participation for Competitive Multiplayer Gaming', () {
    late JoinRoomUseCase joinRoomUseCase;
    late MockRoomRepository mockRepository;

    setUp(() {
      mockRepository = MockRoomRepository();
      joinRoomUseCase = JoinRoomUseCase(mockRepository);
    });

    test(
      'should successfully enable competitive multiplayer participation when strategic rooms are available for joining',
      () async {
        // Test behavior: room joining enables competitive participation by adding players to available strategic gaming environments

        const competitiveRoomId = 'strategic-tournament-arena-789';
        const strategicCompetitorId = 'elite-strategic-player-456';

        final availableCompetitiveRoom = Room(
          id: competitiveRoomId,
          creatorId: 'tournament-organizer-123',
          playerIds: ['tournament-organizer-123'],
          status: RoomStatus.waiting,
          maxPlayers: 6,
          createdAt: DateTime.now(),
        );

        final expandedCompetitiveRoom = availableCompetitiveRoom.copyWith(
          playerIds: ['tournament-organizer-123', strategicCompetitorId],
        );

        when(
          () => mockRepository.getRoom(competitiveRoomId),
        ).thenAnswer((_) async => availableCompetitiveRoom);
        when(
          () => mockRepository.joinRoom(
            roomId: competitiveRoomId,
            playerId: strategicCompetitorId,
          ),
        ).thenAnswer((_) async => expandedCompetitiveRoom);

        final participatedRoom = await joinRoomUseCase(
          roomId: competitiveRoomId,
          playerId: strategicCompetitorId,
        );

        expect(
          participatedRoom,
          isNotNull,
          reason: 'Join operation should return valid room',
        );
        expect(
          participatedRoom!.playerIds,
          contains(strategicCompetitorId),
          reason:
              'Strategic competitors should be successfully added to competitive rooms',
        );
        expect(
          participatedRoom.playerIds.length,
          2,
          reason:
              'Room expansion should accommodate new competitive participants',
        );
        expect(
          participatedRoom.status,
          RoomStatus.waiting,
          reason:
              'Joined rooms should maintain availability for additional competitive participants',
        );

        verify(() => mockRepository.getRoom(competitiveRoomId)).called(1);
        verify(
          () => mockRepository.joinRoom(
            roomId: competitiveRoomId,
            playerId: strategicCompetitorId,
          ),
        ).called(1);
      },
    );

    group(
      'should enforce competitive gaming constraints to maintain fair and strategic multiplayer experiences',
      () {
        test('when attempting to join non-existent competitive rooms', () async {
          // Test behavior: room participation validates room existence to prevent invalid competitive scenarios

          const nonExistentRoomId = 'phantom-strategic-arena-999';
          const strategicCompetitorId = 'strategic-player-456';

          when(
            () => mockRepository.getRoom(nonExistentRoomId),
          ).thenAnswer((_) async => null);

          expect(
            () => joinRoomUseCase(
              roomId: nonExistentRoomId,
              playerId: strategicCompetitorId,
            ),
            throwsException,
            reason:
                'Non-existent rooms should be rejected to prevent invalid competitive participation',
          );
        });

        test(
          'when attempting to join active competitive matches in progress',
          () async {
            // Test behavior: room participation prevents mid-game joining to maintain competitive integrity

            const activeRoomId = 'ongoing-tournament-match-456';
            const lateCompetitorId = 'late-strategic-player-789';

            final activeCompetitiveRoom = Room(
              id: activeRoomId,
              creatorId: 'tournament-host-123',
              playerIds: ['tournament-host-123', 'early-competitor-456'],
              status: RoomStatus.inGame,
              maxPlayers: 4,
              createdAt: DateTime.now(),
            );

            when(
              () => mockRepository.getRoom(activeRoomId),
            ).thenAnswer((_) async => activeCompetitiveRoom);

            expect(
              () => joinRoomUseCase(
                roomId: activeRoomId,
                playerId: lateCompetitorId,
              ),
              throwsException,
              reason:
                  'Active matches should reject new participants to maintain competitive fairness',
            );
          },
        );

        test(
          'when attempting to join capacity-reached competitive rooms',
          () async {
            // Test behavior: room participation enforces capacity limits to maintain strategic competitive balance

            const capacityReachedRoomId = 'full-strategic-arena-123';
            const excludedCompetitorId = 'overflow-strategic-player-999';

            final capacityReachedRoom = Room(
              id: capacityReachedRoomId,
              creatorId: 'tournament-organizer-123',
              playerIds: ['tournament-organizer-123', 'competitor-456'],
              status: RoomStatus.waiting,
              maxPlayers: 2,
              createdAt: DateTime.now(),
            );

            when(
              () => mockRepository.getRoom(capacityReachedRoomId),
            ).thenAnswer((_) async => capacityReachedRoom);

            expect(
              () => joinRoomUseCase(
                roomId: capacityReachedRoomId,
                playerId: excludedCompetitorId,
              ),
              throwsException,
              reason:
                  'Capacity-reached rooms should reject additional participants to maintain strategic competitive balance',
            );
          },
        );
      },
    );
  });
}
