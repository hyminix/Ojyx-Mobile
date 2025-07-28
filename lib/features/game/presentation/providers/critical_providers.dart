import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/entities/game_state.dart';
import '../../data/services/heartbeat_service.dart';
import 'game_providers.dart';

part 'critical_providers.g.dart';

/// Critical providers that should survive widget disposal
/// These providers maintain important state that shouldn't be lost during navigation

/// Provider for HeartbeatService that keeps alive
/// This ensures heartbeat continues even when navigating between screens
@Riverpod(keepAlive: true)
class CriticalHeartbeatServiceManager extends _$CriticalHeartbeatServiceManager {
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

/// Provider for critical game state management
/// Keeps game state alive during navigation to prevent state loss
@Riverpod(keepAlive: true)
class CriticalGameStateManager extends _$CriticalGameStateManager {
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
  
  /// Manually dispose when game ends
  void disposeGame() {
    // Clean up resources when game is truly finished
    ref.invalidateSelf();
  }
}

/// Provider for active game tracking
/// Keeps track of which games are currently active to manage lifecycle
@Riverpod(keepAlive: true)
class ActiveGamesTracker extends _$ActiveGamesTracker {
  @override
  Set<String> build() => {};
  
  void addGame(String gameId) {
    state = {...state, gameId};
  }
  
  void removeGame(String gameId) {
    state = {...state}..remove(gameId);
    
    // Invalidate the game state when removed
    ref.invalidate(criticalGameStateManagerProvider(gameId));
  }
  
  bool isGameActive(String gameId) => state.contains(gameId);
}