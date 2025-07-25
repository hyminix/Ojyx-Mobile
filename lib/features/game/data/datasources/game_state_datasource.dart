import '../models/game_state_model.dart';
import '../models/player_grid_model.dart';

abstract class GameStateDataSource {
  // Game States
  Future<GameStateModel> createGameState(GameStateModel gameState);
  Future<GameStateModel?> getGameState(String gameStateId);
  Future<GameStateModel> updateGameState(GameStateModel gameState);
  Future<void> deleteGameState(String gameStateId);
  Future<GameStateModel?> getGameStateByRoom(String roomId);
  Stream<GameStateModel> watchGameState(String gameStateId);
  Stream<GameStateModel> watchGameStateByRoom(String roomId);

  // GamePlayer Grids
  Future<PlayerGridModel> createPlayerGrid(PlayerGridModel playerGrid);
  Future<PlayerGridModel> updatePlayerGrid(PlayerGridModel playerGrid);
  Future<List<PlayerGridModel>> getPlayerGrids(String gameStateId);
  Future<PlayerGridModel?> getPlayerGrid({
    required String gameStateId,
    required String playerId,
  });
  Stream<List<PlayerGridModel>> watchPlayerGrids(String gameStateId);
}
