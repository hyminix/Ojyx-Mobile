import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/calculate_scores.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

void main() {
  late CalculateScores calculateScores;

  setUp(() {
    calculateScores = CalculateScores();
  });

  group('CalculateScores UseCase', () {
    test('should calculate basic scores correctly', () async {
      final grid1 = PlayerGrid.empty()
          .placeCard(const Card(value: 5, isRevealed: true), 0, 0)
          .placeCard(const Card(value: 10, isRevealed: true), 0, 1)
          .placeCard(const Card(value: -2, isRevealed: true), 1, 0)
          .placeCard(const Card(value: 0, isRevealed: true), 1, 1);

      final grid2 = PlayerGrid.empty()
          .placeCard(const Card(value: 8, isRevealed: true), 0, 0)
          .placeCard(const Card(value: 3, isRevealed: true), 0, 1)
          .placeCard(const Card(value: 7, isRevealed: true), 1, 0);

      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: grid1,
          isHost: true,
        ),
        GamePlayer(id: 'player2', name: 'GamePlayer 2', grid: grid2),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players);

      final result = await calculateScores(
        CalculateScoresParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (scores) {
        expect(scores.length, 2);
        expect(scores['player1'], 13); // 5 + 10 + (-2) + 0
        expect(scores['player2'], 18); // 8 + 3 + 7
      });
    });

    test('should handle empty grids', () async {
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

      final gameState = GameState.initial(roomId: 'room123', players: players);

      final result = await calculateScores(
        CalculateScoresParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (scores) {
        expect(scores['player1'], 0);
        expect(scores['player2'], 0);
      });
    });

    test('should handle negative scores', () async {
      final grid = PlayerGrid.empty()
          .placeCard(const Card(value: -2, isRevealed: true), 0, 0)
          .placeCard(const Card(value: -1, isRevealed: true), 0, 1)
          .placeCard(const Card(value: -2, isRevealed: true), 1, 0)
          .placeCard(const Card(value: 3, isRevealed: true), 1, 1);

      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: grid,
          isHost: true,
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players);

      final result = await calculateScores(
        CalculateScoresParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (scores) {
        expect(scores['player1'], -2); // -2 + (-1) + (-2) + 3
      });
    });

    test('should only count revealed cards', () async {
      final grid = PlayerGrid.empty()
          .placeCard(
            const Card(value: 10, isRevealed: false),
            0,
            0,
          ) // Not counted
          .placeCard(const Card(value: 5, isRevealed: true), 0, 1)
          .placeCard(
            const Card(value: 8, isRevealed: false),
            1,
            0,
          ) // Not counted
          .placeCard(const Card(value: 2, isRevealed: true), 1, 1);

      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: grid,
          isHost: true,
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players);

      final result = await calculateScores(
        CalculateScoresParams(gameState: gameState, onlyRevealed: true),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (scores) {
        expect(scores['player1'], 7); // Only 5 + 2
      });
    });

    test('should apply score multiplier', () async {
      final grid = PlayerGrid.empty()
          .placeCard(const Card(value: 5, isRevealed: true), 0, 0)
          .placeCard(const Card(value: 3, isRevealed: true), 0, 1);

      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: grid,
          isHost: true,
          scoreMultiplier: 2, // Double penalty
        ),
        GamePlayer(
          id: 'player2',
          name: 'GamePlayer 2',
          grid: grid,
          scoreMultiplier: 1, // Normal
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players);

      final result = await calculateScores(
        CalculateScoresParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (scores) {
        expect(scores['player1'], 16); // (5 + 3) * 2
        expect(scores['player2'], 8); // (5 + 3) * 1
      });
    });

    test('should return sorted scores when requested', () async {
      final grid1 = PlayerGrid.empty().placeCard(
        const Card(value: 10, isRevealed: true),
        0,
        0,
      );

      final grid2 = PlayerGrid.empty().placeCard(
        const Card(value: 5, isRevealed: true),
        0,
        0,
      );

      final grid3 = PlayerGrid.empty().placeCard(
        const Card(value: 12, isRevealed: true),
        0,
        0,
      );

      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: grid1,
          isHost: true,
        ),
        GamePlayer(id: 'player2', name: 'GamePlayer 2', grid: grid2),
        GamePlayer(id: 'player3', name: 'GamePlayer 3', grid: grid3),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players);

      final result = await calculateScores(
        CalculateScoresParams(gameState: gameState, sorted: true),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (scores) {
        final sortedEntries = scores.entries.toList();
        // Should be sorted from lowest to highest
        expect(sortedEntries[0].key, 'player2'); // Score: 5
        expect(sortedEntries[1].key, 'player1'); // Score: 10
        expect(sortedEntries[2].key, 'player3'); // Score: 12
      });
    });
  });
}
