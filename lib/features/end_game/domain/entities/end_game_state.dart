import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';

part 'end_game_state.freezed.dart';
part 'end_game_state.g.dart';

@Freezed()
abstract class EndGameState with _$EndGameState {
  const EndGameState._();

  const factory EndGameState({
    required List<GamePlayer> players,
    required String roundInitiatorId,
    required int roundNumber,
    @Default({}) Map<String, bool> playersVotes,
  }) = _EndGameState;

  factory EndGameState.fromJson(Map<String, dynamic> json) =>
      _$EndGameStateFromJson(json);

  /// Get players ranked by score (lowest to highest)
  /// Applies penalty to round initiator if they don't have the lowest score
  List<GamePlayer> get rankedPlayers {
    // Find the lowest score
    final lowestScore = players
        .map((p) => p.currentScore)
        .reduce((a, b) => a < b ? a : b);

    // Apply penalty if needed
    final playersWithPenalty = players.map((player) {
      if (player.id == roundInitiatorId && player.currentScore > lowestScore) {
        // Double the score as penalty by setting scoreMultiplier to 2
        return player.copyWith(scoreMultiplier: 2);
      }
      return player;
    }).toList();

    // Sort by score (ascending)
    final sorted = List<GamePlayer>.from(playersWithPenalty)
      ..sort((a, b) => a.currentScore.compareTo(b.currentScore));

    return sorted;
  }

  /// Get the winner (player with lowest score after penalties)
  GamePlayer get winner => rankedPlayers.first;

  /// Update a player's vote
  EndGameState updatePlayerVote(String playerId, bool vote) {
    // Initialize votes if empty
    Map<String, bool> currentVotes = playersVotes;
    if (currentVotes.isEmpty) {
      currentVotes = {};
      for (final player in players) {
        currentVotes[player.id] = false;
      }
    }

    final newVotes = Map<String, bool>.from(currentVotes);
    newVotes[playerId] = vote;
    return copyWith(playersVotes: newVotes);
  }

  /// Determine if the game should continue based on majority vote
  bool get shouldContinue {
    if (playersVotes.isEmpty) {
      // Initialize votes if empty
      final initialVotes = <String, bool>{};
      for (final player in players) {
        initialVotes[player.id] = false;
      }
      return false;
    }

    final votesToContinue = playersVotes.values.where((vote) => vote).length;
    final totalPlayers = players.length;

    // Majority vote (more than half)
    return votesToContinue > totalPlayers / 2;
  }
}
