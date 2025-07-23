import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/deck_state.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

void main() {
  group('DeckState', () {
    final testCards = [
      const Card(value: 5, isRevealed: false),
      const Card(value: -2, isRevealed: false),
      const Card(value: 10, isRevealed: false),
      const Card(value: 0, isRevealed: false),
    ];

    test('should create DeckState with draw and discard piles', () {
      // Arrange & Act
      final deckState = DeckState(
        drawPile: testCards.sublist(0, 3),
        discardPile: [testCards[3]],
      );

      // Assert
      expect(deckState.drawPile.length, equals(3));
      expect(deckState.discardPile.length, equals(1));
      expect(deckState.drawPile.first.value, equals(5));
      expect(deckState.discardPile.first.value, equals(0));
    });

    test('should create empty DeckState', () {
      // Arrange & Act
      final deckState = DeckState.empty();

      // Assert
      expect(deckState.drawPile, isEmpty);
      expect(deckState.discardPile, isEmpty);
    });

    test('should get top discard card when discard pile is not empty', () {
      // Arrange
      final deckState = DeckState(
        drawPile: testCards.sublist(0, 2),
        discardPile: testCards.sublist(2, 4),
      );

      // Act
      final topCard = deckState.topDiscardCard;

      // Assert
      expect(topCard, isNotNull);
      expect(topCard!.value, equals(0)); // Last card in discard pile
    });

    test('should return null for top discard when pile is empty', () {
      // Arrange
      final deckState = DeckState(drawPile: testCards, discardPile: const []);

      // Act
      final topCard = deckState.topDiscardCard;

      // Assert
      expect(topCard, isNull);
    });

    test('should calculate remaining draw count', () {
      // Arrange
      final deckState = DeckState(
        drawPile: testCards.sublist(0, 3),
        discardPile: [testCards[3]],
      );

      // Act
      final count = deckState.remainingDrawCount;

      // Assert
      expect(count, equals(3));
    });

    test('should check if draw pile is empty', () {
      // Arrange
      final emptyDrawState = DeckState(
        drawPile: const [],
        discardPile: testCards,
      );
      final nonEmptyDrawState = DeckState(
        drawPile: testCards,
        discardPile: const [],
      );

      // Act & Assert
      expect(emptyDrawState.isDrawPileEmpty, isTrue);
      expect(nonEmptyDrawState.isDrawPileEmpty, isFalse);
    });

    test('should draw a card from draw pile', () {
      // Arrange
      final deckState = DeckState(drawPile: testCards, discardPile: const []);

      // Act
      final (newState, drawnCard) = deckState.drawCard();

      // Assert
      expect(drawnCard, isNotNull);
      expect(drawnCard!.value, equals(5)); // First card from draw pile
      expect(newState.drawPile.length, equals(3));
      expect(newState.discardPile.length, equals(0));
    });

    test('should return null when drawing from empty pile', () {
      // Arrange
      final deckState = DeckState.empty();

      // Act
      final (newState, drawnCard) = deckState.drawCard();

      // Assert
      expect(drawnCard, isNull);
      expect(newState.drawPile, isEmpty);
      expect(newState.discardPile, isEmpty);
    });

    test('should add card to discard pile', () {
      // Arrange
      final deckState = DeckState(
        drawPile: testCards.sublist(0, 2),
        discardPile: [testCards[2]],
      );
      final cardToDiscard = testCards[3];

      // Act
      final newState = deckState.discardCard(cardToDiscard);

      // Assert
      expect(newState.discardPile.length, equals(2));
      expect(newState.discardPile.last, equals(cardToDiscard));
      expect(newState.drawPile.length, equals(2)); // Unchanged
    });

    test('should reshuffle discard pile into draw pile', () {
      // Arrange
      final deckState = DeckState(drawPile: const [], discardPile: testCards);

      // Act
      final newState = deckState.reshuffleDiscardIntoDraw();

      // Assert
      expect(newState.drawPile.length, equals(3)); // All but top card
      expect(newState.discardPile.length, equals(1)); // Keep top card
      expect(newState.discardPile.first, equals(testCards.last));

      // Verify cards were moved (not necessarily in same order due to shuffle)
      final allCards = [...newState.drawPile, ...newState.discardPile];
      expect(allCards.length, equals(testCards.length));
    });

    test('should not reshuffle if discard pile has one or no cards', () {
      // Arrange
      final oneCardState = DeckState(
        drawPile: const [],
        discardPile: [testCards[0]],
      );
      final emptyState = DeckState.empty();

      // Act
      final newOneCardState = oneCardState.reshuffleDiscardIntoDraw();
      final newEmptyState = emptyState.reshuffleDiscardIntoDraw();

      // Assert
      expect(newOneCardState, equals(oneCardState));
      expect(newEmptyState, equals(emptyState));
    });

    test('should support value equality', () {
      // Arrange
      final state1 = DeckState(
        drawPile: testCards.sublist(0, 2),
        discardPile: testCards.sublist(2, 4),
      );
      final state2 = DeckState(
        drawPile: testCards.sublist(0, 2),
        discardPile: testCards.sublist(2, 4),
      );
      final state3 = DeckState(
        drawPile: testCards.sublist(0, 1),
        discardPile: testCards.sublist(2, 4),
      );

      // Act & Assert
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('should serialize to and from JSON', () {
      // Arrange
      final deckState = DeckState(
        drawPile: testCards.sublist(0, 2),
        discardPile: testCards.sublist(2, 4),
      );

      // Act
      final json = deckState.toJson();
      final restored = DeckState.fromJson(json);

      // Assert
      expect(restored, equals(deckState));
      expect(restored.drawPile.length, equals(2));
      expect(restored.discardPile.length, equals(2));
    });

    test('should copy with modifications', () {
      // Arrange
      final original = DeckState(
        drawPile: testCards.sublist(0, 2),
        discardPile: testCards.sublist(2, 4),
      );

      // Act
      final modified = original.copyWith(drawPile: testCards.sublist(0, 1));

      // Assert
      expect(modified.drawPile.length, equals(1));
      expect(modified.discardPile.length, equals(2)); // Unchanged
      expect(original.drawPile.length, equals(2)); // Original unchanged
    });
  });
}
