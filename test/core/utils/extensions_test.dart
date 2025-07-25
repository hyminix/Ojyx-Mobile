import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/utils/extensions.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  group('CardValueExtensions Strategic Color Communication Behavior', () {
    test('should communicate card value risk levels through strategic color coding', () {
      // Test behavior: color system enables rapid strategic assessment of card values
      final strategicColorScenarios = [
        // (values, expectedColor, strategicMeaning)
        ([-2, -1], CardValueColor.darkBlue, 'bonus cards signal high-value opportunities'),
        ([0], CardValueColor.lightBlue, 'neutral card indicates safe middle ground'),
        ([1, 2, 3, 4], CardValueColor.green, 'low penalties encourage strategic retention'),
        ([5, 6, 7, 8], CardValueColor.yellow, 'moderate risk requires tactical decisions'),
        ([9, 10, 11, 12], CardValueColor.red, 'high penalties demand immediate action'),
      ];

      for (final (values, expectedColor, strategicMeaning) in strategicColorScenarios) {
        for (final value in values) {
          expect(value.cardColor, equals(expectedColor),
              reason: 'Value $value color enables: $strategicMeaning');
        }
      }
    });

    test('should provide visually distinct colors for competitive card recognition', () {
      // Test behavior: display colors enable instant visual card assessment in gameplay
      final visualStrategyMap = [
        (-2, const Color(0xFF1565C0), 'dark blue highlights valuable bonus cards'),
        (0, const Color(0xFF42A5F5), 'light blue shows neutral strategic position'),
        (2, const Color(0xFF66BB6A), 'green indicates manageable risk level'),
        (6, const Color(0xFFFFCA28), 'yellow warns of increasing penalty risk'),
        (10, const Color(0xFFEF5350), 'red alerts high penalty requiring action'),
      ];

      for (final (value, expectedColor, visualStrategy) in visualStrategyMap) {
        expect(value.displayColor, equals(expectedColor),
            reason: 'Strategic visual communication: $visualStrategy');
      }
    });

    test('should maintain color consistency across entire value range for strategic planning', () {
      // Test behavior: consistent color mapping enables reliable strategic decisions
      expect(kMinCardValue.displayColor, isA<Color>(),
          reason: 'Minimum value card must have visual representation');
      expect(kMaxCardValue.displayColor, isA<Color>(),
          reason: 'Maximum value card must have visual representation');

      // Verify complete value range coverage
      for (int value = kMinCardValue; value <= kMaxCardValue; value++) {
        expect(value.displayColor, isA<Color>(),
            reason: 'Every card value $value must have visual representation for gameplay');
      }
    });
  });

  group('ListExtensions Gameplay Utility Behavior', () {
    test('should enable fair deck shuffling without affecting original deck order', () {
      // Test behavior: shuffling creates randomized gameplay while preserving deck integrity
      final deckScenarios = [
        ([1, 2, 3, 4, 5], 'standard deck maintains all cards after shuffle'),
        (<int>[], 'empty deck handles gracefully without errors'),
        ([1], 'single card deck remains functional'),
      ];

      for (final (deck, scenario) in deckScenarios) {
        final originalDeck = List<int>.from(deck);
        final shuffledDeck = deck.shuffled();

        // Verify fair shuffling behavior
        expect(shuffledDeck.length, equals(deck.length),
            reason: 'Shuffling preserves deck size for $scenario');
        if (deck.isNotEmpty) {
          expect(shuffledDeck.toSet(), equals(deck.toSet()),
              reason: 'All cards remain in deck for $scenario');
        }
        expect(identical(shuffledDeck, deck), isFalse,
            reason: 'New deck instance prevents corruption for $scenario');
        expect(deck, equals(originalDeck),
            reason: 'Original deck unchanged ensures game integrity for $scenario');
      }
    });

    test('should enable strategic card distribution for multiplayer game setup', () {
      // Test behavior: chunking facilitates fair card dealing to multiple players
      final dealingScenarios = [
        // (deck, playersOrChunkSize, expectedDistribution, scenario)
        (
          [1, 2, 3, 4, 5, 6, 7, 8, 9],
          3,
          [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
          'perfect distribution for 3 players with 3 cards each'
        ),
        (
          [1, 2, 3, 4, 5],
          2,
          [[1, 2], [3, 4], [5]],
          'uneven distribution handled fairly with last player getting fewer'
        ),
        (
          [1, 2, 3],
          5,
          [[1, 2, 3]],
          'fewer cards than chunk size creates single group'
        ),
        (
          <int>[],
          3,
          <List<int>>[],
          'empty deck produces no distribution'
        ),
        (
          [1, 2, 3],
          1,
          [[1], [2], [3]],
          'individual card distribution for turn-based dealing'
        ),
      ];

      for (final (deck, chunkSize, expectedChunks, scenario) in dealingScenarios) {
        final chunks = deck.chunked(chunkSize);
        
        expect(chunks, equals(expectedChunks),
            reason: 'Card distribution behavior: $scenario');
        
        // Verify all cards are distributed
        if (deck.isNotEmpty) {
          final distributedCards = chunks.expand((chunk) => chunk).toList();
          expect(distributedCards, equals(deck),
              reason: 'All cards distributed without loss or duplication');
        }
      }
    });
  });
}
