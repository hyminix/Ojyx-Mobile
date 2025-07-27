import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/supabase_exceptions.dart';
import '../../../../core/extensions/supabase_extensions.dart';
import '../models/room_model.dart';

class SupabaseRoomDatasource {
  final SupabaseClient _supabase;

  SupabaseRoomDatasource(this._supabase);

  Future<RoomModel> createRoom({
    required String creatorId,
    required int maxPlayers,
  }) async {
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

    final updatedPlayerIds = [...room.playerIds, playerId];

    final response = await SupabaseExceptionHandler.handleSupabaseCall(
      call: () => _supabase
          .from('rooms')
          .update({
            'player_ids': updatedPlayerIds,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', roomId)
          .select()
          .single(),
      operation: 'join_room',
      context: {
        'room_id': roomId,
        'player_id': playerId,
        'current_players': room.playerIds.length,
        'max_players': room.maxPlayers,
      },
    );

    return RoomModel.fromJson(response);
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
}
