import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/supabase_exceptions.dart';

/// Service responsible for sending periodic heartbeats to keep a room alive
/// and detect stale/inactive rooms
class RoomHeartbeatService {
  final SupabaseClient _supabase;
  Timer? _heartbeatTimer;
  String? _currentRoomId;
  bool _isActive = false;
  
  /// How often to send heartbeat signals
  static const Duration heartbeatInterval = Duration(seconds: 30);
  
  /// After this duration without heartbeat, a room is considered stale
  static const Duration staleThreshold = Duration(minutes: 2);
  
  RoomHeartbeatService(this._supabase);
  
  /// Start sending heartbeats for a specific room
  void startHeartbeat(String roomId) {
    debugPrint('Starting heartbeat for room: $roomId');
    
    // Stop any existing heartbeat
    stopHeartbeat();
    
    _currentRoomId = roomId;
    _isActive = true;
    
    // Send immediate heartbeat
    _sendHeartbeat();
    
    // Schedule periodic heartbeats
    _heartbeatTimer = Timer.periodic(heartbeatInterval, (_) {
      if (_isActive && _currentRoomId != null) {
        _sendHeartbeat();
      }
    });
  }
  
  /// Stop sending heartbeats
  void stopHeartbeat() {
    debugPrint('Stopping heartbeat for room: $_currentRoomId');
    
    _isActive = false;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _currentRoomId = null;
  }
  
  /// Pause heartbeats temporarily (e.g., when app goes to background)
  void pauseHeartbeat() {
    debugPrint('Pausing heartbeat');
    _isActive = false;
  }
  
  /// Resume heartbeats (e.g., when app returns to foreground)
  void resumeHeartbeat() {
    if (_currentRoomId != null) {
      debugPrint('Resuming heartbeat for room: $_currentRoomId');
      _isActive = true;
      // Send immediate heartbeat on resume
      _sendHeartbeat();
    }
  }
  
  /// Send a single heartbeat update
  Future<void> _sendHeartbeat() async {
    if (!_isActive || _currentRoomId == null) return;
    
    try {
      final result = await SupabaseExceptionHandler.handleSupabaseCall(
        call: () => _supabase.rpc(
          'update_room_heartbeat',
          params: {
            'p_room_id': _currentRoomId,
          },
        ),
        operation: 'update_room_heartbeat',
        context: {
          'room_id': _currentRoomId,
        },
      );
      
      if (result['success'] == true) {
        debugPrint('Heartbeat sent successfully for room: $_currentRoomId');
      } else {
        debugPrint('Heartbeat failed: ${result['error']}');
        // If room not found, stop heartbeat
        if (result['error'] == 'Room not found') {
          stopHeartbeat();
        }
      }
    } catch (e) {
      debugPrint('Heartbeat error: $e');
      // Don't stop heartbeat on network errors - will retry on next interval
    }
  }
  
  /// Check if heartbeat is currently active
  bool get isActive => _isActive && _currentRoomId != null;
  
  /// Get the current room ID being monitored
  String? get currentRoomId => _currentRoomId;
  
  /// Dispose of resources
  void dispose() {
    stopHeartbeat();
  }
}