import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/action_card.dart';
import '../../domain/repositories/action_card_repository.dart';

class ServerActionCardRepository implements ActionCardRepository {
  final SupabaseClient _supabase;

  ServerActionCardRepository(this._supabase);

  @override
  List<ActionCard> getAvailableActionCards() {
    // This method should be replaced with server-side logic
    // For now, return the standard set of action cards
    return [
      const ActionCard(
        id: 'teleport_1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes de votre grille',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      ),
      const ActionCard(
        id: 'turnAround_1',
        type: ActionCardType.turnAround,
        name: 'Demi-tour',
        description: 'Changez le sens du jeu',
        timing: ActionTiming.immediate,
        target: ActionTarget.none,
      ),
      const ActionCard(
        id: 'peek_1',
        type: ActionCardType.peek,
        name: 'Regard',
        description: 'Regardez une carte sans la révéler',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      ),
      const ActionCard(
        id: 'swap_1',
        type: ActionCardType.swap,
        name: 'Échange',
        description: 'Échangez une carte avec un adversaire',
        timing: ActionTiming.optional,
        target: ActionTarget.singleOpponent,
      ),
    ];
  }

  @override
  List<ActionCard> getPlayerActionCards(String playerId) {
    // This should not be used in server-authoritative architecture
    // GamePlayer action cards are now stored in player_grids table
    throw UnsupportedError(
      'Use GameStateRepository.getPlayerGrid() to get player action cards'
    );
  }

  @override
  void addActionCardToPlayer(String playerId, ActionCard card) {
    // This should not be used in server-authoritative architecture
    throw UnsupportedError(
      'Action cards are managed server-side through PostgreSQL functions'
    );
  }

  @override
  void removeActionCardFromPlayer(String playerId, ActionCard card) {
    // This should not be used in server-authoritative architecture
    throw UnsupportedError(
      'Action cards are managed server-side through PostgreSQL functions'
    );
  }

  @override
  ActionCard? drawActionCard() {
    // This should not be used in server-authoritative architecture
    throw UnsupportedError(
      'Card drawing is managed server-side through PostgreSQL functions'
    );
  }

  @override
  void discardActionCard(ActionCard card) {
    // This should not be used in server-authoritative architecture
    throw UnsupportedError(
      'Card discarding is managed server-side through PostgreSQL functions'
    );
  }

  @override
  void shuffleActionCards() {
    // This should not be used in server-authoritative architecture
    throw UnsupportedError(
      'Card shuffling is managed server-side through PostgreSQL functions'
    );
  }

  // New server-side methods for action card validation and usage

  /// Validate if an action card can be used (server-side validation)
  Future<Map<String, dynamic>> validateActionCardUse({
    required String gameStateId,
    required String playerId,
    required ActionCardType actionCardType,
    Map<String, dynamic>? targetData,
  }) async {
    try {
      final response = await _supabase.rpc('validate_action_card_use', params: {
        'p_game_state_id': gameStateId,
        'p_player_id': playerId,
        'p_action_card_type': actionCardType.name,
        'p_target_data': targetData ?? {},
      });

      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to validate action card use: $e');
    }
  }

  /// Process action card usage (server-side processing)
  Future<Map<String, dynamic>> processActionCardUse({
    required String gameStateId,
    required String playerId,
    required ActionCardType actionCardType,
    Map<String, dynamic>? targetData,
  }) async {
    try {
      final response = await _supabase.rpc('process_action_card', params: {
        'p_game_state_id': gameStateId,
        'p_player_id': playerId,
        'p_action_card_type': actionCardType.name,
        'p_target_data': targetData ?? {},
      });

      if (response['valid'] != true) {
        throw Exception(response['error'] ?? 'Invalid action card use');
      }

      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to process action card use: $e');
    }
  }

  /// Validate action card timing (server-side timing validation)
  Future<Map<String, dynamic>> validateActionTiming({
    required String gameStateId,
    required String playerId,
    required ActionCardType actionCardType,
  }) async {
    try {
      final response = await _supabase.rpc('validate_action_timing', params: {
        'p_game_state_id': gameStateId,
        'p_player_id': playerId,
        'p_action_card_type': actionCardType.name,
      });

      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to validate action timing: $e');
    }
  }

  /// Get action card definition by type
  ActionCard? getActionCardByType(ActionCardType type) {
    return getAvailableActionCards()
        .where((card) => card.type == type)
        .firstOrNull;
  }

  /// Check if action card is immediate (must be played right away)
  bool isImmediateAction(ActionCard card) {
    return card.timing == ActionTiming.immediate;
  }

  /// Check if action card is optional (can be stored)
  bool isOptionalAction(ActionCard card) {
    return card.timing == ActionTiming.optional;
  }

  /// Check if action card is reactive (can be played in response)
  bool isReactiveAction(ActionCard card) {
    return card.timing == ActionTiming.reactive;
  }
}