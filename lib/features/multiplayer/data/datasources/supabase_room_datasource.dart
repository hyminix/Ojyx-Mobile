import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/room_model.dart';
import '../../domain/entities/room_event.dart';
import '../../../game/data/models/game_state_model.dart';

class SupabaseRoomDatasource {
  final SupabaseClient _supabase;

  SupabaseRoomDatasource(this._supabase);

  Future<RoomModel> createRoom({
    required String creatorId,
    required int maxPlayers,
  }) async {
    final response = await _supabase
        .from('rooms')
        .insert({
          'creator_id': creatorId,
          'player_ids': [creatorId],
          'status': 'waiting',
          'max_players': maxPlayers,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return RoomModel.fromJson(response);
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

    final response = await _supabase
        .from('rooms')
        .update({
          'player_ids': updatedPlayerIds,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', roomId)
        .select()
        .single();

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

    await _supabase
        .from('rooms')
        .update({
          'player_ids': updatedPlayerIds,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', roomId);
  }

  Future<RoomModel?> getRoom(String roomId) async {
    try {
      final response = await _supabase
          .from('rooms')
          .select()
          .eq('id', roomId)
          .single();

      return RoomModel.fromJson(response);
    } catch (e) {
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
    await _supabase.from('room_events').insert({
      'room_id': roomId,
      'event_type': eventData['type'],
      'event_data': eventData,
      'created_at': DateTime.now().toIso8601String(),
    });
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
    final response = await _supabase
        .from('rooms')
        .select()
        .eq('status', 'waiting')
        .order('created_at', ascending: false);

    return (response as List).map((json) => RoomModel.fromJson(json)).toList();
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

    await _supabase.from('rooms').update(updates).eq('id', roomId);
  }
}
