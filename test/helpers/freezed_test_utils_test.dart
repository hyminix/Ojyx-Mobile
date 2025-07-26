import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/utils/constants.dart';
import 'freezed_test_utils.dart';

void main() {
  group('Freezed Test Utils', () {
    group('CardBuilder', () {
      test('should create card with default values', () {
        // Arrange & Act
        final card = CardBuilder().build();

        // Assert
        expect(card.value, 5);
        expect(card.isRevealed, false);
      });

      test('should create custom card with fluent API', () {
        // Arrange & Act
        final card = CardBuilder().withValue(10).revealed().build();

        // Assert
        expect(card.value, 10);
        expect(card.isRevealed, true);
      });

      test('should create hidden card', () {
        // Arrange & Act
        final card = CardBuilder().withValue(7).revealed().hidden().build();

        // Assert
        expect(card.value, 7);
        expect(card.isRevealed, false);
      });
    });

    group('PlayerGridBuilder', () {
      test('should create empty grid with correct dimensions', () {
        // Arrange & Act
        final grid = PlayerGridBuilder().build();

        // Assert
        expect(grid.cards.length, kGridRows);
        expect(grid.cards[0].length, kGridColumns);
        for (final row in grid.cards) {
          for (final card in row) {
            expect(card, isNull);
          }
        }
      });

      test('should add cards to specific positions', () {
        // Arrange
        final card1 = createTestCard(value: 7);
        final card2 = createTestCard(value: 3);

        // Act
        final grid = PlayerGridBuilder()
            .withCard(0, 0, card1)
            .withCard(2, 3, card2)
            .build();

        // Assert
        expect(grid.getCard(0, 0), card1);
        expect(grid.getCard(2, 3), card2);
        expect(grid.getCard(1, 1), isNull);
      });

      test('should create full grid', () {
        // Arrange & Act
        final grid = PlayerGridBuilder().withFullGrid().build();

        // Assert
        for (int row = 0; row < kGridRows; row++) {
          for (int col = 0; col < kGridColumns; col++) {
            final card = grid.getCard(row, col);
            expect(card, isNotNull);
            expect(card, isValidCard);
          }
        }
      });
    });

    group('GamePlayerBuilder', () {
      test('should create player with default values', () {
        // Arrange & Act
        final player = GamePlayerBuilder().build();

        // Assert
        expect(player.id, 'player-1');
        expect(player.name, 'Test Player');
        expect(player.grid.cards.length, kGridRows);
        expect(player.actionCards, isEmpty);
        expect(player.isConnected, true);
        expect(player.isHost, false);
        expect(player.hasFinishedRound, false);
        expect(player.scoreMultiplier, 1);
      });

      test('should create custom player', () {
        // Arrange & Act
        final player = GamePlayerBuilder()
            .withId('custom-id')
            .withName('Custom Player')
            .asHost()
            .withScoreMultiplier(2)
            .build();

        // Assert
        expect(player.id, 'custom-id');
        expect(player.name, 'Custom Player');
        expect(player.isHost, true);
        expect(player.scoreMultiplier, 2);
      });

      test('should create player with full grid', () {
        // Arrange & Act
        final player = createTestPlayer(withFullGrid: true);

        // Assert
        for (int row = 0; row < kGridRows; row++) {
          for (int col = 0; col < kGridColumns; col++) {
            expect(player.grid.getCard(row, col), isNotNull);
          }
        }
      });
    });

    group('Custom Matchers', () {
      test('isValidCard should accept valid cards', () {
        // Arrange
        final validCards = [
          createTestCard(value: kMinCardValue),
          createTestCard(value: 0),
          createTestCard(value: 5),
          createTestCard(value: 10),
          createTestCard(value: kMaxCardValue),
        ];

        // Act & Assert
        for (final card in validCards) {
          expect(card, isValidCard);
        }
      });

      test('hasCurrentScore matcher should match player scores', () {
        // Arrange
        final grid = PlayerGridBuilder()
            .withCard(0, 0, createTestCard(value: 10))
            .withCard(0, 1, createTestCard(value: 5))
            .build();

        final player = GamePlayerBuilder()
            .withGrid(grid)
            .withScoreMultiplier(2)
            .build();

        // Act & Assert
        // currentScore = grid.totalScore * scoreMultiplier
        // With 2 cards (10 + 5) * 2 = 30
        expect(player, hasCurrentScore(30));
        expect(player, isNot(hasCurrentScore(15)));
      });
    });

    group('Helper Functions', () {
      test('createTestCard should create cards with custom properties', () {
        // Arrange & Act
        final card = createTestCard(value: 8, isRevealed: true);

        // Assert
        expect(card.value, 8);
        expect(card.isRevealed, true);
      });

      test('createTestGrid should create empty or filled grids', () {
        // Arrange & Act
        final emptyGrid = createTestGrid(filled: false);
        final filledGrid = createTestGrid(filled: true);

        // Assert
        expect(emptyGrid.getCard(0, 0), isNull);
        expect(filledGrid.getCard(0, 0), isNotNull);
      });

      test('createTestPlayer should create players with custom properties', () {
        // Arrange & Act
        final player = createTestPlayer(
          id: 'custom-id',
          name: 'Custom Player',
          withFullGrid: false,
        );

        // Assert
        expect(player.id, 'custom-id');
        expect(player.name, 'Custom Player');
        expect(player.grid.getCard(0, 0), isNull);
      });
    });
  });
}
