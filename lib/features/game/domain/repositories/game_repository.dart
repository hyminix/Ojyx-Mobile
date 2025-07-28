import '../entities/game_state.dart';
import '../entities/card.dart';

/// Repository interface pour les opérations de jeu
abstract class GameRepository {
  /// Charge un jeu par son ID
  Future<GameState?> loadGame(String gameId);

  /// Met à jour la grille d'un joueur
  Future<void> updatePlayerGrid({
    required String gameId,
    required String playerId,
    required List<Card> gridCards,
  });

  /// Soumet une action de jeu
  Future<void> submitAction({
    required String gameId,
    required String playerId,
    required String actionType,
    required Map<String, dynamic> actionData,
  });

  /// Écoute les changements d'un jeu en temps réel
  Stream<GameState> watchGame(String gameId);
}
