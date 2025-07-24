import 'package:flutter/material.dart';
import '../../domain/entities/player_grid.dart';
import '../../domain/entities/card.dart' as game;
import 'card_widget.dart';

class PlayerGridWidget extends StatelessWidget {
  final PlayerGrid grid;
  final bool isCurrentPlayer;
  final bool canInteract;
  final Function(int row, int col)? onCardTap;
  final Set<(int, int)> highlightedPositions;
  final Set<(int, int)> selectedPositions;

  const PlayerGridWidget({
    super.key,
    required this.grid,
    required this.isCurrentPlayer,
    this.canInteract = false,
    this.onCardTap,
    this.highlightedPositions = const {},
    this.selectedPositions = const {},
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card dimensions with a slightly smaller size to prevent overflow
        final totalPadding = 32 + (4 * 8); // Container padding + card paddings
        final availableWidth =
            constraints.maxWidth - totalPadding - 8; // Extra margin for safety
        final cardWidth = availableWidth / 4;
        final cardHeight = cardWidth / 0.7; // Ratio carte

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCurrentPlayer
                ? Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCurrentPlayer
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              width: isCurrentPlayer ? 2 : 1,
            ),
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCurrentPlayer)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Votre grille',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (row) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (col) {
                          final card = grid.getCard(row, col);
                          final position = (row, col);
                          final isHighlighted = highlightedPositions.contains(
                            position,
                          );
                          final isSelected = selectedPositions.contains(
                            position,
                          );

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: SizedBox(
                              width: cardWidth,
                              height: cardHeight,
                              child: CardWidget(
                                card: card,
                                isPlaceholder: card == null && canInteract,
                                isHighlighted: isHighlighted,
                                isSelected: isSelected,
                                onTap: canInteract && onCardTap != null
                                    ? () => onCardTap!(row, col)
                                    : null,
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
                if (isCurrentPlayer)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: _buildGridStats(context),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridStats(BuildContext context) {
    final revealedCount = _countRevealedCards();
    final totalScore = grid.totalScore;
    final identicalColumns = grid.getIdenticalColumns();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatChip(
          icon: Icons.visibility,
          label: '$revealedCount/12',
          tooltip: 'Cartes révélées',
          context: context,
        ),
        _StatChip(
          icon: Icons.calculate,
          label: '$totalScore pts',
          tooltip: 'Score actuel',
          context: context,
          highlight: true,
        ),
        if (identicalColumns.isNotEmpty)
          _StatChip(
            icon: Icons.done_all,
            label: '${identicalColumns.length} col',
            tooltip: 'Colonnes identiques',
            context: context,
            color: Colors.green,
          ),
      ],
    );
  }

  int _countRevealedCards() {
    int count = 0;
    for (final row in grid.cards) {
      for (final card in row) {
        if (card != null && card.isRevealed) {
          count++;
        }
      }
    }
    return count;
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final BuildContext context;
  final bool highlight;
  final Color? color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.context,
    this.highlight = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor =
        color ??
        (highlight
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary);

    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: chipColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: chipColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: chipColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: chipColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
