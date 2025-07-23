import 'package:flutter/material.dart';
import '../../domain/entities/card.dart' as game;
import 'card_widget.dart';

class PlayerHandWidget extends StatelessWidget {
  final game.Card? drawnCard;
  final bool canDiscard;
  final VoidCallback? onDiscard;
  final bool isCurrentPlayer;

  const PlayerHandWidget({
    super.key,
    this.drawnCard,
    this.canDiscard = false,
    this.onDiscard,
    required this.isCurrentPlayer,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCurrentPlayer || drawnCard == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.pan_tool,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Carte en main',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (canDiscard)
                TextButton.icon(
                  onPressed: onDiscard,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: const Text('Défausser'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: CardWidget(
                    card: drawnCard!.reveal(),
                    isHighlighted: canDiscard,
                  ),
                ),
                if (canDiscard) ...[
                  const SizedBox(width: 24),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Glissez sur\nune carte',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
