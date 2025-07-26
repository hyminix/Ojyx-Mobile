import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Service to monitor and manage network connectivity
class ConnectivityService {
  final Connectivity _connectivity;
  
  // Stream subscription for connectivity changes
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  // Stream controller for connectivity status
  final _connectivityStreamController = StreamController<ConnectivityStatus>.broadcast();
  
  // Current connectivity status
  ConnectivityStatus _currentStatus = ConnectivityStatus.unknown;
  
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();
      
  /// Create with a mock connectivity instance (for testing)
  ConnectivityService.createWithConnectivity(Connectivity connectivity)
      : _connectivity = connectivity;

  /// Stream of connectivity status changes
  Stream<ConnectivityStatus> get connectivityStream => _connectivityStreamController.stream;
  
  /// Stream of boolean connectivity status (for backward compatibility)
  Stream<bool> get connectionStream => _connectivityStreamController.stream.map((status) => status.isOnline);
  
  /// Current connectivity status
  ConnectivityStatus get currentStatus => _currentStatus;
  
  /// Check if currently connected to internet
  bool get isConnected => _currentStatus == ConnectivityStatus.online;

  /// Initialize the connectivity service
  Future<void> initialize() async {
    try {
      // Get initial connectivity status
      await checkConnectivity();
      
      // Listen for connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _handleConnectivityChange,
        onError: (error) {
          debugPrint('Connectivity monitoring error: $error');
        },
      );
      
      debugPrint('Connectivity service initialized');
    } catch (e) {
      debugPrint('Failed to initialize connectivity service: $e');
      // Set to unknown but don't throw - app should work offline
      _updateStatus(ConnectivityStatus.unknown);
    }
  }

  /// Check current connectivity status
  Future<ConnectivityStatus> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      
      if (results.isEmpty) {
        _updateStatus(ConnectivityStatus.offline);
        return _currentStatus;
      }
      
      // Check if any result indicates connectivity
      final hasConnectivity = results.any((result) => 
        result != ConnectivityResult.none
      );
      
      if (hasConnectivity) {
        // Verify actual internet connectivity
        final hasInternet = await _verifyInternetConnection();
        _updateStatus(hasInternet ? ConnectivityStatus.online : ConnectivityStatus.offline);
      } else {
        _updateStatus(ConnectivityStatus.offline);
      }
      
      return _currentStatus;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      _updateStatus(ConnectivityStatus.unknown);
      return _currentStatus;
    }
  }

  /// Handle connectivity changes
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    debugPrint('Connectivity changed: $results');
    
    // Re-check connectivity when it changes
    checkConnectivity();
  }

  /// Verify actual internet connection
  /// connectivity_plus only checks if connected to a network, not internet
  Future<bool> _verifyInternetConnection() async {
    try {
      // In a real app, you might ping a reliable server
      // For now, we'll assume network connectivity = internet
      // This could be enhanced with actual HTTP request
      return true;
    } catch (e) {
      debugPrint('Internet verification failed: $e');
      return false;
    }
  }

  /// Update connectivity status
  void _updateStatus(ConnectivityStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _connectivityStreamController.add(status);
      debugPrint('Connectivity status updated: $status');
    }
  }

  /// Dispose of resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityStreamController.close();
  }
}

/// Connectivity status enum
enum ConnectivityStatus {
  /// Connected to internet
  online,
  
  /// Not connected to internet
  offline,
  
  /// Unknown connectivity status
  unknown,
}

/// Extension for user-friendly status messages
extension ConnectivityStatusExtension on ConnectivityStatus {
  String get message {
    switch (this) {
      case ConnectivityStatus.online:
        return 'En ligne';
      case ConnectivityStatus.offline:
        return 'Hors ligne';
      case ConnectivityStatus.unknown:
        return 'Connexion inconnue';
    }
  }
  
  bool get isOnline => this == ConnectivityStatus.online;
  bool get isOffline => this == ConnectivityStatus.offline;
}