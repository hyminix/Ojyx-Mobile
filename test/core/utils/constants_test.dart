import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  group('Game Constants', () {
    test('should have valid player limits', () {
      expect(kMinPlayers, equals(2));
      expect(kMaxPlayers, equals(8));
      expect(kMinPlayers, lessThan(kMaxPlayers));
    });

    test('should have valid grid dimensions', () {
      expect(kGridRows, equals(3));
      expect(kGridColumns, equals(4));
      expect(kCardsPerPlayer, equals(kGridRows * kGridColumns));
    });

    test('should have valid initial game settings', () {
      expect(kInitialRevealedCards, equals(2));
      expect(kInitialRevealedCards, lessThanOrEqualTo(kCardsPerPlayer));
      expect(kMaxActionCardsInHand, equals(3));
    });

    test('should have valid card value range', () {
      expect(kMinCardValue, equals(-2));
      expect(kMaxCardValue, equals(12));
      expect(kMinCardValue, lessThan(kMaxCardValue));
    });
  });

  group('Timing Constants', () {
    test('should have reasonable timeout durations', () {
      expect(kReconnectionTimeout, equals(const Duration(minutes: 2)));
      expect(kTurnTimeout, equals(const Duration(seconds: 60)));
      expect(kAnimationDuration, equals(const Duration(milliseconds: 300)));

      // Verify relationships
      expect(kReconnectionTimeout, greaterThan(kTurnTimeout));
      expect(kTurnTimeout, greaterThan(kAnimationDuration));
    });
  });

  group('Card Distribution', () {
    test('should have distribution for all card values', () {
      // Check all values from min to max are present
      for (int value = kMinCardValue; value <= kMaxCardValue; value++) {
        expect(
          kCardDistribution.containsKey(value),
          isTrue,
          reason: 'Missing distribution for card value $value',
        );
      }
    });

    test('should have correct total cards', () {
      final totalCards = kCardDistribution.values.reduce((a, b) => a + b);
      expect(totalCards, equals(150));
    });

    test('should have valid distribution counts', () {
      expect(kCardDistribution[-2], equals(5));
      expect(kCardDistribution[-1], equals(10));
      expect(kCardDistribution[0], equals(15));

      // All positive values should have 10 cards each
      for (int value = 1; value <= 12; value++) {
        expect(
          kCardDistribution[value],
          equals(10),
          reason: 'Card value $value should have 10 cards',
        );
      }
    });

    test('should have more neutral cards than extreme cards', () {
      final negativeCards = kCardDistribution[-2]! + kCardDistribution[-1]!;
      final neutralCards = kCardDistribution[0]!;
      final highValueCards = kCardDistribution[11]! + kCardDistribution[12]!;

      expect(neutralCards, greaterThan(negativeCards));
      expect(neutralCards, lessThan(highValueCards));
    });
  });

  group('CardValueColor enum', () {
    test('should have all color categories', () {
      expect(CardValueColor.values.length, equals(5));
      expect(CardValueColor.values, contains(CardValueColor.darkBlue));
      expect(CardValueColor.values, contains(CardValueColor.lightBlue));
      expect(CardValueColor.values, contains(CardValueColor.green));
      expect(CardValueColor.values, contains(CardValueColor.yellow));
      expect(CardValueColor.values, contains(CardValueColor.red));
    });
  });
}
