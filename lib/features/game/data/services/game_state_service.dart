import 'dart:convert';
import '../../domain/utils/grid_generator.dart';

/// Service pour gérer la création et la gestion du game state via Supabase
class GameStateService {
  /// Crée un nouveau game state avec toutes les données initiales
  /// Utilise une transaction pour garantir l'atomicité
  static Future<String> createGameState({
    required String roomId,
    required List<String> playerIds,
    required int seed,
  }) async {
    // Cette méthode sera appelée depuis le repository qui a accès à Supabase
    // Elle retourne l'ID du game state créé
    throw UnimplementedError('Must be implemented with Supabase access');
  }

  /// Génère les données initiales pour le game state
  static Map<String, dynamic> generateInitialGameStateData({
    required String roomId,
    required List<String> playerIds,
  }) {
    return {
      'room_id': roomId,
      'status': 'playing',
      'game_phase': 'in_progress',
      'turn_number': 1,
      'round_number': 1,
      'current_player_id': playerIds.first,
      'direction': 'clockwise',
      'deck_count': 100, // Sera calculé correctement après distribution
      'discard_pile': [],
      'action_cards_deck_count': 30,
      'action_cards_discard': [],
      'is_last_round': false,
    };
  }

  /// Génère les données pour un player_grid
  static Map<String, dynamic> generatePlayerGridData({
    required String gameStateId,
    required String playerId,
    required int position,
    required int seed,
  }) {
    // Générer la grille avec le seed pour la cohérence
    final grid = GridGenerator.generateInitialGrid(seed: seed + position);
    
    return {
      'game_state_id': gameStateId,
      'player_id': playerId,
      'position': position,
      'grid_cards': json.encode(grid),
      'action_cards': json.encode([]),
      'score': 0,
      'is_ready': false,
      'is_active': true,
      'has_revealed_all': false,
    };
  }

  /// Calcule l'ordre des joueurs pour le tour
  static List<String> calculatePlayerOrder({
    required List<String> playerIds,
    required String currentPlayerId,
    required String direction,
  }) {
    final currentIndex = playerIds.indexOf(currentPlayerId);
    if (currentIndex == -1) return playerIds;

    final orderedPlayers = <String>[];
    final count = playerIds.length;

    if (direction == 'clockwise') {
      for (int i = 0; i < count; i++) {
        final index = (currentIndex + i) % count;
        orderedPlayers.add(playerIds[index]);
      }
    } else {
      for (int i = 0; i < count; i++) {
        final index = (currentIndex - i + count) % count;
        orderedPlayers.add(playerIds[index]);
      }
    }

    return orderedPlayers;
  }
}
