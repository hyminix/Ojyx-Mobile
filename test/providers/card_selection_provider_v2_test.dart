import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider_v2.dart';

void main() {
  group('CardSelectionProvider V2 (Modern Syntax)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should have same initial state as legacy version', () {
      final state = container.read(cardSelectionProvider);
      expect(state.isSelecting, false);
      expect(state.selectionType, null);
      expect(state.firstSelection, null);
      expect(state.secondSelection, null);
      expect(state.selections, isEmpty);
    });

    test('should maintain teleport selection behavior', () {
      final notifier = container.read(cardSelectionProvider.notifier);

      notifier.startTeleportSelection();
      var state = container.read(cardSelectionProvider);
      expect(state.isSelecting, true);
      expect(state.selectionType, CardSelectionType.teleport);
      expect(state.maxSelections, 2);

      notifier.selectCard(0, 0);
      state = container.read(cardSelectionProvider);
      expect(state.firstSelection?.row, 0);
      expect(state.firstSelection?.col, 0);
      expect(state.isSelectionComplete, false);

      notifier.selectCard(1, 1);
      state = container.read(cardSelectionProvider);
      expect(state.secondSelection?.row, 1);
      expect(state.secondSelection?.col, 1);
      expect(state.isSelectionComplete, true);

      final result = notifier.completeSelection();
      expect(result, isNotNull);
      expect(result!['position1'], {'row': 0, 'col': 0});
      expect(result['position2'], {'row': 1, 'col': 1});

      // Should reset after completion
      state = container.read(cardSelectionProvider);
      expect(state.isSelecting, false);
    });

    test('should maintain multi-selection behavior for peek', () {
      final notifier = container.read(cardSelectionProvider.notifier);

      notifier.startPeekSelection(maxCards: 3);

      // Select 3 cards
      notifier.selectCard(0, 0);
      notifier.selectCard(0, 1);
      notifier.selectCard(0, 2);

      var state = container.read(cardSelectionProvider);
      expect(state.selections.length, 3);
      expect(state.isSelectionComplete, true);

      // Select 4th card - should replace oldest
      notifier.selectCard(1, 0);
      state = container.read(cardSelectionProvider);
      expect(state.selections.length, 3);
      expect(
        state.selections.any((s) => s.equals(0, 0)),
        false,
      ); // First removed
      expect(state.selections.any((s) => s.equals(1, 0)), true); // New added
    });

    test('should toggle selection in multi-select mode', () {
      final notifier = container.read(cardSelectionProvider.notifier);

      notifier.startPeekSelection(maxCards: 3);

      // Select card
      notifier.selectCard(0, 0);
      expect(container.read(cardSelectionProvider).selections.length, 1);

      // Click same card to deselect
      notifier.selectCard(0, 0);
      expect(container.read(cardSelectionProvider).selections.length, 0);
    });

    test('should handle single selection modes', () {
      final notifier = container.read(cardSelectionProvider.notifier);

      // Test bomb selection
      notifier.startSingleSelection(CardSelectionType.bomb);
      notifier.selectCard(2, 2);

      var state = container.read(cardSelectionProvider);
      expect(state.firstSelection?.row, 2);
      expect(state.firstSelection?.col, 2);
      expect(state.isSelectionComplete, true);

      // Toggle selection
      notifier.selectCard(2, 2);
      state = container.read(cardSelectionProvider);
      expect(state.firstSelection, null);
    });

    test('should handle steal selection (opponent + card)', () {
      final notifier = container.read(cardSelectionProvider.notifier);

      notifier.startStealSelection();

      var state = container.read(cardSelectionProvider);
      expect(state.requiresOpponent, true);
      expect(state.isSelectionComplete, false);

      // Select opponent first
      notifier.selectOpponent('player3');
      state = container.read(cardSelectionProvider);
      expect(state.selectedOpponentId, 'player3');
      expect(state.isSelectionComplete, false);

      // Then select card
      notifier.selectCard(0, 1);
      state = container.read(cardSelectionProvider);
      expect(state.isSelectionComplete, true);

      final result = notifier.completeSelection();
      expect(result, isNotNull);
      expect(result!['opponentId'], 'player3');
      expect(result['position'], {'row': 0, 'col': 1});
    });

    test('should handle cancel selection', () {
      final notifier = container.read(cardSelectionProvider.notifier);

      notifier.startSwapSelection();
      notifier.selectCard(0, 0);
      notifier.selectCard(1, 1);

      notifier.cancelSelection();

      final state = container.read(cardSelectionProvider);
      expect(state.isSelecting, false);
      expect(state.selectionType, null);
      expect(state.firstSelection, null);
      expect(state.secondSelection, null);
    });

    test('position check methods should work correctly', () {
      final notifier = container.read(cardSelectionProvider.notifier);

      notifier.startSwapSelection();
      notifier.selectCard(0, 0);
      notifier.selectCard(1, 1);

      expect(notifier.isFirstSelection(0, 0), true);
      expect(notifier.isSecondSelection(1, 1), true);
      expect(notifier.isPositionSelected(0, 0), true);
      expect(notifier.isPositionSelected(1, 1), true);
      expect(notifier.isPositionSelected(2, 2), false);
    });

    test('auto-generated provider should be available', () {
      // This tests that the code generation worked correctly
      final provider = cardSelectionProvider;
      expect(provider, isNotNull);
      expect(
        provider
            is AutoDisposeNotifierProvider<CardSelection, CardSelectionState>,
        true,
      );
    });
  });
}
