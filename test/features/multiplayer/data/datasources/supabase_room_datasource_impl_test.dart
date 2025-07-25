import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_room_datasource_impl.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_room_datasource.dart';
import 'package:ojyx/features/multiplayer/data/models/room_model_extensions.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import '../../../../mocks/mock_room_datasource.dart';

class MockSupabaseRoomDatasource extends Mock
    implements SupabaseRoomDatasource {}

void main() {
  group(
    'Supabase Room Data Persistence for Competitive Multiplayer Gaming Infrastructure',
    () {
      late SupabaseRoomDatasourceImpl datasource;
      late MockSupabaseRoomDatasource mockSupabaseDatasource;

      setUp(() {
        mockSupabaseDatasource = MockSupabaseRoomDatasource();
        datasource = SupabaseRoomDatasourceImpl(mockSupabaseDatasource);
      });

      setUpAll(() {
        registerRoomFallbackValues();
      });

      test(
        'should enable comprehensive competitive room data management for strategic multiplayer gaming coordination',
        () async {
          // Test behavior: datasource provides reliable room persistence to support competitive multiplayer experiences through complete room lifecycle management

          const strategicHostId = 'competitive-tournament-host-789';
          const competitiveCapacity = 6;
          const competitiveRoomId = 'strategic-tournament-arena-456';
          const liveGameId = 'active-competitive-match-999';

          final newCompetitiveRoom = Room(
            id: competitiveRoomId,
            creatorId: strategicHostId,
            playerIds: [strategicHostId],
            status: RoomStatus.waiting,
            maxPlayers: competitiveCapacity,
            createdAt: DateTime.now(),
          );

          final updatedCompetitiveRoom = newCompetitiveRoom.copyWith(
            playerIds: [
              strategicHostId,
              'strategic-competitor-123',
              'tactical-player-456',
            ],
            status: RoomStatus.inGame,
            currentGameId: liveGameId,
            updatedAt: DateTime.now(),
          );

          final availableCompetitiveRooms = [
            Room(
              id: 'arena-alpha-123',
              creatorId: 'host-alpha',
              playerIds: ['host-alpha'],
              status: RoomStatus.waiting,
              maxPlayers: 4,
              createdAt: DateTime.now(),
            ),
            Room(
              id: 'arena-beta-456',
              creatorId: 'host-beta',
              playerIds: ['host-beta', 'player-gamma'],
              status: RoomStatus.waiting,
              maxPlayers: 6,
              createdAt: DateTime.now(),
            ),
          ];

          // Room creation behavior - establish competitive environments
          when(
            () => mockSupabaseDatasource.createRoom(
              creatorId: strategicHostId,
              maxPlayers: competitiveCapacity,
            ),
          ).thenAnswer((_) async => newCompetitiveRoom.toModel());

          final createdRoom = await datasource.createRoom(
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
            reason:
                'Capacity should enable strategic group competitive gameplay',
          );
          expect(
            createdRoom.status,
            RoomStatus.waiting,
            reason:
                'New rooms should be ready to accept competitive participants',
          );

          // Real-time room monitoring behavior - enable live coordination
          when(
            () => mockSupabaseDatasource.watchRoom(competitiveRoomId),
          ).thenAnswer((_) => Stream.value(updatedCompetitiveRoom.toModel()));

          final roomMonitoringStream = datasource.watchRoom(competitiveRoomId);

          await expectLater(
            roomMonitoringStream,
            emits(updatedCompetitiveRoom),
            reason:
                'Room monitoring should provide real-time updates for competitive coordination',
          );

          // Room state management behavior - coordinate competitive transitions
          when(
            () => mockSupabaseDatasource.updateRoomStatus(
              roomId: competitiveRoomId,
              status: 'in_game',
              gameId: liveGameId,
            ),
          ).thenAnswer((_) async {});
          when(
            () => mockSupabaseDatasource.getRoom(competitiveRoomId),
          ).thenAnswer((_) async => updatedCompetitiveRoom.toModel());

          final persistedRoom = await datasource.updateRoom(
            updatedCompetitiveRoom,
          );

          expect(
            persistedRoom.status,
            RoomStatus.inGame,
            reason: 'Room updates should reflect competitive game transitions',
          );
          expect(
            persistedRoom.currentGameId,
            liveGameId,
            reason:
                'Active game references should be maintained for competitive coordination',
          );
          expect(
            persistedRoom.playerIds.length,
            3,
            reason:
                'Player roster should be preserved through competitive state changes',
          );

          // Room discovery behavior - enable competitive matchmaking
          when(() => mockSupabaseDatasource.getAvailableRooms()).thenAnswer(
            (_) async =>
                availableCompetitiveRooms.map((r) => r.toModel()).toList(),
          );

          final discoveredRooms = await datasource.getAvailableRooms();

          expect(
            discoveredRooms.length,
            2,
            reason:
                'Room discovery should provide multiple competitive options for strategic matchmaking',
          );
          expect(
            discoveredRooms[0].id,
            'arena-alpha-123',
            reason:
                'First discovered room should be accessible for competitive participation',
          );
          expect(
            discoveredRooms[1].id,
            'arena-beta-456',
            reason:
                'Second discovered room should offer alternative competitive gameplay',
          );
          expect(
            discoveredRooms.every((room) => room.status == RoomStatus.waiting),
            true,
            reason:
                'All discovered rooms should be accepting new competitive participants',
          );

          // Error handling behavior - maintain system reliability
          when(
            () => mockSupabaseDatasource.createRoom(
              creatorId: any(named: 'creatorId'),
              maxPlayers: any(named: 'maxPlayers'),
            ),
          ).thenThrow(
            Exception(
              'Competitive room infrastructure temporarily unavailable',
            ),
          );

          expect(
            () =>
                datasource.createRoom(creatorId: 'failing-host', maxPlayers: 4),
            throwsException,
            reason:
                'Infrastructure failures should be properly propagated to maintain competitive system reliability',
          );

          verify(
            () => mockSupabaseDatasource.createRoom(
              creatorId: strategicHostId,
              maxPlayers: competitiveCapacity,
            ),
          ).called(1);
          verify(
            () => mockSupabaseDatasource.updateRoomStatus(
              roomId: competitiveRoomId,
              status: 'in_game',
              gameId: liveGameId,
            ),
          ).called(1);
          verify(
            () => mockSupabaseDatasource.getRoom(competitiveRoomId),
          ).called(1);
          verify(() => mockSupabaseDatasource.getAvailableRooms()).called(1);
        },
      );
    },
  );
}
