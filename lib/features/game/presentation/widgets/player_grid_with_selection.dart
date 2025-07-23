import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/player_grid.dart';
import '../providers/card_selection_provider.dart';
import 'player_grid_widget.dart';

class PlayerGridWithSelection extends ConsumerWidget {
  final PlayerGrid grid;
  final bool isCurrentPlayer;
  final bool canInteract;
  final Function(int row, int col)? onCardTap;
  final Function(Map<String, dynamic> targetData)? onTeleportComplete;
  final Set<(int, int)> highlightedPositions;

  const PlayerGridWithSelection({
    super.key,
    required this.grid,
    required this.isCurrentPlayer,
    this.canInteract = false,
    this.onCardTap,
    this.onTeleportComplete,
    this.highlightedPositions = const {},
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(cardSelectionProvider);
    final selectionNotifier = ref.read(cardSelectionProvider.notifier);

    // Build selected positions set from selection state
    final selectedPositions = <(int, int)>{};
    if (selectionState.firstSelection != null) {
      selectedPositions.add((
        selectionState.firstSelection!.row,
        selectionState.firstSelection!.col,
      ));
    }
    if (selectionState.secondSelection != null) {
      selectedPositions.add((
        selectionState.secondSelection!.row,
        selectionState.secondSelection!.col,
      ));
    }

    if (!selectionState.isSelecting) {
      // When not selecting, just return the plain grid
      return PlayerGridWidget(
        grid: grid,
        isCurrentPlayer: isCurrentPlayer,
        canInteract: canInteract,
        highlightedPositions: highlightedPositions,
        selectedPositions: selectedPositions,
        onCardTap: onCardTap,
      );
    }

    // When selecting, wrap in a scrollable column
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selection instructions
          _buildSelectionHeader(context, selectionState, selectionNotifier),
          const SizedBox(height: 8),

          // Player grid
          PlayerGridWidget(
            grid: grid,
            isCurrentPlayer: isCurrentPlayer,
            canInteract: canInteract,
            highlightedPositions: highlightedPositions,
            selectedPositions: selectedPositions,
            onCardTap: (row, col) => _handleSelectionTap(selectionNotifier, row, col),
          ),

          // Selection controls
          const SizedBox(height: 12),
          _buildSelectionControls(context, selectionState, selectionNotifier),
        ],
      ),
    );
  }

  Widget _buildSelectionHeader(
    BuildContext context,
    CardSelectionState selectionState,
    CardSelectionNotifier selectionNotifier,
  ) {
    final theme = Theme.of(context);
    
    String instructionText;
    IconData instructionIcon;
    
    switch (selectionState.selectionType) {
      case CardSelectionType.teleport:
        if (!selectionState.hasFirstSelection) {
          instructionText = 'Sélectionnez la première carte à échanger';
          instructionIcon = Icons.touch_app;
        } else if (!selectionState.hasSecondSelection) {
          instructionText = 'Sélectionnez la deuxième carte à échanger';
          instructionIcon = Icons.touch_app;
        } else {
          instructionText = 'Cartes sélectionnées - confirmez l\'échange';
          instructionIcon = Icons.swap_horiz;
        }
        break;
      case CardSelectionType.swap:
        instructionText = 'Sélectionnez deux cartes à échanger';
        instructionIcon = Icons.swap_horiz;
        break;
      case null:
        instructionText = 'Sélectionnez deux cartes à échanger';
        instructionIcon = Icons.touch_app;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            instructionIcon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              instructionText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionControls(
    BuildContext context,
    CardSelectionState selectionState,
    CardSelectionNotifier selectionNotifier,
  ) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Cancel button
        OutlinedButton.icon(
          onPressed: () => selectionNotifier.cancelSelection(),
          icon: const Icon(Icons.close, size: 18),
          label: const Text('Annuler'),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
            side: BorderSide(color: theme.colorScheme.error),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Confirm button
        FilledButton.icon(
          onPressed: selectionState.canCompleteSelection
              ? () => _handleConfirmSelection(selectionNotifier)
              : null,
          icon: const Icon(Icons.check, size: 18),
          label: const Text('Confirmer'),
          style: FilledButton.styleFrom(
            backgroundColor: selectionState.canCompleteSelection
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceVariant,
          ),
        ),
      ],
    );
  }

  void _handleSelectionTap(
    CardSelectionNotifier selectionNotifier,
    int row,
    int col,
  ) {
    selectionNotifier.selectCard(row, col);
  }

  void _handleConfirmSelection(CardSelectionNotifier selectionNotifier) {
    final targetData = selectionNotifier.completeSelection();
    if (targetData != null && onTeleportComplete != null) {
      onTeleportComplete!(targetData);
    }
  }
}

// Extension to add teleportation functionality to any PlayerGrid widget
extension PlayerGridTeleportation on PlayerGridWidget {
  /// Start teleportation selection mode
  static void startTeleportSelection(WidgetRef ref) {
    ref.read(cardSelectionProvider.notifier).startTeleportSelection();
  }

  /// Check if currently in selection mode
  static bool isSelecting(WidgetRef ref) {
    return ref.watch(cardSelectionProvider).isSelecting;
  }

  /// Cancel current selection
  static void cancelSelection(WidgetRef ref) {
    ref.read(cardSelectionProvider.notifier).cancelSelection();
  }
}