import 'package:flutter/material.dart';
import '../../domain/entities/card.dart' as game;
import 'draw_pile_widget.dart';
import 'discard_pile_widget.dart';

class CommonAreaWidget extends StatelessWidget {
  final int drawPileCount;
  final game.Card? topDiscardCard;
  final bool isPlayerTurn;
  final VoidCallback onDrawCard;
  final ValueChanged<game.Card>? onDiscardCard;
  final bool canDiscard;
  final bool showReshuffleIndicator;
  final String? currentPlayerName;
  final int? roundNumber;
  final bool isGamePaused;

  const CommonAreaWidget({
    super.key,
    required this.drawPileCount,
    required this.topDiscardCard,
    required this.isPlayerTurn,
    required this.onDrawCard,
    this.onDiscardCard,
    this.canDiscard = false,
    this.showReshuffleIndicator = false,
    this.currentPlayerName,
    this.roundNumber,
    this.isGamePaused = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Zone commune de jeu',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Game info
            if (currentPlayerName != null || roundNumber != null)
              _buildGameInfo(context),

            // Turn indicator
            if (isPlayerTurn && !isGamePaused) _buildTurnIndicator(context),

            // Pause indicator
            if (isGamePaused) _buildPauseIndicator(context),

            const SizedBox(height: 16),

            // Piles row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Draw pile
                DrawPileWidget(
                  cardCount: drawPileCount,
                  isPlayerTurn: isPlayerTurn && !isGamePaused,
                  onTap: isGamePaused ? null : onDrawCard,
                ),

                const SizedBox(width: 32),

                // Discard pile
                DiscardPileWidget(
                  topCard: topDiscardCard,
                  canDiscard: canDiscard && !isGamePaused,
                  showStackEffect: true,
                  onCardDropped: isGamePaused ? null : onDiscardCard,
                ),
              ],
            ),

            // Reshuffle indicator
            if (showReshuffleIndicator) _buildReshuffleIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentPlayerName != null) ...[
            Icon(
              Icons.person,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(width: 4),
            Text(
              'Tour de $currentPlayerName',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
          if (currentPlayerName != null && roundNumber != null)
            const SizedBox(width: 16),
          if (roundNumber != null) ...[
            Icon(
              Icons.flag,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(width: 4),
            Text(
              'Manche $roundNumber',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTurnIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_downward,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Votre tour',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPauseIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pause, size: 16, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Text(
            'Jeu en pause',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReshuffleIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.tertiary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shuffle, size: 16, color: theme.colorScheme.tertiary),
            const SizedBox(width: 8),
            Text(
              'Mélange nécessaire',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
