import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';
import 'package:ojyx/features/global_scores/data/datasources/supabase_global_score_datasource.dart';
import 'package:ojyx/features/global_scores/data/repositories/supabase_global_score_repository.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/save_global_score.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/get_player_stats.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/get_top_players.dart';

// Repository Provider
final globalScoreRepositoryProvider = Provider<GlobalScoreRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseGlobalScoreDataSource(supabase);
  return SupabaseGlobalScoreRepository(dataSource);
});

// Use Case Providers
final saveGlobalScoreUseCaseProvider = Provider<SaveGlobalScoreUseCase>((ref) {
  final repository = ref.watch(globalScoreRepositoryProvider);
  return SaveGlobalScoreUseCase(repository);
});

final getPlayerStatsUseCaseProvider = Provider<GetPlayerStatsUseCase>((ref) {
  final repository = ref.watch(globalScoreRepositoryProvider);
  return GetPlayerStatsUseCase(repository);
});

final getTopPlayersUseCaseProvider = Provider<GetTopPlayersUseCase>((ref) {
  final repository = ref.watch(globalScoreRepositoryProvider);
  return GetTopPlayersUseCase(repository);
});

// Data Providers
final playerStatsProvider = FutureProvider.family<PlayerStats?, String>((
  ref,
  playerId,
) async {
  final useCase = ref.watch(getPlayerStatsUseCaseProvider);
  final result = await useCase(GetPlayerStatsParams(playerId: playerId));

  return result.fold((failure) => throw Exception(failure), (stats) => stats);
});

final topPlayersProvider = FutureProvider<List<PlayerStats>>((ref) async {
  final useCase = ref.watch(getTopPlayersUseCaseProvider);
  final result = await useCase(const GetTopPlayersParams());

  return result.fold(
    (failure) => throw Exception(failure),
    (players) => players,
  );
});

final recentGamesProvider = FutureProvider.family<List<GlobalScore>, String>((
  ref,
  playerId,
) async {
  final repository = ref.watch(globalScoreRepositoryProvider);
  return await repository.getRecentGames(playerId, limit: 10);
});

// Room Scores Provider - for a specific game room
final roomScoresProvider = FutureProvider.family<List<GlobalScore>, String>((
  ref,
  roomId,
) async {
  final repository = ref.watch(globalScoreRepositoryProvider);
  return await repository.getScoresByRoom(roomId);
});
