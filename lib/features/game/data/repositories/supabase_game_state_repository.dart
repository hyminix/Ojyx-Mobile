import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/game_state_repository.dart';
import '../../domain/entities/game_state.dart';
import '../models/db_player_grid_model.dart';
import '../../domain/entities/action_card.dart';
import '../models/game_state_model.dart';
import '../models/player_grid_model.dart';
import '../../domain/entities/player_grid.dart';

class SupabaseGameStateRepository implements GameStateRepository {
  final SupabaseClient _supabase;

  SupabaseGameStateRepository(this._supabase);

  @override
  Future<GameState> initializeGame({
    required String roomId,
    required List<String> playerIds,
    required String creatorId,
  }) async {
    try {
      // Call PostgreSQL function to initialize game
      final response = await _supabase.rpc('initialize_game', params: {
        'p_room_id': roomId,
        'p_player_ids': playerIds,
        'p_creator_id': creatorId,
      });

      if (response['valid'] != true) {
        throw Exception(response['error'] ?? 'Failed to initialize game');
      }

      final gameStateId = response['game_state_id'] as String;
      
      // Fetch the created game state
      final gameState = await getGameState(gameStateId);
      if (gameState == null) {
        throw Exception('Failed to retrieve initialized game state');
      }

      return gameState;
    } catch (e) {
      throw Exception('Failed to initialize game: $e');
    }
  }

  @override
  Future<GameState?> getGameState(String gameStateId) async {
    try {
      final response = await _supabase
          .from('game_states')
          .select()
          .eq('id', gameStateId)
          .single();

      return GameStateModel.fromJson(response).toDomainComplete();
    } catch (e) {
      if (e.toString().contains('No rows found')) {
        return null;
      }
      throw Exception('Failed to get game state: $e');
    }
  }

  @override
  Stream<GameState> watchGameState(String gameStateId) {
    return _supabase
        .from('game_states')
        .stream(primaryKey: ['id'])
        .eq('id', gameStateId)
        .map((data) => data.isEmpty 
            ? throw Exception('Game state not found')
            : GameStateModel.fromJson(data.first).toDomainComplete());
  }

  @override
  Future<PlayerGrid?> getPlayerGrid({
    required String gameStateId,
    required String playerId,
  }) async {
    try {
      final response = await _supabase
          .from('player_grids')
          .select()
          .eq('game_state_id', gameStateId)
          .eq('player_id', playerId)
          .single();

      final dbGrid = PlayerGridModel.fromJson(response).toDomain();
      return dbGrid.toPlayerGrid();
    } catch (e) {
      if (e.toString().contains('No rows found')) {
        return null;
      }
      throw Exception('Failed to get player grid: $e');
    }
  }

  @override
  Stream<PlayerGrid> watchPlayerGrid({
    required String gameStateId,
    required String playerId,
  }) {
    return _supabase
        .from('player_grids')
        .stream(primaryKey: ['id'])
        .eq('game_state_id', gameStateId)
        .map((data) => data.isEmpty 
            ? throw Exception('GamePlayer grid not found')
            : PlayerGridModel.fromJson(data.first).toDomain().toPlayerGrid());
  }

  @override
  Future<Map<String, dynamic>> revealCard({
    required String gameStateId,
    required String playerId,
    required int position,
  }) async {
    try {
      // Call PostgreSQL function for server-side validation
      final response = await _supabase.rpc('process_card_reveal', params: {
        'p_game_state_id': gameStateId,
        'p_player_id': playerId,
        'p_position': position,
      });

      if (response['valid'] != true) {
        throw Exception(response['error'] ?? 'Invalid card reveal');
      }

      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to reveal card: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> useActionCard({
    required String gameStateId,
    required String playerId,
    required ActionCardType actionCardType,
    Map<String, dynamic>? targetData,
  }) async {
    try {
      // Call PostgreSQL function for server-side validation
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
      throw Exception('Failed to use action card: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> advanceTurn({
    required String gameStateId,
  }) async {
    try {
      final response = await _supabase.rpc('advance_turn', params: {
        'p_game_state_id': gameStateId,
      });

      if (response['valid'] != true) {
        throw Exception(response['error'] ?? 'Failed to advance turn');
      }

      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to advance turn: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> checkEndGameConditions({
    required String gameStateId,
  }) async {
    try {
      final response = await _supabase.rpc('check_end_game_conditions', params: {
        'p_game_state_id': gameStateId,
      });

      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to check end game conditions: $e');
    }
  }

  @override
  Future<List<PlayerGrid>> getAllPlayerGrids(String gameStateId) async {
    try {
      final response = await _supabase
          .from('player_grids')
          .select()
          .eq('game_state_id', gameStateId)
          .order('position');

      return response
          .map<PlayerGrid>((json) => PlayerGridModel.fromJson(json).toDomain().toPlayerGrid())
          .toList();
    } catch (e) {
      throw Exception('Failed to get all player grids: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGameActions({
    required String gameStateId,
    int? limit,
  }) async {
    try {
      var query = _supabase
          .from('game_actions')
          .select()
          .eq('game_state_id', gameStateId)
          .order('created_at', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return response.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to get game actions: $e');
    }
  }

  @override
  Stream<Map<String, dynamic>> watchGameActions(String gameStateId) {
    return _supabase
        .from('game_actions')
        .stream(primaryKey: ['id'])
        .eq('game_state_id', gameStateId)
        .order('created_at', ascending: false)
        .map((data) => data.isEmpty 
            ? <String, dynamic>{}
            : data.first as Map<String, dynamic>);
  }
}