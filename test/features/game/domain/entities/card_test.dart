import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/utils/constants.dart';
import '../../../../helpers/test_data_builders_simple.dart';
import '../../../../helpers/custom_matchers_simple.dart';

void main() {
  group('Card Entity', () {
    group('Card Color Visual Feedback', () {
      test('should_return_dark_blue_color_when_card_value_is_negative', () {
        // Arrange
        final negativeValueCard1 = CardBuilder().withValue(-2).build();
        final negativeValueCard2 = CardBuilder().withValue(-1).build();

        // Act & Assert
        expect(
          negativeValueCard1,
          hasCardColor(CardValueColor.darkBlue),
          reason:
              'Negative values should display as dark blue to indicate low score benefit',
        );
        expect(
          negativeValueCard2,
          hasCardColor(CardValueColor.darkBlue),
          reason: 'All negative values should consistently show dark blue',
        );
      });

      test('should_return_light_blue_color_when_card_value_is_zero', () {
        // Arrange
        final zeroCard = CardBuilder().withValue(0).build();

        // Act & Assert
        expect(
          zeroCard,
          hasCardColor(CardValueColor.lightBlue),
          reason:
              'Zero value should display as light blue to indicate neutral score',
        );
      });

      test('should_return_green_color_when_card_value_is_low_positive', () {
        // Arrange
        final lowPositiveCard = CardBuilder().withValue(3).build();

        // Act & Assert
        expect(
          lowPositiveCard,
          hasCardColor(CardValueColor.green),
          reason:
              'Low positive values (1-5) should display as green to indicate acceptable score',
        );
      });

      test('should_return_yellow_color_when_card_value_is_medium', () {
        // Arrange
        final mediumValueCard = CardBuilder().withValue(7).build();

        // Act & Assert
        expect(
          mediumValueCard,
          hasCardColor(CardValueColor.yellow),
          reason:
              'Medium values (6-9) should display as yellow to warn of moderate penalty',
        );
      });

      test('should_return_red_color_when_card_value_is_high', () {
        // Arrange
        final highValueCard = CardBuilder().withValue(11).build();

        // Act & Assert
        expect(
          highValueCard,
          hasCardColor(CardValueColor.red),
          reason:
              'High values (10+) should display as red to indicate severe penalty',
        );
      });
    });

    group('Card Revelation Mechanics', () {
      test('should_create_revealed_copy_when_reveal_is_called', () {
        // Arrange
        final hiddenCard = CardBuilder().withValue(5).hidden().build();

        // Act
        final revealedCard = hiddenCard.reveal();

        // Assert
        expect(
          hiddenCard,
          isHidden,
          reason:
              'Original card must remain unchanged to maintain immutability',
        );
        expect(
          revealedCard,
          isRevealed,
          reason: 'New card instance should be marked as revealed',
        );
        expect(
          revealedCard,
          hasCardValue(hiddenCard.value),
          reason: 'Card value must be preserved during revelation',
        );
      });

      test('should_create_hidden_copy_when_hide_is_called', () {
        // Arrange
        final revealedCard = CardBuilder().withValue(5).revealed().build();

        // Act
        final hiddenCard = revealedCard.hide();

        // Assert
        expect(
          revealedCard,
          isRevealed,
          reason:
              'Original card must remain unchanged to maintain immutability',
        );
        expect(
          hiddenCard,
          isHidden,
          reason: 'New card instance should be marked as hidden',
        );
        expect(
          hiddenCard,
          hasCardValue(revealedCard.value),
          reason: 'Card value must be preserved during hiding',
        );
      });
    });

    group('Card Equality and Comparison', () {
      test('should_be_equal_when_cards_have_same_value_and_revealed_state', () {
        // Arrange
        final card1 = CardBuilder().withValue(5).hidden().build();
        final card2 = CardBuilder().withValue(5).hidden().build();

        // Act & Assert
        expect(
          card1,
          equals(card2),
          reason:
              'Cards with identical value and revealed state should be equal',
        );
      });

      test('should_not_be_equal_when_cards_have_different_revealed_state', () {
        // Arrange
        final hiddenCard = CardBuilder().withValue(5).hidden().build();
        final revealedCard = CardBuilder().withValue(5).revealed().build();

        // Act & Assert
        expect(
          hiddenCard,
          isNot(equals(revealedCard)),
          reason:
              'Cards with same value but different revealed state should not be equal',
        );
      });

      test('should_not_be_equal_when_cards_have_different_values', () {
        // Arrange
        final card1 = CardBuilder().withValue(5).build();
        final card2 = CardBuilder().withValue(7).build();

        // Act & Assert
        expect(
          card1,
          isNot(equals(card2)),
          reason: 'Cards with different values should not be equal',
        );
      });
    });

    group('Card Value Validation', () {
      // Constants for test clarity
      const int MINIMUM_ALLOWED_VALUE = kMinCardValue;
      const int MAXIMUM_ALLOWED_VALUE = kMaxCardValue;

      test('should_create_card_when_value_is_within_valid_range', () {
        // Arrange & Act & Assert
        expect(
          () => CardBuilder().withValue(MINIMUM_ALLOWED_VALUE).build(),
          returnsNormally,
          reason:
              'Minimum valid value ($MINIMUM_ALLOWED_VALUE) should be accepted',
        );
        expect(
          () => CardBuilder().withValue(MAXIMUM_ALLOWED_VALUE).build(),
          returnsNormally,
          reason:
              'Maximum valid value ($MAXIMUM_ALLOWED_VALUE) should be accepted',
        );
        expect(
          () => CardBuilder().withValue(0).build(),
          returnsNormally,
          reason: 'Zero value should be accepted as it is within valid range',
        );
      });

      test('should_throw_assertion_error_when_value_is_below_minimum', () {
        // Arrange
        const int belowMinimumValue = MINIMUM_ALLOWED_VALUE - 1;

        // Act & Assert
        expect(
          () => Card(value: belowMinimumValue),
          throwsAssertionError,
          reason:
              'Values below minimum ($belowMinimumValue) should be rejected to maintain game balance',
        );
      });

      test('should_throw_assertion_error_when_value_is_above_maximum', () {
        // Arrange
        const int aboveMaximumValue = MAXIMUM_ALLOWED_VALUE + 1;

        // Act & Assert
        expect(
          () => Card(value: aboveMaximumValue),
          throwsAssertionError,
          reason:
              'Values above maximum ($aboveMaximumValue) should be rejected to maintain game balance',
        );
      });
    });

    group('Card Validation Matcher', () {
      test('should_correctly_identify_valid_cards', () {
        // Arrange
        final validCard = CardBuilder().withValue(5).build();
        final minValueCard = CardBuilder().withValue(kMinCardValue).build();
        final maxValueCard = CardBuilder().withValue(kMaxCardValue).build();

        // Act & Assert
        expect(validCard, isValidCard);
        expect(minValueCard, isValidCard);
        expect(maxValueCard, isValidCard);
      });
    });
  });
}
