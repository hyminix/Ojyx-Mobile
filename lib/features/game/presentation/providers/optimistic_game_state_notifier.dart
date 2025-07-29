import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/optimistic_state.dart';
import '../../domain/entities/optimistic_action.dart';
import '../../domain/entities/optimistic_actions.dart';
import '../../domain/entities/card.dart';
import '../../../multiplayer/presentation/providers/room_providers.dart';
import '../../../multiplayer/data/services/game_sync_service.dart';
import '../../../../core/providers/supabase_provider.dart';
import 'optimistic_action_storage.dart';
import 'connection_monitor_provider.dart';

part 'optimistic_game_state_notifier.g.dart';

/// Notifier pour gérer l'état optimiste du jeu avec synchronisation
@riverpod
class OptimisticGameStateNotifier extends _$OptimisticGameStateNotifier {
  Timer? _syncDebouncer;
  final _syncQueue = Queue<OptimisticAction>();
  final _processingActions = <String, bool>{};
  late final OptimisticActionStorage _storage;
  StreamSubscription? _connectionSubscription;
  
  @override
  OptimisticState<GameState> build() {
    _storage = ref.watch(optimisticActionStorageProvider);
    _setupConnectionListener();
    
    // Charger les actions en attente au démarrage
    _loadPendingActions();
    
    return OptimisticState(
      localValue: GameState.initial(),
      serverValue: GameState.initial(),
      lastSyncAttempt: DateTime.now(),
    );
  }
  
  /// Applique une action de manière optimiste
  Future<void> applyOptimisticAction(OptimisticAction action) async {
    debugPrint('OptimisticGameState: Applying action ${action.type}');
    
    // Vérifier si l'action peut être appliquée
    if (!action.canApply(state.localValue)) {
      debugPrint('OptimisticGameState: Action cannot be applied');
      _showError('Cette action n\'est pas possible actuellement');
      return;
    }
    
    // Éviter les doublons
    if (_processingActions[action.id] == true) {
      debugPrint('OptimisticGameState: Action already processing');
      return;
    }
    
    _processingActions[action.id] = true;
    
    try {
      // 1. Appliquer immédiatement localement
      final newLocalState = action.apply(state.localValue);
      state = state.copyWith(
        localValue: newLocalState,
        isSyncing: true,
        pendingActionsCount: state.pendingActionsCount + 1,
      );
      
      // 2. Sauvegarder l'action localement
      await _storage.savePendingAction(action);
      
      // 3. Ajouter à la queue de synchronisation
      _syncQueue.add(action);
      
      // 4. Debouncer pour grouper les actions
      _syncDebouncer?.cancel();
      _syncDebouncer = Timer(
        const Duration(milliseconds: 300),
        _processSyncQueue,
      );
    } catch (e) {
      debugPrint('OptimisticGameState: Error applying action - $e');
      _processingActions.remove(action.id);
      _showError('Erreur lors de l\'application de l\'action');
    }
  }
  
  /// Traite la queue de synchronisation
  Future<void> _processSyncQueue() async {
    debugPrint('OptimisticGameState: Processing sync queue (${_syncQueue.length} actions)');
    
    // Trier par priorité
    final sortedActions = _syncQueue.toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
    
    _syncQueue.clear();
    
    for (final action in sortedActions) {
      if (!mounted) break;
      
      try {
        // Envoyer au serveur via GameSyncService
        await _syncWithServer(action);
        
        // Retirer de la liste des actions en attente
        await _storage.removePendingAction(action.id);
        _processingActions.remove(action.id);
        
        // Mettre à jour le compteur
        state = state.copyWith(
          pendingActionsCount: state.pendingActionsCount - 1,
          lastSyncedActionId: action.id,
          syncError: null,
        );
      } catch (e) {
        debugPrint('OptimisticGameState: Sync failed for ${action.type} - $e');
        await _handleSyncError(action, e);
      }
    }
    
    // Fin de la synchronisation
    if (mounted && _syncQueue.isEmpty) {
      state = state.copyWith(
        isSyncing: false,
        lastSyncAttempt: DateTime.now(),
      );
    }
  }
  
  /// Synchronise une action avec le serveur
  Future<void> _syncWithServer(OptimisticAction action) async {
    final gameSyncController = ref.read(gameSyncControllerProvider.notifier);
    
    switch (action.type) {
      case 'reveal_card':
        final revealAction = action as RevealCardAction;
        await gameSyncController.revealCard(
          playerId: revealAction.playerId,
          row: revealAction.row,
          col: revealAction.col,
          card: revealAction.expectedCard ?? Card.unknown(),
        );
        break;
        
      case 'play_action_card':
        final playAction = action as PlayActionCardAction;
        await gameSyncController.playActionCard(
          playerId: playAction.playerId,
          actionCard: playAction.actionCard,
          actionData: playAction.actionData,
        );
        break;
        
      case 'end_turn':
        final endTurnAction = action as EndTurnAction;
        await gameSyncController.notifyTurnChange(
          previousPlayerId: state.localValue.currentPlayer.id,
          currentPlayerId: state.localValue.players[state.localValue.getNextPlayerIndex()].id,
          turnNumber: state.localValue.turnNumber + 1,
        );
        break;
        
      default:
        throw Exception('Unknown action type: ${action.type}');
    }
  }
  
