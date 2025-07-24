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

    testWidgets('should show timing indicator for immediate cards', (
      tester,
    ) async {
      // Arrange
      const immediateCard = ActionCard(
        id: 'test-card',
        type: ActionCardType.turnAround,
        name: 'Demi-tour',
        description: 'Inversez le sens du jeu',
        timing: ActionTiming.immediate,
        target: ActionTarget.none,
      );

      // Act
      await tester.pumpWidget(createTestWidget(immediateCard));

      // Assert
      expect(
        find.byIcon(Icons.flash_on),
        findsOneWidget,
      ); // Immediate indicator
      expect(find.text('Immédiate'), findsOneWidget);
    });

    testWidgets('should show timing indicator for optional cards', (
      tester,
    ) async {
      // Arrange
      const optionalCard = ActionCard(
        id: 'test-card',
        type: ActionCardType.skip,
        name: 'Saut',
        description: 'Le prochain joueur passe son tour',
        timing: ActionTiming.optional,
        target: ActionTarget.none,
      );

      // Act
      await tester.pumpWidget(createTestWidget(optionalCard));

      // Assert
      expect(find.byIcon(Icons.schedule), findsOneWidget); // Optional indicator
      expect(find.text('Optionnelle'), findsOneWidget);
    });

    testWidgets('should show timing indicator for reactive cards', (
      tester,
    ) async {
      // Arrange
      const reactiveCard = ActionCard(
        id: 'test-card',
        type: ActionCardType.shield,
        name: 'Bouclier',
        description: 'Protégez-vous des attaques',
        timing: ActionTiming.reactive,
        target: ActionTarget.self,
      );

      // Act
      await tester.pumpWidget(createTestWidget(reactiveCard));

      // Assert
      expect(find.byIcon(Icons.shield), findsOneWidget); // Reactive indicator
      expect(find.text('Réactive'), findsOneWidget);
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

    testWidgets('should use correct color for different card types', (
      tester,
    ) async {
      // Test movement card (teleport)
      const teleportCard = ActionCard(
        id: 'test-card-1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );

      await tester.pumpWidget(createTestWidget(teleportCard));
      var container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(Container).first,
        ),
      );
      expect(
        (container.decoration as BoxDecoration).color,
        equals(Colors.blue.shade50),
      );

      // Test attack card (steal)
      const stealCard = ActionCard(
        id: 'test-card-2',
        type: ActionCardType.steal,
        name: 'Vol',
        description: 'Volez une carte action',
        timing: ActionTiming.optional,
        target: ActionTarget.singleOpponent,
      );

      await tester.pumpWidget(createTestWidget(stealCard));
      container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(Container).first,
        ),
      );
      expect(
        (container.decoration as BoxDecoration).color,
        equals(Colors.red.shade50),
      );

      // Test utility card (draw)
      const drawCard = ActionCard(
        id: 'test-card-3',
        type: ActionCardType.draw,
        name: 'Pioche',
        description: 'Piochez 2 cartes actions',
        timing: ActionTiming.optional,
        target: ActionTarget.deck,
      );

      await tester.pumpWidget(createTestWidget(drawCard));
      container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(Container).first,
        ),
      );
      expect(
        (container.decoration as BoxDecoration).color,
        equals(Colors.green.shade50),
      );
    });

    testWidgets('should show target icon based on target type', (tester) async {
      // Test self target
      const selfCard = ActionCard(
        id: 'test-card-1',
        type: ActionCardType.shield,
        name: 'Bouclier',
        description: 'Protégez-vous',
        timing: ActionTiming.reactive,
        target: ActionTarget.self,
      );

      await tester.pumpWidget(createTestWidget(selfCard));
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Test single opponent target
      const singleCard = ActionCard(
        id: 'test-card-2',
        type: ActionCardType.steal,
        name: 'Vol',
        description: 'Volez une carte',
        timing: ActionTiming.optional,
        target: ActionTarget.singleOpponent,
      );

      await tester.pumpWidget(createTestWidget(singleCard));
      expect(find.byIcon(Icons.person_pin), findsOneWidget);

      // Test all opponents target
      const allCard = ActionCard(
        id: 'test-card-3',
        type: ActionCardType.reveal,
        name: 'Révélation',
        description: 'Révélez une carte',
        timing: ActionTiming.optional,
        target: ActionTarget.allOpponents,
      );

      await tester.pumpWidget(createTestWidget(allCard));
      expect(find.byIcon(Icons.groups), findsOneWidget);
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
