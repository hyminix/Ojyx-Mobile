import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/deck_state.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

void main() {
  group('DeckState', () {
    final testCards = [
      const Card(value: 5, isRevealed: false),
      const Card(value: 0, isRevealed: false),
      const Card(value: 10, isRevealed: false),
      const Card(value: 1, isRevealed: false),
    ];

    test('should manage deck state properties correctly for gameplay', () {
      // Test cases for different deck configurations and their expected behaviors
      final testCases = [
        // (drawPile, discardPile, expectedDrawCount, expectedTopValue, expectedIsEmpty, description)
        (testCards.sublist(0, 3), [testCards[3]], 3, 1, false, 'standard game state'),
        (const <Card>[], const <Card>[], 0, null, true, 'empty deck state'),
        (testCards, const <Card>[], 4, null, false, 'full draw pile, empty discard'),
        (const <Card>[], testCards, 0, 1, true, 'empty draw pile, full discard'),
        ([testCards[0]], [testCards[1], testCards[2]], 1, 10, false, 'mixed state with cards in both piles'),
      ];

      for (final (drawPile, discardPile, expectedCount, expectedTopValue, expectedEmpty, description) in testCases) {
        final deckState = DeckState(drawPile: drawPile, discardPile: discardPile);

        // Verify deck properties for game logic
        expect(deckState.remainingDrawCount, expectedCount, 
               reason: 'Draw count should be correct for $description');
        expect(deckState.isDrawPileEmpty, expectedEmpty, 
               reason: 'Empty state should be correct for $description');
        
        if (expectedTopValue != null) {
          expect(deckState.topDiscardCard?.value, expectedTopValue, 
                 reason: 'Top discard card should be correct for $description');
        } else {
          expect(deckState.topDiscardCard, isNull, 
                 reason: 'Top discard card should be null for $description');
        }
      }
    });

    test('should handle card operations correctly for game flow', () {
      // Test draw and discard operations that affect game state
      final operationTestCases = [
        // Test drawing from non-empty pile
        () {
          final deckState = DeckState(drawPile: testCards, discardPile: const []);
          final (newState, drawnCard) = deckState.drawCard();
          
          expect(drawnCard, isNotNull, reason: 'Should draw card from non-empty pile');
          expect(drawnCard!.value, equals(5), reason: 'Should draw first card from pile');
          expect(newState.drawPile.length, equals(3), reason: 'Draw pile should decrease by 1');
          expect(newState.discardPile.length, equals(0), reason: 'Discard pile should remain unchanged');
        },
        
        // Test drawing from empty pile
        () {
          final deckState = DeckState.empty();
          final (newState, drawnCard) = deckState.drawCard();
          
          expect(drawnCard, isNull, reason: 'Should return null when drawing from empty pile');
          expect(newState.drawPile, isEmpty, reason: 'Empty draw pile should remain empty');
          expect(newState.discardPile, isEmpty, reason: 'Empty discard pile should remain empty');
        },
        
        // Test discarding a card
        () {
          final deckState = DeckState(
            drawPile: testCards.sublist(0, 2),
            discardPile: [testCards[2]],
          );
          final cardToDiscard = testCards[3];
          final newState = deckState.discardCard(cardToDiscard);
          
          expect(newState.discardPile.length, equals(2), reason: 'Discard pile should grow by 1');
          expect(newState.discardPile.last, equals(cardToDiscard), reason: 'Discarded card should be on top');
          expect(newState.drawPile.length, equals(2), reason: 'Draw pile should remain unchanged');
        },
      ];

      for (int i = 0; i < operationTestCases.length; i++) {
        operationTestCases[i]();
      }
    });

    test('should handle deck reshuffling behavior for continuous gameplay', () {
      // Test reshuffle behavior for different discard pile scenarios
      final reshuffleTestCases = [
        // (initialDraw, initialDiscard, shouldReshuffle, expectedDrawCount, expectedDiscardCount, description)
        (const <Card>[], testCards, true, 3, 1, 'reshuffle full discard pile'),
        (const <Card>[], [testCards[0]], false, 0, 1, 'no reshuffle with single card'),
        (const <Card>[], const <Card>[], false, 0, 0, 'no reshuffle with empty discard'),
        ([testCards[0]], [testCards[1], testCards[2]], true, 1, 1, 'reshuffle with existing draw pile'),
      ];

      for (final (initialDraw, initialDiscard, shouldReshuffle, expectedDrawCount, expectedDiscardCount, description) in reshuffleTestCases) {
        final deckState = DeckState(drawPile: initialDraw, discardPile: initialDiscard);
        final newState = deckState.reshuffleDiscardIntoDraw();

        if (shouldReshuffle) {
          expect(newState.drawPile.length, expectedDrawCount, 
                 reason: 'Draw pile count should be correct after $description');
          expect(newState.discardPile.length, expectedDiscardCount, 
                 reason: 'Discard pile should keep top card after $description');
          
          // Verify total card count after reshuffle (implementation removes existing draw pile)
          final totalCards = newState.drawPile.length + newState.discardPile.length;
          final expectedTotal = (initialDiscard.length - 1) + 1; // Cards moved from discard minus top card + top card kept
          expect(totalCards, expectedTotal, 
                 reason: 'Total card count should match reshuffled cards for $description');
        } else {
          expect(newState, equals(deckState), 
                 reason: 'State should remain unchanged for $description');
        }
      }
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
