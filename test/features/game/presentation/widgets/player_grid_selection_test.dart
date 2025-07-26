import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_with_selection.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider_v2.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('PlayerGridWithSelection', () {
    late List<game.Card> testCards;
    late PlayerGrid grid;

    setUp(() {
      testCards = List.generate(12, (index) => game.Card(value: index));
      grid = PlayerGrid.fromCards(testCards);
    });

    testWidgets('should render PlayerGridWidget with selection integration', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
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

      // Should render the grid
      expect(find.byType(PlayerGridWidget), findsOneWidget);
      expect(find.text('Votre grille'), findsOneWidget);
    });

    testWidgets('should show selection state when teleport mode is active', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
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

      // Start teleport selection
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PlayerGridWithSelection)),
      );
      container.read(cardSelectionProvider.notifier).startTeleportSelection();
      await tester.pump();

      // Should show selection mode UI (this will be implemented)
      expect(find.byType(PlayerGridWidget), findsOneWidget);
    });

    testWidgets('should handle card selection when in teleport mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
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

      // Start teleport selection
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PlayerGridWithSelection)),
      );
      container.read(cardSelectionProvider.notifier).startTeleportSelection();
      await tester.pump();

      // Tap on a card position - should select it
      await tester.tap(find.byType(PlayerGridWidget));
      await tester.pump();

      // Verify selection state
      final selectionState = container.read(cardSelectionProvider);
      expect(selectionState.isSelecting, isTrue);
    });

    testWidgets('should show visual feedback for selected cards', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
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

      // Should pass selectedPositions to PlayerGridWidget
      final playerGridWidget = tester.widget<PlayerGridWidget>(
        find.byType(PlayerGridWidget),
      );
      expect(playerGridWidget.selectedPositions.contains((0, 0)), isTrue);
    });

    testWidgets(
      'should handle normal card interaction when not in selection mode',
      (tester) async {
        var onCardTapCalled = false;
        var tappedRow = -1;
        var tappedCol = -1;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: PlayerGridWithSelection(
                    grid: grid,
                    isCurrentPlayer: true,
                    canInteract: true,
                    onCardTap: (row, col) {
                      onCardTapCalled = true;
                      tappedRow = row;
                      tappedCol = col;
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        // Import CardWidget if not already imported
        // Tap on the first card without being in selection mode
        // Find the first card widget within the grid
        final cardFinder = find
            .byWidgetPredicate(
              (widget) => widget.runtimeType.toString() == 'CardWidget',
            )
            .first;
        await tester.tap(cardFinder);
        await tester.pump();

        // Should call normal onCardTap
        expect(onCardTapCalled, isTrue);
        expect(tappedRow, greaterThanOrEqualTo(0));
        expect(tappedCol, greaterThanOrEqualTo(0));
      },
    );

    testWidgets('should show selection instructions when in teleport mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
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

      // Should show instructions
      expect(
        find.text('Sélectionnez la première carte à échanger'),
        findsOneWidget,
      );
    });

    testWidgets('should show cancel button when in selection mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
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

      // Should show cancel button
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Annuler'), findsOneWidget);
    });

    testWidgets('should show confirm button when selection is complete', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
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

      // Start selection and select two cards
      final notifier = container.read(cardSelectionProvider.notifier);
      notifier.startTeleportSelection();
      notifier.selectCard(0, 0);
      notifier.selectCard(0, 1);
      await tester.pump();

      // Should show confirm button
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Confirmer'), findsOneWidget);
    });

    testWidgets('should call onTeleportComplete when confirming selection', (
      tester,
    ) async {
      Map<String, dynamic>? receivedTargetData;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
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

      // Start selection and select two cards
      final notifier = container.read(cardSelectionProvider.notifier);
      notifier.startTeleportSelection();
      notifier.selectCard(0, 0);
      notifier.selectCard(1, 2);
      await tester.pump();

      // Scroll to make confirm button visible and tap it
      await tester.ensureVisible(find.byIcon(Icons.check));
      await tester.tap(find.byIcon(Icons.check));
      await tester.pump();

      // Should call onTeleportComplete with correct data
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
              body: SingleChildScrollView(
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
      await tester.ensureVisible(find.byIcon(Icons.close));
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      // Selection should be cancelled
      final selectionState = container.read(cardSelectionProvider);
      expect(selectionState.isSelecting, isFalse);
      expect(selectionState.firstSelection, isNull);
    });

    testWidgets('should highlight selected positions correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
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

      // Start selection and select two cards
      final notifier = container.read(cardSelectionProvider.notifier);
      notifier.startTeleportSelection();
      notifier.selectCard(0, 1);
      notifier.selectCard(2, 3);
      await tester.pump();

      // Should pass correct selectedPositions to PlayerGridWidget
      final playerGridWidget = tester.widget<PlayerGridWidget>(
        find.byType(PlayerGridWidget),
      );
      expect(playerGridWidget.selectedPositions.contains((0, 1)), isTrue);
      expect(playerGridWidget.selectedPositions.contains((2, 3)), isTrue);
      expect(playerGridWidget.selectedPositions.length, equals(2));
    });
  });
}
