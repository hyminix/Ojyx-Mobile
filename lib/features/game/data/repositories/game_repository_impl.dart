import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/supabase_exceptions.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/game_player.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/action_card.dart';
import '../../domain/entities/player_grid.dart';

class GameRepositoryImpl implements GameRepository {
  final SupabaseClient _supabase;

  GameRepositoryImpl(this._supabase);

  @override
  Future<GameState?> loadGame(String gameId) async {
    try {
      // Charger le game state
      final gameStateResponse = await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase
            .from('game_states')
            .select()
            .eq('id', gameId)
            .single(),
        operation: 'load_game_state',
        context: {'game_id': gameId},
      );

      // Charger les player grids
      final playerGridsResponse = await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase
            .from('player_grids')
            .select('*, players!inner(*)')
            .eq('game_state_id', gameId)
            .order('position'),
        operation: 'load_player_grids',
        context: {'game_id': gameId},
      );

      // Convertir en GameState
      return _parseGameState(gameStateResponse, playerGridsResponse);
    } catch (e) {
      throw Exception('Failed to load game: $e');
    }
  }

  @override
  Future<void> updatePlayerGrid({
    required String gameId,
    required String playerId,
    required List<Card> gridCards,
  }) async {
    final gridData = gridCards.asMap().entries.map((entry) => {
      'position': entry.key,
      'value': entry.value.value,
      'isRevealed': entry.value.isRevealed,
      'row': entry.key ~/ 4,
      'column': entry.key % 4,
    }).toList();

    await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase
          .from('player_grids')
          .update({
            'grid_cards': json.encode(gridData),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('game_state_id', gameId)
          .eq('player_id', playerId),
      operation: 'update_player_grid',
      context: {
        'game_id': gameId,
        'player_id': playerId,
      },
    );
  }

  @override
  Future<void> submitAction({
    required String gameId,
    required String playerId,
    required String actionType,
    required Map<String, dynamic> actionData,
  }) async {
    // Obtenir le prochain numéro de séquence
    final sequenceResponse = await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase
          .from('game_actions')
          .select('sequence_number')
          .eq('game_state_id', gameId)
          .order('sequence_number', ascending: false)
          .limit(1),
      operation: 'get_last_sequence',
      context: {'game_id': gameId},
    );

    final nextSequence = sequenceResponse.isEmpty 
        ? 1 
        : (sequenceResponse.first['sequence_number'] as int) + 1;

    await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase
          .from('game_actions')
          .insert({
            'game_state_id': gameId,
            'player_id': playerId,
            'action_type': actionType,
            'action_data': actionData,
            'sequence_number': nextSequence,
            'is_valid': true,
          }),
      operation: 'submit_action',
      context: {
        'game_id': gameId,
        'player_id': playerId,
        'action_type': actionType,
      },
    );
  }

  @override
  Stream<GameState> watchGame(String gameId) {
    // Combiner les streams de game_states et player_grids
    return _supabase
        .from('game_states')
        .stream(primaryKey: ['id'])
        .eq('id', gameId)
        .asyncMap((gameStateData) async {
          if (gameStateData.isEmpty) {
            throw Exception('Game not found');
          }

          // Charger les player grids à chaque changement
          final playerGridsResponse = await _supabase
              .from('player_grids')
              .select('*, players!inner(*)')
              .eq('game_state_id', gameId)
              .order('position');

          return _parseGameState(gameStateData.first, playerGridsResponse);
        });
  }

  GameState _parseGameState(
    Map<String, dynamic> gameStateData,
    List<Map<String, dynamic>> playerGridsData,
  ) {
    // Parser les joueurs
    final players = playerGridsData.map((gridData) {
      final playerData = gridData['players'] as Map<String, dynamic>;
      final gridCardsJson = json.decode(gridData['grid_cards'] as String) as List;
      
      // Créer la grille de cartes 3x4
      final cards = List.generate(3, (row) => 
        List.generate(4, (col) {
          final position = row * 4 + col;
          if (position < gridCardsJson.length) {
            final cardJson = gridCardsJson[position];
            return Card(
              value: cardJson['value'],
              isRevealed: cardJson['isRevealed'] ?? false,
            );
          }
          return null;
        })
      );
      
      final grid = PlayerGrid(cards: cards);

      final actionCards = (json.decode(gridData['action_cards'] as String) as List)
          .map((cardJson) => ActionCard(
                id: cardJson['id'],
                type: ActionCardType.values.firstWhere(
                  (t) => t.name == cardJson['type'],
                  orElse: () => ActionCardType.peek,
                ),
                name: cardJson['name'],
                description: cardJson['description'],
                timing: ActionTiming.values.firstWhere(
                  (t) => t.name == cardJson['timing'],
                  orElse: () => ActionTiming.optional,
                ),
                target: ActionTarget.values.firstWhere(
                  (t) => t.name == cardJson['target'],
                  orElse: () => ActionTarget.none,
                ),
                parameters: cardJson['parameters'] ?? {},
              ))
          .toList()
          .cast<ActionCard>();

      return GamePlayer(
        id: playerData['id'],
        name: playerData['name'],
        grid: grid,
        actionCards: actionCards,
        isConnected: gridData['is_active'] ?? true,
        isHost: playerData['is_host'] ?? false,
        hasFinishedRound: gridData['has_revealed_all'] ?? false,
      );
    }).toList();

    // Récupérer l'index du joueur actuel
    final currentPlayerIndex = players.indexWhere(
      (p) => p.id == gameStateData['current_player_id'],
    );

    // Parser le statut du jeu
    final status = GameStatus.values.firstWhere(
      (s) => s.name == gameStateData['game_phase'],
      orElse: () => GameStatus.playing,
    );

    // Parser la direction
    final turnDirection = gameStateData['direction'] == 'counter_clockwise' 
        ? TurnDirection.counterClockwise 
        : TurnDirection.clockwise;

    // Parser le deck
    final deck = List<Card>.generate(
      gameStateData['deck_count'] ?? 0,
      (_) => const Card(value: 0), // Les cartes du deck ne sont pas révélées
    );

    // Parser la pile de défausse
    final discardPile = (json.decode(gameStateData['discard_pile'] ?? '[]') as List)
        .map((cardJson) => Card(
              value: cardJson['value'],
              isRevealed: true,
            ))
        .toList();

    // Parser les cartes action (placeholder pour l'instant)
    final actionDeck = <ActionCard>[];
    final actionDiscard = <ActionCard>[];

    // Créer le GameState
    return GameState(
      roomId: gameStateData['room_id'],
      players: players,
      currentPlayerIndex: currentPlayerIndex >= 0 ? currentPlayerIndex : 0,
      deck: deck,
      discardPile: discardPile,
      actionDeck: actionDeck,
      actionDiscard: actionDiscard,
      status: status,
      turnDirection: turnDirection,
      lastRound: gameStateData['is_last_round'] ?? false,
      initiatorPlayerId: gameStateData['round_initiator_id'],
      createdAt: DateTime.parse(gameStateData['created_at']),
      startedAt: gameStateData['started_at'] != null 
          ? DateTime.parse(gameStateData['started_at']) 
          : null,
    );
  }
}
