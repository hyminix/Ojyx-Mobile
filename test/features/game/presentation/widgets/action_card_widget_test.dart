import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/presentation/widgets/action_card_widget.dart';

void main() {
  group('ActionCardWidget', () {
    Widget createTestWidget(
      ActionCard card, {
      bool isSelectable = true,
      void Function()? onTap,
      bool isHighlighted = false,
    }) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: ActionCardWidget(
                card: card,
                isSelectable: isSelectable,
                onTap: onTap,
                isHighlighted: isHighlighted,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('should display action card with name and type', (
      tester,
    ) async {
      // Arrange
      const card = ActionCard(
        id: 'test-card',
        type: ActionCardType.turnAround,
        name: 'Demi-tour',
        description: 'Inversez le sens du jeu',
        timing: ActionTiming.immediate,
        target: ActionTarget.none,
      );

      // Act
      await tester.pumpWidget(createTestWidget(card));

      // Assert
      expect(find.text('Demi-tour'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should show correct timing indicators for all card timings', (
      tester,
    ) async {
      // Test data for all timing types
      final timingTestCases = [
        (
          card: const ActionCard(
            id: 'immediate-card',
            type: ActionCardType.turnAround,
            name: 'Demi-tour',
            description: 'Inversez le sens du jeu',
            timing: ActionTiming.immediate,
            target: ActionTarget.none,
          ),
          expectedIcon: Icons.flash_on,
          expectedText: 'Immédiate',
        ),
        (
          card: const ActionCard(
            id: 'optional-card',
            type: ActionCardType.skip,
            name: 'Saut',
            description: 'Le prochain joueur passe son tour',
            timing: ActionTiming.optional,
            target: ActionTarget.none,
          ),
          expectedIcon: Icons.schedule,
          expectedText: 'Optionnelle',
        ),
        (
          card: const ActionCard(
            id: 'reactive-card',
            type: ActionCardType.shield,
            name: 'Bouclier',
            description: 'Protégez-vous des attaques',
            timing: ActionTiming.reactive,
            target: ActionTarget.self,
          ),
          expectedIcon: Icons.shield,
          expectedText: 'Réactive',
        ),
      ];

      // Test each timing type
      for (final testCase in timingTestCases) {
        await tester.pumpWidget(createTestWidget(testCase.card));

        expect(
          find.byIcon(testCase.expectedIcon),
          findsOneWidget,
          reason:
              'Should show ${testCase.expectedIcon} for ${testCase.card.timing} timing',
        );
        expect(
          find.text(testCase.expectedText),
          findsOneWidget,
          reason:
              'Should show "${testCase.expectedText}" for ${testCase.card.timing} timing',
        );

        // Clear the widget tree for next test
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('should be tappable when selectable', (tester) async {
      // Arrange
      var wasTapped = false;
      const card = ActionCard(
        id: 'test-card',
        type: ActionCardType.skip,
        name: 'Saut',
        description: 'Le prochain joueur passe son tour',
        timing: ActionTiming.optional,
        target: ActionTarget.none,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(card, onTap: () => wasTapped = true),
      );
      await tester.tap(find.byType(ActionCardWidget));
      await tester.pump();

      // Assert
      expect(wasTapped, isTrue);
    });

    testWidgets('should not be tappable when not selectable', (tester) async {
      // Arrange
      var wasTapped = false;
      const card = ActionCard(
        id: 'test-card',
        type: ActionCardType.skip,
        name: 'Saut',
        description: 'Le prochain joueur passe son tour',
        timing: ActionTiming.optional,
        target: ActionTarget.none,
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          card,
          isSelectable: false,
          onTap: () => wasTapped = true,
        ),
      );
      await tester.tap(find.byType(ActionCardWidget));
      await tester.pump();

      // Assert
      expect(wasTapped, isFalse);
    });

    testWidgets('should show highlight when highlighted', (tester) async {
      // Arrange
      const card = ActionCard(
        id: 'test-card',
        type: ActionCardType.skip,
        name: 'Saut',
        description: 'Le prochain joueur passe son tour',
        timing: ActionTiming.optional,
        target: ActionTarget.none,
      );

      // Act
      await tester.pumpWidget(createTestWidget(card, isHighlighted: true));

      // Assert
      final cardWidget = tester.widget<Card>(find.byType(Card));
      expect(cardWidget.color, equals(Colors.yellow.shade100));
    });

    testWidgets('should show description on long press', (tester) async {
      // Arrange
      const card = ActionCard(
        id: 'test-card',
        type: ActionCardType.turnAround,
        name: 'Demi-tour',
        description: 'Inversez le sens du jeu',
        timing: ActionTiming.immediate,
        target: ActionTarget.none,
      );

      // Act
      await tester.pumpWidget(createTestWidget(card));
      await tester.longPress(find.byType(ActionCardWidget));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Inversez le sens du jeu'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('should display correct styling based on card category', (
      tester,
    ) async {
      // Test data for different card categories
      final categoryTestCases = [
        // Movement cards
        (
          card: const ActionCard(
            id: 'teleport-card',
            type: ActionCardType.teleport,
            name: 'Téléportation',
            description: 'Échangez deux cartes',
            timing: ActionTiming.optional,
            target: ActionTarget.self,
          ),
          expectedColor: Colors.blue.shade50,
          category: 'movement',
        ),
        // Attack cards
        (
          card: const ActionCard(
            id: 'steal-card',
            type: ActionCardType.steal,
            name: 'Vol',
            description: 'Volez une carte action',
            timing: ActionTiming.optional,
            target: ActionTarget.singleOpponent,
          ),
          expectedColor: Colors.red.shade50,
          category: 'attack',
        ),
        // Utility cards
        (
          card: const ActionCard(
            id: 'draw-card',
            type: ActionCardType.draw,
            name: 'Pioche',
            description: 'Piochez 2 cartes actions',
            timing: ActionTiming.optional,
            target: ActionTarget.deck,
          ),
          expectedColor: Colors.green.shade50,
          category: 'utility',
        ),
      ];

      // Target icon test cases
      final targetIconTestCases = [
        (target: ActionTarget.self, expectedIcon: Icons.person),
        (target: ActionTarget.singleOpponent, expectedIcon: Icons.person_pin),
        (target: ActionTarget.allOpponents, expectedIcon: Icons.groups),
      ];

      // Test card colors by category
      for (final testCase in categoryTestCases) {
        await tester.pumpWidget(createTestWidget(testCase.card));

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(Card),
            matching: find.byType(Container).first,
          ),
        );

        expect(
          (container.decoration as BoxDecoration).color,
          equals(testCase.expectedColor),
          reason:
              '${testCase.category} cards should have ${testCase.expectedColor} background',
        );

        await tester.pumpWidget(Container());
      }

      // Test target icons
      for (final testCase in targetIconTestCases) {
        final card = ActionCard(
          id: 'test-${testCase.target}',
          type: ActionCardType.shield,
          name: 'Test Card',
          description: 'Test Description',
          timing: ActionTiming.optional,
          target: testCase.target,
        );

        await tester.pumpWidget(createTestWidget(card));

        expect(
          find.byIcon(testCase.expectedIcon),
          findsOneWidget,
          reason:
              'Cards targeting ${testCase.target} should show ${testCase.expectedIcon}',
        );

        await tester.pumpWidget(Container());
      }
    });

    testWidgets('should be properly sized for mobile', (tester) async {
      // Arrange
      const card = ActionCard(
        id: 'test-card',
        type: ActionCardType.skip,
        name: 'Saut',
        description: 'Le prochain joueur passe son tour',
        timing: ActionTiming.optional,
        target: ActionTarget.none,
      );

      // Act
      await tester.pumpWidget(createTestWidget(card));

      // Assert
      final sizedBox = tester.widget<SizedBox>(
        find
            .ancestor(of: find.byType(Card), matching: find.byType(SizedBox))
            .first,
      );
      expect(sizedBox.width, equals(100));
      expect(sizedBox.height, equals(140));
    });
  });
}
