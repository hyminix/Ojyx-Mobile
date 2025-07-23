import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  group('PlayerGrid Entity', () {
    test('should create empty grid with correct dimensions', () {
      final grid = PlayerGrid.empty();

      expect(grid.cards.length, kGridRows);
      expect(grid.cards[0].length, kGridColumns);
      expect(
        grid.cards.every((row) => row.every((card) => card == null)),
        true,
      );
    });

    test('should create grid from cards list', () {
      final cards = List.generate(
        kCardsPerPlayer,
        (index) => Card(value: index % 13 - 2),
      );

      final grid = PlayerGrid.fromCards(cards);

      expect(grid.cards.length, kGridRows);
      expect(grid.cards[0].length, kGridColumns);

      // Verify all cards are placed
      final placedCards = grid.cards
          .expand((row) => row)
          .where((card) => card != null)
          .toList();
      expect(placedCards.length, kCardsPerPlayer);
    });

    test('should throw if cards list has wrong length', () {
      final cards = List.generate(10, (index) => Card(value: index));

      expect(() => PlayerGrid.fromCards(cards), throwsAssertionError);
    });

    test('should get card at position', () {
      final cards = List.generate(
        kCardsPerPlayer,
        (index) => Card(value: index),
      );
      final grid = PlayerGrid.fromCards(cards);

      final card = grid.getCard(0, 0);
      expect(card, isNotNull);
      expect(card!.value, 0);
    });

    test('should set card at position', () {
      final grid = PlayerGrid.empty();
      const newCard = Card(value: 5);

      final updatedGrid = grid.setCard(1, 2, newCard);

      expect(grid.getCard(1, 2), isNull);
      expect(updatedGrid.getCard(1, 2), equals(newCard));
    });

    test('should reveal card at position', () {
      final cards = List.generate(
        kCardsPerPlayer,
        (index) => Card(value: index),
      );
      final grid = PlayerGrid.fromCards(cards);

      final updatedGrid = grid.revealCard(0, 0);

      expect(grid.getCard(0, 0)!.isRevealed, false);
      expect(updatedGrid.getCard(0, 0)!.isRevealed, true);
    });

    test('should calculate total score correctly', () {
      final cards = [
        const Card(value: -2, isRevealed: true),
        const Card(value: 0, isRevealed: true),
        const Card(value: 5, isRevealed: true),
        const Card(value: 12, isRevealed: true),
        ...List.generate(8, (index) => const Card(value: 1)),
      ];

      final grid = PlayerGrid.fromCards(cards);

      expect(grid.totalScore, -2 + 0 + 5 + 12 + (8 * 1));
    });

    test('should check if all cards are revealed', () {
      final hiddenCards = List.generate(
        kCardsPerPlayer,
        (index) => Card(value: index),
      );
      final revealedCards = List.generate(
        kCardsPerPlayer,
        (index) => Card(value: index, isRevealed: true),
      );

      final hiddenGrid = PlayerGrid.fromCards(hiddenCards);
      final revealedGrid = PlayerGrid.fromCards(revealedCards);

      expect(hiddenGrid.allCardsRevealed, false);
      expect(revealedGrid.allCardsRevealed, true);
    });

    test('should detect identical columns', () {
      final grid = PlayerGrid.empty()
          .setCard(0, 0, const Card(value: 5, isRevealed: true))
          .setCard(1, 0, const Card(value: 5, isRevealed: true))
          .setCard(2, 0, const Card(value: 5, isRevealed: true))
          .setCard(0, 1, const Card(value: 3, isRevealed: true))
          .setCard(1, 1, const Card(value: 3, isRevealed: true))
          .setCard(
            2,
            1,
            const Card(value: 3, isRevealed: false),
          ); // Not revealed

      final identicalColumns = grid.getIdenticalColumns();

      expect(identicalColumns.length, 1);
      expect(identicalColumns.first, 0);
    });

    test('should remove column', () {
      final cards = List.generate(
        kCardsPerPlayer,
        (index) => Card(value: index),
      );
      final grid = PlayerGrid.fromCards(cards);

      final updatedGrid = grid.removeColumn(1);

      expect(updatedGrid.getCard(0, 1), isNull);
      expect(updatedGrid.getCard(1, 1), isNull);
      expect(updatedGrid.getCard(2, 1), isNull);
      expect(updatedGrid.getCard(0, 0), isNotNull);
    });
  });
}
