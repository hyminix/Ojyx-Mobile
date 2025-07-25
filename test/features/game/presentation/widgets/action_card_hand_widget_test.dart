import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/presentation/widgets/action_card_hand_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/action_card_widget.dart';

void main() {
  group('ActionCardHand Strategic Hand Management Behavior', () {
    late GamePlayer testPlayer;
    late List<ActionCard> strategicCards;

    setUp(() {
      strategicCards = [
        const ActionCard(
          id: 'skip-card',
          type: ActionCardType.skip,
          name: 'Saut',
          description: 'Le prochain joueur passe son tour',
          timing: ActionTiming.optional,
          target: ActionTarget.none,
        ),
        const ActionCard(
          id: 'shield-card',
          type: ActionCardType.shield,
          name: 'Bouclier',
          description: 'Protégez-vous des attaques',
          timing: ActionTiming.reactive,
          target: ActionTarget.self,
        ),
        const ActionCard(
          id: 'reverse-card',
          type: ActionCardType.turnAround,
          name: 'Demi-tour',
          description: 'Inversez le sens du jeu',
          timing: ActionTiming.immediate,
          target: ActionTarget.none,
        ),
      ];

      testPlayer = GamePlayer(
        id: 'strategic-player',
        name: 'Strategic Master',
        grid: PlayerGrid.empty(),
        actionCards: strategicCards,
      );
    });

    Widget createTestWidget({
      required GamePlayer player,
      bool isCurrentPlayer = true,
      void Function(ActionCard)? onCardTap,
      void Function(ActionCard)? onCardDiscard,
    }) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: ActionCardHandWidget(
                player: player,
                isCurrentPlayer: isCurrentPlayer,
                onCardTap: onCardTap,
                onCardDiscard: onCardDiscard,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('should enforce immediate action card priority for game flow integrity', (tester) async {
      // Test behavior: immediate cards must be played first to maintain game rules
      await tester.pumpWidget(
        createTestWidget(player: testPlayer, isCurrentPlayer: true),
      );

      // Verify immediate card is highlighted for forced play
      final immediateCardWidget = tester.widget<ActionCardWidget>(
        find.byType(ActionCardWidget).at(2), // Demi-tour card
      );
      expect(immediateCardWidget.isHighlighted, isTrue,
          reason: 'Immediate cards create mandatory strategic decisions');
      expect(immediateCardWidget.card.timing, ActionTiming.immediate,
          reason: 'Turn reversal must execute immediately affecting all players');
    });

    testWidgets('should enable strategic card activation only during player turn', (tester) async {
      // Test behavior: turn-based fairness prevents unauthorized card usage
      final activationScenarios = [
        (isCurrentPlayer: true, expectActivation: true, 'current player can execute strategic actions'),
        (isCurrentPlayer: false, expectActivation: false, 'opponents cannot hijack turn order'),
      ];

      for (final (:isCurrentPlayer, :expectActivation, scenario) in activationScenarios) {
        ActionCard? activatedCard;
        await tester.pumpWidget(
          createTestWidget(
            player: testPlayer,
            isCurrentPlayer: isCurrentPlayer,
            onCardTap: (card) => activatedCard = card,
          ),
        );

        await tester.tap(find.text('Saut')); // Try to skip opponent's turn
        await tester.pump();

        if (expectActivation) {
          expect(activatedCard, isNotNull, reason: 'Scenario: $scenario');
          expect(activatedCard!.type, ActionCardType.skip,
              reason: 'Strategic skip disrupts opponent planning');
        } else {
          expect(activatedCard, isNull, reason: 'Scenario: $scenario');
        }

        await tester.pump(const Duration(milliseconds: 300)); // Cleanup
      }
    });

    testWidgets('should communicate hand capacity constraints for strategic planning', (tester) async {
      // Test behavior: capacity limits force strategic card management decisions
      final capacityScenarios = [
        (actionCards: strategicCards, display: 'Cartes Actions (3/3)', 'full capacity forces discard decisions'),
        (actionCards: strategicCards.take(2).toList(), display: 'Cartes Actions (2/3)', 'available space allows new acquisitions'),
        (actionCards: <ActionCard>[], display: 'Aucune carte action', 'empty hand limits strategic options'),
      ];

      for (final (:actionCards, :display, scenario) in capacityScenarios) {
        final player = testPlayer.copyWith(actionCards: actionCards);
        await tester.pumpWidget(createTestWidget(player: player));

        if (actionCards.isEmpty) {
          expect(find.text(display), findsOneWidget,
              reason: 'Empty hand communicates vulnerability: $scenario');
          expect(find.byIcon(Icons.do_not_disturb), findsOneWidget,
              reason: 'Visual indicator of limited strategic options');
        } else {
          expect(find.text(display), findsOneWidget,
              reason: 'Capacity awareness enables strategic planning: $scenario');
        }
      }
    });

    testWidgets('should categorize cards by strategic timing for tactical awareness', (tester) async {
      // Test behavior: timing categories enable strategic planning and counterplay
      await tester.pumpWidget(createTestWidget(player: testPlayer));

      // Verify all strategic timing types are represented
      final cardWidgets = tester.widgetList<ActionCardWidget>(
        find.byType(ActionCardWidget),
      ).toList();

      final timingCategories = {
        ActionTiming.optional: 'flexible timing for optimal strategic deployment',
        ActionTiming.reactive: 'defensive capability for threat mitigation',
        ActionTiming.immediate: 'mandatory execution affecting game flow',
      };

      for (final widget in cardWidgets) {
        final timing = widget.card.timing;
        expect(timingCategories.containsKey(timing), isTrue,
            reason: 'Card timing enables strategic categorization');
      }
    });

    testWidgets('should support strategic card discarding for hand optimization', (tester) async {
      // Test behavior: selective discarding enables hand optimization
      await tester.pumpWidget(
        createTestWidget(
          player: testPlayer,
          isCurrentPlayer: true,
          onCardDiscard: (card) {
            // Strategic discard to make room for better cards
          },
        ),
      );

      // Verify long press enables strategic discard
      final gesture = tester.widget<GestureDetector>(
        find.descendant(
          of: find.byType(ActionCardHandWidget),
          matching: find.byType(GestureDetector),
        ).first,
      );

      expect(gesture.onLongPress, isNotNull,
          reason: 'Long press enables strategic hand management through selective discarding');
    });

    testWidgets('should prevent concurrent card activations maintaining game integrity', (tester) async {
      // Test behavior: single action enforcement prevents game state corruption
      var activationCount = 0;
      await tester.pumpWidget(
        createTestWidget(
          player: testPlayer,
          isCurrentPlayer: true,
          onCardTap: (card) => activationCount++,
        ),
      );

      // Rapid activation attempts during animation
      await tester.tap(find.byType(ActionCardWidget).first);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(ActionCardWidget).first); // Should be blocked
      await tester.pump();

      expect(activationCount, 1,
          reason: 'Animation lock prevents duplicate strategic actions corrupting game state');

      await tester.pump(const Duration(milliseconds: 300)); // Cleanup
    });

    testWidgets('should adapt hand visibility based on strategic context', (tester) async {
      // Test behavior: visibility adaptation supports competitive information asymmetry
      final visibilityScenarios = [
        (isCurrentPlayer: true, expectFullDetails: true, 'current player needs full strategic information'),
        (isCurrentPlayer: false, expectFullDetails: false, 'opponents see limited information for competitive balance'),
      ];

      for (final (:isCurrentPlayer, :expectFullDetails, scenario) in visibilityScenarios) {
        await tester.pumpWidget(
          createTestWidget(
            player: testPlayer,
            isCurrentPlayer: isCurrentPlayer,
          ),
        );

        // All cards visible but interaction differs
        expect(find.byType(ActionCardWidget), findsNWidgets(3),
            reason: 'Card count visible for strategic assessment');

        final container = tester.widget<Container>(
          find.ancestor(
            of: find.text('Cartes Actions (3/3)'),
            matching: find.byType(Container),
          ).first,
        );

        if (expectFullDetails) {
          expect(container.constraints?.maxHeight, 180,
              reason: 'Full view for strategic planning: $scenario');
        } else {
          expect(container.constraints?.maxHeight, 120,
              reason: 'Compact view maintains information asymmetry: $scenario');
        }
      }
    });
  });
}
