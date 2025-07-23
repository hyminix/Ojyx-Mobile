import '../entities/game_state.dart';
import '../entities/player.dart';
import '../entities/player_grid.dart';

class GameInitializationUseCase {
  GameState initializeGame({
    required List<String> playerIds,
    required String roomId,
    String? startingPlayerId,
  }) {
    final players = playerIds.map((id) => Player(
      id: id,
      name: 'Player $id',
      grid: PlayerGrid.empty(),
      actionCards: [],
      isHost: playerIds.first == id,
    )).toList();

    return GameState.initial(
      roomId: roomId,
      players: players,
      currentPlayerIndex: startingPlayerId != null 
          ? playerIds.indexOf(startingPlayerId) 
          : 0,
    );
  }
}