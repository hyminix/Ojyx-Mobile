import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/reveal_initial_cards.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  late RevealInitialCards revealInitialCards;

  setUp(() {
    revealInitialCards = RevealInitialCards();
  });

  group('RevealInitialCards UseCase', () {
    test('should reveal exactly 2 cards per player', () async {
      // Create players with full grids
      final cards = List.generate(
        kCardsPerPlayer,
        (index) => Card(value: index % 13 - 2),
      );

      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.fromCards(cards),
        ),
        Player(
          id: 'player2',
          name: 'Player 2',
          grid: PlayerGrid.fromCards(cards),
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players);

      final result = await revealInitialCards(
        RevealInitialCardsParams(
          gameState: gameState,
          playerId: 'player1',
          positions: [(0, 0), (2, 3)], // Top-left and bottom-right
        ),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (updatedState) {
        final player = updatedState.players.firstWhere(
          (p) => p.id == 'player1',
        );

        // Check specific positions are revealed
        expect(player.grid.getCard(0, 0)?.isRevealed, true);
        expect(player.grid.getCard(2, 3)?.isRevealed, true);

        // Check total revealed count
        int revealedCount = 0;
        for (int row = 0; row < kGridRows; row++) {
          for (int col = 0; col < kGridColumns; col++) {
            if (player.grid.getCard(row, col)?.isRevealed == true) {
              revealedCount++;
            }
          }
        }
        expect(revealedCount, kInitialRevealedCards);
      });
    });

    test('should fail if positions list has wrong length', () async {
      final cards = List.generate(
        kCardsPerPlayer,
        (index) => Card(value: index),
      );

      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.fromCards(cards),
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players);

      final result = await revealInitialCards(
        RevealInitialCardsParams(
          gameState: gameState,
          playerId: 'player1',
          positions: [(0, 0)], // Only 1 position instead of 2
        ),
      );

      expect(result.isLeft(), true);
    });

    test('should fail if position is invalid', () async {
      final cards = List.generate(
        kCardsPerPlayer,
        (index) => Card(value: index),
      );

      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.fromCards(cards),
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players);

      final result = await revealInitialCards(
        RevealInitialCardsParams(
          gameState: gameState,
          playerId: 'player1',
          positions: [(0, 0), (5, 5)], // Invalid position
        ),
      );

      expect(result.isLeft(), true);
    });

    test('should fail if player not found', () async {
      final cards = List.generate(
        kCardsPerPlayer,
        (index) => Card(value: index),
      );

      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.fromCards(cards),
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players);

      final result = await revealInitialCards(
        RevealInitialCardsParams(
          gameState: gameState,
          playerId: 'nonexistent',
          positions: [(0, 0), (1, 1)],
        ),
      );

      expect(result.isLeft(), true);
    });

    test('should not reveal already revealed cards', () async {
      final cards = List.generate(
        kCardsPerPlayer,
        (index) => Card(
          value: index,
          isRevealed: index == 0, // First card already revealed
        ),
      );

      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.fromCards(cards),
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players);

      final result = await revealInitialCards(
        RevealInitialCardsParams(
          gameState: gameState,
          playerId: 'player1',
          positions: [(0, 0), (1, 1)], // (0,0) is already revealed
        ),
      );

      expect(result.isLeft(), true);
    });

    test('should handle simultaneous reveals for all players', () async {
      final cards = List.generate(
        kCardsPerPlayer,
        (index) => Card(value: index),
      );

      final players = List.generate(
        3,
        (i) => Player(
          id: 'player$i',
          name: 'Player $i',
          grid: PlayerGrid.fromCards(List.from(cards)),
        ),
      );

      var gameState = GameState.initial(roomId: 'room123', players: players);

      // Reveal cards for each player
      for (int i = 0; i < players.length; i++) {
        final result = await revealInitialCards(
          RevealInitialCardsParams(
            gameState: gameState,
            playerId: 'player$i',
            positions: [(0, i), (2, i)], // Different positions per player
          ),
        );

        expect(result.isRight(), true);

        result.fold(
          (failure) => fail('Should not fail'),
          (newState) => gameState = newState,
        );
      }

      // Verify all players have their cards revealed
      for (int i = 0; i < players.length; i++) {
        final player = gameState.players[i];
        expect(player.grid.getCard(0, i)?.isRevealed, true);
        expect(player.grid.getCard(2, i)?.isRevealed, true);
      }
    });
  });
}
