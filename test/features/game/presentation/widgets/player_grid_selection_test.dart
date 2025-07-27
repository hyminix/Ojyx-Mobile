import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_with_selection.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider_v2.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import '../../../../helpers/riverpod_test_helpers.dart';

// Test implementation for CardSelection
class TestCardSelection extends CardSelection {
  final CardSelectionState initialState;

  TestCardSelection(this.initialState);

  @override
  CardSelectionState build() => initialState;
}

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
      // Utilisation du helper pour pump l'app avec Riverpod
      await tester.pumpRiverpodApp(
        child: Scaffold(
          body: SingleChildScrollView(
            child: PlayerGridWithSelection(
              grid: grid,
              isCurrentPlayer: true,
              canInteract: true,
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

      // Start teleport selection
      container.read(cardSelectionProvider.notifier).startTeleportSelection();
      await tester.pump();

      // Should show selection mode UI
      expect(find.byType(PlayerGridWidget), findsOneWidget);
    });

    testWidgets('should handle card selection when in teleport mode', (
      tester,
    ) async {
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

      // Start teleport selection
      container.read(cardSelectionProvider.notifier).startTeleportSelection();
      await tester.pump();

      // Tap on a card position - should select it
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();

      // Vérifier l'état de sélection
      final selectionState = container.read(cardSelectionProvider);
      expect(selectionState.isSelecting, isTrue);
    });

    testWidgets('should handle provider overrides correctly', (tester) async {
      // State initial pour le test
      const testState = CardSelectionState(
        isSelecting: true,
        selectionType: CardSelectionType.teleport,
      );

      bool stateVerified = false;

      await tester.pumpRiverpodApp(
        child: Consumer(
          builder: (context, ref, child) {
            // Vérifier l'état dans le builder
            final selectionState = ref.watch(cardSelectionProvider);
            if (!stateVerified) {
              stateVerified = true;
              expect(selectionState.isSelecting, isTrue);
              expect(selectionState.selectionType, CardSelectionType.teleport);
            }

            return Scaffold(
              body: SingleChildScrollView(
                child: PlayerGridWithSelection(
                  grid: grid,
                  isCurrentPlayer: true,
                  canInteract: true,
                ),
              ),
            );
          },
        ),
        overrides: [
          cardSelectionProvider.overrideWith(
            () => TestCardSelection(testState),
          ),
        ],
      );

      // Le widget devrait utiliser notre override
      expect(find.byType(PlayerGridWidget), findsOneWidget);
      expect(stateVerified, isTrue);
    });
  });
}
