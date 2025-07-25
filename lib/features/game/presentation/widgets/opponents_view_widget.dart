import 'package:flutter/material.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/game_player.dart';
import '../../domain/entities/player_state.dart';
import '../../domain/entities/card.dart' as game_card;
import 'opponent_grid_widget.dart';

class OpponentsViewWidget extends StatelessWidget {
  final GameState gameState;
  final String currentPlayerId;
  final Function(String playerId)? onPlayerTap;

  const OpponentsViewWidget({
    super.key,
    required this.gameState,
    required this.currentPlayerId,
    this.onPlayerTap,
  });

  PlayerState _playerToPlayerState(GamePlayer player) {
    // Flatten the 2D grid to 1D list
    final flatCards = <game_card.Card?>[];
    for (final row in player.grid.cards) {
      flatCards.addAll(row);
    }

    final revealedCount = flatCards
        .where((card) => card?.isRevealed ?? false)
        .length;
    final identicalColumns = player.grid.getIdenticalColumns();

    return PlayerState(
      playerId: player.id,
      cards: flatCards,
      currentScore: player.currentScore,
      revealedCount: revealedCount,
      identicalColumns: identicalColumns,
      hasFinished: player.hasFinishedRound,
    );
  }

  @override
  Widget build(BuildContext context) {
    final opponents = gameState.players
        .where((player) => player.id != currentPlayerId)
        .toList();

    if (opponents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Adversaires (${opponents.length})',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: opponents.length,
            itemBuilder: (context, index) {
              final opponent = opponents[index];
              final playerState = _playerToPlayerState(opponent);
              final isCurrentTurn =
                  gameState.players[gameState.currentPlayerIndex].id ==
                  opponent.id;

              return Padding(
                padding: EdgeInsets.only(
                  right: index < opponents.length - 1 ? 12 : 0,
                ),
                child: SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      Expanded(
                        child: OpponentGridWidget(
                          playerState: playerState,
                          isCurrentPlayer: isCurrentTurn,
                          onTap: onPlayerTap != null
                              ? () => onPlayerTap!(opponent.id)
                              : null,
                        ),
                      ),
                      // Show compact action cards view
                      if (opponent.actionCards.isNotEmpty)
                        Container(
                          height: 50,
                          padding: const EdgeInsets.all(4),
                          child: Center(
                            child: Text(
                              'Cartes Actions (${opponent.actionCards.length}/3)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Widget pour afficher les adversaires en mode grille (pour tablettes/grands écrans)
class OpponentsGridViewWidget extends StatelessWidget {
  final GameState gameState;
  final String currentPlayerId;
  final Function(String playerId)? onPlayerTap;
  final int crossAxisCount;

  const OpponentsGridViewWidget({
    super.key,
    required this.gameState,
    required this.currentPlayerId,
    this.onPlayerTap,
    this.crossAxisCount = 2,
  });

  PlayerState _playerToPlayerState(GamePlayer player) {
    // Flatten the 2D grid to 1D list
    final flatCards = <game_card.Card?>[];
    for (final row in player.grid.cards) {
      flatCards.addAll(row);
    }

    final revealedCount = flatCards
        .where((card) => card?.isRevealed ?? false)
        .length;
    final identicalColumns = player.grid.getIdenticalColumns();

    return PlayerState(
      playerId: player.id,
      cards: flatCards,
      currentScore: player.currentScore,
      revealedCount: revealedCount,
      identicalColumns: identicalColumns,
      hasFinished: player.hasFinishedRound,
    );
  }

  @override
  Widget build(BuildContext context) {
    final opponents = gameState.players
        .where((player) => player.id != currentPlayerId)
        .toList();

    if (opponents.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Adversaires (${opponents.length})',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: opponents.length,
              itemBuilder: (context, index) {
                final opponent = opponents[index];
                final playerState = _playerToPlayerState(opponent);
                final isCurrentTurn =
                    gameState.players[gameState.currentPlayerIndex].id ==
                    opponent.id;

                return OpponentGridWidget(
                  playerState: playerState,
                  isCurrentPlayer: isCurrentTurn,
                  onTap: onPlayerTap != null
                      ? () => onPlayerTap!(opponent.id)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
