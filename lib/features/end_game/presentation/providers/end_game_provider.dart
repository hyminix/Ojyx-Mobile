import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/end_game/domain/entities/end_game_state.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/save_global_score.dart';
import 'package:ojyx/features/global_scores/presentation/providers/global_score_providers.dart';

/// Provider for the end game state
final endGameProvider = Provider<AsyncValue<EndGameState?>>((ref) {
  final gameStateAsync = ref.watch(gameStateNotifierProvider);
  final roomId = ref.watch(currentRoomIdProvider);

  if (gameStateAsync == null || roomId == null) {
    return const AsyncData(null);
  }

  // Only create EndGameState if the game is finished or in last round
  if (gameStateAsync.status != GameStatus.finished &&
      gameStateAsync.status != GameStatus.lastRound) {
    return const AsyncData(null);
  }

  // Determine round number from some other source or default to 1
  final roundNumber = 1; // TODO: Track round number properly

  return AsyncData(
    EndGameState(
      players: gameStateAsync.players,
      roundInitiatorId:
          gameStateAsync.endRoundInitiator ??
          gameStateAsync.initiatorPlayerId ??
          '',
      roundNumber: roundNumber,
    ),
  );
});

/// Provider to handle vote to continue action
final voteToContineProvider = Provider.family<void, String>((ref, playerId) {
  final endGameStateAsync = ref.read(endGameProvider);

  endGameStateAsync.whenData((state) {
    if (state != null) {
      // TODO: Update vote and sync with backend via room repository
      // For now, we'll just prepare the update locally
      // This will be handled by the multiplayer system in production
      state.updatePlayerVote(playerId, true);
    }
  });
});

/// Provider to handle end game action
final endGameActionProvider = Provider<void>((ref) {
  // Save global scores first
  ref.read(endGameWithSaveProvider);
  
  // Navigate to home screen
  ref.read(navigateToHomeProvider);

  // TODO: Clean up room and game state
  // This will be handled by the room repository
});

/// Provider to save global scores when game ends
final endGameWithSaveProvider = FutureProvider<void>((ref) async {
  final gameState = ref.read(gameStateNotifierProvider);
  final roomId = ref.read(currentRoomIdProvider);
  
  if (gameState == null || roomId == null) {
    return;
  }
  
  // Only save if game is finished
  if (gameState.status != GameStatus.finished) {
    return;
  }
  
  final useCase = ref.read(saveGlobalScoreUseCaseProvider);
  final params = SaveGlobalScoreParams(
    gameState: gameState,
    roundNumber: 1, // TODO: Track round number properly
  );
  
  final result = await useCase(params);
  
  result.fold(
    (failure) => throw Exception('Failed to save scores: ${failure.message}'),
    (_) => {}, // Success
  );
});

/// Provider to navigate to home (to be implemented with go_router)
final navigateToHomeProvider = Provider<void>((ref) {
  // This will be overridden in the app with actual navigation
  // For now, it's a placeholder for testing
});
