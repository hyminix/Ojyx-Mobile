import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/card_position.dart';

part 'card_selection_provider.freezed.dart';

enum CardSelectionType {
  teleport,
  swap,
}

@freezed
class CardSelectionState with _$CardSelectionState {
  const factory CardSelectionState({
    @Default(false) bool isSelecting,
    CardSelectionType? selectionType,
    CardPosition? firstSelection,
    CardPosition? secondSelection,
  }) = _CardSelectionState;

  const CardSelectionState._();

  /// Check if first selection is made
  bool get hasFirstSelection => firstSelection != null;

  /// Check if second selection is made
  bool get hasSecondSelection => secondSelection != null;

  /// Check if selection is complete (both cards selected)
  bool get isSelectionComplete => hasFirstSelection && hasSecondSelection;

  /// Check if selection can be completed
  bool get canCompleteSelection => isSelectionComplete && isSelecting;
}

class CardSelectionNotifier extends StateNotifier<CardSelectionState> {
  CardSelectionNotifier() : super(const CardSelectionState());

  /// Start teleportation selection mode
  void startTeleportSelection() {
    state = const CardSelectionState(
      isSelecting: true,
      selectionType: CardSelectionType.teleport,
    );
  }

  /// Start swap selection mode
  void startSwapSelection() {
    state = const CardSelectionState(
      isSelecting: true,
      selectionType: CardSelectionType.swap,
    );
  }

  /// Select a card at the given position
  void selectCard(int row, int col) {
    if (!state.isSelecting) return;

    final position = CardPosition(row: row, col: col);

    // If clicking on first selection, deselect it
    if (state.firstSelection?.equals(row, col) == true) {
      state = state.copyWith(firstSelection: null);
      return;
    }

    // If clicking on second selection, deselect it
    if (state.secondSelection?.equals(row, col) == true) {
      state = state.copyWith(secondSelection: null);
      return;
    }

    // If no first selection, set as first
    if (state.firstSelection == null) {
      state = state.copyWith(firstSelection: position);
      return;
    }

    // If no second selection, set as second
    if (state.secondSelection == null) {
      state = state.copyWith(secondSelection: position);
      return;
    }

    // If both selections exist, replace first with new selection
    state = state.copyWith(
      firstSelection: position,
      secondSelection: null,
    );
  }

  /// Check if a position is currently selected
  bool isPositionSelected(int row, int col) {
    return isFirstSelection(row, col) || isSecondSelection(row, col);
  }

  /// Check if a position is the first selection
  bool isFirstSelection(int row, int col) {
    return state.firstSelection?.equals(row, col) == true;
  }

  /// Check if a position is the second selection
  bool isSecondSelection(int row, int col) {
    return state.secondSelection?.equals(row, col) == true;
  }

  /// Cancel current selection
  void cancelSelection() {
    state = const CardSelectionState();
  }

  /// Complete selection and return target data
  Map<String, dynamic>? completeSelection() {
    if (!state.canCompleteSelection) return null;

    final targetData = {
      'position1': state.firstSelection!.toTargetData(),
      'position2': state.secondSelection!.toTargetData(),
    };

    // Reset state
    state = const CardSelectionState();

    return targetData;
  }
}

final cardSelectionProvider =
    StateNotifierProvider<CardSelectionNotifier, CardSelectionState>(
  (ref) => CardSelectionNotifier(),
);