import 'package:flutter/material.dart';
import '../../domain/entities/game_state.dart';

class TurnInfoWidget extends StatelessWidget {
  final GameState gameState;
  final String currentPlayerId;

  const TurnInfoWidget({
    super.key,
    required this.gameState,
    required this.currentPlayerId,
  });

  @override
  Widget build(BuildContext context) {
    final currentPlayer = gameState.currentPlayer;
    final isMyTurn = currentPlayer.id == currentPlayerId;
    final turnDirection = gameState.turnDirection;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isMyTurn
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Direction indicator
          Icon(
            turnDirection == TurnDirection.clockwise
                ? Icons.rotate_right
                : Icons.rotate_left,
            size: 20,
            color: isMyTurn
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          // Turn info
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMyTurn ? 'Votre tour' : 'Tour de ${currentPlayer.name}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isMyTurn
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                _getPhaseText(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isMyTurn
                      ? Theme.of(
                          context,
                        ).colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                      : Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          // Status indicators
          if (gameState.lastRound) ...[
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, size: 14, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    'Dernier tour',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getPhaseText() {
    switch (gameState.status) {
      case GameStatus.drawPhase:
        return 'Phase de pioche';
      case GameStatus.playing:
        if (gameState.drawnCard != null) {
          return 'Phase de défausse';
        }
        return 'En jeu';
      case GameStatus.lastRound:
        return 'Dernier tour !';
      case GameStatus.finished:
        return 'Partie terminée';
      default:
        return '';
    }
  }
}
