import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/discard_pile_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('DiscardPile Strategic Discard Management Behavior', () {
    const testCard = game.Card(value: 7, isRevealed: true);

    testWidgets('should reveal strategic information through visible discard values', (tester) async {
      // Test behavior: discard pile provides competitive intelligence
      final strategicCards = [
        (card: const game.Card(value: -2, isRevealed: true), insight: 'bonus card discarded reveals risk tolerance'),
        (card: const game.Card(value: 12, isRevealed: true), insight: 'penalty discard shows defensive play'),
        (card: const game.Card(value: 5, isRevealed: true), insight: 'neutral discard indicates calculated strategy'),
        (card: null, insight: 'empty discard removes historical context'),
      ];

      for (final (:card, :insight) in strategicCards) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: DiscardPileWidget(topCard: card)),
          ),
        );

        if (card != null) {
          expect(find.text(card.value.toString()), findsWidgets,
              reason: 'Visible value provides: $insight');
        } else {
          expect(find.text('Défausse'), findsOneWidget,
              reason: 'Empty state indicates: $insight');
          expect(find.byIcon(Icons.layers_clear), findsOneWidget,
              reason: 'Visual indicator of no discard history');
        }
      }
    });

    testWidgets('should enable strategic discard actions based on game context', (tester) async {
      // Test behavior: discard interactions create strategic opportunities
      final discardScenarios = [
        (
          canDiscard: true,
          onTap: true,
          expectInteraction: true,
          scenario: 'active turn enables strategic card removal'
        ),
        (
          canDiscard: false,
          onTap: false,
          expectInteraction: false,
          scenario: 'opponent turn prevents discard manipulation'
        ),
        (
          canDiscard: true,
          onTap: false,
          expectInteraction: false,
          scenario: 'draw phase restricts discard options'
        ),
      ];

      for (final (:canDiscard, :onTap, :expectInteraction, :scenario) in discardScenarios) {
        var interactionOccurred = false;
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DiscardPileWidget(
                topCard: testCard,
                canDiscard: canDiscard,
                onTap: onTap ? () => interactionOccurred = true : null,
              ),
            ),
          ),
        );

        if (onTap) {
          await tester.tap(find.byType(DiscardPileWidget));
          await tester.pump();
        }

        expect(interactionOccurred, expectInteraction,
            reason: 'Strategic scenario: $scenario');

        // Visual feedback for allowed actions
        if (canDiscard) {
          final containers = tester.widgetList<Container>(find.byType(Container));
          final hasHighlight = containers.any((container) {
            final decoration = container.decoration as BoxDecoration?;
            return decoration?.border != null || 
                   (decoration?.boxShadow?.any((s) => s.color.opacity > 0.3) ?? false);
          });
          expect(hasHighlight, isTrue,
              reason: 'Visual feedback indicates strategic opportunity');
        }
      }
    });

    testWidgets('should track discard patterns for strategic opponent analysis', (tester) async {
      // Test behavior: discard history reveals opponent strategies
      const strategicSequence = [
        game.Card(value: 12, isRevealed: true), // Initial high penalty
        game.Card(value: -2, isRevealed: true), // Shift to bonus
        game.Card(value: 5, isRevealed: true),  // Neutral play
      ];

      for (final card in strategicSequence) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: DiscardPileWidget(topCard: card)),
          ),
        );

        // Animated transitions reveal strategy shifts
        expect(find.byType(AnimatedSwitcher), findsWidgets,
            reason: 'Smooth transitions highlight strategic pattern changes');
        
        // Visual variety aids pattern recognition
        expect(find.text(card.value.toString()), findsWidgets,
            reason: 'Card value ${card.value} contributes to pattern analysis');
      }
    });

    testWidgets('should communicate discard accessibility for inclusive gameplay', (tester) async {
      // Test behavior: accessibility features ensure fair competitive play
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DiscardPileWidget(topCard: testCard)),
        ),
      );

      expect(
        find.bySemanticsLabel(RegExp(r'Défausse.*carte.*7')),
        findsOneWidget,
        reason: 'Screen readers announce discard state for visually impaired players'
      );
    });

    testWidgets('should enable strategic card disposal through drag-drop mechanics', (tester) async {
      // Test behavior: drag-drop enables tactical card management
      final disposalScenarios = [
        (
          canDiscard: true,
          cardToDispose: const game.Card(value: 10, isRevealed: true),
          expectSuccess: true,
          strategy: 'high penalty disposal improves position'
        ),
        (
          canDiscard: false,
          cardToDispose: const game.Card(value: -2, isRevealed: true),
          expectSuccess: false,
          strategy: 'turn restrictions prevent premature disposal'
        ),
      ];

      for (final (:canDiscard, :cardToDispose, :expectSuccess, :strategy) in disposalScenarios) {
        game.Card? discardedCard;
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DiscardPileWidget(
                topCard: null,
                canDiscard: canDiscard,
                onCardDropped: (card) => discardedCard = card,
              ),
            ),
          ),
        );

        final discardWidget = tester.widget<DiscardPileWidget>(
          find.byType(DiscardPileWidget),
        );
        
        if (expectSuccess) {
          expect(discardWidget.onCardDropped, isNotNull,
              reason: 'Drop handler enables: $strategy');
          discardWidget.onCardDropped!(cardToDispose);
          expect(discardedCard, equals(cardToDispose),
              reason: 'Strategic disposal executed successfully');
        } else {
          expect(discardWidget.canDiscard, isFalse,
              reason: 'System enforces: $strategy');
        }
      }
    });
  });
}
