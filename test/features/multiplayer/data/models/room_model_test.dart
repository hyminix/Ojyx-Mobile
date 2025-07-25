import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/data/models/room_model.dart';
import 'package:ojyx/features/multiplayer/data/models/room_model_extensions.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';

void main() {
  group('Room Model and Extension Conversion for Multiplayer Data Management', () {
    test(
      'should enable comprehensive room data representation and conversion for competitive multiplayer coordination',
      () {
        // Test behavior: room model supports complete multiplayer data lifecycle with domain-persistence conversion

        final competitiveTimestamp = DateTime.now();

        // Complete room model for active competitive gameplay
        final fullCompetitiveRoom = RoomModel(
          id: 'competitive-arena-789',
          creatorId: 'strategic-host-456',
          playerIds: ['strategic-host-456', 'tactical-player-123'],
          status: 'waiting',
          maxPlayers: 6,
          currentGameId: null,
          createdAt: competitiveTimestamp,
          updatedAt: competitiveTimestamp,
        );

        expect(
          fullCompetitiveRoom.id,
          'competitive-arena-789',
          reason:
              'Room should be properly identified for multiplayer coordination',
        );
        expect(
          fullCompetitiveRoom.creatorId,
          'strategic-host-456',
          reason: 'Host should be established for game control',
        );
        expect(
          fullCompetitiveRoom.playerIds.length,
          2,
          reason:
              'Current participants should be tracked for competitive roster',
        );
        expect(
          fullCompetitiveRoom.status,
          'waiting',
          reason: 'Room state should indicate readiness for additional players',
        );
        expect(
          fullCompetitiveRoom.maxPlayers,
          6,
          reason: 'Capacity should enable strategic group gameplay',
        );

        // Domain entity to model conversion for persistence
        final competitiveDomainRoom = Room(
          id: 'domain-competitive-555',
          creatorId: 'domain-host-789',
          playerIds: [
            'domain-host-789',
            'competitive-player-123',
            'strategic-player-456',
          ],
          status: RoomStatus.inGame,
          maxPlayers: 8,
          currentGameId: 'active-competitive-match-999',
          createdAt: competitiveTimestamp,
          updatedAt: competitiveTimestamp,
        );

        final convertedModel = competitiveDomainRoom.toModel();
        expect(
          convertedModel.id,
          'domain-competitive-555',
          reason: 'Domain to model conversion should preserve room identity',
        );
        expect(
          convertedModel.status,
          'in_game',
          reason: 'Game status should be properly converted for persistence',
        );
        expect(
          convertedModel.playerIds.length,
          3,
          reason:
              'All competitive participants should be preserved in conversion',
        );
        expect(
          convertedModel.currentGameId,
          'active-competitive-match-999',
          reason: 'Active game reference should enable coordination',
        );
      },
    );

    test(
      'should execute bidirectional JSON serialization for persistent multiplayer room coordination',
      () {
        // Test behavior: room serialization enables database persistence and network synchronization

        final persistenceTimestamp = DateTime.now();
        final competitiveRoomModel = RoomModel(
          id: 'serializable-competitive-room-123',
          creatorId: 'persistent-host-456',
          playerIds: ['persistent-host-456', 'competitive-participant-789'],
          status: 'waiting',
          maxPlayers: 4,
          currentGameId: 'persistent-game-555',
          createdAt: persistenceTimestamp,
          updatedAt: persistenceTimestamp,
        );

        // Room to JSON for database storage
        final persistedJson = competitiveRoomModel.toJson();
        expect(
          persistedJson['id'],
          'serializable-competitive-room-123',
          reason: 'Room ID should be preserved for database identification',
        );
        expect(
          persistedJson['creator_id'],
          'persistent-host-456',
          reason: 'Host identification should persist for game control',
        );
        expect(
          persistedJson['player_ids'],
          ['persistent-host-456', 'competitive-participant-789'],
          reason: 'Player roster should be preserved for game continuity',
        );
        expect(
          persistedJson['status'],
          'waiting',
          reason: 'Room state should be accurately persisted',
        );
        expect(
          persistedJson['current_game_id'],
          'persistent-game-555',
          reason: 'Game reference should enable session coordination',
        );

        // JSON to room for data restoration
        final restorationData = {
          'id': 'restored-competitive-arena-789',
          'creator_id': 'restored-host-123',
          'player_ids': [
            'restored-host-123',
            'restored-player-456',
            'restored-competitor-789',
          ],
          'status': 'in_game',
          'max_players': 6,
          'current_game_id': 'restored-match-555',
          'created_at': persistenceTimestamp.toIso8601String(),
          'updated_at': persistenceTimestamp.toIso8601String(),
        };

        final restoredRoomModel = RoomModel.fromJson(restorationData);
        expect(
          restoredRoomModel.id,
          'restored-competitive-arena-789',
          reason: 'Restored room should maintain proper identification',
        );
        expect(
          restoredRoomModel.creatorId,
          'restored-host-123',
          reason: 'Host authority should be preserved through persistence',
        );
        expect(
          restoredRoomModel.playerIds.length,
          3,
          reason:
              'All competitive participants should be restored from database',
        );
        expect(
          restoredRoomModel.status,
          'in_game',
          reason: 'Active game status should be accurately restored',
        );
        expect(
          restoredRoomModel.currentGameId,
          'restored-match-555',
          reason: 'Game reference should enable session continuity',
        );
      },
    );

    test(
      'should enable comprehensive room status transitions and edge cases for competitive gameplay coordination',
      () {
        // Test behavior: room model handles all competitive game states and edge cases

        // Complete room status enum conversion testing
        final roomStatusMappings = [
          (RoomStatus.waiting, 'waiting'),
          (RoomStatus.inGame, 'in_game'),
          (RoomStatus.finished, 'finished'),
          (RoomStatus.cancelled, 'cancelled'),
        ];

        for (final (domainStatus, modelStatus) in roomStatusMappings) {
          final testRoom = Room(
            id: 'status-test-${domainStatus.name}',
            creatorId: 'status-tester-123',
            playerIds: ['status-tester-123'],
            status: domainStatus,
            maxPlayers: 4,
          );

          final convertedModel = testRoom.toModel();
          expect(
            convertedModel.status,
            modelStatus,
            reason:
                'Status ${domainStatus.name} should convert to $modelStatus for persistence',
          );
        }

        // Maximum capacity competitive room
        const fullCapacityRoom = Room(
          id: 'max-capacity-competitive-arena',
          creatorId: 'tournament-host-999',
          playerIds: [
            'tournament-host-999',
            'strategic-player-1',
            'tactical-player-2',
            'competitive-player-3',
            'experienced-player-4',
            'skilled-player-5',
            'expert-player-6',
            'master-player-7',
          ],
          status: RoomStatus.inGame,
          maxPlayers: 8,
        );

        final fullCapacityModel = fullCapacityRoom.toModel();
        expect(
          fullCapacityModel.playerIds.length,
          8,
          reason:
              'Maximum capacity rooms should track all competitive participants',
        );
        expect(
          fullCapacityModel.maxPlayers,
          8,
          reason:
              'Capacity limits should be preserved for tournament coordination',
        );

        // Single-player room edge case
        const soloRoom = Room(
          id: 'solo-preparation-room',
          creatorId: 'solo-strategist-456',
          playerIds: ['solo-strategist-456'],
          status: RoomStatus.waiting,
          maxPlayers: 2,
        );

        final soloModel = soloRoom.toModel();
        expect(
          soloModel.playerIds.length,
          1,
          reason: 'Solo rooms should handle single-player scenarios',
        );
        expect(
          soloModel.creatorId,
          soloModel.playerIds.first,
          reason: 'Creator should be the sole participant in solo rooms',
        );

        // Completed game room with full metadata
        final completedTimestamp = DateTime.now();
        final completedRoom = Room(
          id: 'completed-competitive-match',
          creatorId: 'match-winner-789',
          playerIds: [
            'match-winner-789',
            'skilled-competitor-123',
            'tactical-participant-456',
          ],
          status: RoomStatus.finished,
          maxPlayers: 4,
          currentGameId: 'finished-tournament-match-555',
          createdAt: completedTimestamp.subtract(const Duration(hours: 2)),
          updatedAt: completedTimestamp,
        );

        final completedModel = completedRoom.toModel();
        expect(
          completedModel.status,
          'finished',
          reason:
              'Completed games should reflect finished status for proper archival',
        );
        expect(
          completedModel.currentGameId,
          'finished-tournament-match-555',
          reason: 'Game references should be preserved for result tracking',
        );
        expect(
          completedModel.updatedAt,
          completedTimestamp,
          reason:
              'Completion timestamps should enable accurate game duration calculation',
        );
      },
    );
  });
}
