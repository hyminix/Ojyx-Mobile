import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider.dart';

void main() {
  group('CardSelectionProvider Migration Test', () {
    // These tests ensure the provider behavior remains the same after migration
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should maintain initial state after migration', () {
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
      
      notifier.selectCard(0, 0);
      state = container.read(cardSelectionProvider);
      expect(state.firstSelection?.row, 0);
      expect(state.firstSelection?.col, 0);
      
      notifier.selectCard(1, 1);
      state = container.read(cardSelectionProvider);
      expect(state.isSelectionComplete, true);
      
      final result = notifier.completeSelection();
      expect(result, isNotNull);
      expect(result!['position1'], {'row': 0, 'col': 0});
      expect(result['position2'], {'row': 1, 'col': 1});
    });

    test('should maintain multi-selection behavior', () {
      final notifier = container.read(cardSelectionProvider.notifier);
      
      notifier.startPeekSelection(maxCards: 3);
      notifier.selectCard(0, 0);
      notifier.selectCard(0, 1);
      notifier.selectCard(0, 2);
      
      final state = container.read(cardSelectionProvider);
      expect(state.selections.length, 3);
      expect(state.isSelectionComplete, true);
    });

    test('should maintain cancel behavior', () {
      final notifier = container.read(cardSelectionProvider.notifier);
      
      notifier.startSwapSelection();
      notifier.selectCard(0, 0);
      notifier.cancelSelection();
      
      final state = container.read(cardSelectionProvider);
      expect(state.isSelecting, false);
      expect(state.firstSelection, null);
    });
  });
}