  /// Gère les erreurs de synchronisation
  Future<void> _handleSyncError(OptimisticAction action, dynamic error) async {
    debugPrint('OptimisticGameState: Handling sync error for ${action.type}');
    
    // Retirer l'action de la liste de traitement
    _processingActions.remove(action.id);
    
    // Si l'action peut être réessayée
    if (action.isRetryable && !action.hasReachedMaxRetries) {
      debugPrint('OptimisticGameState: Scheduling retry (attempt ${action.retryCount + 1})');
      
      // Programmer un retry avec backoff exponentiel
      final delay = Duration(milliseconds: action.retryDelayMs);
      Future.delayed(delay, () {
        if (mounted) {
          applyOptimisticAction(action.withRetry());
        }
      });
    } else {
      // Échec définitif - Rollback
      debugPrint('OptimisticGameState: Permanent failure, rolling back');
      
      await _rollbackToServerState();
      await _storage.removePendingAction(action.id);
      
      state = state.copyWith(
        syncError: 'Échec de synchronisation: ${error.toString()}',
        pendingActionsCount: state.pendingActionsCount - 1,
      );
      
      _showError('Action non synchronisée. Retour à l\'état précédent.');
    }
  }
  
  /// Effectue un rollback vers l'état serveur
  Future<void> _rollbackToServerState() async {
    if (state.serverValue != null) {
      state = state.copyWith(
        localValue: state.serverValue!,
        isSyncing: false,
      );
      
      // Vider la queue et les actions en attente
      _syncQueue.clear();
      await _storage.clearAllPendingActions();
    }
  }
  
  /// Met à jour l'état serveur confirmé
  void updateServerState(GameState serverState) {
    debugPrint('OptimisticGameState: Updating server state');
    
    state = state.copyWith(
      serverValue: serverState,
      // Si pas d'actions en attente, synchroniser l'état local aussi
      localValue: state.pendingActionsCount == 0 ? serverState : state.localValue,
    );
  }
  
  /// Configure l'écoute de la connexion
  void _setupConnectionListener() {
    // Écouter les changements de connexion
    ref.listen(connectionStatusProvider, (previous, current) {
      debugPrint('OptimisticGameState: Connection status changed from $previous to $current');
      
      if (previous == ConnectionStatus.disconnected && current == ConnectionStatus.connected) {
        // Reconnexion détectée - forcer la resynchronisation
        debugPrint('OptimisticGameState: Reconnection detected, forcing resync');
        forceResync();
      }
    });
  }
  
  /// Charge les actions en attente depuis le stockage local
  Future<void> _loadPendingActions() async {
    try {
      final pendingActions = await _storage.loadPendingActions();
      
      if (pendingActions.isNotEmpty) {
        debugPrint('OptimisticGameState: Loading ${pendingActions.length} pending actions');
        
        for (final action in pendingActions) {
          _syncQueue.add(action);
        }
        
        state = state.copyWith(
          pendingActionsCount: pendingActions.length,
        );
        
        // Déclencher la synchronisation
        _processSyncQueue();
      }
    } catch (e) {
      debugPrint('OptimisticGameState: Error loading pending actions - $e');
    }
  }
  
  /// Affiche une erreur à l'utilisateur
  void _showError(String message) {
    // Sera implémenté avec un système de notification/snackbar
    debugPrint('OptimisticGameState: ERROR - $message');
  }
  
  /// Force une resynchronisation complète
  Future<void> forceResync() async {
    debugPrint('OptimisticGameState: Forcing resync');
    
    // Recharger depuis le serveur
    // Sera implémenté avec l'intégration complète
    state = state.copyWith(
      isSyncing: true,
      lastSyncAttempt: DateTime.now(),
    );
    
    await _processSyncQueue();
  }
  
  @override
  void dispose() {
    _syncDebouncer?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }
}

/// Provider pour accéder facilement à l'état local
@riverpod
GameState optimisticGameState(OptimisticGameStateRef ref) {
  final optimisticState = ref.watch(optimisticGameStateNotifierProvider);
  return optimisticState.localValue;
}

/// Provider pour accéder au statut de synchronisation
@riverpod
bool isGameStateSyncing(IsGameStateSyncingRef ref) {
  final optimisticState = ref.watch(optimisticGameStateNotifierProvider);
  return optimisticState.isSyncing;
}

/// Provider pour accéder aux erreurs de synchronisation
@riverpod
String? gameSyncError(GameSyncErrorRef ref) {
  final optimisticState = ref.watch(optimisticGameStateNotifierProvider);
  return optimisticState.syncError;
}