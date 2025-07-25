import 'package:flutter/material.dart';
import '../../domain/entities/player_state.dart';
import '../../domain/entities/card.dart' as game;
import '../../../../core/utils/constants.dart';

class OpponentGridWidget extends StatelessWidget {
  final PlayerState playerState;
  final bool isCurrentPlayer;
  final VoidCallback? onTap;

  const OpponentGridWidget({
    super.key,
    required this.playerState,
    this.isCurrentPlayer = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: isCurrentPlayer
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header avec info joueur
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isCurrentPlayer
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    // Avatar/Icon
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: isCurrentPlayer
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      child: Text(
                        playerState.playerId.substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isCurrentPlayer
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Nom du joueur
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Joueur ${playerState.playerId.substring(0, 6)}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isCurrentPlayer)
                            Text(
                              'En train de jouer',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                        ],
                      ),
                    ),
                    // Score
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${playerState.currentScore} pts',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Mini grille
              Padding(
                padding: const EdgeInsets.all(8),
                child: AspectRatio(
                  aspectRatio: kGridColumns / kGridRows,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = constraints.maxWidth / kGridColumns;
                      final cardHeight = constraints.maxHeight / kGridRows;

                      return Stack(
                        children: [
                          // Grille de cartes
                          for (int row = 0; row < kGridRows; row++)
                            for (int col = 0; col < kGridColumns; col++)
                              Positioned(
                                left: col * cardWidth,
                                top: row * cardHeight,
                                width: cardWidth,
                                height: cardHeight,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: _buildMiniCard(
                                    context,
                                    playerState.cards[row * kGridColumns + col],
                                  ),
                                ),
                              ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Stats footer
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildStat(
                        context,
                        Icons.visibility,
                        '${playerState.revealedCount}',
                        'Révélées',
                        key: ValueKey('revealed_count_${playerState.playerId}'),
                      ),
                    ),
                    Expanded(
                      child: _buildStat(
                        context,
                        Icons.grid_on,
                        '${playerState.identicalColumns.length}',
                        'Colonnes',
                        key: ValueKey(
                          'identical_columns_${playerState.playerId}',
                        ),
                      ),
                    ),
                    if (playerState.hasFinished)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.flag,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniCard(BuildContext context, game.Card? card) {
    if (card == null) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: card.isRevealed
            ? Container(
                color: _getMiniCardColor(context, card),
                child: Center(
                  child: Text(
                    card.value.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getMiniCardTextColor(card),
                      fontSize: 10,
                    ),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                      Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    IconData icon,
    String value,
    String label, {
    Key? key,
  }) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Color _getMiniCardColor(BuildContext context, game.Card card) {
    switch (card.color) {
      case CardValueColor.darkBlue:
      case CardValueColor.lightBlue:
        return Colors.blue.shade100;
      case CardValueColor.green:
        return Colors.green.shade100;
      case CardValueColor.yellow:
        return Colors.yellow.shade100;
      case CardValueColor.red:
        return Colors.red.shade100;
    }
  }

  Color _getMiniCardTextColor(game.Card card) {
    switch (card.color) {
      case CardValueColor.darkBlue:
      case CardValueColor.lightBlue:
        return Colors.blue.shade900;
      case CardValueColor.green:
        return Colors.green.shade900;
      case CardValueColor.yellow:
        return Colors.yellow.shade900;
      case CardValueColor.red:
        return Colors.red.shade900;
    }
  }
}
