import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/entities/game_state.dart';
import '../../data/services/heartbeat_service.dart';

part 'game_providers.g.dart';

/// Provider pour l'instance Supabase
@riverpod
SupabaseClient supabase(SupabaseRef ref) {
  return Supabase.instance.client;
}

/// Provider pour le GameRepository
@riverpod
GameRepository gameRepository(GameRepositoryRef ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  return GameRepositoryImpl(supabaseClient);
}

/// Provider pour le HeartbeatService
@riverpod
class HeartbeatServiceManager extends _$HeartbeatServiceManager {
  HeartbeatService? _service;

  @override
  void build() {
    final supabaseClient = ref.watch(supabaseProvider);
    _service = HeartbeatService(supabaseClient);
    
    ref.onDispose(() {
      _service?.dispose();
    });
  }
  
  void startHeartbeat(String playerId) {
    _service?.startHeartbeat(playerId);
  }
  
  void stopHeartbeat() {
    _service?.stopHeartbeat();
  }
}

/// Provider pour charger un jeu par son ID
@riverpod
Future<GameState?> gameLoader(GameLoaderRef ref, String gameId) async {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.loadGame(gameId);
}

/// Provider pour écouter les changements d'un jeu en temps réel
@riverpod
Stream<GameState> gameStream(GameStreamRef ref, String gameId) {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.watchGame(gameId);
}

/// Provider pour gérer l'état du jeu avec le nouveau système
@riverpod
class GameStateManager extends _$GameStateManager {
  @override
  Future<GameState?> build(String gameId) async {
    // Charger l'état initial
    final repository = ref.watch(gameRepositoryProvider);
    final initialState = await repository.loadGame(gameId);
    
    // Écouter les changements
    ref.listen(gameStreamProvider(gameId), (previous, next) {
      next.when(
        data: (gameState) => state = AsyncData(gameState),
        error: (error, stack) => state = AsyncError(error, stack),
        loading: () => state = const AsyncLoading(),
      );
    });
    
    return initialState;
  }
  
  Future<void> updatePlayerGrid(String playerId, List<dynamic> gridCards) async {
    final repository = ref.read(gameRepositoryProvider);
    final currentState = state.valueOrNull;
    if (currentState == null) return;
    
    await repository.updatePlayerGrid(
      gameId: currentState.roomId,
      playerId: playerId,
      gridCards: gridCards.cast(),
    );
  }
  
  Future<void> submitAction({
    required String playerId,
    required String actionType,
    required Map<String, dynamic> actionData,
  }) async {
    final repository = ref.read(gameRepositoryProvider);
    final currentState = state.valueOrNull;
    if (currentState == null) return;
    
    await repository.submitAction(
      gameId: currentState.roomId,
      playerId: playerId,
      actionType: actionType,
      actionData: actionData,
    );
  }
}
