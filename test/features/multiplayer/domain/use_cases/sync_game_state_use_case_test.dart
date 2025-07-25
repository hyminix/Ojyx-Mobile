import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/repositories/game_state_repository.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/sync_game_state_use_case.dart';

class MockGameStateRepository extends Mock implements GameStateRepository {}

void main() {
  group(
    'Game State Synchronization for Real-Time Competitive Multiplayer Coordination',
    () {
      late SyncGameStateUseCase syncGameStateUseCase;
      late MockGameStateRepository mockRepository;

      setUp(() {
        mockRepository = MockGameStateRepository();
        syncGameStateUseCase = SyncGameStateUseCase(mockRepository);
      });

      test(
        'should stream real-time game state updates for multiplayer synchronization',
        () async {
          // Given: An active multiplayer game
          const gameId = 'game-123';
          final gameState = GameState(
            roomId: 'room-456',
            players: [
              GamePlayer(
                id: 'player-1',
                name: 'Player 1',
                grid: PlayerGrid.empty(),
                actionCards: [],
                isHost: true,
              ),
              GamePlayer(
                id: 'player-2',
                name: 'Player 2',
                grid: PlayerGrid.empty(),
                actionCards: [],
                isHost: false,
              ),
            ],
            currentPlayerIndex: 0,
            deck: [const Card(value: 1)],
            discardPile: [],
            status: GameStatus.playing,
            actionDeck: [],
            actionDiscard: [],
            turnDirection: TurnDirection.clockwise,
            lastRound: false,
          );

          when(
            () => mockRepository.watchGameState(gameId),
          ).thenAnswer((_) => Stream.value(gameState));

          // When: Watching game state
          final gameStateStream = syncGameStateUseCase.watchGameState(gameId);
          final receivedState = await gameStateStream.first;

          // Then: Game state is synchronized
          expect(receivedState.players, hasLength(2));
          expect(receivedState.status, equals(GameStatus.playing));
          expect(receivedState.currentPlayerIndex, equals(0));
        },
      );

      test(
        'should determine player action permissions based on turn order',
        () async {
          // Given: A game with defined turn order
          const gameId = 'game-123';
          final gameState = GameState(
            roomId: 'room-456',
            players: [
              GamePlayer(
                id: 'player-1',
                name: 'Player 1',
                grid: PlayerGrid.empty(),
                actionCards: [],
              ),
              GamePlayer(
                id: 'player-2',
                name: 'Player 2',
                grid: PlayerGrid.empty(),
                actionCards: [],
              ),
            ],
            currentPlayerIndex: 0,
            deck: [],
            discardPile: [],
            status: GameStatus.playing,
            actionDeck: [],
            actionDiscard: [],
            turnDirection: TurnDirection.clockwise,
            lastRound: false,
          );

          when(
            () => mockRepository.getGameState(gameId),
          ).thenAnswer((_) async => gameState);

          // When: Checking action permissions
          final canPlayer1Act = await syncGameStateUseCase.canPlayerAct(
            gameStateId: gameId,
            playerId: 'player-1',
          );
          final canPlayer2Act = await syncGameStateUseCase.canPlayerAct(
            gameStateId: gameId,
            playerId: 'player-2',
          );

          // Then: Only current player can act
          expect(canPlayer1Act, isTrue);
          expect(canPlayer2Act, isFalse);
        },
      );

      test('should synchronize card reveal actions across players', () async {
        // Given: A player revealing a card
        const gameId = 'game-123';
        const playerId = 'player-1';
        const position = 5;

        final revealResult = {
          'success': true,
          'revealed_card': {'value': 9, 'position': position},
        };

        when(
          () => mockRepository.revealCard(
            gameStateId: gameId,
            playerId: playerId,
            position: position,
          ),
        ).thenAnswer((_) async => revealResult);

        // When: Revealing a card
        final response = await syncGameStateUseCase.revealCard(
          gameStateId: gameId,
          playerId: playerId,
          position: position,
        );

        // Then: Card reveal is synchronized
        expect(response['success'], isTrue);
        expect(response['revealed_card']['value'], equals(9));
      });
    },
  );
}
