import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/card_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('CardWidget', () {
    testWidgets('should display placeholder when isPlaceholder is true', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CardWidget(isPlaceholder: true)),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display hidden card when card is not revealed', (
      tester,
    ) async {
      // Arrange
      const card = game.Card(value: 5, isRevealed: false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CardWidget(card: card)),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.question_mark), findsOneWidget);
      expect(find.text('5'), findsNothing); // Value should not be visible
    });

    testWidgets('should display card value when revealed', (tester) async {
      // Arrange
      const card = game.Card(value: 7, isRevealed: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CardWidget(card: card)),
        ),
      );

      // Assert
      expect(
        find.text('7'),
        findsNWidgets(3),
      ); // Value shown 3 times (top-left, center, bottom-right)
      expect(find.byIcon(Icons.question_mark), findsNothing);
    });

    testWidgets('should handle tap when onTap is provided', (tester) async {
      // Arrange
      bool tapped = false;
      const card = game.Card(value: 3, isRevealed: false);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardWidget(card: card, onTap: () => tapped = true),
          ),
        ),
      );

      await tester.tap(find.byType(CardWidget));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should handle long press when onLongPress is provided', (
      tester,
    ) async {
      // Arrange
      bool longPressed = false;
      const card = game.Card(value: 9, isRevealed: false);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardWidget(card: card, onLongPress: () => longPressed = true),
          ),
        ),
      );

      await tester.longPress(find.byType(CardWidget));
      await tester.pump();

      // Assert
      expect(longPressed, isTrue);
    });

    testWidgets('should show selection border when isSelected is true', (
      tester,
    ) async {
      // Arrange
      const card = game.Card(value: 2, isRevealed: true);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CardWidget(card: card, isSelected: true)),
        ),
      );

      // Assert
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border?.top.width, equals(3));
    });

    testWidgets('should show highlight border when isHighlighted is true', (
      tester,
    ) async {
      // Arrange
      const card = game.Card(value: 4, isRevealed: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CardWidget(card: card, isHighlighted: true)),
        ),
      );

      // Assert
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border?.top.color, equals(Colors.orange));
      expect(decoration.border?.top.width, equals(3));
    });

    testWidgets(
      'should display nothing when card is null and not placeholder',
      (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: CardWidget(card: null, isPlaceholder: false)),
          ),
        );

        // Assert
        expect(find.byType(SizedBox), findsWidgets);
        expect(find.byIcon(Icons.add), findsNothing);
        expect(find.byIcon(Icons.question_mark), findsNothing);
      },
    );

    testWidgets('should apply correct color based on card value', (
      tester,
    ) async {
      // Test for each value range
      final testCases = [
        (-2, Colors.blue.shade900), // Dark blue
        (0, Colors.blue.shade900), // Light blue
        (3, Colors.green.shade900), // Green
        (7, Colors.yellow.shade900), // Yellow
        (11, Colors.red.shade900), // Red
      ];

      for (final (value, expectedColor) in testCases) {
        // Arrange
        final card = game.Card(value: value, isRevealed: true);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: CardWidget(card: card)),
          ),
        );

        // Assert
        final textWidgets = tester.widgetList<Text>(
          find.text(value.toString()),
        );
        expect(textWidgets.length, equals(3));

        // Verify text color matches expected color
        for (final textWidget in textWidgets) {
          final textColor = textWidget.style?.color;
          expect(textColor, equals(expectedColor));
        }
      }
    });

    testWidgets('should maintain aspect ratio of 0.7', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(width: 100, child: CardWidget(isPlaceholder: true)),
          ),
        ),
      );

      // Assert
      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, equals(0.7));
    });
  });
}
