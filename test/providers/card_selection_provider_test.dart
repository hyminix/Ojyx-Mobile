import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider.dart';
import 'package:ojyx/features/game/domain/entities/card_position.dart';

void main() {
  group('CardSelectionProvider', () {
    late ProviderContainer container;
    late CardSelectionNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(cardSelectionProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be not selecting', () {
      final state = container.read(cardSelectionProvider);
      expect(state.isSelecting, false);
      expect(state.selectionType, null);
      expect(state.firstSelection, null);
      expect(state.secondSelection, null);
      expect(state.selections, isEmpty);
    });

    group('Teleport Selection', () {
      test('should start teleport selection mode', () {
        notifier.startTeleportSelection();
        
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, true);
        expect(state.selectionType, CardSelectionType.teleport);
        expect(state.maxSelections, 2);
      });

      test('should select two cards for teleport', () {
        notifier.startTeleportSelection();
        
        // Select first card
        notifier.selectCard(0, 0);
        var state = container.read(cardSelectionProvider);
        expect(state.firstSelection, isNotNull);
        expect(state.firstSelection!.row, 0);
        expect(state.firstSelection!.col, 0);
        expect(state.isSelectionComplete, false);
        
        // Select second card
        notifier.selectCard(1, 1);
        state = container.read(cardSelectionProvider);
        expect(state.secondSelection, isNotNull);
        expect(state.secondSelection!.row, 1);
        expect(state.secondSelection!.col, 1);
        expect(state.isSelectionComplete, true);
      });

      test('should toggle selection when clicking same card', () {
        notifier.startTeleportSelection();
        
        // Select card
        notifier.selectCard(0, 0);
        expect(container.read(cardSelectionProvider).firstSelection, isNotNull);
        
        // Click same card to deselect
        notifier.selectCard(0, 0);
        expect(container.read(cardSelectionProvider).firstSelection, null);
      });
    });

    group('Peek Selection', () {
      test('should start peek selection with max cards', () {
        notifier.startPeekSelection(maxCards: 3);
        
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, true);
        expect(state.selectionType, CardSelectionType.peek);
        expect(state.maxSelections, 3);
      });

      test('should allow multiple card selections up to max', () {
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
        expect(state.selections.any((s) => s.equals(0, 0)), false); // First removed
        expect(state.selections.any((s) => s.equals(1, 0)), true); // New added
      });

      test('should toggle selection when clicking selected card', () {
        notifier.startPeekSelection(maxCards: 3);
        
        // Select card
        notifier.selectCard(0, 0);
        expect(container.read(cardSelectionProvider).selections.length, 1);
        
        // Click same card to deselect
        notifier.selectCard(0, 0);
        expect(container.read(cardSelectionProvider).selections.length, 0);
      });
    });

    group('Single Selection Modes', () {
      test('should handle bomb selection', () {
        notifier.startSingleSelection(CardSelectionType.bomb);
        
        final state = container.read(cardSelectionProvider);
        expect(state.selectionType, CardSelectionType.bomb);
        expect(state.maxSelections, 1);
        
        // Select card
        notifier.selectCard(2, 2);
        final selectedState = container.read(cardSelectionProvider);
        expect(selectedState.firstSelection?.row, 2);
        expect(selectedState.firstSelection?.col, 2);
        expect(selectedState.isSelectionComplete, true);
      });

      test('should handle mirror selection', () {
        notifier.startSingleSelection(CardSelectionType.mirror);
        
        notifier.selectCard(1, 2);
        final state = container.read(cardSelectionProvider);
        expect(state.isSelectionComplete, true);
      });
    });

    group('Opponent Selection', () {
      test('should handle opponent selection', () {
        notifier.startOpponentSelection();
        
        expect(container.read(cardSelectionProvider).isSelectionComplete, false);
        
        notifier.selectOpponent('player2');
        final state = container.read(cardSelectionProvider);
        expect(state.selectedOpponentId, 'player2');
        expect(state.isSelectionComplete, true);
      });
    });

    group('Steal Selection', () {
      test('should require opponent then card for steal', () {
        notifier.startStealSelection();
        
        final initialState = container.read(cardSelectionProvider);
        expect(initialState.requiresOpponent, true);
        expect(initialState.isSelectionComplete, false);
        
        // Select opponent first
        notifier.selectOpponent('player3');
        expect(container.read(cardSelectionProvider).isSelectionComplete, false);
        
        // Then select card
        notifier.selectCard(0, 1);
        final finalState = container.read(cardSelectionProvider);
        expect(finalState.isSelectionComplete, true);
        expect(finalState.selectedOpponentId, 'player3');
        expect(finalState.firstSelection?.row, 0);
        expect(finalState.firstSelection?.col, 1);
      });
    });

    group('Complete Selection', () {
      test('should complete teleport selection and return data', () {
        notifier.startTeleportSelection();
        notifier.selectCard(0, 0);
        notifier.selectCard(1, 1);
        
        final result = notifier.completeSelection();
        expect(result, isNotNull);
        expect(result!['position1'], {'row': 0, 'col': 0});
        expect(result['position2'], {'row': 1, 'col': 1});
        
        // Should reset state
        expect(container.read(cardSelectionProvider).isSelecting, false);
      });

      test('should complete peek selection and return positions', () {
        notifier.startPeekSelection(maxCards: 2);
        notifier.selectCard(0, 0);
        notifier.selectCard(0, 1);
        
        final result = notifier.completeSelection();
        expect(result, isNotNull);
        expect(result!['positions'], [
          {'row': 0, 'col': 0},
          {'row': 0, 'col': 1},
        ]);
      });

      test('should return null if selection not complete', () {
        notifier.startSwapSelection();
        notifier.selectCard(0, 0); // Only one selected
        
        final result = notifier.completeSelection();
        expect(result, null);
      });
    });

    group('Cancel Selection', () {
      test('should reset state when cancelled', () {
        notifier.startTeleportSelection();
        notifier.selectCard(0, 0);
        
        notifier.cancelSelection();
        
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, false);
        expect(state.selectionType, null);
        expect(state.firstSelection, null);
      });
    });

    group('Position Checks', () {
      test('should correctly identify selected positions', () {
        notifier.startSwapSelection();
        notifier.selectCard(0, 0);
        notifier.selectCard(1, 1);
        
        expect(notifier.isFirstSelection(0, 0), true);
        expect(notifier.isSecondSelection(1, 1), true);
        expect(notifier.isPositionSelected(0, 0), true);
        expect(notifier.isPositionSelected(1, 1), true);
        expect(notifier.isPositionSelected(2, 2), false);
      });
    });
  });
}