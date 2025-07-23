import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider.dart';

void main() {
  group('CardSelectionProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Initial State', () {
      test('should have initial state with no selections', () {
        // Act
        final state = container.read(cardSelectionProvider);

        // Assert
        expect(state.isSelecting, isFalse);
        expect(state.firstSelection, isNull);
        expect(state.secondSelection, isNull);
        expect(state.selectionType, isNull);
      });

      test('should have helper getters returning correct values', () {
        // Act
        final state = container.read(cardSelectionProvider);

        // Assert
        expect(state.hasFirstSelection, isFalse);
        expect(state.hasSecondSelection, isFalse);
        expect(state.isSelectionComplete, isFalse);
        expect(state.canCompleteSelection, isFalse);
      });
    });

    group('Start Selection', () {
      test('should start teleportation selection correctly', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);

        // Act
        notifier.startTeleportSelection();

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, isTrue);
        expect(state.selectionType, equals(CardSelectionType.teleport));
        expect(state.firstSelection, isNull);
        expect(state.secondSelection, isNull);
      });

      test('should start swap selection correctly', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);

        // Act
        notifier.startSwapSelection();

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, isTrue);
        expect(state.selectionType, equals(CardSelectionType.swap));
        expect(state.firstSelection, isNull);
        expect(state.secondSelection, isNull);
      });

      test('should start peek selection correctly', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);

        // Act
        notifier.startPeekSelection(maxCards: 3);

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, isTrue);
        expect(state.selectionType, equals(CardSelectionType.peek));
        expect(state.maxSelections, equals(3));
        expect(state.selections.isEmpty, isTrue);
      });

      test('should start single card selection correctly', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);

        // Act
        notifier.startSingleSelection(CardSelectionType.bomb);

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, isTrue);
        expect(state.selectionType, equals(CardSelectionType.bomb));
        expect(state.maxSelections, equals(1));
        expect(state.selections.isEmpty, isTrue);
      });

      test('should start opponent selection correctly', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);

        // Act
        notifier.startOpponentSelection();

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, isTrue);
        expect(state.selectionType, equals(CardSelectionType.selectOpponent));
        expect(state.selectedOpponentId, isNull);
      });

      test('should reset previous selections when starting new selection', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();
        notifier.selectCard(0, 0);
        notifier.selectCard(0, 1);

        // Act
        notifier.startSwapSelection();

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, isTrue);
        expect(state.selectionType, equals(CardSelectionType.swap));
        expect(state.firstSelection, isNull);
        expect(state.secondSelection, isNull);
      });
    });

    group('Card Selection', () {
      test('should select first card correctly', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();

        // Act
        notifier.selectCard(0, 1);

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.hasFirstSelection, isTrue);
        expect(state.hasSecondSelection, isFalse);
        expect(state.firstSelection?.row, equals(0));
        expect(state.firstSelection?.col, equals(1));
        expect(state.secondSelection, isNull);
      });

      test('should handle multiple card selection for peek', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startPeekSelection(maxCards: 3);

        // Act
        notifier.selectCard(0, 0);
        notifier.selectCard(0, 1);
        notifier.selectCard(0, 2);

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.selections.length, equals(3));
        expect(state.isSelectionComplete, isTrue);
        expect(state.canCompleteSelection, isTrue);
      });

      test('should not exceed max selections for peek', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startPeekSelection(maxCards: 2);

        // Act
        notifier.selectCard(0, 0);
        notifier.selectCard(0, 1);
        notifier.selectCard(0, 2); // This should replace the first

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.selections.length, equals(2));
        expect(state.selections.any((s) => s.row == 0 && s.col == 0), isFalse);
        expect(state.selections.any((s) => s.row == 0 && s.col == 1), isTrue);
        expect(state.selections.any((s) => s.row == 0 && s.col == 2), isTrue);
      });

      test('should toggle selection for multi-select modes', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startPeekSelection(maxCards: 3);

        // Act
        notifier.selectCard(0, 0);
        notifier.selectCard(0, 0); // Toggle off

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.selections.isEmpty, isTrue);
      });

      test('should select second card correctly', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1);

        // Act
        notifier.selectCard(1, 2);

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.hasFirstSelection, isTrue);
        expect(state.hasSecondSelection, isTrue);
        expect(state.isSelectionComplete, isTrue);
        expect(state.canCompleteSelection, isTrue);
        expect(state.secondSelection?.row, equals(1));
        expect(state.secondSelection?.col, equals(2));
      });

      test('should replace first selection if selecting third card', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1);
        notifier.selectCard(1, 2);

        // Act
        notifier.selectCard(2, 3);

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.hasFirstSelection, isTrue);
        expect(state.hasSecondSelection, isFalse);
        expect(state.firstSelection?.row, equals(2));
        expect(state.firstSelection?.col, equals(3));
        expect(state.secondSelection, isNull);
      });

      test('should deselect card if selecting same position twice', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1);

        // Act
        notifier.selectCard(0, 1); // Same position

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.hasFirstSelection, isFalse);
        expect(state.firstSelection, isNull);
      });

      test('should deselect second card if selecting same position', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1);
        notifier.selectCard(1, 2);

        // Act
        notifier.selectCard(1, 2); // Same as second selection

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.hasFirstSelection, isTrue);
        expect(state.hasSecondSelection, isFalse);
        expect(state.firstSelection?.row, equals(0));
        expect(state.firstSelection?.col, equals(1));
        expect(state.secondSelection, isNull);
      });

      test('should not allow selection when not in selection mode', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);

        // Act
        notifier.selectCard(0, 1);

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.hasFirstSelection, isFalse);
        expect(state.firstSelection, isNull);
      });
    });

    group('Card Position Queries', () {
      test('should identify selected positions correctly', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1);
        notifier.selectCard(1, 2);

        // Act & Assert
        expect(container.read(cardSelectionProvider.notifier).isPositionSelected(0, 1), isTrue);
        expect(container.read(cardSelectionProvider.notifier).isPositionSelected(1, 2), isTrue);
        expect(container.read(cardSelectionProvider.notifier).isPositionSelected(0, 0), isFalse);
        expect(container.read(cardSelectionProvider.notifier).isPositionSelected(2, 3), isFalse);
      });

      test('should identify first selection position', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1);
        notifier.selectCard(1, 2);

        // Act & Assert
        expect(container.read(cardSelectionProvider.notifier).isFirstSelection(0, 1), isTrue);
        expect(container.read(cardSelectionProvider.notifier).isFirstSelection(1, 2), isFalse);
        expect(container.read(cardSelectionProvider.notifier).isFirstSelection(0, 0), isFalse);
      });

      test('should identify second selection position', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1);
        notifier.selectCard(1, 2);

        // Act & Assert
        expect(container.read(cardSelectionProvider.notifier).isSecondSelection(1, 2), isTrue);
        expect(container.read(cardSelectionProvider.notifier).isSecondSelection(0, 1), isFalse);
        expect(container.read(cardSelectionProvider.notifier).isSecondSelection(0, 0), isFalse);
      });
    });

    group('Cancel Selection', () {
      test('should cancel selection and reset state', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1);
        notifier.selectCard(1, 2);

        // Act
        notifier.cancelSelection();

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, isFalse);
        expect(state.selectionType, isNull);
        expect(state.firstSelection, isNull);
        expect(state.secondSelection, isNull);
        expect(state.hasFirstSelection, isFalse);
        expect(state.hasSecondSelection, isFalse);
        expect(state.isSelectionComplete, isFalse);
      });

      test('should be safe to cancel when not selecting', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);

        // Act & Assert - Should not throw
        expect(() => notifier.cancelSelection(), returnsNormally);
        
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, isFalse);
      });
    });

    group('Opponent Selection', () {
      test('should select opponent correctly', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startOpponentSelection();

        // Act
        notifier.selectOpponent('player-2');

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.selectedOpponentId, equals('player-2'));
        expect(state.canCompleteSelection, isTrue);
      });

      test('should handle two-phase selection (opponent then card)', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startStealSelection(); // Requires opponent + card

        // Act - Phase 1: Select opponent
        notifier.selectOpponent('player-2');
        var state = container.read(cardSelectionProvider);
        expect(state.selectedOpponentId, equals('player-2'));
        expect(state.canCompleteSelection, isFalse); // Need card too

        // Act - Phase 2: Select card
        notifier.selectCard(1, 2);
        state = container.read(cardSelectionProvider);
        expect(state.hasFirstSelection, isTrue);
        expect(state.canCompleteSelection, isTrue);
      });
    });

    group('Complete Selection', () {
      test('should complete selection and return target data', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1);
        notifier.selectCard(2, 3);

        // Act
        final targetData = notifier.completeSelection();

        // Assert
        expect(targetData, isNotNull);
        expect(targetData!['position1']['row'], equals(0));
        expect(targetData['position1']['col'], equals(1));
        expect(targetData['position2']['row'], equals(2));
        expect(targetData['position2']['col'], equals(3));

        // State should be reset
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, isFalse);
        expect(state.firstSelection, isNull);
        expect(state.secondSelection, isNull);
      });

      test('should complete multi-selection and return all positions', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startPeekSelection(maxCards: 3);
        notifier.selectCard(0, 0);
        notifier.selectCard(1, 1);
        notifier.selectCard(2, 2);

        // Act
        final targetData = notifier.completeSelection();

        // Assert
        expect(targetData, isNotNull);
        expect(targetData!['positions'], isA<List>());
        expect(targetData['positions'].length, equals(3));
        expect(targetData['positions'][0]['row'], equals(0));
        expect(targetData['positions'][0]['col'], equals(0));
      });

      test('should complete steal selection with opponent and card', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startStealSelection();
        notifier.selectOpponent('player-2');
        notifier.selectCard(1, 2);

        // Act
        final targetData = notifier.completeSelection();

        // Assert
        expect(targetData, isNotNull);
        expect(targetData!['opponentId'], equals('player-2'));
        expect(targetData['position']['row'], equals(1));
        expect(targetData['position']['col'], equals(2));
      });

      test('should return null if selection is incomplete', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1); // Only first selection

        // Act
        final targetData = notifier.completeSelection();

        // Assert
        expect(targetData, isNull);
        
        // State should remain unchanged
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, isTrue);
        expect(state.hasFirstSelection, isTrue);
        expect(state.hasSecondSelection, isFalse);
      });

      test('should return null if not in selection mode', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);

        // Act
        final targetData = notifier.completeSelection();

        // Assert
        expect(targetData, isNull);
      });
    });

    group('State Listeners', () {
      test('should notify listeners when state changes', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        var callCount = 0;
        final subscription = container.listen(cardSelectionProvider, (previous, next) {
          callCount++;
        });

        // Act
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1);
        notifier.selectCard(1, 2);
        notifier.cancelSelection();

        // Assert
        expect(callCount, equals(4)); // Start + First + Second + Cancel

        // Cleanup
        subscription.close();
      });

      test('should provide correct helper values during selection', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        final states = <CardSelectionState>[];
        final subscription = container.listen(cardSelectionProvider, (previous, next) {
          states.add(next);
        });

        // Act
        notifier.startTeleportSelection();
        notifier.selectCard(0, 1);
        notifier.selectCard(1, 2);

        // Assert
        expect(states.length, equals(3));
        
        // After start
        expect(states[0].isSelecting, isTrue);
        expect(states[0].canCompleteSelection, isFalse);
        
        // After first selection
        expect(states[1].hasFirstSelection, isTrue);
        expect(states[1].canCompleteSelection, isFalse);
        
        // After second selection
        expect(states[2].isSelectionComplete, isTrue);
        expect(states[2].canCompleteSelection, isTrue);

        // Cleanup
        subscription.close();
      });
    });

    group('Edge Cases', () {
      test('should handle rapid selection changes', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();

        // Act - Rapid selections
        notifier.selectCard(0, 0); // First selection
        notifier.selectCard(0, 1); // Second selection
        notifier.selectCard(0, 2); // Replaces first, second becomes null
        notifier.selectCard(1, 0); // Becomes second selection
        notifier.selectCard(1, 1); // Replaces first, second becomes null

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.hasFirstSelection, isTrue);
        expect(state.hasSecondSelection, isFalse); // Second should be null after last replacement
        expect(state.firstSelection?.row, equals(1));
        expect(state.firstSelection?.col, equals(1));
        expect(state.secondSelection, isNull);
      });

      test('should handle boundary positions correctly', () {
        // Arrange
        final notifier = container.read(cardSelectionProvider.notifier);
        notifier.startTeleportSelection();

        // Act - Select corner positions
        notifier.selectCard(0, 0); // Top-left
        notifier.selectCard(2, 3); // Bottom-right (assuming 3x4 grid)

        // Assert
        final state = container.read(cardSelectionProvider);
        expect(state.isSelectionComplete, isTrue);
        expect(state.firstSelection?.row, equals(0));
        expect(state.firstSelection?.col, equals(0));
        expect(state.secondSelection?.row, equals(2));
        expect(state.secondSelection?.col, equals(3));
      });
    });
  });
}