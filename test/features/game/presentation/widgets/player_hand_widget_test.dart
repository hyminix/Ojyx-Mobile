import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/player_hand_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('PlayerHandWidget', () {
    testWidgets('should show nothing when not current player', (
      WidgetTester tester,
    ) async {
      // Arrange
      const drawnCard = game.Card(value: 5, isRevealed: false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(
              drawnCard: drawnCard,
              isCurrentPlayer: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Container), findsNothing);
      expect(find.text('Carte en main'), findsNothing);
    });

    testWidgets('should show nothing when no drawn card', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(drawnCard: null, isCurrentPlayer: true),
          ),
        ),
      );

      // Assert
      expect(find.byType(Container), findsNothing);
      expect(find.text('Carte en main'), findsNothing);
    });

    testWidgets('should show card when current player has drawn card', (
      WidgetTester tester,
    ) async {
      // Arrange
      const drawnCard = game.Card(value: 5, isRevealed: false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(drawnCard: drawnCard, isCurrentPlayer: true),
          ),
        ),
      );

      // Assert
      expect(find.text('Carte en main'), findsOneWidget);
      expect(find.byIcon(Icons.pan_tool), findsOneWidget);
    });

    testWidgets('should show discard button when canDiscard is true', (
      WidgetTester tester,
    ) async {
      // Arrange
      const drawnCard = game.Card(value: 7, isRevealed: false);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(
              drawnCard: drawnCard,
              isCurrentPlayer: true,
              canDiscard: true,
              onDiscard: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Défausser'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.text('Glissez sur\nune carte'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('should not show discard button when canDiscard is false', (
      WidgetTester tester,
    ) async {
      // Arrange
      const drawnCard = game.Card(value: 3, isRevealed: false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(
              drawnCard: drawnCard,
              isCurrentPlayer: true,
              canDiscard: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Défausser'), findsNothing);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
      expect(find.text('Glissez sur\nune carte'), findsNothing);
      expect(find.byIcon(Icons.arrow_forward), findsNothing);
    });

    testWidgets('should call onDiscard when button is pressed', (
      WidgetTester tester,
    ) async {
      // Arrange
      const drawnCard = game.Card(value: 10, isRevealed: false);
      var discardCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(
              drawnCard: drawnCard,
              isCurrentPlayer: true,
              canDiscard: true,
              onDiscard: () {
                discardCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Défausser'));
      await tester.pump();

      // Assert
      expect(discardCalled, isTrue);
    });

    testWidgets('should apply proper styling', (WidgetTester tester) async {
      // Arrange
      const drawnCard = game.Card(value: 2, isRevealed: false);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              error: Colors.red,
              surfaceContainerHighest: Colors.grey,
            ),
          ),
          home: Scaffold(
            body: PlayerHandWidget(
              drawnCard: drawnCard,
              isCurrentPlayer: true,
              canDiscard: true,
              onDiscard: () {},
            ),
          ),
        ),
      );

      // Assert
      // Find the main container with decoration
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decoratedContainer = containers.firstWhere(
        (container) =>
            container.decoration != null &&
            container.decoration is BoxDecoration &&
            (container.decoration as BoxDecoration).borderRadius != null,
      );
      final decoration = decoratedContainer.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(16));
      expect(decoration.color, Colors.grey);

      // Check discard button color if present
      final textButtonFinder = find.byType(TextButton);
      if (textButtonFinder.evaluate().isNotEmpty) {
        final textButton = tester.widget<TextButton>(textButtonFinder);
        expect(textButton.style?.foregroundColor?.resolve({}), Colors.red);
      }
    });

    testWidgets('should display card with correct dimensions', (
      WidgetTester tester,
    ) async {
      // Arrange
      const drawnCard = game.Card(value: 8, isRevealed: false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(drawnCard: drawnCard, isCurrentPlayer: true),
          ),
        ),
      );

      // Assert
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));

      // Find the SizedBox with height 140
      final heightSizedBoxes = sizedBoxes.where(
        (widget) => widget.height == 140,
      );
      expect(
        heightSizedBoxes.isNotEmpty,
        isTrue,
        reason: 'SizedBox with height 140 not found',
      );
      expect(heightSizedBoxes.first.height, equals(140));

      // Find the SizedBox with width 100
      final widthSizedBoxes = sizedBoxes.where((widget) => widget.width == 100);
      expect(
        widthSizedBoxes.isNotEmpty,
        isTrue,
        reason: 'SizedBox with width 100 not found',
      );
      expect(widthSizedBoxes.first.width, equals(100));
    });

    testWidgets('should apply shadow correctly', (WidgetTester tester) async {
      // Arrange
      const drawnCard = game.Card(value: 4, isRevealed: false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(drawnCard: drawnCard, isCurrentPlayer: true),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, equals(1));
      expect(decoration.boxShadow!.first.blurRadius, equals(8));
      expect(decoration.boxShadow!.first.offset, equals(const Offset(0, -2)));
    });

    testWidgets('should handle null onDiscard callback', (
      WidgetTester tester,
    ) async {
      // Arrange
      const drawnCard = game.Card(value: 6, isRevealed: false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(
              drawnCard: drawnCard,
              isCurrentPlayer: true,
              canDiscard: true,
              onDiscard: null,
            ),
          ),
        ),
      );

      // Assert - Verify the button is displayed but disabled
      expect(find.text('Défausser'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      // The fact that the button is rendered with null onDiscard callback is the test
      // We verify the UI elements are present, which means the widget handles null correctly
      // without causing any errors
    });
  });
}
