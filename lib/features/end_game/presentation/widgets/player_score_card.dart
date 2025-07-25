import 'package:flutter/material.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';

class PlayerScoreCard extends StatelessWidget {
  final GamePlayer player;
  final int rank;
  final bool isPenalized;
  final bool hasVoted;

  const PlayerScoreCard({
    super.key,
    required this.player,
    required this.rank,
    required this.isPenalized,
    required this.hasVoted,
  });

  String get rankText {
    switch (rank) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '${rank}th';
    }
  }

  Color get rankColor {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[400]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: rank == 1 ? 8 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Rank badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: rankColor.withAlpha((0.2 * 255).round()),
                shape: BoxShape.circle,
                border: Border.all(color: rankColor, width: 2),
              ),
              child: Center(
                child: Text(
                  rankText,
                  style: TextStyle(
                    color: rankColor,
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
                  Text(
                    player.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${player.currentScore} points',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (isPenalized) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha((0.2 * 255).round()),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Score doubled!',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Vote indicator
            if (hasVoted)
              const Icon(Icons.check_circle, color: Colors.green, size: 32),
          ],
        ),
      ),
    );
  }
}
