import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  group('Card Entity', () {
    test('should provide proper visual feedback based on value for player decision', () {
      // Test behavior: players need visual cues to make strategic decisions
      final colorTestCases = [
        (-2, CardValueColor.darkBlue, 'negative values should show as dark blue for low score'),
        (-1, CardValueColor.darkBlue, 'negative values should show as dark blue for low score'),
        (0, CardValueColor.lightBlue, 'zero should show as light blue for neutral score'),
        (3, CardValueColor.green, 'low positive values should show as green for good score'),
        (7, CardValueColor.yellow, 'medium values should show as yellow for warning'),
        (11, CardValueColor.red, 'high values should show as red for high penalty'),
      ];

      for (final (value, expectedColor, reasoning) in colorTestCases) {
        final card = Card(value: value);
        expect(card.color, expectedColor, reason: reasoning);
      }
    });

    test('should allow strategic card revelation during gameplay', () {
      // Test behavior: players must be able to reveal cards during their turn
      const hiddenCard = Card(value: 5);
      final revealedCard = hiddenCard.reveal();

      // Verify the revelation behavior preserves game state
      expect(hiddenCard.isRevealed, false, 
             reason: 'Original card should remain unchanged for immutability');
      expect(revealedCard.isRevealed, true, 
             reason: 'Revealed card should be visible to all players');
      expect(revealedCard.value, hiddenCard.value, 
             reason: 'Card value should remain same after revelation');
    });

    test('should allow tactical card hiding for bluffing strategy', () {
      // Test behavior: some action cards allow hiding revealed cards
      const revealedCard = Card(value: 5, isRevealed: true);
      final hiddenCard = revealedCard.hide();

      // Verify the hiding behavior for strategic gameplay
      expect(revealedCard.isRevealed, true, 
             reason: 'Original card should remain unchanged for immutability');
      expect(hiddenCard.isRevealed, false, 
             reason: 'Hidden card should not be visible to opponents');
      expect(hiddenCard.value, revealedCard.value, 
             reason: 'Card value should remain same after hiding');
    });

    test('should distinguish cards for game state tracking', () {
      // Test behavior: game must track identical vs different cards
      const card1 = Card(value: 5);
      const card2 = Card(value: 5);
      const revealedCard = Card(value: 5, isRevealed: true);

      // Verify card comparison for game logic
      expect(card1, equals(card2), 
             reason: 'Hidden cards with same value should be equal');
      expect(card1, isNot(equals(revealedCard)), 
             reason: 'Hidden and revealed cards should be different for game state');
    });

    test('should enforce valid card values for fair gameplay', () {
      // Test behavior: prevent invalid cards from breaking game balance
      
      // Valid cards should work normally
      expect(() => Card(value: kMinCardValue), returnsNormally, 
             reason: 'Minimum valid value should be allowed');
      expect(() => Card(value: kMaxCardValue), returnsNormally, 
             reason: 'Maximum valid value should be allowed');
      expect(() => Card(value: 0), returnsNormally, 
             reason: 'Zero value should be allowed');

      // Invalid cards should be prevented
      expect(() => Card(value: kMinCardValue - 1), throwsAssertionError, 
             reason: 'Values below minimum should be rejected for game balance');
      expect(() => Card(value: kMaxCardValue + 1), throwsAssertionError, 
             reason: 'Values above maximum should be rejected for game balance');
    });
  });
}
