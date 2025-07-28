import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import '../../../../core/errors/supabase_exceptions.dart';
import '../../../../core/extensions/supabase_extensions.dart';
import '../models/room_model.dart';
import '../../../game/data/services/game_state_service.dart';
import '../../../game/domain/utils/grid_generator.dart';

class SupabaseRoomDatasource {
  final SupabaseClient _supabase;

  SupabaseRoomDatasource(this._supabase);

  Future<RoomModel> createRoom({
    required String creatorId,
    required int maxPlayers,
  }) async {
    // First ensure creator exists in players table
    final existingPlayer = await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase
          .from('players')
          .select()
          .eq('id', creatorId)
          .maybeSingle(),
      operation: 'check_creator_exists',
      context: {
        'creator_id': creatorId,
      },
    );

    // If creator doesn't exist, create them
    if (existingPlayer == null) {
      await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase
            .from('players')
            .insert({
              'id': creatorId,
              'name': 'Player', // Default name, can be updated later
              'connection_status': 'online',
            }),
        operation: 'create_creator_player',
        context: {
          'creator_id': creatorId,
        },
      );
    }

    final response = await _supabase.safeInsert(
      'rooms',
      {
        'creator_id': creatorId,
        'player_ids': [creatorId],
        'status': 'waiting',
        'max_players': maxPlayers,
        'created_at': DateTime.now().toIso8601String(),
      },
      context: {
        'creator_id': creatorId,
        'max_players': maxPlayers,
      },
    );

    // Update player's current room
    await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase
          .from('players')
          .update({
            'current_room_id': response.first['id'],
            'last_seen_at': DateTime.now().toIso8601String(),
          })
          .eq('id', creatorId),
      operation: 'update_player_room',
      context: {
        'player_id': creatorId,
        'room_id': response.first['id'],
      },
    );

    return RoomModel.fromJson(response.first);
  }

  Future<RoomModel?> joinRoom({
    required String roomId,
    required String playerId,
  }) async {
    final room = await getRoom(roomId);
    if (room == null) return null;

    if (room.playerIds.contains(playerId)) {
      return room;
    }

    if (room.playerIds.length >= room.maxPlayers) {
      return null;
    }

    // Ensure joining player exists in players table
    final existingPlayer = await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase
          .from('players')
          .select()
          .eq('id', playerId)
          .maybeSingle(),
      operation: 'check_joining_player_exists',
      context: {
        'player_id': playerId,
      },
    );

    // If player doesn't exist, create them
    if (existingPlayer == null) {
      await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase
            .from('players')
            .insert({
              'id': playerId,
              'name': 'Player ${room.playerIds.length + 1}', // Default name
              'connection_status': 'online',
              'current_room_id': roomId,
            }),
        operation: 'create_joining_player',
        context: {
          'player_id': playerId,
          'room_id': roomId,
        },
      );
    } else {
      // Update existing player's current room
      await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase
            .from('players')
            .update({
              'current_room_id': roomId,
              'last_seen_at': DateTime.now().toIso8601String(),
              'connection_status': 'online',
            })
            .eq('id', playerId),
        operation: 'update_joining_player_room',
        context: {
          'player_id': playerId,
          'room_id': roomId,
        },
      );
    }

    final updatedPlayerIds = [...room.playerIds, playerId];

    // First perform the update without select
    await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase
          .from('rooms')
          .update({
            'player_ids': updatedPlayerIds,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', roomId),
      operation: 'update_room_players',
      context: {
        'room_id': roomId,
        'player_id': playerId,
        'current_players': room.playerIds.length,
        'max_players': room.maxPlayers,
      },
    );

    // Then fetch the updated room data separately
    final updatedRoom = await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase
          .from('rooms')
          .select()
          .eq('id', roomId)
          .single(),
      operation: 'fetch_updated_room',
      context: {
        'room_id': roomId,
        'player_id': playerId,
      },
    );

    return RoomModel.fromJson(updatedRoom);
  }

  Future<void> leaveRoom({
    required String roomId,
    required String playerId,
  }) async {
    final room = await getRoom(roomId);
    if (room == null) return;

    final updatedPlayerIds = room.playerIds
        .where((id) => id != playerId)
        .toList();

    await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase
          .from('rooms')
          .update({
            'player_ids': updatedPlayerIds,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', roomId),
      operation: 'leave_room',
      context: {
        'room_id': roomId,
        'player_id': playerId,
      },
    );

    // Update player's current room to null
    await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase
          .from('players')
          .update({
            'current_room_id': null,
            'last_seen_at': DateTime.now().toIso8601String(),
          })
          .eq('id', playerId),
      operation: 'update_leaving_player',
      context: {
        'player_id': playerId,
        'room_id': roomId,
      },
    );
  }

  Future<RoomModel?> getRoom(String roomId) async {
    try {
      final response = await _supabase.safeSelectWhere(
        'rooms',
        column: 'id',
        value: roomId,
        context: {'room_id': roomId},
      );

      if (response.isEmpty) return null;
      return RoomModel.fromJson(response.first);
    } catch (e) {
      // Si la room n'existe pas, retourner null
      return null;
    }
  }

  Stream<RoomModel> watchRoom(String roomId) {
    return _supabase
        .from('rooms')
        .stream(primaryKey: ['id'])
        .eq('id', roomId)
        .map((data) => RoomModel.fromJson(data.first));
  }

  Future<void> sendEvent({
    required String roomId,
    required Map<String, dynamic> eventData,
  }) async {
    await _supabase.safeInsert(
      'room_events',
      {
        'room_id': roomId,
        'event_type': eventData['type'],
        'event_data': eventData,
        'created_at': DateTime.now().toIso8601String(),
      },
      context: {
        'room_id': roomId,
        'event_type': eventData['type'],
      },
    );
  }

  Stream<Map<String, dynamic>> watchRoomEvents(String roomId) {
    return _supabase
        .from('room_events')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at')
        .map((events) => events.isNotEmpty ? events.last['event_data'] : {});
  }

  Future<List<RoomModel>> getAvailableRooms() async {
    final response = await _supabase.safeSelectWhere(
      'rooms',
      column: 'status',
      value: 'waiting',
      context: {'operation': 'list_available_rooms'},
    );

    return response.map((json) => RoomModel.fromJson(json)).toList();
  }

  Future<void> updateRoomStatus({
    required String roomId,
    required String status,
    String? gameId,
  }) async {
    final updates = {
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (gameId != null) {
      updates['current_game_id'] = gameId;
    }

    await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase.from('rooms').update(updates).eq('id', roomId),
      operation: 'update_room_status',
      context: {
        'room_id': roomId,
        'status': status,
        if (gameId != null) 'game_id': gameId,
      },
    );
  }

  Future<String> startGame({
    required String roomId,
  }) async {
    // Timeout de 30 secondes pour la création complète
    return await Future.any([
      _createGameWithTimeout(roomId),
      Future.delayed(const Duration(seconds: 30)).then((_) {
        throw TimeoutException('Game creation timed out after 30 seconds');
      }),
    ]);
  }
  
  Future<String> _createGameWithTimeout(String roomId) async {
    // Ensure user is authenticated before creating game
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated. Please sign in and try again.');
    }

    // Récupérer la room et les joueurs
    final room = await getRoom(roomId);
    if (room == null) {
      throw Exception('Room not found');
    }

    if (room.playerIds.length < 2) {
      throw Exception('Not enough players to start the game');
    }

    // Générer un seed pour la cohérence
    final seed = Random().nextInt(1000000);
    
    String? gameId;

    try {
      // First, ensure all players exist in the players table
      for (final playerId in room.playerIds) {
        // Check if player exists
        final existingPlayer = await SupabaseExceptionHandler.handleSupabaseCall(
          call: () => _supabase
              .from('players')
              .select()
              .eq('id', playerId)
              .maybeSingle(),
          operation: 'check_player_exists',
          context: {
            'player_id': playerId,
          },
        );

        // If player doesn't exist, create them
        if (existingPlayer == null) {
          await SupabaseExceptionHandler.handleSupabaseCall(
            call: () => _supabase
                .from('players')
                .insert({
                  'id': playerId,
                  'name': 'Player ${room.playerIds.indexOf(playerId) + 1}', // Default name
                  'connection_status': 'online',
                  'current_room_id': roomId,
                }),
            operation: 'create_player',
            context: {
              'player_id': playerId,
              'room_id': roomId,
            },
          );
        }
      }

      // Créer le game state
      final gameStateResponse = await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase
            .from('game_states')
            .insert({
              'room_id': roomId,
              'status': 'playing',
              'game_phase': 'in_progress',
              'turn_number': 0,
              'round_number': 1,
              'current_player_id': room.playerIds.first,
              'direction': 'clockwise',
              'deck_count': 100,
              'discard_pile': json.encode([]),
              'action_cards_deck_count': 30,
              'action_cards_discard': json.encode([]),
              'is_last_round': false,
            })
            .select()
            .single(),
        operation: 'create_game_state',
        context: {
          'room_id': roomId,
          'player_count': room.playerIds.length,
        },
      );

      gameId = gameStateResponse['id'] as String;

      // Créer les player_grids pour chaque joueur
      final playerGrids = <Map<String, dynamic>>[];
      for (int i = 0; i < room.playerIds.length; i++) {
        final playerId = room.playerIds[i];
        final grid = GridGenerator.generateInitialGrid(seed: seed + i);
        
        playerGrids.add({
          'game_state_id': gameId,
          'player_id': playerId,
          'position': i,
          'grid_cards': json.encode(grid),
          'action_cards': json.encode([]),
          'score': 0,
          'is_ready': false,
          'is_active': true,
          'has_revealed_all': false,
        });
      }

      // Insérer tous les player_grids en une seule requête
      await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase
            .from('player_grids')
            .insert(playerGrids),
        operation: 'create_player_grids',
        context: {
          'game_id': gameId,
          'player_count': playerGrids.length,
        },
      );

      // Mettre à jour la room avec le game_id
      await updateRoomStatus(
        roomId: roomId,
        status: 'in_game',
        gameId: gameId,
      );

      return gameId;
    } catch (e) {
      // En cas d'erreur, essayer de nettoyer manuellement
      if (gameId != null) {
        try {
          // Nettoyer en utilisant une transaction
          await SupabaseExceptionHandler.handleSupabaseCall(
            call: () async {
              // Supprimer les player_grids
              await _supabase
                  .from('player_grids')
                  .delete()
                  .eq('game_state_id', gameId as Object);
              
              // Supprimer le game_state
              await _supabase
                  .from('game_states')
                  .delete()
                  .eq('id', gameId as Object);
              
              // Réinitialiser le current_game_id de la room
              await _supabase
                  .from('rooms')
                  .update({
                    'current_game_id': null,
                    'status': 'waiting',
                  })
                  .eq('id', roomId);
              
              // Note: We don't delete players as they might be used in other rooms
              // Only update their current_room_id if needed
              await _supabase
                  .from('players')
                  .update({
                    'current_room_id': null,
                  })
                  .inFilter('id', room.playerIds);
            },
            operation: 'rollback_game_creation',
            context: {
              'room_id': roomId,
              'game_id': gameId,
              'error': e.toString(),
            },
          );
        } catch (rollbackError) {
          // Log l'erreur de rollback mais continuer avec l'erreur originale
          print('Rollback failed: $rollbackError');
        }
      }
      
      throw Exception('Failed to start game: $e');
    }
  }
}
