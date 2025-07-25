import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/check_end_round.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

void main() {
  late CheckEndRound checkEndRound;

  setUp(() {
    checkEndRound = CheckEndRound();
  });

  group('CheckEndRound UseCase', () {
    test('should continue to next player when not in last round', () async {
      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'GamePlayer 2',
          grid: PlayerGrid.empty(),
        ),
        GamePlayer(
          id: 'player3',
          name: 'GamePlayer 3',
          grid: PlayerGrid.empty(),
        ),
      ];

      final gameState = GameState.initial(
        roomId: 'room123',
        players: players,
      ).copyWith(status: GameStatus.playing, currentPlayerIndex: 1);

      final result = await checkEndRound(
        CheckEndRoundParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // Should simply continue playing
        expect(newState.status, GameStatus.playing);
        expect(newState.currentPlayerIndex, 1);
      });
    });

    test(
      'should end game when last player of last round completes turn',
      () async {
        // Arrange: Game in last round with simple scores
        final players = [
          GamePlayer(
            id: 'player1',
            name: 'Round Initiator',
            grid: PlayerGrid.empty()
                .placeCard(const Card(value: 5, isRevealed: true), 0, 0)
                .placeCard(const Card(value: 3, isRevealed: true), 0, 1),
            isHost: true,
          ),
          GamePlayer(
            id: 'player2',
            name: 'Higher Score Player',
            grid: PlayerGrid.empty()
                .placeCard(const Card(value: 10, isRevealed: true), 0, 0)
                .placeCard(const Card(value: 8, isRevealed: true), 0, 1),
          ),
          GamePlayer(
            id: 'player3',
            name: 'Lowest Score Player',
            grid: PlayerGrid.empty()
                .placeCard(const Card(value: 2, isRevealed: true), 0, 0)
                .placeCard(const Card(value: 1, isRevealed: true), 0, 1),
          ),
        ];

        final gameState = GameState.initial(roomId: 'room123', players: players)
            .copyWith(
              status: GameStatus.lastRound,
              currentPlayerIndex: 2, // Last player's turn
              endRoundInitiator: 'player1',
            );

        // Act: Check if round ends
        final result = await checkEndRound(
          CheckEndRoundParams(gameState: gameState),
        );

        // Assert: Game should finish and apply double penalty rule
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not fail'), (finalState) {
          expect(finalState.status, GameStatus.finished);

          // Initiator should get double penalty for not having lowest score
          expect(finalState.players[0].currentScore, 16); // (5 + 3) * 2
          expect(finalState.players[1].currentScore, 18); // 10 + 8
          expect(finalState.players[2].currentScore, 3); // 2 + 1 (lowest)
        });
      },
    );

    test(
      'should handle double penalty rule correctly for round initiator',
      () async {
        // Arrange: Test both penalty scenarios
        // Scenario 1: Initiator with lowest score (no penalty)
        final winnersGrid = PlayerGrid.empty()
            .placeCard(const Card(value: 1, isRevealed: true), 0, 0)
            .placeCard(const Card(value: 2, isRevealed: true), 0, 1);

        final losersGrid = PlayerGrid.empty()
            .placeCard(const Card(value: 10, isRevealed: true), 0, 0)
            .placeCard(const Card(value: 8, isRevealed: true), 0, 1);

        // Test no penalty when initiator has lowest score
        final scenarioA =
            GameState.initial(
              roomId: 'room123',
              players: [
                GamePlayer(
                  id: 'winner',
                  name: 'Winner Initiator',
                  grid: winnersGrid,
                  isHost: true,
                ),
                GamePlayer(
                  id: 'loser',
                  name: 'High Score Player',
                  grid: losersGrid,
                ),
              ],
            ).copyWith(
              status: GameStatus.lastRound,
              currentPlayerIndex: 1,
              endRoundInitiator: 'winner',
            );

        final resultA = await checkEndRound(
          CheckEndRoundParams(gameState: scenarioA),
        );

        // Test double penalty when initiator doesn't have lowest score
        final scenarioB =
            GameState.initial(
              roomId: 'room123',
              players: [
                GamePlayer(
                  id: 'loser',
                  name: 'Loser Initiator',
                  grid: losersGrid,
                  isHost: true,
                ),
                GamePlayer(
                  id: 'winner',
                  name: 'Low Score Player',
                  grid: winnersGrid,
                ),
              ],
            ).copyWith(
              status: GameStatus.lastRound,
              currentPlayerIndex: 1,
              endRoundInitiator: 'loser',
            );

        final resultB = await checkEndRound(
          CheckEndRoundParams(gameState: scenarioB),
        );

        // Assert both scenarios
        expect(resultA.isRight() && resultB.isRight(), true);

        resultA.fold((failure) => fail('Should not fail'), (stateA) {
          // No penalty when initiator has lowest score
          expect(stateA.players[0].currentScore, 3); // 1 + 2
          expect(stateA.players[1].currentScore, 18); // 10 + 8
        });

        resultB.fold((failure) => fail('Should not fail'), (stateB) {
          // Double penalty when initiator doesn't have lowest score
          expect(stateB.players[0].currentScore, 36); // (10 + 8) * 2
          expect(stateB.players[1].currentScore, 3); // 1 + 2
        });
      },
    );

    test('should handle tied lowest scores correctly', () async {
      // Arrange: Players with tied lowest scores
      final tiedGrid1 = PlayerGrid.empty()
          .placeCard(const Card(value: 2, isRevealed: true), 0, 0)
          .placeCard(const Card(value: 3, isRevealed: true), 0, 1);

      final tiedGrid2 = PlayerGrid.empty()
          .placeCard(const Card(value: 1, isRevealed: true), 0, 0)
          .placeCard(const Card(value: 4, isRevealed: true), 0, 1);

      final highGrid = PlayerGrid.empty().placeCard(
        const Card(value: 10, isRevealed: true),
        0,
        0,
      );

      final players = [
        GamePlayer(
          id: 'tied1',
          name: 'Tied Player 1',
          grid: tiedGrid1,
          isHost: true,
        ),
        GamePlayer(id: 'tied2', name: 'Tied Player 2', grid: tiedGrid2),
        GamePlayer(id: 'high', name: 'High Score Initiator', grid: highGrid),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.lastRound,
            currentPlayerIndex: 2,
            endRoundInitiator: 'high', // Initiator with highest score
          );

      // Act: Check end round
      final result = await checkEndRound(
        CheckEndRoundParams(gameState: gameState),
      );

      // Assert: Initiator gets penalty despite ties
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not fail'), (newState) {
        expect(newState.players[2].currentScore, 20); // 10 * 2 (penalty)
        expect(newState.players[0].currentScore, 5); // 2 + 3 (tied)
        expect(newState.players[1].currentScore, 5); // 1 + 4 (tied)
      });
    });

    test('should set finishedAt timestamp when round ends', () async {
      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'GamePlayer 2',
          grid: PlayerGrid.empty(),
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.lastRound,
            currentPlayerIndex: 1,
            endRoundInitiator: 'player1',
            startedAt: DateTime.now().subtract(const Duration(minutes: 10)),
          );

      final result = await checkEndRound(
        CheckEndRoundParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        expect(newState.status, GameStatus.finished);
        expect(newState.finishedAt, isNotNull);
        expect(newState.finishedAt!.isAfter(newState.startedAt!), true);
      });
    });

    test('should continue last round if not at last player', () async {
      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'GamePlayer 2',
          grid: PlayerGrid.empty(),
        ),
        GamePlayer(
          id: 'player3',
          name: 'GamePlayer 3',
          grid: PlayerGrid.empty(),
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.lastRound,
            currentPlayerIndex: 0, // First player, not last
            endRoundInitiator: 'player1',
          );

      final result = await checkEndRound(
        CheckEndRoundParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // Should continue last round
        expect(newState.status, GameStatus.lastRound);
        expect(newState.finishedAt, isNull);
      });
    });
  });
}
