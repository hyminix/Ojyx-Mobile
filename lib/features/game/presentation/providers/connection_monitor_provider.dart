import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'optimistic_game_state_notifier.dart';

part 'connection_monitor_provider.g.dart';
part 'connection_monitor_provider.freezed.dart';

/// État de la connexion réseau
enum ConnectionStatus {
  connected,
  disconnected,
  reconnecting,
}

/// État du moniteur de connexion
@freezed
class ConnectionMonitorState with _$ConnectionMonitorState {
  const factory ConnectionMonitorState({
    required ConnectionStatus status,
    DateTime? lastDisconnect,
    DateTime? lastReconnect,
    @Default(0) int reconnectAttempts,
    @Default(false) bool isResynchronizing,
  }) = _ConnectionMonitorState;
  
  factory ConnectionMonitorState.initial() => const ConnectionMonitorState(
    status: ConnectionStatus.connected,
  );
}

/// Moniteur de connexion pour la gestion optimiste
@riverpod
class ConnectionMonitor extends _$ConnectionMonitor {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _reconnectTimer;
  bool _wasDisconnected = false;
  
  @override
  ConnectionMonitorState build() {
    // Démarrer la surveillance
    _startMonitoring();
    
    // Nettoyer à la destruction
    ref.onDispose(() {
      _connectivitySubscription?.cancel();
      _reconnectTimer?.cancel();
    });
    
    return ConnectionMonitorState.initial();
  }
  
  /// Démarre la surveillance de la connexion
  void _startMonitoring() {
    final connectivity = Connectivity();
    
    // Vérifier l'état initial
    connectivity.checkConnectivity().then((results) {
      _handleConnectivityChange(results);
    });
    
    // Écouter les changements
    _connectivitySubscription = connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
      onError: (error) {
        debugPrint('ConnectionMonitor: Error monitoring connectivity - $error');
      },
    );
  }
  
  /// Gère les changements de connectivité
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final hasConnection = results.isNotEmpty && 
        results.any((result) => result != ConnectivityResult.none);
    
    if (hasConnection) {
      _handleConnection();
    } else {
      _handleDisconnection();
    }
  }
  
  /// Gère la connexion réseau
  void _handleConnection() {
    debugPrint('ConnectionMonitor: Network connected');
    
    if (_wasDisconnected) {
      // Reconnexion après déconnexion
      state = state.copyWith(
        status: ConnectionStatus.reconnecting,
        lastReconnect: DateTime.now(),
      );
      
      _wasDisconnected = false;
      _reconnectTimer?.cancel();
      
      // Déclencher la resynchronisation
      _triggerResynchronization();
    } else {
      // Connexion normale
      state = state.copyWith(
        status: ConnectionStatus.connected,
        reconnectAttempts: 0,
      );
    }
  }
  
  /// Gère la perte de connexion
  void _handleDisconnection() {
    debugPrint('ConnectionMonitor: Network disconnected');
    
    if (state.status != ConnectionStatus.disconnected) {
      _wasDisconnected = true;
      
      state = state.copyWith(
        status: ConnectionStatus.disconnected,
        lastDisconnect: DateTime.now(),
      );
      
      // Démarrer les tentatives de reconnexion
      _startReconnectTimer();
    }
  }
  
  /// Démarre le timer de reconnexion
  void _startReconnectTimer() {
    _reconnectTimer?.cancel();
    
    // Vérifier la connexion toutes les 5 secondes
    _reconnectTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      state = state.copyWith(
        reconnectAttempts: state.reconnectAttempts + 1,
      );
      
      // Vérifier manuellement la connexion
      Connectivity().checkConnectivity().then((results) {
        _handleConnectivityChange(results);
      });
    });
  }
  
  /// Déclenche la resynchronisation après reconnexion
  Future<void> _triggerResynchronization() async {
    debugPrint('ConnectionMonitor: Triggering resynchronization');
    
    state = state.copyWith(isResynchronizing: true);
    
    try {
      // Forcer la resynchronisation de l'état optimiste
      final optimisticNotifier = ref.read(optimisticGameStateNotifierProvider.notifier);
      await optimisticNotifier.forceResync();
      
      // Marquer comme connecté
      state = state.copyWith(
        status: ConnectionStatus.connected,
        isResynchronizing: false,
        reconnectAttempts: 0,
      );
      
      debugPrint('ConnectionMonitor: Resynchronization complete');
    } catch (e) {
      debugPrint('ConnectionMonitor: Resynchronization failed - $e');
      
      state = state.copyWith(
        isResynchronizing: false,
      );
      
      // Réessayer dans quelques secondes
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && state.status == ConnectionStatus.reconnecting) {
          _triggerResynchronization();
        }
      });
    }
  }
  
  /// Force une vérification manuelle de la connexion
  Future<void> checkConnection() async {
    final connectivity = Connectivity();
    final results = await connectivity.checkConnectivity();
    _handleConnectivityChange(results);
  }
  
  /// Obtient la durée depuis la dernière déconnexion
  Duration? getTimeSinceDisconnect() {
    if (state.lastDisconnect == null) return null;
    return DateTime.now().difference(state.lastDisconnect!);
  }
  
  /// Indique si la connexion est stable (connectée depuis au moins 10 secondes)
  bool isConnectionStable() {
    if (state.status != ConnectionStatus.connected) return false;
    if (state.lastReconnect == null) return true;
    
    final timeSinceReconnect = DateTime.now().difference(state.lastReconnect!);
    return timeSinceReconnect > const Duration(seconds: 10);
  }
}

/// Provider pour accéder facilement au statut de connexion
@riverpod
ConnectionStatus connectionStatus(ConnectionStatusRef ref) {
  return ref.watch(connectionMonitorProvider.select((state) => state.status));
}

/// Provider pour vérifier si la connexion est stable
@riverpod
bool isConnectionStable(IsConnectionStableRef ref) {
  final monitor = ref.watch(connectionMonitorProvider.notifier);
  return monitor.isConnectionStable();
}

/// Provider pour obtenir le nombre de tentatives de reconnexion
@riverpod
int reconnectAttempts(ReconnectAttemptsRef ref) {
  return ref.watch(connectionMonitorProvider.select((state) => state.reconnectAttempts));
}