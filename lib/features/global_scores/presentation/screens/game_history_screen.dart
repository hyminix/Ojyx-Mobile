import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/presentation/providers/global_score_providers.dart';

class GameHistoryScreen extends ConsumerWidget {
  final String playerId;
  final void Function(GlobalScore)? onGameTap;

  const GameHistoryScreen({super.key, required this.playerId, this.onGameTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(recentGamesProvider(playerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Historique des parties')),
      body: RefreshIndicator(
        onRefresh: () async {
          // Force refresh by invalidating the provider
          ref.invalidate(recentGamesProvider(playerId));
        },
        child: gamesAsync.when(
          data: (games) {
            if (games.isEmpty) {
              return const Center(
                child: Text(
                  'Aucune partie jouée',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return _GameHistoryCard(game: game, onTap: onGameTap);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(
              'Erreur lors du chargement',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GameHistoryCard extends StatelessWidget {
  final GlobalScore game;
  final void Function(GlobalScore)? onTap;

  const _GameHistoryCard({required this.game, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap != null ? () => onTap!(game) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(game.createdAt),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (game.isWinner)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '🏆 Victoire',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.score,
                    label: 'Score: ${game.totalScore}',
                  ),
                  const SizedBox(width: 12),
                  _InfoChip(
                    icon: Icons.emoji_events,
                    label: 'Position: ${_getPositionText(game.position)}',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.loop,
                    label: '${game.roundNumber} manches',
                  ),
                  if (game.gameDuration != null) ...[
                    const SizedBox(width: 12),
                    _InfoChip(
                      icon: Icons.timer,
                      label: 'Durée: ${_formatDuration(game.gameDuration!)}',
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Salle: ${game.roomId}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPositionText(int position) {
    return position == 1 ? '1er' : '${position}e';
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = duration.inHours;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}min';
  }

  String _formatDate(DateTime date) {
    const months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
