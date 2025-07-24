import '../../../game/domain/entities/game_state.dart';
import '../../../game/domain/entities/player_grid.dart';
import '../../../game/domain/repositories/game_state_repository.dart';

class SyncGameStateUseCase {
  final GameStateRepository _gameStateRepository;

  SyncGameStateUseCase(this._gameStateRepository);

  /// Watch game state changes in real-time (server-authoritative)
  Stream<GameState> watchGameState(String gameStateId) {
    return _gameStateRepository.watchGameState(gameStateId);
  }

  /// Watch specific player grid changes
  Stream<PlayerGrid> watchPlayerGrid({
    required String gameStateId,
    required String playerId,
  }) {
    return _gameStateRepository.watchPlayerGrid(
      gameStateId: gameStateId,
      playerId: playerId,
    );
  }

  /// Watch all game actions for real-time updates
  Stream<Map<String, dynamic>> watchGameActions(String gameStateId) {
    return _gameStateRepository.watchGameActions(gameStateId);
  }

  /// Get current game state snapshot
  Future<GameState?> getCurrentGameState(String gameStateId) async {
    return await _gameStateRepository.getGameState(gameStateId);
  }

  /// Get current player grid snapshot
  Future<PlayerGrid?> getCurrentPlayerGrid({
    required String gameStateId,
    required String playerId,
  }) async {
    return await _gameStateRepository.getPlayerGrid(
      gameStateId: gameStateId,
      playerId: playerId,
    );
  }

  /// Get all player grids for the game (for spectating or game overview)
  Future<List<PlayerGrid>> getAllPlayerGrids(String gameStateId) async {
    return await _gameStateRepository.getAllPlayerGrids(gameStateId);
  }

  /// Perform a card reveal action (server-validated)
  Future<Map<String, dynamic>> revealCard({
    required String gameStateId,
    required String playerId,
    required int position,
  }) async {
    return await _gameStateRepository.revealCard(
      gameStateId: gameStateId,
      playerId: playerId,
      position: position,
    );
  }

  /// Advance to the next turn (server-managed)
  Future<Map<String, dynamic>> advanceTurn({
    required String gameStateId,
  }) async {
    return await _gameStateRepository.advanceTurn(
      gameStateId: gameStateId,
    );
  }

  /// Check for end game conditions (server-validated)
  Future<Map<String, dynamic>> checkEndGameConditions({
    required String gameStateId,
  }) async {
    return await _gameStateRepository.checkEndGameConditions(
      gameStateId: gameStateId,
    );
  }

  /// Get game action history for replay or debugging
  Future<List<Map<String, dynamic>>> getGameActionHistory({
    required String gameStateId,
    int? limit,
  }) async {
    return await _gameStateRepository.getGameActions(
      gameStateId: gameStateId,
      limit: limit,
    );
  }

  /// Validate if a player can perform an action (for UI feedback)
  Future<bool> canPlayerAct({
    required String gameStateId,
    required String playerId,
  }) async {
    try {
      final gameState = await getCurrentGameState(gameStateId);
      if (gameState == null) return false;
      
      // Check if it's the player's turn and game is playing
      return gameState.currentPlayer.id == playerId && 
             gameState.status == GameStatus.playing;
    } catch (e) {
      return false;
    }
  }
}
