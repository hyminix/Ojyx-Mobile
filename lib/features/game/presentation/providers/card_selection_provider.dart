import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/card_position.dart';

part 'card_selection_provider.freezed.dart';

enum CardSelectionType {
  teleport,
  swap,
  peek,
  bomb,
  mirror,
  gift,
  selectOpponent,
  steal, // Two-phase: opponent then card
  scout,
}

@freezed
class CardSelectionState with _$CardSelectionState {
  const factory CardSelectionState({
    @Default(false) bool isSelecting,
    CardSelectionType? selectionType,
    CardPosition? firstSelection,
    CardPosition? secondSelection,
    @Default([]) List<CardPosition> selections, // For multi-select modes
    @Default(1) int maxSelections, // Max number of selections allowed
    String? selectedOpponentId, // For opponent selection
    @Default(false) bool requiresOpponent, // If true, need opponent before cards
  }) = _CardSelectionState;

  const CardSelectionState._();

  /// Check if first selection is made
  bool get hasFirstSelection => firstSelection != null;

  /// Check if second selection is made
  bool get hasSecondSelection => secondSelection != null;

  /// Check if selection is complete based on selection type
  bool get isSelectionComplete {
    if (!isSelecting) return false;
    
    switch (selectionType) {
      case CardSelectionType.teleport:
      case CardSelectionType.swap:
        return hasFirstSelection && hasSecondSelection;
      case CardSelectionType.peek:
      case CardSelectionType.scout:
        return selections.isNotEmpty; // At least one selection
      case CardSelectionType.bomb:
      case CardSelectionType.mirror:
      case CardSelectionType.gift:
        return hasFirstSelection;
      case CardSelectionType.selectOpponent:
        return selectedOpponentId != null;
      case CardSelectionType.steal:
        return selectedOpponentId != null && hasFirstSelection;
      case null:
        return false;
    }
  }

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
      selections: [],
      maxSelections: 2,
    );
  }

  /// Start swap selection mode
  void startSwapSelection() {
    state = const CardSelectionState(
      isSelecting: true,
      selectionType: CardSelectionType.swap,
      selections: [],
      maxSelections: 2,
    );
  }

  /// Start peek selection mode (select multiple cards to view)
  void startPeekSelection({required int maxCards}) {
    state = CardSelectionState(
      isSelecting: true,
      selectionType: CardSelectionType.peek,
      maxSelections: maxCards,
    );
  }

  /// Start single card selection mode
  void startSingleSelection(CardSelectionType type) {
    state = CardSelectionState(
      isSelecting: true,
      selectionType: type,
      maxSelections: 1,
    );
  }

  /// Start opponent selection mode
  void startOpponentSelection() {
    state = const CardSelectionState(
      isSelecting: true,
      selectionType: CardSelectionType.selectOpponent,
    );
  }

  /// Start steal selection mode (select opponent, then card)
  void startStealSelection() {
    state = const CardSelectionState(
      isSelecting: true,
      selectionType: CardSelectionType.steal,
      requiresOpponent: true,
    );
  }

  /// Select a card at the given position
  void selectCard(int row, int col) {
    if (!state.isSelecting) return;

    final position = CardPosition(row: row, col: col);

    // Handle multi-select modes (peek, scout)
    if (state.selectionType == CardSelectionType.peek ||
        state.selectionType == CardSelectionType.scout) {
      final currentSelections = List<CardPosition>.from(state.selections);
      
      // Toggle selection if already selected
      final existingIndex = currentSelections.indexWhere((s) => s.equals(row, col));
      if (existingIndex != -1) {
        currentSelections.removeAt(existingIndex);
        state = state.copyWith(selections: currentSelections);
        return;
      }
      
      // Add new selection if under max
      if (currentSelections.length < state.maxSelections) {
        currentSelections.add(position);
        state = state.copyWith(selections: currentSelections);
      } else {
        // Replace oldest selection
        currentSelections.removeAt(0);
        currentSelections.add(position);
        state = state.copyWith(selections: currentSelections);
      }
      return;
    }

    // Handle single selection modes
    if (state.selectionType == CardSelectionType.bomb ||
        state.selectionType == CardSelectionType.mirror ||
        state.selectionType == CardSelectionType.gift) {
      if (state.firstSelection?.equals(row, col) == true) {
        state = state.copyWith(firstSelection: null);
      } else {
        state = state.copyWith(firstSelection: position);
      }
      return;
    }

    // Handle two-card selection modes (teleport, swap)
    if (state.firstSelection?.equals(row, col) == true) {
      state = state.copyWith(firstSelection: null);
      return;
    }

    if (state.secondSelection?.equals(row, col) == true) {
      state = state.copyWith(secondSelection: null);
      return;
    }

    if (state.firstSelection == null) {
      state = state.copyWith(firstSelection: position);
      return;
    }

    if (state.secondSelection == null) {
      state = state.copyWith(secondSelection: position);
      return;
    }

    // Replace first with new selection
    state = state.copyWith(
      firstSelection: position,
      secondSelection: null,
    );
  }

  /// Select an opponent
  void selectOpponent(String opponentId) {
    if (!state.isSelecting) return;
    
    state = state.copyWith(selectedOpponentId: opponentId);
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

    Map<String, dynamic> targetData;
    
    switch (state.selectionType) {
      case CardSelectionType.teleport:
      case CardSelectionType.swap:
        targetData = {
          'position1': state.firstSelection!.toTargetData(),
          'position2': state.secondSelection!.toTargetData(),
        };
        break;
      case CardSelectionType.peek:
      case CardSelectionType.scout:
        targetData = {
          'positions': state.selections
              .map((pos) => pos.toTargetData())
              .toList(),
        };
        break;
      case CardSelectionType.bomb:
      case CardSelectionType.mirror:
      case CardSelectionType.gift:
        targetData = {
          'position': state.firstSelection!.toTargetData(),
        };
        break;
      case CardSelectionType.selectOpponent:
        targetData = {
          'opponentId': state.selectedOpponentId!,
        };
        break;
      case CardSelectionType.steal:
        targetData = {
          'opponentId': state.selectedOpponentId!,
          'position': state.firstSelection!.toTargetData(),
        };
        break;
      case null:
        return null;
    }

    // Reset state
    state = const CardSelectionState();

    return targetData;
  }
}

final cardSelectionProvider =
    StateNotifierProvider<CardSelectionNotifier, CardSelectionState>(
  (ref) => CardSelectionNotifier(),
);