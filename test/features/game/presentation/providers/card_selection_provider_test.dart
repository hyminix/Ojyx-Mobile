import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider.dart';

void main() {
  group('CardSelectionProvider Strategic Game Behavior', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should enable complete strategic card action workflows for competitive gameplay', () {
      // Test behavior: comprehensive strategic action system for competitive card game
      final notifier = container.read(cardSelectionProvider.notifier);
      
      // Scenario 1: Strategic teleport for position optimization
      notifier.startTeleportSelection();
      var state = container.read(cardSelectionProvider);
      expect(state.isSelecting, isTrue, reason: 'Strategic action mode should be active');
      expect(state.selectionType, CardSelectionType.teleport, reason: 'Teleport strategy should be selected');
      
      notifier.selectCard(0, 1);
      notifier.selectCard(2, 3);
      final teleportData = notifier.completeSelection();
      expect(teleportData, isNotNull, reason: 'Strategic teleport should produce action data');
      expect(teleportData!['position1'], isNotNull, reason: 'Source position should be captured');
      expect(teleportData['position2'], isNotNull, reason: 'Target position should be captured');
      
      // Scenario 2: Intelligence gathering via peek operations
      notifier.startPeekSelection(maxCards: 3);
      notifier.selectCard(0, 0);
      notifier.selectCard(1, 1);
      notifier.selectCard(2, 2);
      state = container.read(cardSelectionProvider);
      expect(state.selections.length, 3, reason: 'Intelligence gathering should track all targets');
      
      final peekData = notifier.completeSelection();
      expect(peekData!['positions'], isA<List>(), reason: 'Intelligence operation should return all scouted positions');
      
      // Scenario 3: Competitive opponent targeting with dual-phase selection
      notifier.startStealSelection();
      notifier.selectOpponent('rival-player');
      notifier.selectCard(1, 2);
      state = container.read(cardSelectionProvider);
      expect(state.selectedOpponentId, 'rival-player', reason: 'Competitive target should be locked in');
      expect(state.isSelectionComplete, isTrue, reason: 'Dual-phase action should be ready for execution');
      
      final stealData = notifier.completeSelection();
      expect(stealData!['opponentId'], 'rival-player', reason: 'Target opponent should be preserved');
      expect(stealData['position'], isNotNull, reason: 'Strategic card position should be captured');
    });

    test('should support strategic action mode switching for tactical flexibility', () {
      // Test behavior: players can switch between different strategic actions dynamically
      final notifier = container.read(cardSelectionProvider.notifier);
      
      // Test strategic flexibility with action switching
      final actionScenarios = [
        (CardSelectionType.teleport, () => notifier.startTeleportSelection(), 'position optimization'),
        (CardSelectionType.swap, () => notifier.startSwapSelection(), 'tactical exchange'),
        (CardSelectionType.peek, () => notifier.startPeekSelection(maxCards: 2), 'intelligence gathering'),
        (CardSelectionType.bomb, () => notifier.startSingleSelection(CardSelectionType.bomb), 'destructive action'),
        (CardSelectionType.selectOpponent, () => notifier.startOpponentSelection(), 'competitive targeting'),
      ];
      
      for (final (expectedType, actionStarter, description) in actionScenarios) {
        actionStarter();
        final state = container.read(cardSelectionProvider);
        expect(state.isSelecting, isTrue, reason: 'Strategic $description mode should be active');
        expect(state.selectionType, expectedType, reason: '$description action should be properly configured');
        notifier.cancelSelection(); // Reset for next test
      }
      
      // Test strategic transition preserves game integrity
      notifier.startTeleportSelection();
      notifier.selectCard(0, 0);
      notifier.selectCard(0, 1);
      
      notifier.startSwapSelection(); // Switch strategy mid-action
      final finalState = container.read(cardSelectionProvider);
      expect(finalState.selectionType, CardSelectionType.swap, reason: 'New strategy should override previous');
      expect(finalState.firstSelection, isNull, reason: 'Previous selections should be cleared for clean transition');
      expect(finalState.secondSelection, isNull, reason: 'Strategic state should be reset for new action');
    });

    test('should enforce intelligent capacity management and strategic selection patterns', () {
      // Test behavior: intelligent selection system with capacity limits and strategic flexibility
      final notifier = container.read(cardSelectionProvider.notifier);
      
      // Test capacity-limited intelligence gathering
      notifier.startPeekSelection(maxCards: 2);
      notifier.selectCard(0, 0);
      notifier.selectCard(0, 1);
      notifier.selectCard(0, 2); // Should intelligently replace oldest
      
      var state = container.read(cardSelectionProvider);
      expect(state.selections.length, 2, reason: 'Intelligence capacity should be enforced');
      expect(state.selections.any((s) => s.row == 0 && s.col == 0), false, reason: 'Oldest intelligence should be rotated out');
      expect(state.selections.any((s) => s.row == 0 && s.col == 2), true, reason: 'New intelligence should be retained');
      
      // Test strategic toggle behavior for refined targeting
      notifier.selectCard(0, 2); // Toggle off most recent
      state = container.read(cardSelectionProvider);
      expect(state.selections.length, 1, reason: 'Strategic deselection should reduce capacity usage');
      
      // Test dual-selection strategic positioning 
      notifier.startTeleportSelection();
      notifier.selectCard(0, 1);
      notifier.selectCard(1, 2);
      state = container.read(cardSelectionProvider);
      expect(state.isSelectionComplete, true, reason: 'Dual-position strategy should be complete');
      
      // Test strategic position replacement for optimization
      notifier.selectCard(2, 3); // Should replace first position
      state = container.read(cardSelectionProvider);
      expect(state.firstSelection?.row, 2, reason: 'Strategic repositioning should update first target');
      expect(state.secondSelection, isNull, reason: 'Strategic cycle should clear second position for fresh selection');
      
      // Test defensive deselection patterns
      notifier.selectCard(2, 3); // Same position - should deselect
      state = container.read(cardSelectionProvider);
      expect(state.hasFirstSelection, false, reason: 'Strategic cancellation should clear position');
      
      // Test protection against invalid selection contexts
      notifier.cancelSelection();
      notifier.selectCard(0, 1); // No active selection mode
      state = container.read(cardSelectionProvider);
      expect(state.hasFirstSelection, false, reason: 'System should protect against invalid selection contexts');
    });

    test('should provide precise position tracking for strategic decision making', () {
      // Test behavior: position tracking system enables informed strategic decisions
      final notifier = container.read(cardSelectionProvider.notifier);
      notifier.startTeleportSelection();
      notifier.selectCard(0, 1);
      notifier.selectCard(1, 2);
      
      // Test strategic position awareness for UI feedback
      final positionChecks = [
        ((0, 1), true, 'primary strategic position'),
        ((1, 2), true, 'secondary strategic position'),
        ((0, 0), false, 'unselected position'),
        ((2, 3), false, 'alternative position'),
      ];
      
      for (final ((row, col), expectedSelected, description) in positionChecks) {
        final isSelected = notifier.isPositionSelected(row, col);
        expect(isSelected, expectedSelected, reason: 'Position tracking should accurately identify $description');
      }
      
      // Test specific role-based position identification
      expect(notifier.isFirstSelection(0, 1), true, reason: 'Primary strategic position should be correctly identified');
      expect(notifier.isSecondSelection(1, 2), true, reason: 'Secondary strategic position should be correctly identified');
      expect(notifier.isFirstSelection(1, 2), false, reason: 'Position role distinction should be maintained');
    });

    test('should enable strategic action cancellation for tactical flexibility', () {
      // Test behavior: strategic cancellation preserves game flow and provides tactical options
      final notifier = container.read(cardSelectionProvider.notifier);
      notifier.startTeleportSelection();
      notifier.selectCard(0, 1);
      notifier.selectCard(1, 2);

      // Player decides to abort strategic action
      notifier.cancelSelection();

      final state = container.read(cardSelectionProvider);
      expect(state.isSelecting, false, reason: 'Strategic mode should be deactivated');
      expect(state.selectionType, isNull, reason: 'Action type should be cleared');
      expect(state.firstSelection, isNull, reason: 'All strategic positions should be cleared');
      expect(state.secondSelection, isNull, reason: 'Complete selection state should be reset');
      
      // Test defensive programming - cancellation should be safe in any state
      expect(() => notifier.cancelSelection(), returnsNormally, reason: 'Repeated cancellation should be safe');
    });

    test('should deliver complete strategic data structures for game action execution', () {
      // Test behavior: comprehensive data generation for strategic action implementation
      final notifier = container.read(cardSelectionProvider.notifier);
      
      // Test multi-format data delivery for different strategic contexts
      final strategicScenarios = [
        // Teleport action data format
        () {
          notifier.startTeleportSelection();
          notifier.selectCard(0, 1);
          notifier.selectCard(2, 3);
          final data = notifier.completeSelection();
          expect(data!['position1']['row'], 0, reason: 'Source position should be accurately captured');
          expect(data['position2']['col'], 3, reason: 'Target position should be precisely recorded');
        },
        
        // Intelligence gathering data format
        () {
          notifier.startPeekSelection(maxCards: 3);
          notifier.selectCard(0, 0);
          notifier.selectCard(1, 1);
          notifier.selectCard(2, 2);
          final data = notifier.completeSelection();
          expect(data!['positions'], isA<List>(), reason: 'Intelligence data should be in list format');
          expect(data['positions'].length, 3, reason: 'All scouted positions should be included');
        },
        
        // Competitive targeting data format
        () {
          notifier.startStealSelection();
          notifier.selectOpponent('target-player');
          notifier.selectCard(1, 2);
          final data = notifier.completeSelection();
          expect(data!['opponentId'], 'target-player', reason: 'Target opponent should be preserved');
          expect(data['position']['row'], 1, reason: 'Strategic card position should be captured');
        },
      ];
      
      for (final scenario in strategicScenarios) {
        scenario();
      }
      
      // Test data protection - incomplete actions should not produce data
      notifier.startTeleportSelection();
      notifier.selectCard(0, 1); // Incomplete
      final incompleteData = notifier.completeSelection();
      expect(incompleteData, isNull, reason: 'Incomplete strategic actions should not produce execution data');
      
      // Test state management after data generation
      notifier.startTeleportSelection();
      notifier.selectCard(0, 1);
      notifier.selectCard(1, 2);
      notifier.completeSelection();
      
      final postExecutionState = container.read(cardSelectionProvider);
      expect(postExecutionState.isSelecting, false, reason: 'Strategic mode should reset after action execution');
    });
  });
}
