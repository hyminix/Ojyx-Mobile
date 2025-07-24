import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/presentation/providers/global_score_providers.dart';

class LeaderboardScreen extends ConsumerWidget {
  final void Function(PlayerStats)? onPlayerTap;

  const LeaderboardScreen({
    super.key,
    this.onPlayerTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(topPlayersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classement'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Force refresh by invalidating the provider
          ref.invalidate(topPlayersProvider);
        },
        child: playersAsync.when(
          data: (players) {
            if (players.isEmpty) {
              return const Center(
                child: Text(
                  'Aucun joueur dans le classement',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            // Sort players by win rate (highest first)
            final sortedPlayers = List<PlayerStats>.from(players)
              ..sort((a, b) => b.winRate.compareTo(a.winRate));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedPlayers.length,
              itemBuilder: (context, index) {
                final player = sortedPlayers[index];
                return _PlayerRankCard(
                  player: player,
                  rank: index + 1,
                  onTap: onPlayerTap,
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
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

class _PlayerRankCard extends StatelessWidget {
  final PlayerStats player;
  final int rank;
  final void Function(PlayerStats)? onTap;

  const _PlayerRankCard({
    required this.player,
    required this.rank,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final trophy = _getTrophyEmoji(rank);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: rank <= 3 ? 4 : 2,
      child: InkWell(
        onTap: onTap != null ? () => onTap!(player) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Rank indicator
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getRankColor(rank),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: trophy != null
                      ? Text(
                          trophy,
                          style: const TextStyle(fontSize: 24),
                        )
                      : Text(
                          '$rank',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              // GamePlayer info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          player.playerName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(player.winRate * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.emoji_events,
                          label: '${player.totalWins} victoires',
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          icon: Icons.sports_esports,
                          label: '${player.totalGamesPlayed} parties',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.score,
                          label: 'Score moyen: ${player.averageScore.toStringAsFixed(1)}',
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          icon: Icons.star,
                          label: 'Meilleur: ${player.bestScore}',
                        ),
                      ],
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

  String? _getTrophyEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return null;
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[400]!;
      default:
        return Colors.blue[400]!;
    }
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}