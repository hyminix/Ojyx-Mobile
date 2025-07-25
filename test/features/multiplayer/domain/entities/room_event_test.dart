import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';

void main() {
  group('Room Event Coordination for Multiplayer Game Communication', () {
    test(
      'should enable comprehensive room event creation and handling for competitive multiplayer coordination',
      () {
        // Test behavior: room events support complete multiplayer communication for competitive gaming

        // Player joining event for competitive coordination
        const competitiveJoinEvent = RoomEvent.playerJoined(
          playerId: 'strategic-competitor-789',
          playerName: 'Elite Strategic Player',
        );

        competitiveJoinEvent.when(
          playerJoined: (playerId, playerName) {
            expect(
              playerId,
              'strategic-competitor-789',
              reason:
                  'Join events should identify new competitive participants',
            );
            expect(
              playerName,
              'Elite Strategic Player',
              reason:
                  'Player names should be preserved for competitive identification',
            );
          },
          playerLeft: (_) => fail('Event type mismatch - expected player join'),
          gameStarted: (_, _) =>
              fail('Event type mismatch - expected player join'),
          gameStateUpdated: (_) =>
              fail('Event type mismatch - expected player join'),
          playerAction: (_, _, __) =>
              fail('Event type mismatch - expected player join'),
        );

        // Player departure event for competitive coordination
        const competitiveLeaveEvent = RoomEvent.playerLeft(
          playerId: 'departing-competitor-456',
        );

        competitiveLeaveEvent.when(
          playerJoined: (_, _) =>
              fail('Event type mismatch - expected player leave'),
          playerLeft: (playerId) {
            expect(
              playerId,
              'departing-competitor-456',
              reason:
                  'Leave events should identify departing competitive participants',
            );
          },
          gameStarted: (_, _) =>
              fail('Event type mismatch - expected player leave'),
          gameStateUpdated: (_) =>
              fail('Event type mismatch - expected player leave'),
          playerAction: (_, _, __) =>
              fail('Event type mismatch - expected player leave'),
        );

        // Game initiation event for competitive match start
        final competitiveGameState = GameState.initial(
          roomId: 'competitive-tournament-room-555',
          players: [
            GamePlayer(
              id: 'tournament-host-123',
              name: 'Tournament Organizer',
              grid: PlayerGrid.empty(),
              isHost: true,
            ),
            GamePlayer(
              id: 'strategic-player-456',
              name: 'Strategic Competitor',
              grid: PlayerGrid.empty(),
              isHost: false,
            ),
          ],
        );

        final competitiveGameStartEvent = RoomEvent.gameStarted(
          gameId: 'tournament-match-789',
          initialState: competitiveGameState,
        );

        competitiveGameStartEvent.when(
          playerJoined: (_, _) =>
              fail('Event type mismatch - expected game start'),
          playerLeft: (_) => fail('Event type mismatch - expected game start'),
          gameStarted: (gameId, gameState) {
            expect(
              gameId,
              'tournament-match-789',
              reason: 'Game start events should identify competitive matches',
            );
            expect(
              gameState.roomId,
              'competitive-tournament-room-555',
              reason: 'Initial game state should link to competitive room',
            );
            expect(
              gameState.players.length,
              2,
              reason: 'Game state should include all competitive participants',
            );
          },
          gameStateUpdated: (_) =>
              fail('Event type mismatch - expected game start'),
          playerAction: (_, _, __) =>
              fail('Event type mismatch - expected game start'),
        );

        // Strategic player action event for competitive gameplay
        final strategicActionData = {
          'cardPosition': 3,
          'actionSource': 'strategic_deck',
        };
        final competitiveActionEvent = RoomEvent.playerAction(
          playerId: 'strategic-player-456',
          actionType: PlayerActionType.drawCard,
          actionData: strategicActionData,
        );

        competitiveActionEvent.when(
          playerJoined: (_, _) =>
              fail('Event type mismatch - expected player action'),
          playerLeft: (_) =>
              fail('Event type mismatch - expected player action'),
          gameStarted: (_, _) =>
              fail('Event type mismatch - expected player action'),
          gameStateUpdated: (_) =>
              fail('Event type mismatch - expected player action'),
          playerAction: (playerId, actionType, data) {
            expect(
              playerId,
              'strategic-player-456',
              reason: 'Action events should identify acting competitive player',
            );
            expect(
              actionType,
              PlayerActionType.drawCard,
              reason:
                  'Action type should enable proper competitive game coordination',
            );
            expect(
              data,
              strategicActionData,
              reason:
                  'Action data should preserve strategic context for competitive gameplay',
            );
          },
        );
      },
    );

    test(
      'should support event serialization for persistent multiplayer communication and synchronization',
      () {
        // Test behavior: event serialization enables network communication and state persistence

        const persistableJoinEvent = RoomEvent.playerJoined(
          playerId: 'network-competitor-789',
          playerName: 'Network Strategic Player',
        );

        final serializedEventData = persistableJoinEvent.toJson();
        final deserializedEvent = RoomEvent.fromJson(serializedEventData);

        expect(
          deserializedEvent,
          persistableJoinEvent,
          reason:
              'Event serialization should preserve all competitive communication data',
        );

        // Comprehensive action type support for all competitive scenarios
        for (final competitiveActionType in PlayerActionType.values) {
          final comprehensiveActionEvent = RoomEvent.playerAction(
            playerId: 'versatile-competitor-123',
            actionType: competitiveActionType,
            actionData: {'competitiveContext': 'tournament_action'},
          );

          expect(
            comprehensiveActionEvent,
            isA<RoomEvent>(),
            reason:
                'All action types should be supported for complete competitive gameplay',
          );
        }
      },
    );
  });
}
