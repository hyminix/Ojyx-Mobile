import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/supabase_exceptions.dart';

/// Service pour gérer le heartbeat des joueurs
class HeartbeatService {
  final SupabaseClient _supabase;
  Timer? _heartbeatTimer;
  final Duration _heartbeatInterval = const Duration(seconds: 30);
  final Duration _disconnectTimeout = const Duration(minutes: 2);
  String? _currentPlayerId;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  HeartbeatService(this._supabase);

  /// Démarre le heartbeat pour un joueur
  void startHeartbeat(String playerId) {
    _currentPlayerId = playerId;
    _retryCount = 0;
    
    // Mettre à jour immédiatement le statut à connecté
    _updatePlayerStatus(playerId, 'connected');
    
    // Démarrer le timer périodique
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      _sendHeartbeat();
    });
  }

  /// Arrête le heartbeat
  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    
    // Mettre à jour le statut à déconnecté
    if (_currentPlayerId != null) {
      _updatePlayerStatus(_currentPlayerId!, 'disconnected');
    }
    _currentPlayerId = null;
  }

  /// Envoie un heartbeat
  Future<void> _sendHeartbeat() async {
    if (_currentPlayerId == null) return;

    try {
      await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase
            .from('players')
            .update({
              'last_seen_at': DateTime.now().toIso8601String(),
              'connection_status': 'connected',
            })
            .eq('id', _currentPlayerId!),
        operation: 'heartbeat',
        context: {'player_id': _currentPlayerId},
      );
      
      // Réinitialiser le compteur de retry en cas de succès
      _retryCount = 0;
    } catch (e) {
      _retryCount++;
      
      if (_retryCount >= _maxRetries) {
        // Arrêter le heartbeat après trop d'échecs
        stopHeartbeat();
        throw Exception('Heartbeat failed after $_maxRetries attempts');
      }
      
      // Retry avec un délai exponentiel
      await Future.delayed(Duration(seconds: _retryCount * 2));
      _sendHeartbeat();
    }
  }

  /// Met à jour le statut de connexion d'un joueur
  Future<void> _updatePlayerStatus(String playerId, String status) async {
    try {
      await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase
            .from('players')
            .update({
              'connection_status': status,
              'last_seen_at': DateTime.now().toIso8601String(),
            })
            .eq('id', playerId),
        operation: 'update_connection_status',
        context: {
          'player_id': playerId,
          'status': status,
        },
      );
    } catch (e) {
      // Log l'erreur mais ne pas interrompre l'application
      print('Failed to update player status: $e');
    }
  }

  /// Vérifie si un joueur est considéré comme déconnecté
  static bool isPlayerDisconnected(DateTime lastSeenAt) {
    return DateTime.now().difference(lastSeenAt) > const Duration(minutes: 2);
  }

  void dispose() {
    stopHeartbeat();
  }
}
