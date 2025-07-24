import '../entities/game_state.dart';
import '../entities/db_player_grid.dart';
import '../entities/action_card.dart';

abstract class GameStateRepository {
  /// Initialize a new game with given players
  Future<GameState> initializeGame({
    required String roomId,
    required List<String> playerIds,
    required String creatorId,
  });

  /// Get current game state
  Future<GameState?> getGameState(String gameStateId);

  /// Watch game state changes in real-time
  Stream<GameState> watchGameState(String gameStateId);

  /// Get player grid for a specific player in a game
  Future<DbPlayerGrid?> getPlayerGrid({
    required String gameStateId,
    required String playerId,
  });

  /// Watch player grid changes
  Stream<DbPlayerGrid> watchPlayerGrid({
    required String gameStateId,
    required String playerId,
  });

  /// Reveal a card at the specified position (server-validated)
  Future<Map<String, dynamic>> revealCard({
    required String gameStateId,
    required String playerId,
    required int position,
  });

  /// Use an action card (server-validated)
  Future<Map<String, dynamic>> useActionCard({
    required String gameStateId,
    required String playerId,
    required ActionCardType actionCardType,
    Map<String, dynamic>? targetData,
  });

  /// Advance to next player's turn
  Future<Map<String, dynamic>> advanceTurn({
    required String gameStateId,
  });

  /// Check if game has ended and handle end conditions
  Future<Map<String, dynamic>> checkEndGameConditions({
    required String gameStateId,
  });

  /// Get all player grids for a game (for spectating/admin)
  Future<List<DbPlayerGrid>> getAllPlayerGrids(String gameStateId);

  /// Get game action history
  Future<List<Map<String, dynamic>>> getGameActions({
    required String gameStateId,
    int? limit,
  });

  /// Watch game actions in real-time
  Stream<Map<String, dynamic>> watchGameActions(String gameStateId);
}