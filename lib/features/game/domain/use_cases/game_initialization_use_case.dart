import '../entities/game_state.dart';
import '../repositories/game_state_repository.dart';

class GameInitializationUseCase {
  final GameStateRepository _gameStateRepository;

  GameInitializationUseCase(this._gameStateRepository);

  /// Initialize a new game using server-side validation and PostgreSQL functions
  Future<GameState> execute({
    required String roomId,
    required List<String> playerIds,
    required String creatorId,
  }) async {
    if (playerIds.isEmpty) {
      throw Exception('Cannot initialize game with no players');
    }

    if (playerIds.length < 2 || playerIds.length > 8) {
      throw Exception('Game requires 2-8 players');
    }

    if (!playerIds.contains(creatorId)) {
      throw Exception('Creator must be included in player list');
    }

    try {
      // Use server-side PostgreSQL function to initialize game
      final gameState = await _gameStateRepository.initializeGame(
        roomId: roomId,
        playerIds: playerIds,
        creatorId: creatorId,
      );

      return gameState;
    } catch (e) {
      throw Exception('Failed to initialize game: $e');
    }
  }

  /// Get the current game state for a room
  Future<GameState?> getGameState(String gameStateId) async {
    try {
      return await _gameStateRepository.getGameState(gameStateId);
    } catch (e) {
      throw Exception('Failed to get game state: $e');
    }
  }

  /// Watch game state changes in real-time
  Stream<GameState> watchGameState(String gameStateId) {
    return _gameStateRepository.watchGameState(gameStateId);
  }
}
