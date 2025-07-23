import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/player_hand_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('PlayerHandWidget', () {
    testWidgets('should show nothing when not current player', (WidgetTester tester) async {
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

    testWidgets('should show nothing when no drawn card', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(
              drawnCard: null,
              isCurrentPlayer: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Container), findsNothing);
      expect(find.text('Carte en main'), findsNothing);
    });

    testWidgets('should show card when current player has drawn card', (WidgetTester tester) async {
      // Arrange
      const drawnCard = game.Card(value: 5, isRevealed: false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(
              drawnCard: drawnCard,
              isCurrentPlayer: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Carte en main'), findsOneWidget);
      expect(find.byIcon(Icons.pan_tool), findsOneWidget);
    });

    testWidgets('should show discard button when canDiscard is true', (WidgetTester tester) async {
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

    testWidgets('should not show discard button when canDiscard is false', (WidgetTester tester) async {
      // Arrange
      const drawnCard = game.Card( value: 3, isRevealed: false);

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

    testWidgets('should call onDiscard when button is pressed', (WidgetTester tester) async {
      // Arrange
      const drawnCard = game.Card( value: 10, isRevealed: false);
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
      const drawnCard = game.Card( value: 2, isRevealed: false);

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
      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(16));
      expect(decoration.color, Colors.grey);

      // Check discard button color
      final textButton = tester.widget<TextButton>(find.byType(TextButton));
      expect(textButton.style?.foregroundColor?.resolve({}), Colors.red);
    });

    testWidgets('should display card with correct dimensions', (WidgetTester tester) async {
      // Arrange
      const drawnCard = game.Card( value: 8, isRevealed: false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(
              drawnCard: drawnCard,
              isCurrentPlayer: true,
            ),
          ),
        ),
      );

      // Assert
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      
      // Find the SizedBox with height 140
      final heightSizedBox = sizedBoxes.firstWhere(
        (widget) => widget.height == 140,
        orElse: () => throw StateError('SizedBox with height 140 not found'),
      );
      expect(heightSizedBox.height, equals(140));
      
      // Find the SizedBox with width 100
      final widthSizedBox = sizedBoxes.firstWhere(
        (widget) => widget.width == 100,
        orElse: () => throw StateError('SizedBox with width 100 not found'),
      );
      expect(widthSizedBox.width, equals(100));
    });

    testWidgets('should apply shadow correctly', (WidgetTester tester) async {
      // Arrange
      const drawnCard = game.Card( value: 4, isRevealed: false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlayerHandWidget(
              drawnCard: drawnCard,
              isCurrentPlayer: true,
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, equals(1));
      expect(decoration.boxShadow!.first.blurRadius, equals(8));
      expect(decoration.boxShadow!.first.offset, equals(const Offset(0, -2)));
    });

    testWidgets('should handle null onDiscard callback', (WidgetTester tester) async {
      // Arrange
      const drawnCard = game.Card( value: 6, isRevealed: false);

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

      // Assert
      expect(find.text('Défausser'), findsOneWidget);
      final textButton = tester.widget<TextButton>(find.byType(TextButton));
      expect(textButton.onPressed, isNull);
    });
  });
}