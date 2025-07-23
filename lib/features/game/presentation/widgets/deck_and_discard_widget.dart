import 'package:flutter/material.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/card.dart' as game;
import 'card_widget.dart';

class DeckAndDiscardWidget extends StatelessWidget {
  final GameState gameState;
  final bool canDraw;
  final VoidCallback? onDrawFromDeck;
  final VoidCallback? onDrawFromDiscard;

  const DeckAndDiscardWidget({
    super.key,
    required this.gameState,
    this.canDraw = false,
    this.onDrawFromDeck,
    this.onDrawFromDiscard,
  });

  @override
  Widget build(BuildContext context) {
    final topDiscard = gameState.discardPile.isNotEmpty
        ? gameState.discardPile.first
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Deck
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pioche',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Shadow cards to show depth
                  for (int i = 2; i >= 0; i--)
                    Transform.translate(
                      offset: Offset(i * 2.0, i * 2.0),
                      child: SizedBox(
                        width: 80,
                        height: 112,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Top card (clickable)
                  GestureDetector(
                    onTap: canDraw ? onDrawFromDeck : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      height: 112,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: canDraw
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3,
                              )
                            : null,
                      ),
                      child: Stack(
                        children: [
                          const CardWidget(
                            card: game.Card(value: 0, isRevealed: false),
                          ),
                          if (canDraw)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.2),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.touch_app,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 32,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${gameState.deck.length} cartes',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),

          // Center arrow
          Icon(
            Icons.arrow_forward,
            size: 32,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),

          // Discard pile
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Défausse',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: canDraw && topDiscard != null ? onDrawFromDiscard : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 80,
                  height: 112,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: canDraw && topDiscard != null
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          )
                        : Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                  ),
                  child: topDiscard != null
                      ? Stack(
                          children: [
                            CardWidget(card: topDiscard.reveal()),
                            if (canDraw)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.2),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.touch_app,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 32,
                                  ),
                                ),
                              ),
                          ],
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withValues(alpha: 0.5),
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Vide',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${gameState.discardPile.length} cartes',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
