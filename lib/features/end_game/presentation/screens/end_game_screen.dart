import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/end_game/presentation/providers/end_game_provider.dart';
import 'package:ojyx/features/end_game/presentation/widgets/player_score_card.dart';
import 'package:ojyx/features/end_game/presentation/widgets/vote_section.dart';
import 'package:ojyx/features/end_game/presentation/widgets/winner_announcement.dart';

class EndGameScreen extends ConsumerWidget {
  const EndGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final endGameStateAsync = ref.watch(endGameProvider);

    return Scaffold(
      body: endGameStateAsync.when(
        data: (endGameState) {
          if (endGameState == null) {
            return const Center(child: Text('No game data available'));
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha((0.1 * 255).round()),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Round title
                    Text(
                      'Round ${endGameState.roundNumber} Results',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Winner announcement
                    WinnerAnnouncement(winner: endGameState.winner),
                    const SizedBox(height: 32),

                    // GamePlayer rankings
                    ...endGameState.rankedPlayers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final player = entry.value;
                      final isPenalized =
                          player.id == endGameState.roundInitiatorId &&
                          player.currentScore >
                              endGameState.rankedPlayers.first.currentScore;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: PlayerScoreCard(
                          player: player,
                          rank: index + 1,
                          isPenalized: isPenalized,
                          hasVoted:
                              endGameState.playersVotes[player.id] ?? false,
                        ),
                      );
                    }),
                    const SizedBox(height: 32),

                    // Voting section
                    VoteSection(
                      onVoteToContinue: () {
                        // TODO: Get current player ID from auth/room provider
                        ref.read(voteToContineProvider('player1'));
                      },
                      onEndGame: () {
                        ref.read(endGameActionProvider);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
