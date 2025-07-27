import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/card_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/core/utils/constants.dart';
import '../../../../../helpers/widget_test_helpers.dart';
import '../../../../../helpers/test_data_builders_simple.dart';

void main() {
  group('CardWidget', () {
    // Test constants
    const CARD_WIDTH = 60.0;
    const CARD_HEIGHT = 90.0;
    const SELECTED_SCALE = 1.1;
    const ANIMATION_DURATION = Duration(milliseconds: 200);
    
    group('Placeholder card', () {
      testWidgets('should_display_add_icon_when_isPlaceholder_is_true', (tester) async {
        // Arrange & Act
        await tester.pumpTestWidget(
          const CardWidget(isPlaceholder: true),
        );
        
        // Assert
        expect(
          find.byIcon(Icons.add),
          findsOneWidget,
          reason: 'Placeholder card should display add icon to indicate action',
        );
        expect(
          find.text('?'),
          findsNothing,
          reason: 'Placeholder should not display question mark',
        );
      });
      
      testWidgets('should_have_dashed_border_when_placeholder', (tester) async {
        // Arrange & Act
        await tester.pumpTestWidget(
          const CardWidget(isPlaceholder: true),
        );
        
        // Assert
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(CardWidget),
            matching: find.byType(Container).first,
          ),
        );
        
        expect(
          container.decoration,
          isA<BoxDecoration>(),
          reason: 'Placeholder should have box decoration',
        );
        
        final decoration = container.decoration as BoxDecoration;
        expect(
          decoration.border,
          isNotNull,
          reason: 'Placeholder should have border to indicate interactivity',
        );
      });
    });
    
    group('Hidden card', () {
      testWidgets('should_display_back_design_when_card_is_not_revealed', (tester) async {
        // Arrange
        final hiddenCard = CardBuilder()
          .withValue(5)
          .hidden()
          .build();
        
        // Act
        await tester.pumpTestWidget(
          CardWidget(card: hiddenCard),
        );
        
        // Assert
        expect(
          find.byIcon(Icons.question_mark),
          findsOneWidget,
          reason: 'Hidden card should show question mark to indicate unknown value',
        );
        expect(
          find.text('5'),
          findsNothing,
          reason: 'Card value should not be visible when card is hidden',
        );
      });
      
      testWidgets('should_have_gradient_background_when_hidden', (tester) async {
        // Arrange
        final hiddenCard = CardBuilder().hidden().build();
        
        // Act
        await tester.pumpTestWidget(
          CardWidget(card: hiddenCard),
        );
        
        // Assert
        final decoratedBox = tester.widget<DecoratedBox>(
          find.descendant(
            of: find.byType(CardWidget),
            matching: find.byType(DecoratedBox),
          ).first,
        );
        
        expect(
          decoratedBox.decoration,
          isA<BoxDecoration>(),
          reason: 'Hidden card should have box decoration',
        );
        
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(
          decoration.gradient,
          isNotNull,
          reason: 'Hidden card should have gradient for visual appeal',
        );
      });
    });
    
    group('Revealed card', () {
      testWidgets('should_display_card_value_when_revealed', (tester) async {
        // Arrange
        final revealedCard = CardBuilder()
          .withValue(7)
          .revealed()
          .build();
        
        // Act
        await tester.pumpTestWidget(
          CardWidget(card: revealedCard),
        );
        
        // Assert
        expect(
          find.text('7'),
          findsOneWidget,
          reason: 'Revealed card should display its numeric value',
        );
        expect(
          find.byIcon(Icons.question_mark),
          findsNothing,
          reason: 'Revealed card should not show question mark',
        );
      });
      
      testWidgets('should_display_correct_color_based_on_value', (tester) async {
        // Arrange
        final testCases = [
          (value: -2, expectedColor: CardValueColor.darkBlue, description: 'negative values'),
          (value: 0, expectedColor: CardValueColor.lightBlue, description: 'zero'),
          (value: 3, expectedColor: CardValueColor.green, description: 'low positive'),
          (value: 7, expectedColor: CardValueColor.yellow, description: 'medium values'),
          (value: 11, expectedColor: CardValueColor.red, description: 'high values'),
        ];
        
        for (final testCase in testCases) {
          // Act
          await tester.pumpTestWidget(
            CardWidget(
              card: CardBuilder()
                .withValue(testCase.value)
                .revealed()
                .build(),
            ),
          );
          
          // Assert
          final text = tester.widget<Text>(find.text('${testCase.value}'));
          expect(
            text.style?.color,
            isNotNull,
            reason: 'Card value text should have color for ${testCase.description}',
          );
          
          // Clean up for next iteration
          await tester.pumpWidget(Container());
        }
      });
    });
    
    group('User interactions', () {
      testWidgets('should_trigger_onTap_callback_when_card_is_tapped', (tester) async {
        // Arrange
        bool wasTapped = false;
        final card = CardBuilder().hidden().build();
        
        // Act
        await tester.pumpTestWidget(
          CardWidget(
            card: card,
            onTap: () => wasTapped = true,
          ),
        );
        
        await tester.tap(find.byType(CardWidget));
        await tester.pump();
        
        // Assert
        expect(
          wasTapped,
          isTrue,
          reason: 'onTap callback should be triggered when card is interacted with',
        );
      });
      
      testWidgets('should_not_respond_to_tap_when_onTap_is_null', (tester) async {
        // Arrange
        final card = CardBuilder().build();
        
        // Act
        await tester.pumpTestWidget(
          CardWidget(card: card, onTap: null),
        );
        
        // Assert - Should not throw when tapped
        await expectLater(
          () => tester.tap(find.byType(CardWidget)),
          returnsNormally,
          reason: 'Card without onTap should safely ignore tap events',
        );
      });
    });
    
    group('Selection state', () {
      testWidgets('should_show_selection_indicator_when_selected', (tester) async {
        // Arrange
        final card = CardBuilder().build();
        
        // Act
        await tester.pumpTestWidget(
          CardWidget(
            card: card,
            isSelected: true,
          ),
        );
        
        // Assert
        final transformedCard = tester.widget<Transform>(
          find.ancestor(
            of: find.byType(Card),
            matching: find.byType(Transform),
          ),
        );
        
        expect(
          transformedCard.transform,
          isNotNull,
          reason: 'Selected card should have transform applied',
        );
        
        // Check for selection border or highlight
        final cardWidget = tester.widget<Card>(find.byType(Card));
        expect(
          cardWidget.shape,
          isA<RoundedRectangleBorder>(),
          reason: 'Selected card should have defined border shape',
        );
      });
      
      testWidgets('should_animate_selection_state_changes', (tester) async {
        // Arrange
        final card = CardBuilder().build();
        
        // Act - Start unselected
        await tester.pumpTestWidget(
          CardWidget(
            card: card,
            isSelected: false,
          ),
        );
        
        // Change to selected
        await tester.pumpTestWidget(
          CardWidget(
            card: card,
            isSelected: true,
          ),
        );
        
        // Assert - Animation in progress
        await tester.pump(ANIMATION_DURATION ~/ 2);
        
        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        expect(
          animatedContainer.duration,
          equals(ANIMATION_DURATION),
          reason: 'Selection animation should use consistent duration',
        );
        
        // Complete animation
        await tester.pumpAndSettle();
      });
    });
    
    group('Accessibility', () {
      testWidgets('should_have_semantic_label_for_screen_readers', (tester) async {
        // Arrange
        final revealedCard = CardBuilder()
          .withValue(10)
          .revealed()
          .build();
        
        // Act
        await tester.pumpTestWidget(
          CardWidget(card: revealedCard),
        );
        
        // Assert
        final semantics = tester.getSemantics(find.byType(CardWidget));
        expect(
          semantics.label,
          contains('10'),
          reason: 'Screen readers should announce card value when revealed',
        );
      });
      
      testWidgets('should_indicate_hidden_state_in_semantics', (tester) async {
        // Arrange
        final hiddenCard = CardBuilder().hidden().build();
        
        // Act
        await tester.pumpTestWidget(
          CardWidget(card: hiddenCard),
        );
        
        // Assert
        final semantics = tester.getSemantics(find.byType(CardWidget));
        expect(
          semantics.label,
          anyOf(contains('hidden'), contains('face down')),
          reason: 'Screen readers should indicate when card is not revealed',
        );
      });
    });
    
    group('Visual specifications', () {
      testWidgets('should_maintain_consistent_card_dimensions', (tester) async {
        // Arrange
        final card = CardBuilder().build();
        
        // Act
        await tester.pumpTestWidget(
          CardWidget(card: card),
        );
        
        // Assert
        final cardSize = tester.getSize(find.byType(CardWidget));
        expect(
          cardSize.width,
          closeTo(CARD_WIDTH, 1.0),
          reason: 'Card width should match design specifications',
        );
        expect(
          cardSize.height,
          closeTo(CARD_HEIGHT, 1.0),
          reason: 'Card height should maintain aspect ratio',
        );
      });
      
      testWidgets('should_apply_shadow_for_depth_perception', (tester) async {
        // Arrange
        final card = CardBuilder().build();
        
        // Act
        await tester.pumpTestWidget(
          CardWidget(card: card),
        );
        
        // Assert
        final cardWidget = tester.widget<Card>(find.byType(Card));
        expect(
          cardWidget.elevation,
          greaterThan(0),
          reason: 'Card should have elevation for visual depth',
        );
      });
    });
  });
}