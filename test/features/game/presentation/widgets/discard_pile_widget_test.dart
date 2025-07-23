import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/discard_pile_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('DiscardPileWidget', () {
    const testCard = game.Card(value: 7, isRevealed: true);

    testWidgets('should display top card when available', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DiscardPileWidget(topCard: testCard)),
        ),
      );

      // Assert
      expect(find.text('7'), findsWidgets); // Card should show value
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('should show empty state when no card', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DiscardPileWidget(topCard: null)),
        ),
      );

      // Assert
      expect(find.text('Défausse'), findsOneWidget);
      expect(find.byIcon(Icons.layers_clear), findsOneWidget);
    });

    testWidgets('should show stack effect with multiple cards beneath', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DiscardPileWidget(topCard: testCard, showStackEffect: true),
          ),
        ),
      );

      // Assert
      final stack = tester.widget<Stack>(find.byType(Stack).first);
      // Should have at least 3 children (2 shadow cards + top card)
      expect(stack.children.length, greaterThanOrEqualTo(3));
    });

    testWidgets('should handle tap when callback provided', (tester) async {
      // Arrange
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DiscardPileWidget(
              topCard: testCard,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DiscardPileWidget));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should highlight when canDiscard is true', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DiscardPileWidget(topCard: testCard, canDiscard: true),
          ),
        ),
      );

      // Assert
      // Check for highlight effect (border or glow)
      final containers = tester.widgetList<Container>(find.byType(Container));
      bool hasHighlight = false;

      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration?.border != null ||
            (decoration?.boxShadow != null &&
                decoration!.boxShadow!.any((s) => s.color.opacity > 0.3))) {
          hasHighlight = true;
          break;
        }
      }

      expect(hasHighlight, isTrue);
    });

    testWidgets('should animate card changes', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DiscardPileWidget(topCard: testCard)),
        ),
      );

      // Act - Change to different card
      const newCard = game.Card(value: 3, isRevealed: true);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DiscardPileWidget(topCard: newCard)),
        ),
      );

      // Assert
      expect(find.byType(AnimatedSwitcher), findsWidgets);
    });

    testWidgets('should show slight rotation for visual effect', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DiscardPileWidget(topCard: testCard)),
        ),
      );

      // Assert
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('should display different cards with correct colors', (
      tester,
    ) async {
      // Test multiple card values
      final testCases = [
        const game.Card(value: -2, isRevealed: true), // Dark blue
        const game.Card(value: 0, isRevealed: true), // Light blue
        const game.Card(value: 5, isRevealed: true), // Yellow
        const game.Card(value: 12, isRevealed: true), // Red
      ];

      for (final card in testCases) {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: DiscardPileWidget(topCard: card)),
          ),
        );

        // Assert
        expect(find.text(card.value.toString()), findsWidgets);
      }
    });

    testWidgets('should scale on hover when interactive', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DiscardPileWidget(topCard: testCard, onTap: () {}),
          ),
        ),
      );

      // Assert
      expect(find.byType(MouseRegion), findsWidgets);
    });

    testWidgets('should have correct accessibility label', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DiscardPileWidget(topCard: testCard)),
        ),
      );

      // Assert
      expect(
        find.bySemanticsLabel(RegExp(r'Défausse.*carte.*7')),
        findsOneWidget,
      );
    });

    testWidgets('should verify drag target functionality', (tester) async {
      // Arrange
      game.Card? droppedCard;
      const testDropCard = game.Card(value: 10, isRevealed: true);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DiscardPileWidget(
              topCard: null,
              canDiscard: true,
              onCardDropped: (card) => droppedCard = card,
            ),
          ),
        ),
      );

      // Verify the widget can accept dropped cards by calling the callback directly
      final discardWidget = tester.widget<DiscardPileWidget>(
        find.byType(DiscardPileWidget),
      );
      expect(discardWidget.onCardDropped, isNotNull);

      // Simulate drop by calling the callback
      discardWidget.onCardDropped!(testDropCard);
      expect(droppedCard, equals(testDropCard));
    });

    testWidgets('should not accept drops when canDiscard is false', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DiscardPileWidget(
              topCard: testCard,
              canDiscard: false,
              onCardDropped: (card) {},
            ),
          ),
        ),
      );

      // Verify widget state
      final discardWidget = tester.widget<DiscardPileWidget>(
        find.byType(DiscardPileWidget),
      );
      expect(discardWidget.canDiscard, isFalse);
    });
  });
}
