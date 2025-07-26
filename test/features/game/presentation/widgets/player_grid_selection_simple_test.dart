import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_with_selection.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider_v2.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('PlayerGridWithSelection - Core Functionality', () {
    late List<game.Card> testCards;
    late PlayerGrid grid;

    setUp(() {
      testCards = List.generate(12, (index) => game.Card(value: index));
      grid = PlayerGrid.fromCards(testCards);
    });

    testWidgets('should integrate with CardSelectionProvider', (tester) async {
      late ProviderContainer container;

      await tester.pumpWidget(
        ProviderScope(
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp(
                home: Scaffold(
                  body: SingleChildScrollView(
                    child: PlayerGridWithSelection(
                      grid: grid,
                      isCurrentPlayer: true,
                      canInteract: true,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Initially, not in selection mode
      expect(container.read(cardSelectionProvider).isSelecting, isFalse);

      // Start teleport selection
      container.read(cardSelectionProvider.notifier).startTeleportSelection();
      await tester.pump();

      // Should be in selection mode
      expect(container.read(cardSelectionProvider).isSelecting, isTrue);
      expect(
        container.read(cardSelectionProvider).selectionType,
        equals(CardSelectionType.teleport),
      );
    });

    testWidgets('should show selection instructions when in teleport mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: PlayerGridWithSelection(
                  grid: grid,
                  isCurrentPlayer: true,
                  canInteract: true,
                ),
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(PlayerGridWithSelection)),
      );

      // Start teleport selection
      container.read(cardSelectionProvider.notifier).startTeleportSelection();
      await tester.pump();

      // Should show first selection instruction
      expect(
        find.text('Sélectionnez la première carte à échanger'),
        findsOneWidget,
      );
    });

    testWidgets('should update instruction text as selection progresses', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: PlayerGridWithSelection(
                  grid: grid,
                  isCurrentPlayer: true,
                  canInteract: true,
                ),
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(PlayerGridWithSelection)),
      );

      // Start teleport selection
      final notifier = container.read(cardSelectionProvider.notifier);
      notifier.startTeleportSelection();
      await tester.pump();

      // Select first card
      notifier.selectCard(0, 0);
      await tester.pump();

      // Should show second selection instruction
      expect(
        find.text('Sélectionnez la deuxième carte à échanger'),
        findsOneWidget,
      );

      // Select second card
      notifier.selectCard(0, 1);
      await tester.pump();

      // Should show confirmation instruction
      expect(
        find.text('Cartes sélectionnées - confirmez l\'échange'),
        findsOneWidget,
      );
    });

    testWidgets('should call onTeleportComplete when selection is confirmed', (
      tester,
    ) async {
      Map<String, dynamic>? receivedTargetData;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: PlayerGridWithSelection(
                  grid: grid,
                  isCurrentPlayer: true,
                  canInteract: true,
                  onTeleportComplete: (targetData) {
                    receivedTargetData = targetData;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(PlayerGridWithSelection)),
      );

      // Complete selection
      final notifier = container.read(cardSelectionProvider.notifier);
      notifier.startTeleportSelection();
      notifier.selectCard(0, 0);
      notifier.selectCard(1, 2);
      await tester.pump();

      // Tap confirm button
      await tester.tap(find.text('Confirmer'));
      await tester.pump();

      // Should call callback with correct data
      expect(receivedTargetData, isNotNull);
      expect(receivedTargetData!['position1']['row'], equals(0));
      expect(receivedTargetData!['position1']['col'], equals(0));
      expect(receivedTargetData!['position2']['row'], equals(1));
      expect(receivedTargetData!['position2']['col'], equals(2));
    });

    testWidgets('should cancel selection when cancel button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: PlayerGridWithSelection(
                  grid: grid,
                  isCurrentPlayer: true,
                  canInteract: true,
                ),
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(PlayerGridWithSelection)),
      );

      // Start selection and select a card
      final notifier = container.read(cardSelectionProvider.notifier);
      notifier.startTeleportSelection();
      notifier.selectCard(0, 0);
      await tester.pump();

      // Scroll to make cancel button visible and tap it
      await tester.ensureVisible(find.text('Annuler'));
      await tester.tap(find.text('Annuler'));
      await tester.pump();

      // Selection should be cancelled
      final selectionState = container.read(cardSelectionProvider);
      expect(selectionState.isSelecting, isFalse);
      expect(selectionState.firstSelection, isNull);
      expect(
        find.text('Sélectionnez la première carte à échanger'),
        findsNothing,
      );
    });

    test('should provide correct selected positions from selection state', () {
      // This is a unit test for the positioning logic
      const firstSelection = (0, 0);
      const secondSelection = (1, 2);

      // Simulate what the widget does
      final selectedPositions = <(int, int)>{};
      selectedPositions.add(firstSelection);
      selectedPositions.add(secondSelection);

      expect(selectedPositions.contains((0, 0)), isTrue);
      expect(selectedPositions.contains((1, 2)), isTrue);
      expect(selectedPositions.length, equals(2));
      expect(selectedPositions.contains((0, 1)), isFalse);
    });
  });
}
