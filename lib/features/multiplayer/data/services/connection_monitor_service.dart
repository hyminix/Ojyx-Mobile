import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/supabase_exceptions.dart';

/// Service to monitor network connection and handle disconnections/reconnections
class ConnectionMonitorService {
  final SupabaseClient _supabase;
  final GoRouter _router;
  
  Timer? _connectionCheckTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isDisconnected = false;
  DateTime? _disconnectedAt;
  
  /// Singleton instance
  static ConnectionMonitorService? _instance;
  
  ConnectionMonitorService._({
    required SupabaseClient supabase,
    required GoRouter router,
  }) : _supabase = supabase,
       _router = router;
  
  /// Get or create singleton instance
  factory ConnectionMonitorService({
    required SupabaseClient supabase,
    required GoRouter router,
  }) {
    _instance ??= ConnectionMonitorService._(
      supabase: supabase,
      router: router,
    );
    return _instance!;
  }
  
  /// Start monitoring connection
  void startMonitoring() {
    debugPrint('ConnectionMonitor: Starting monitoring');
    
    // Listen to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _handleConnectivityChange(results);
      },
    );
    
    // Check WebSocket connection periodically
    _connectionCheckTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _checkRealtimeConnection(),
    );
  }
  
  /// Stop monitoring
  void stopMonitoring() {
    debugPrint('ConnectionMonitor: Stopping monitoring');
    _connectionCheckTimer?.cancel();
    _connectivitySubscription?.cancel();
  }
  
  /// Handle connectivity changes
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final hasConnection = results.any((result) => result != ConnectivityResult.none);
    
    debugPrint('ConnectionMonitor: Connectivity changed - hasConnection: $hasConnection');
    
    if (!hasConnection && !_isDisconnected) {
      _handleDisconnection();
    } else if (hasConnection && _isDisconnected) {
      _handleReconnection();
    }
  }
  
  /// Check realtime connection status
  void _checkRealtimeConnection() {
    // Check if user is authenticated
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    
    // Check WebSocket connection
    final isConnected = _isRealtimeConnected();
    
    if (!isConnected && !_isDisconnected) {
      debugPrint('ConnectionMonitor: WebSocket disconnected');
      _handleDisconnection();
    } else if (isConnected && _isDisconnected) {
      debugPrint('ConnectionMonitor: WebSocket reconnected');
      _handleReconnection();
    }
  }
  
  /// Check if realtime is connected
  bool _isRealtimeConnected() {
    // Supabase doesn't expose direct connection state
    // We'll rely on connectivity and manual disconnect tracking
    return !_isDisconnected;
  }
  
  /// Handle disconnection
  Future<void> _handleDisconnection() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    
    debugPrint('ConnectionMonitor: Handling disconnection for user $userId');
    
    _isDisconnected = true;
    _disconnectedAt = DateTime.now();
    
    try {
      // Mark player as disconnected in database
      await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase.rpc(
          'mark_player_disconnected',
          params: {
            'p_player_id': userId,
          },
        ),
        operation: 'mark_player_disconnected',
        context: {
          'user_id': userId,
        },
      );
    } catch (e) {
      debugPrint('ConnectionMonitor: Failed to mark disconnection: $e');
    }
  }
  
  /// Handle reconnection
  Future<void> _handleReconnection() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    
    debugPrint('ConnectionMonitor: Handling reconnection for user $userId');
    
    try {
      // Try to reconnect player
      final response = await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase.rpc(
          'handle_player_reconnection',
          params: {
            'p_player_id': userId,
          },
        ),
        operation: 'handle_player_reconnection',
        context: {
          'user_id': userId,
        },
      );
      
      _isDisconnected = false;
      _disconnectedAt = null;
      
      if (response['success'] == true) {
        debugPrint('ConnectionMonitor: Reconnection successful');
        
        // Navigate back to room or game
        final roomId = response['room_id'];
        final gameId = response['game_id'];
        final roomStatus = response['room_status'];
        
        if (gameId != null && roomStatus == 'in_game') {
          // Return to game
          debugPrint('ConnectionMonitor: Navigating to game $gameId');
          _router.go('/game/$gameId');
        } else if (roomId != null && roomStatus == 'waiting') {
          // Return to room lobby
          debugPrint('ConnectionMonitor: Navigating to room $roomId');
          _router.go('/room/$roomId');
        }
      } else {
        debugPrint('ConnectionMonitor: Reconnection failed - ${response['reason']}');
        
        // If timeout expired, navigate to home
        if (response['reason'] == 'Timeout expired') {
          _showTimeoutMessage();
          _router.go('/');
        }
      }
    } catch (e) {
      debugPrint('ConnectionMonitor: Reconnection error: $e');
      _isDisconnected = false;
    }
  }
  
  /// Show timeout message
  void _showTimeoutMessage() {
    // This would normally show a snackbar or dialog
    // For now, just log it
    debugPrint('ConnectionMonitor: Session timeout - returning to home');
  }
  
  /// Get current connection status
  bool get isConnected => !_isDisconnected;
  
  /// Get disconnection duration
  Duration? get disconnectionDuration {
    if (_disconnectedAt == null) return null;
    return DateTime.now().difference(_disconnectedAt!);
  }
  
  /// Dispose of resources
  void dispose() {
    stopMonitoring();
    _instance = null;
  }
}