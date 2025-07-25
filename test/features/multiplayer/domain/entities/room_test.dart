import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';

void main() {
  group('Room Behavior for Competitive Multiplayer Gaming Coordination', () {
    test(
      'should enable complete room lifecycle management for strategic competitive multiplayer gaming',
      () {
        // Test behavior: room entity supports full competitive gaming workflow from creation to completion

        final competitiveTimestamp = DateTime.now();

        // Room creation for competitive gameplay
        final newCompetitiveRoom = Room(
          id: 'strategic-arena-789',
          creatorId: 'tournament-host-456',
          playerIds: ['tournament-host-456'],
          status: RoomStatus.waiting,
          maxPlayers: 6,
          createdAt: competitiveTimestamp,
        );

        expect(
          newCompetitiveRoom.id,
          'strategic-arena-789',
          reason: 'Room should be uniquely identified for competitive tracking',
        );
        expect(
          newCompetitiveRoom.creatorId,
          'tournament-host-456',
          reason: 'Host should be established for competitive game control',
        );
        expect(
          newCompetitiveRoom.playerIds,
          ['tournament-host-456'],
          reason: 'Creator should be initial participant in competitive room',
        );
        expect(
          newCompetitiveRoom.status,
          RoomStatus.waiting,
          reason:
              'New rooms should be ready to accept competitive participants',
        );
        expect(
          newCompetitiveRoom.maxPlayers,
          6,
          reason: 'Capacity should enable strategic group competitive gameplay',
        );
        expect(
          newCompetitiveRoom.currentGameId,
          isNull,
          reason: 'Unstarted rooms should not have active game references',
        );

        // Player joining for competitive participation
        final expandedCompetitiveRoom = newCompetitiveRoom.copyWith(
          playerIds: [
            ...newCompetitiveRoom.playerIds,
            'strategic-competitor-123',
            'tactical-player-789',
          ],
        );

        expect(
          expandedCompetitiveRoom.playerIds.length,
          3,
          reason:
              'Room should expand to accommodate strategic competitive participants',
        );
        expect(
          expandedCompetitiveRoom.playerIds,
          contains('strategic-competitor-123'),
          reason: 'New competitors should be properly registered',
        );
        expect(
          expandedCompetitiveRoom.playerIds,
          contains('tactical-player-789'),
          reason:
              'All strategic players should be tracked for competitive coordination',
        );

        // Game initialization for competitive match start
        final activeCompetitiveRoom = expandedCompetitiveRoom.copyWith(
          status: RoomStatus.inGame,
          currentGameId: 'tournament-match-555',
        );

        expect(
          activeCompetitiveRoom.status,
          RoomStatus.inGame,
          reason:
              'Room should transition to active state for competitive gameplay',
        );
        expect(
          activeCompetitiveRoom.currentGameId,
          'tournament-match-555',
          reason:
              'Active game reference should enable competitive match coordination',
        );

        // Room completion for competitive archival
        final completedCompetitiveRoom = activeCompetitiveRoom.copyWith(
          status: RoomStatus.finished,
          updatedAt: competitiveTimestamp.add(const Duration(hours: 1)),
        );

        expect(
          completedCompetitiveRoom.status,
          RoomStatus.finished,
          reason:
              'Completed rooms should reflect finished state for proper competitive archival',
        );
        expect(
          completedCompetitiveRoom.updatedAt?.isAfter(competitiveTimestamp),
          true,
          reason:
              'Completion timestamp should enable accurate competitive duration tracking',
        );
      },
    );

    test(
      'should maintain room identity and support persistence for multiplayer game continuity',
      () {
        // Test behavior: room entity ensures consistent identity and persistence across competitive sessions

        final persistenceTimestamp = DateTime.now();

        // Identical room creation for value equality verification
        final originalCompetitiveRoom = Room(
          id: 'persistent-competitive-arena-123',
          creatorId: 'persistent-host-456',
          playerIds: ['persistent-host-456', 'competitive-player-789'],
          status: RoomStatus.inGame,
          maxPlayers: 4,
          currentGameId: 'persistent-match-555',
          createdAt: persistenceTimestamp,
          updatedAt: persistenceTimestamp,
        );

        final duplicateCompetitiveRoom = Room(
          id: 'persistent-competitive-arena-123',
          creatorId: 'persistent-host-456',
          playerIds: ['persistent-host-456', 'competitive-player-789'],
          status: RoomStatus.inGame,
          maxPlayers: 4,
          currentGameId: 'persistent-match-555',
          createdAt: persistenceTimestamp,
          updatedAt: persistenceTimestamp,
        );

        expect(
          originalCompetitiveRoom,
          duplicateCompetitiveRoom,
          reason:
              'Identical rooms should maintain value equality for consistent competitive state management',
        );

        // Serialization for network persistence and synchronization
        final serializedRoomData = originalCompetitiveRoom.toJson();
        final deserializedRoom = Room.fromJson(serializedRoomData);

        expect(
          deserializedRoom,
          originalCompetitiveRoom,
          reason:
              'Room serialization should preserve all competitive state data for multiplayer continuity',
        );
        expect(
          deserializedRoom.playerIds.length,
          2,
          reason:
              'All competitive participants should be preserved through persistence',
        );
        expect(
          deserializedRoom.currentGameId,
          'persistent-match-555',
          reason:
              'Active game references should survive serialization for session continuity',
        );
      },
    );
  });
}
