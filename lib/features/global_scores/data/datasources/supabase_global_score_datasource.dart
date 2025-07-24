import 'package:ojyx/features/global_scores/data/datasources/global_score_remote_datasource.dart';
import 'package:ojyx/features/global_scores/data/models/global_score_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseGlobalScoreDataSource implements GlobalScoreRemoteDataSource {
  final SupabaseClient _supabase;
  static const String _tableName = 'global_scores';

  SupabaseGlobalScoreDataSource(this._supabase);

  @override
  Future<GlobalScoreModel> saveScore(GlobalScoreModel score) async {
    final response = await _supabase
        .from(_tableName)
        .insert(score.toSupabaseJson())
        .select()
        .single();
    
    return GlobalScoreModel.fromJson(response);
  }

  @override
  Future<List<GlobalScoreModel>> saveBatchScores(List<GlobalScoreModel> scores) async {
    if (scores.isEmpty) return [];

    final data = scores.map((m) => m.toSupabaseJson()).toList();
    
    final response = await _supabase
        .from(_tableName)
        .insert(data)
        .select();
    
    return (response as List)
        .map((json) => GlobalScoreModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<GlobalScoreModel>> getScoresByPlayer(String playerId) async {
    final response = await _supabase
        .from(_tableName)
        .select()
        .eq('player_id', playerId)
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((json) => GlobalScoreModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<GlobalScoreModel>> getScoresByRoom(String roomId) async {
    final response = await _supabase
        .from(_tableName)
        .select()
        .eq('room_id', roomId)
        .order('position', ascending: true);
    
    return (response as List)
        .map((json) => GlobalScoreModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getTopPlayersRaw({int limit = 10}) async {
    final response = await _supabase.rpc('get_top_players', params: {
      'limit_count': limit,
    });

    return response as List<Map<String, dynamic>>;
  }

  @override
  Future<List<GlobalScoreModel>> getRecentGames(String playerId, {int limit = 10}) async {
    final response = await _supabase
        .from(_tableName)
        .select()
        .eq('player_id', playerId)
        .order('created_at', ascending: false)
        .limit(limit);
    
    return (response as List)
        .map((json) => GlobalScoreModel.fromJson(json))
        .toList();
  }

  @override
  Future<bool> deleteScore(String scoreId) async {
    final response = await _supabase
        .from(_tableName)
        .delete()
        .eq('id', scoreId)
        .select();
    
    return (response as List).isNotEmpty;
  }

  @override
  Future<int> deletePlayerData(String playerId) async {
    final response = await _supabase
        .from(_tableName)
        .delete()
        .eq('player_id', playerId)
        .select();
    
    return (response as List).length;
  }
}