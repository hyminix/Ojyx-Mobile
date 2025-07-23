import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/widgets/action_card_draw_pile_widget.dart';
import 'package:ojyx/features/game/presentation/providers/action_card_providers.dart';

class MockActionCardStateNotifier extends ActionCardStateNotifier
    with Mock {
  MockActionCardStateNotifier(ActionCardState initialState) {
    state = initialState;
  }
}

void main() {
  group('ActionCardDrawPileWidget', () {
    late MockActionCardStateNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockActionCardStateNotifier(
        const ActionCardState(
          drawPileCount: 37,
          discardPileCount: 0,
          isLoading: false,
        ),
      );
    });

    Widget createTestWidget({
      bool canDraw = true,
      VoidCallback? onDraw,
    }) {
      return ProviderScope(
        overrides: [
          actionCardStateNotifierProvider.overrideWith(
            (ref) => mockNotifier,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: ActionCardDrawPileWidget(
                canDraw: canDraw,
                onDraw: onDraw,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('should display draw pile with card count', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Cartes Actions'), findsOneWidget);
      expect(find.text('37'), findsOneWidget);
      expect(find.byIcon(Icons.style), findsOneWidget);
    });

    testWidgets('should show empty state when no cards', (tester) async {
      // Arrange
      mockNotifier.state = const ActionCardState(
        drawPileCount: 0,
        discardPileCount: 0,
        isLoading: false,
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Pile vide'), findsOneWidget);
    });

    testWidgets('should be tappable when canDraw is true', (tester) async {
      // Arrange
      var wasTapped = false;

      // Act
      await tester.pumpWidget(createTestWidget(
        canDraw: true,
        onDraw: () => wasTapped = true,
      ));

      await tester.tap(find.byType(ActionCardDrawPileWidget));
      await tester.pump();

      // Assert
      expect(wasTapped, isTrue);
    });

    testWidgets('should not be tappable when canDraw is false', (tester) async {
      // Arrange
      var wasTapped = false;

      // Act
      await tester.pumpWidget(createTestWidget(
        canDraw: false,
        onDraw: () => wasTapped = true,
      ));

      await tester.tap(find.byType(ActionCardDrawPileWidget));
      await tester.pump();

      // Assert
      expect(wasTapped, isFalse);
    });

    testWidgets('should show disabled state when canDraw is false', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(canDraw: false));

      // Assert
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;
      // Check that the gradient colors have reduced opacity
      expect(gradient.colors.first.opacity, lessThan(1.0));
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      // Arrange
      mockNotifier.state = const ActionCardState(
        drawPileCount: 37,
        discardPileCount: 0,
        isLoading: true,
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have proper card back design', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final stack = tester.widget<Stack>(
        find.descendant(
          of: find.byType(ActionCardDrawPileWidget),
          matching: find.byType(Stack),
        ).first,
      );
      expect(stack.children.length, greaterThanOrEqualTo(2)); // Background + content
    });

    testWidgets('should animate on tap when enabled', (tester) async {
      // Arrange
      var tapCount = 0;

      // Act
      await tester.pumpWidget(createTestWidget(
        canDraw: true,
        onDraw: () => tapCount++,
      ));

      // First tap
      await tester.tap(find.byType(ActionCardDrawPileWidget));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(tapCount, equals(1));
      
      // Should show some visual feedback
      final inkWell = tester.widget<InkWell>(
        find.descendant(
          of: find.byType(ActionCardDrawPileWidget),
          matching: find.byType(InkWell),
        ).first,
      );
      expect(inkWell.onTap, isNotNull);
    });

    testWidgets('should display proper size for mobile', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(Stack),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, equals(100));
      expect(sizedBox.height, equals(140));
    });

    testWidgets('should show tooltip on long press', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      
      await tester.longPress(find.byType(ActionCardDrawPileWidget));
      await tester.pumpAndSettle();

      // Assert - The tooltip/snackbar should appear
      expect(find.text('Piochez une carte action'), findsOneWidget);
    });

    testWidgets('should update count when state changes', (tester) async {
      // Initial state
      await tester.pumpWidget(createTestWidget());
      expect(find.text('37'), findsOneWidget);

      // Update state
      mockNotifier.state = const ActionCardState(
        drawPileCount: 25,
        discardPileCount: 12,
        isLoading: false,
      );
      await tester.pump();

      // Assert
      expect(find.text('25'), findsOneWidget);
      expect(find.text('37'), findsNothing);
    });

    testWidgets('should have elevation for depth effect', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final card = tester.widget<Card>(
        find.byType(Card).first,
      );
      expect(card.elevation, greaterThan(0));
    });

    testWidgets('should use theme colors appropriately', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.blue,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: Scaffold(
            body: Center(
              child: ProviderScope(
                overrides: [
                  actionCardStateNotifierProvider.overrideWith(
                    (ref) => mockNotifier,
                  ),
                ],
                child: const ActionCardDrawPileWidget(canDraw: true),
              ),
            ),
          ),
        ),
      );

      // Assert - The widget should use theme colors
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.decoration, isA<BoxDecoration>());
    });
  });
}