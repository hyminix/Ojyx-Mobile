import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  group('Card Entity', () {
    test('should create a valid card with value in range', () {
      const card = Card(value: 5);

      expect(card.value, 5);
      expect(card.isRevealed, false);
    });

    test('should throw assertion error for value below minimum', () {
      expect(() => Card(value: kMinCardValue - 1), throwsAssertionError);
    });

    test('should throw assertion error for value above maximum', () {
      expect(() => Card(value: kMaxCardValue + 1), throwsAssertionError);
    });

    test('should create revealed card', () {
      const card = Card(value: 0, isRevealed: true);

      expect(card.value, 0);
      expect(card.isRevealed, true);
    });

    test('should correctly identify card color', () {
      expect(const Card(value: -2).color, CardValueColor.darkBlue);
      expect(const Card(value: -1).color, CardValueColor.darkBlue);
      expect(const Card(value: 0).color, CardValueColor.lightBlue);
      expect(const Card(value: 3).color, CardValueColor.green);
      expect(const Card(value: 7).color, CardValueColor.yellow);
      expect(const Card(value: 11).color, CardValueColor.red);
    });

    test('should reveal card', () {
      const card = Card(value: 5);
      final revealedCard = card.reveal();

      expect(card.isRevealed, false);
      expect(revealedCard.isRevealed, true);
      expect(revealedCard.value, card.value);
    });

    test('should hide card', () {
      const card = Card(value: 5, isRevealed: true);
      final hiddenCard = card.hide();

      expect(card.isRevealed, true);
      expect(hiddenCard.isRevealed, false);
      expect(hiddenCard.value, card.value);
    });

    test('should support value equality', () {
      const card1 = Card(value: 5);
      const card2 = Card(value: 5);
      const card3 = Card(value: 5, isRevealed: true);

      expect(card1, equals(card2));
      expect(card1, isNot(equals(card3)));
    });
  });
}
