import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/check_end_round.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

void main() {
  late CheckEndRound checkEndRound;

  setUp(() {
    checkEndRound = CheckEndRound();
  });

  // Helper to create a full grid with specific values
  PlayerGrid createFullGrid(List<int> values) {
    var grid = PlayerGrid.empty();
    int valueIndex = 0;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 4; col++) {
        final value = valueIndex < values.length ? values[valueIndex] : 0;
        grid = grid.placeCard(Card(value: value, isRevealed: true), row, col);
        valueIndex++;
      }
    }

    return grid;
  }

  group('CheckEndRound UseCase', () {
    test('should continue to next player when not in last round', () async {
      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        Player(id: 'player2', name: 'Player 2', grid: PlayerGrid.empty()),
        Player(id: 'player3', name: 'Player 3', grid: PlayerGrid.empty()),
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
      'should end round when last player finished their last turn',
      () async {
        // Create players with different scores - fill all 12 positions
        var grid1 = PlayerGrid.empty();
        var grid2 = PlayerGrid.empty();
        var grid3 = PlayerGrid.empty();

        // Fill grid1 with cards totaling 6
        grid1 = grid1.placeCard(const Card(value: 5, isRevealed: true), 0, 0);
        grid1 = grid1.placeCard(const Card(value: 3, isRevealed: true), 0, 1);
        grid1 = grid1.placeCard(const Card(value: -2, isRevealed: true), 1, 0);
        // Fill remaining positions with 0-value cards
        for (int row = 0; row < 3; row++) {
          for (int col = 0; col < 4; col++) {
            if (grid1.cards[row][col] == null) {
              grid1 = grid1.placeCard(
                const Card(value: 0, isRevealed: true),
                row,
                col,
              );
            }
          }
        }

        // Fill grid2 with cards totaling 18
        grid2 = grid2.placeCard(const Card(value: 10, isRevealed: true), 0, 0);
        grid2 = grid2.placeCard(const Card(value: 8, isRevealed: true), 0, 1);
        // Fill remaining with 0s
        for (int row = 0; row < 3; row++) {
          for (int col = 0; col < 4; col++) {
            if (grid2.cards[row][col] == null) {
              grid2 = grid2.placeCard(
                const Card(value: 0, isRevealed: true),
                row,
                col,
              );
            }
          }
        }

        // Fill grid3 with cards totaling 3
        grid3 = grid3.placeCard(const Card(value: 2, isRevealed: true), 0, 0);
        grid3 = grid3.placeCard(const Card(value: 1, isRevealed: true), 0, 1);
        // Fill remaining with 0s
        for (int row = 0; row < 3; row++) {
          for (int col = 0; col < 4; col++) {
            if (grid3.cards[row][col] == null) {
              grid3 = grid3.placeCard(
                const Card(value: 0, isRevealed: true),
                row,
                col,
              );
            }
          }
        }

        final players = [
          Player(id: 'player1', name: 'Player 1', grid: grid1, isHost: true),
          Player(id: 'player2', name: 'Player 2', grid: grid2),
          Player(id: 'player3', name: 'Player 3', grid: grid3),
        ];

        final gameState = GameState.initial(roomId: 'room123', players: players)
            .copyWith(
              status: GameStatus.lastRound,
              currentPlayerIndex: 2, // Last player
              endRoundInitiator: 'player1',
            );

        final result = await checkEndRound(
          CheckEndRoundParams(gameState: gameState),
        );

        expect(result.isRight(), true);

        result.fold((failure) => fail('Should not fail'), (newState) {
          // Should end the round
          expect(newState.status, GameStatus.finished);

          // Check scores are calculated
          // Player 1 is initiator with score 6, player 3 has lowest (3)
          // So player 1 gets double penalty
          expect(newState.players[0].currentScore, 12); // (5 + 3 + (-2)) * 2
          expect(newState.players[1].currentScore, 18); // 10 + 8 + 0s
          expect(newState.players[2].currentScore, 3); // 2 + 1 + 0s (lowest)
        });
      },
    );

    test(
      'should apply double penalty if initiator does not have lowest score',
      () async {
        // Initiator has higher score than another player
        var grid1 = PlayerGrid.empty();
        var grid2 = PlayerGrid.empty();

        // Fill grid1 with total score 20
        grid1 = grid1.placeCard(const Card(value: 10, isRevealed: true), 0, 0);
        grid1 = grid1.placeCard(const Card(value: 10, isRevealed: true), 0, 1);
        // Fill remaining with 0s
        for (int row = 0; row < 3; row++) {
          for (int col = 0; col < 4; col++) {
            if (grid1.cards[row][col] == null) {
              grid1 = grid1.placeCard(
                const Card(value: 0, isRevealed: true),
                row,
                col,
              );
            }
          }
        }

        // Fill grid2 with total score 5
        grid2 = grid2.placeCard(const Card(value: 2, isRevealed: true), 0, 0);
        grid2 = grid2.placeCard(const Card(value: 3, isRevealed: true), 0, 1);
        // Fill remaining with 0s
        for (int row = 0; row < 3; row++) {
          for (int col = 0; col < 4; col++) {
            if (grid2.cards[row][col] == null) {
              grid2 = grid2.placeCard(
                const Card(value: 0, isRevealed: true),
                row,
                col,
              );
            }
          }
        }

        final players = [
          Player(id: 'player1', name: 'Player 1', grid: grid1, isHost: true),
          Player(id: 'player2', name: 'Player 2', grid: grid2),
        ];

        final gameState = GameState.initial(roomId: 'room123', players: players)
            .copyWith(
              status: GameStatus.lastRound,
              currentPlayerIndex: 1, // Last player
              endRoundInitiator:
                  'player1', // Initiator who doesn't have lowest score
            );

        final result = await checkEndRound(
          CheckEndRoundParams(gameState: gameState),
        );

        expect(result.isRight(), true);

        result.fold((failure) => fail('Should not fail'), (newState) {
          // Initiator should have double penalty
          expect(newState.players[0].currentScore, 40); // 20 * 2
          expect(newState.players[1].currentScore, 5); // No penalty
        });
      },
    );

    test('should not apply penalty if initiator has lowest score', () async {
      // Initiator has lowest score
      final grid1 = createFullGrid([1, 2]); // Score: 3 (lowest)
      final grid2 = createFullGrid([10, 8]); // Score: 18

      final players = [
        Player(id: 'player1', name: 'Player 1', grid: grid1, isHost: true),
        Player(id: 'player2', name: 'Player 2', grid: grid2),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.lastRound,
            currentPlayerIndex: 1,
            endRoundInitiator: 'player1', // Initiator with lowest score
          );

      final result = await checkEndRound(
        CheckEndRoundParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // No penalty applied
        expect(newState.players[0].currentScore, 3);
        expect(newState.players[1].currentScore, 18);
      });
    });

    test('should handle tied lowest scores correctly', () async {
      // Two players with same lowest score
      final grid1 = createFullGrid([2, 3]); // Score: 5
      final grid2 = createFullGrid([1, 4]); // Score: 5 (tied)
      final grid3 = createFullGrid([10]); // Score: 10

      final players = [
        Player(id: 'player1', name: 'Player 1', grid: grid1, isHost: true),
        Player(id: 'player2', name: 'Player 2', grid: grid2),
        Player(id: 'player3', name: 'Player 3', grid: grid3),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.lastRound,
            currentPlayerIndex: 2,
            endRoundInitiator: 'player3', // Initiator doesn't have lowest
          );

      final result = await checkEndRound(
        CheckEndRoundParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // Initiator should have penalty (not tied for lowest)
        expect(newState.players[2].currentScore, 20); // 10 * 2
        expect(newState.players[0].currentScore, 5);
        expect(newState.players[1].currentScore, 5);
      });
    });

    test('should set finishedAt timestamp when round ends', () async {
      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        Player(id: 'player2', name: 'Player 2', grid: PlayerGrid.empty()),
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
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        Player(id: 'player2', name: 'Player 2', grid: PlayerGrid.empty()),
        Player(id: 'player3', name: 'Player 3', grid: PlayerGrid.empty()),
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
