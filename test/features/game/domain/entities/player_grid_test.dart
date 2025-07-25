import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  group('PlayerGrid Gameplay Behavior', () {
    test(
      'should enable strategic card placement and management during gameplay',
      () {
        // Test behavior: players can place cards and manage their grid strategically
        final grid = PlayerGrid.empty();
        const strategicCard = Card(value: -2, isRevealed: false); // Bonus card

        final updatedGrid = grid.setCard(1, 2, strategicCard);

        // Verify immutability and strategic placement
        expect(
          grid.getCard(1, 2),
          isNull,
          reason: 'Original grid should remain unchanged',
        );
        expect(
          updatedGrid.getCard(1, 2),
          equals(strategicCard),
          reason: 'Strategic card should be placed correctly',
        );
      },
    );

    test(
      'should support progressive card revelation for information discovery',
      () {
        // Test behavior: players gradually reveal cards to gain information
        final cards = List.generate(
          kCardsPerPlayer,
          (index) => Card(value: index % 5),
        );
        final grid = PlayerGrid.fromCards(cards);

        final revealedGrid = grid.revealCard(0, 0);

        // Verify revelation behavior
        expect(
          grid.getCard(0, 0)!.isRevealed,
          false,
          reason: 'Original card should remain hidden',
        );
        expect(
          revealedGrid.getCard(0, 0)!.isRevealed,
          true,
          reason: 'Card should be revealed for strategic planning',
        );
      },
    );

    test('should calculate competitive score reflecting player performance', () {
      // Test behavior: scoring system determines game winners and strategic value
      final competitiveCards = [
        const Card(value: -2, isRevealed: true), // Strategic bonus
        const Card(value: 0, isRevealed: true), // Neutral card
        const Card(value: 5, isRevealed: true), // Moderate penalty
        const Card(value: 12, isRevealed: true), // High penalty
        ...List.generate(8, (index) => const Card(value: 1)), // Standard cards
      ];

      final grid = PlayerGrid.fromCards(competitiveCards);

      // Verify competitive scoring
      const expectedScore = -2 + 0 + 5 + 12 + (8 * 1); // 23 points
      expect(
        grid.totalScore,
        expectedScore,
        reason: 'Score should reflect competitive performance accurately',
      );
    });

    test('should trigger round end detection when all cards are revealed', () {
      // Test behavior: game system detects when player has revealed all cards
      final testCases = [
        (
          List.generate(
            kCardsPerPlayer,
            (index) => Card(value: index),
          ), // Hidden cards
          false,
          'player with hidden cards should not trigger round end',
        ),
        (
          List.generate(
            kCardsPerPlayer,
            (index) => Card(value: index, isRevealed: true),
          ), // All revealed
          true,
          'player with all revealed cards should trigger round end',
        ),
      ];

      for (final (cards, expectedEndRound, description) in testCases) {
        final grid = PlayerGrid.fromCards(cards);
        expect(grid.allCardsRevealed, expectedEndRound, reason: description);
      }
    });

    test(
      'should enforce column elimination rule when three identical cards are revealed',
      () {
        // Test behavior: automatic column removal when rule conditions are met
        final grid = PlayerGrid.empty()
            .setCard(0, 0, const Card(value: 5, isRevealed: true))
            .setCard(1, 0, const Card(value: 5, isRevealed: true))
            .setCard(
              2,
              0,
              const Card(value: 5, isRevealed: true),
            ) // Identical column
            .setCard(0, 1, const Card(value: 3, isRevealed: true))
            .setCard(1, 1, const Card(value: 3, isRevealed: true))
            .setCard(
              2,
              1,
              const Card(value: 3, isRevealed: false),
            ); // Not all revealed

        final identicalColumns = grid.getIdenticalColumns();

        // Verify rule enforcement behavior
        expect(
          identicalColumns.length,
          1,
          reason: 'Should detect exactly one column eligible for elimination',
        );
        expect(
          identicalColumns.first,
          0,
          reason: 'First column should be identified for elimination',
        );
      },
    );

    test(
      'should execute column removal maintaining grid integrity for continued play',
      () {
        // Test behavior: column removal preserves game state for continued gameplay
        final cards = List.generate(
          kCardsPerPlayer,
          (index) => Card(value: index),
        );
        final grid = PlayerGrid.fromCards(cards);

        final updatedGrid = grid.removeColumn(1);

        // Verify removal behavior preserves grid integrity
        expect(
          updatedGrid.getCard(0, 1),
          isNull,
          reason: 'Column should be completely removed',
        );
        expect(
          updatedGrid.getCard(1, 1),
          isNull,
          reason: 'All cards in column should be removed',
        );
        expect(
          updatedGrid.getCard(2, 1),
          isNull,
          reason: 'Entire column should be cleared',
        );
        expect(
          updatedGrid.getCard(0, 0),
          isNotNull,
          reason: 'Other columns should remain intact for continued play',
        );
      },
    );
  });
}
