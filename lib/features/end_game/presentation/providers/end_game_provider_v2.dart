import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ojyx/features/end_game/domain/entities/end_game_state.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/save_global_score.dart';
import 'package:ojyx/features/global_scores/presentation/providers/global_score_providers_v2.dart';

part 'end_game_provider_v2.g.dart';

/// Provider for the end game state
@riverpod
class EndGameStateNotifier extends _$EndGameStateNotifier {
  @override
  EndGameState? build() {
    final gameState = ref.watch(gameStateNotifierProvider);
    final roomId = ref.watch(currentRoomIdProvider);

    if (gameState == null || roomId == null) {
      return null;
    }

    // Only create EndGameState if the game is finished or in last round
    if (gameState.status != GameStatus.finished &&
        gameState.status != GameStatus.lastRound) {
      return null;
    }

    // Determine round number from some other source or default to 1
    final roundNumber = 1; // TODO: Track round number properly

    return EndGameState(
      players: gameState.players,
      roundInitiatorId:
          gameState.endRoundInitiator ?? gameState.initiatorPlayerId ?? '',
      roundNumber: roundNumber,
    );
  }

  void updatePlayerVote(String playerId, bool voteToContinue) {
    final currentState = state;
    if (currentState != null) {
      // TODO: Update vote and sync with backend via room repository
      // For now, we'll just prepare the update locally
      // This will be handled by the multiplayer system in production
      currentState.updatePlayerVote(playerId, voteToContinue);
      state = currentState;
    }
  }
}

/// Provider to handle vote to continue action
@riverpod
void voteToContine(VoteToContineRef ref, String playerId) {
  ref
      .read(endGameStateNotifierProvider.notifier)
      .updatePlayerVote(playerId, true);
}

/// Provider to save global scores when game ends
@riverpod
class EndGameSaveNotifier extends _$EndGameSaveNotifier {
  @override
  Future<void> build() async {
    // Initial state - no action required
  }

  Future<void> saveScores() async {
    final gameState = ref.read(gameStateNotifierProvider);
    final roomId = ref.read(currentRoomIdProvider);

    if (gameState == null || roomId == null) {
      return;
    }

    // Only save if game is finished
    if (gameState.status != GameStatus.finished) {
      return;
    }

    state = const AsyncValue.loading();

    try {
      final useCase = ref.read(saveGlobalScoreUseCaseProvider);
      final params = SaveGlobalScoreParams(
        gameState: gameState,
        roundNumber: 1, // TODO: Track round number properly
      );

      final result = await useCase(params);

      result.fold(
        (failure) =>
            throw Exception('Failed to save scores: ${failure.message}'),
        (_) => state = const AsyncValue.data(null), // Success
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// Provider to handle end game action
@riverpod
class EndGameAction extends _$EndGameAction {
  @override
  void build() {
    // No initial state needed
  }

  Future<void> endGame() async {
    // Save global scores first
    await ref.read(endGameSaveNotifierProvider.notifier).saveScores();

    // Navigate to home screen
    ref.read(navigateToHomeProvider);

    // TODO: Clean up room and game state
    // This will be handled by the room repository
  }
}

/// Provider to navigate to home (to be implemented with go_router)
@Riverpod(keepAlive: true)
void navigateToHome(NavigateToHomeRef ref) {
  // This will be overridden in the app with actual navigation
  // For now, it's a placeholder for testing
}

// Backward compatibility aliases
final endGameProvider = endGameStateNotifierProvider;
final endGameWithSaveProvider = endGameSaveNotifierProvider;
