import 'package:supabase_flutter/supabase_flutter.dart';
import 'player_datasource.dart';
import '../models/player_model.dart';

class SupabasePlayerDataSource implements PlayerDataSource {
  final SupabaseClient _supabase;

  SupabasePlayerDataSource(this._supabase);

  @override
  Future<PlayerModel> createPlayer({
    required String name,
    String? avatarUrl,
    String? currentRoomId,
  }) async {
    final data = {
      'name': name,
      'avatar_url': avatarUrl,
      'current_room_id': currentRoomId,
      'connection_status': 'online',
    };

    final response = await _supabase
        .from('players')
        .insert(data)
        .select()
        .single();

    return PlayerModel.fromJson(response);
  }

  @override
  Future<PlayerModel?> getPlayer(String playerId) async {
    try {
      final response = await _supabase
          .from('players')
          .select()
          .eq('id', playerId)
          .single();

      return PlayerModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<PlayerModel> updatePlayer(PlayerModel player) async {
    final response = await _supabase
        .from('players')
        .update(player.toSupabaseJson())
        .eq('id', player.id)
        .select()
        .single();

    return PlayerModel.fromJson(response);
  }

  @override
  Future<void> deletePlayer(String playerId) async {
    await _supabase
        .from('players')
        .delete()
        .eq('id', playerId);
  }

  @override
  Future<List<PlayerModel>> getPlayersByRoom(String roomId) async {
    final response = await _supabase
        .from('players')
        .select()
        .eq('current_room_id', roomId)
        .order('created_at');

    return (response as List)
        .map((json) => PlayerModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> updateConnectionStatus({
    required String playerId,
    required String status,
  }) async {
    await _supabase
        .from('players')
        .update({
          'connection_status': status,
          'last_seen_at': DateTime.now().toIso8601String(),
        })
        .eq('id', playerId);
  }

  @override
  Future<void> updateLastSeen(String playerId) async {
    await _supabase
        .from('players')
        .update({
          'last_seen_at': DateTime.now().toIso8601String(),
        })
        .eq('id', playerId);
  }

  @override
  Stream<PlayerModel> watchPlayer(String playerId) {
    return _supabase
        .from('players')
        .stream(primaryKey: ['id'])
        .eq('id', playerId)
        .map((data) => PlayerModel.fromJson(data.first));
  }

  @override
  Stream<List<PlayerModel>> watchPlayersInRoom(String roomId) {
    return _supabase
        .from('players')
        .stream(primaryKey: ['id'])
        .eq('current_room_id', roomId)
        .order('created_at')
        .map((data) => data
            .map((json) => PlayerModel.fromJson(json))
            .toList());
  }
}