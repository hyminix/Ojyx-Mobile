import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/draw_pile_widget.dart';

void main() {
  group('DrawPileWidget', () {
    testWidgets('should display draw pile with card count', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(cardCount: 42, isPlayerTurn: false),
          ),
        ),
      );

      // Assert
      expect(find.text('42'), findsOneWidget);
      expect(find.byType(Stack), findsWidgets); // For stacked card effect
    });

    testWidgets('should show empty state when no cards', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(cardCount: 0, isPlayerTurn: false),
          ),
        ),
      );

      // Assert
      expect(find.text('0'), findsOneWidget);
      // Should still show card back but with different opacity
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should handle tap when onTap is provided and is player turn', (
      tester,
    ) async {
      // Arrange
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(
              cardCount: 10,
              isPlayerTurn: true,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DrawPileWidget));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should not handle tap when not player turn', (tester) async {
      // Arrange
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(
              cardCount: 10,
              isPlayerTurn: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DrawPileWidget));
      await tester.pump();

      // Assert
      expect(tapped, isFalse);
    });

    testWidgets('should show glow effect when player turn', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(cardCount: 10, isPlayerTurn: true),
          ),
        ),
      );

      // Assert
      // Find the main container and check for box shadow
      final containers = tester.widgetList<Container>(find.byType(Container));
      bool hasGlowEffect = false;

      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration?.boxShadow != null &&
            decoration!.boxShadow!.isNotEmpty) {
          // Check for glow-like shadow (checking for spread radius or large blur)
          for (final shadow in decoration.boxShadow!) {
            if (shadow.blurRadius >= 16 || shadow.spreadRadius > 0) {
              hasGlowEffect = true;
              break;
            }
          }
        }
      }

      expect(hasGlowEffect, isTrue);
    });

    testWidgets('should display stacked card effect', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(cardCount: 20, isPlayerTurn: false),
          ),
        ),
      );

      // Assert
      // Should have multiple positioned cards for stack effect
      final stack = tester.widget<Stack>(find.byType(Stack).first);
      expect(stack.children.length, greaterThan(1));
    });

    testWidgets('should show tooltip on hover', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(cardCount: 15, isPlayerTurn: true),
          ),
        ),
      );

      // Assert
      expect(find.byType(Tooltip), findsOneWidget);
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, contains('Piocher'));
    });

    testWidgets('should allow tap when card count is 0 for reshuffle', (
      tester,
    ) async {
      // Arrange
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(
              cardCount: 0,
              isPlayerTurn: true,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DrawPileWidget));
      await tester.pump();

      // Assert - Now expects tap to work even with 0 cards
      expect(tapped, isTrue);

      // Verify tooltip shows reshuffle message
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, contains('Mélanger'));
    });

    testWidgets('should animate card count changes', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(cardCount: 10, isPlayerTurn: false),
          ),
        ),
      );

      // Act - Change card count
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(cardCount: 9, isPlayerTurn: false),
          ),
        ),
      );

      // Assert - Should find AnimatedSwitcher
      expect(find.byType(AnimatedSwitcher), findsWidgets);
    });

    testWidgets('should display card back pattern', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(cardCount: 30, isPlayerTurn: false),
          ),
        ),
      );

      // Assert
      expect(find.byType(CustomPaint), findsWidgets); // For card back pattern
    });

    testWidgets('should scale on tap when enabled', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(
              cardCount: 10,
              isPlayerTurn: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // Get initial scale
      final gesture = tester.widget<GestureDetector>(
        find.byType(GestureDetector).first,
      );

      // Simulate tap down
      await tester.press(find.byType(DrawPileWidget));
      await tester.pump(const Duration(milliseconds: 50));

      // Should have scale animation
      expect(find.byType(AnimatedScale), findsOneWidget);
    });

    testWidgets('should have correct accessibility label', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DrawPileWidget(cardCount: 25, isPlayerTurn: true),
          ),
        ),
      );

      // Assert
      expect(
        find.bySemanticsLabel(RegExp(r'Pioche.*25.*cartes')),
        findsOneWidget,
      );
    });
  });
}
