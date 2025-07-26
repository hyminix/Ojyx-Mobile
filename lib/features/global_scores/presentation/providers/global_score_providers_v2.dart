import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';
import 'package:ojyx/features/global_scores/data/datasources/supabase_global_score_datasource.dart';
import 'package:ojyx/features/global_scores/data/repositories/supabase_global_score_repository.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/save_global_score.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/get_player_stats.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/get_top_players.dart';

part 'global_score_providers_v2.g.dart';

// Repository Provider
@Riverpod(keepAlive: true)
GlobalScoreRepository globalScoreRepository(GlobalScoreRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseGlobalScoreDataSource(supabase);
  return SupabaseGlobalScoreRepository(dataSource);
}

// Use Case Providers
@Riverpod(keepAlive: true)
SaveGlobalScoreUseCase saveGlobalScoreUseCase(SaveGlobalScoreUseCaseRef ref) {
  final repository = ref.watch(globalScoreRepositoryProvider);
  return SaveGlobalScoreUseCase(repository);
}

@Riverpod(keepAlive: true)
GetPlayerStatsUseCase getPlayerStatsUseCase(GetPlayerStatsUseCaseRef ref) {
  final repository = ref.watch(globalScoreRepositoryProvider);
  return GetPlayerStatsUseCase(repository);
}

@Riverpod(keepAlive: true)
GetTopPlayersUseCase getTopPlayersUseCase(GetTopPlayersUseCaseRef ref) {
  final repository = ref.watch(globalScoreRepositoryProvider);
  return GetTopPlayersUseCase(repository);
}

// Data Providers with AsyncNotifier
@riverpod
class PlayerStatsNotifier extends _$PlayerStatsNotifier {
  @override
  Future<PlayerStats?> build(String playerId) async {
    final useCase = ref.watch(getPlayerStatsUseCaseProvider);
    final result = await useCase(GetPlayerStatsParams(playerId: playerId));

    return result.fold((failure) => throw Exception(failure), (stats) => stats);
  }
}

@riverpod
class TopPlayersNotifier extends _$TopPlayersNotifier {
  @override
  Future<List<PlayerStats>> build() async {
    final useCase = ref.watch(getTopPlayersUseCaseProvider);
    final result = await useCase(const GetTopPlayersParams());

    return result.fold(
      (failure) => throw Exception(failure),
      (players) => players,
    );
  }
}

@riverpod
class RecentGamesNotifier extends _$RecentGamesNotifier {
  @override
  Future<List<GlobalScore>> build(String playerId) async {
    final repository = ref.watch(globalScoreRepositoryProvider);
    return await repository.getRecentGames(playerId, limit: 10);
  }
}

@riverpod
class RoomScoresNotifier extends _$RoomScoresNotifier {
  @override
  Future<List<GlobalScore>> build(String roomId) async {
    final repository = ref.watch(globalScoreRepositoryProvider);
    return await repository.getScoresByRoom(roomId);
  }
}

// Backward compatibility aliases
final playerStatsProvider = playerStatsNotifierProvider;
final topPlayersProvider = topPlayersNotifierProvider;
final recentGamesProvider = recentGamesNotifierProvider;
final roomScoresProvider = roomScoresNotifierProvider;
