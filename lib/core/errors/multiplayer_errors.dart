/// Erreurs spécifiques au système multijoueur
class MultiplayerSyncException implements Exception {
  final String message;
  final String? roomId;
  final String? playerId;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;
  
  MultiplayerSyncException({
    required this.message,
    this.roomId,
    this.playerId,
    this.metadata,
  }) : timestamp = DateTime.now();
  
  @override
  String toString() => 'MultiplayerSyncException: $message';
  
  Map<String, dynamic> toJson() => {
    'message': message,
    'room_id': roomId,
    'player_id': playerId,
    'metadata': metadata,
    'timestamp': timestamp.toIso8601String(),
    'type': 'sync_exception',
  };
}

/// Représente une incohérence détectée dans les données multijoueur
class MultiplayerInconsistency {
  final String type;
  final Map<String, dynamic> expected;
  final Map<String, dynamic> actual;
  final String context;
  final String? roomId;
  final String? playerId;
  final String? description;
  final DateTime timestamp;
  final Map<String, dynamic> delta;
  final int deltaCount;
  
  MultiplayerInconsistency({
    required this.type,
    required this.expected,
    required this.actual,
    required this.context,
    this.roomId,
    this.playerId,
    this.description,
  }) : timestamp = DateTime.now(),
       delta = _calculateDelta(expected, actual),
       deltaCount = _countDifferences(expected, actual);
  
  Map<String, dynamic> toJson() => {
    'type': type,
    'expected': expected,
    'actual': actual,
    'context': context,
    'room_id': roomId,
    'player_id': playerId,
    'description': description,
    'timestamp': timestamp.toIso8601String(),
    'delta': delta,
    'delta_count': deltaCount,
    'severity': _getSeverity(),
  };
  
  String _getSeverity() {
    if (deltaCount > 10) return 'critical';
    if (deltaCount > 5) return 'high';
    if (deltaCount > 2) return 'medium';
    return 'low';
  }
  
  /// Calcule les différences entre les valeurs attendues et actuelles
  static Map<String, dynamic> _calculateDelta(
    Map<String, dynamic> expected,
    Map<String, dynamic> actual,
  ) {
    final delta = <String, dynamic>{};
    final allKeys = {...expected.keys, ...actual.keys};
    
    for (final key in allKeys) {
      final expectedValue = expected[key];
      final actualValue = actual[key];
      
      if (expectedValue != actualValue) {
        delta[key] = {
          'expected': expectedValue,
          'actual': actualValue,
          'missing_in_expected': !expected.containsKey(key),
          'missing_in_actual': !actual.containsKey(key),
        };
      }
    }
    
    return delta;
  }
  
  /// Compte le nombre de différences
  static int _countDifferences(
    Map<String, dynamic> expected,
    Map<String, dynamic> actual,
  ) {
    final allKeys = {...expected.keys, ...actual.keys};
    int count = 0;
    
    for (final key in allKeys) {
      if (expected[key] != actual[key]) {
        count++;
      }
    }
    
    return count;
  }
}

/// Erreur de connexion réseau spécifique au multijoueur
class MultiplayerConnectionException implements Exception {
  final String message;
  final String context;
  final String? endpoint;
  final int? statusCode;
  final Duration? timeout;
  final int retryCount;
  final DateTime timestamp;
  
  MultiplayerConnectionException({
    required this.message,
    required this.context,
    this.endpoint,
    this.statusCode,
    this.timeout,
    this.retryCount = 0,
  }) : timestamp = DateTime.now();
  
  @override
  String toString() => 'MultiplayerConnectionException: $message (context: $context)';
  
  Map<String, dynamic> toJson() => {
    'message': message,
    'context': context,
    'endpoint': endpoint,
    'status_code': statusCode,
    'timeout_ms': timeout?.inMilliseconds,
    'retry_count': retryCount,
    'timestamp': timestamp.toIso8601String(),
    'type': 'connection_exception',
  };
  
  bool get isRetryable {
    if (statusCode == null) return true;
    
    // Retry sur les erreurs serveur et timeouts
    if (statusCode! >= 500) return true;
    if (statusCode == 408) return true; // Request Timeout
    if (statusCode == 429) return true; // Too Many Requests
    
    return false;
  }
  
  Duration get nextRetryDelay {
    // Backoff exponentiel avec jitter
    final baseDelay = Duration(seconds: (1 << retryCount).clamp(1, 30));
    final jitter = Duration(
      milliseconds: (DateTime.now().millisecondsSinceEpoch % 1000),
    );
    
    return baseDelay + jitter;
  }
}

/// Erreur de validation de l'état du jeu
class GameStateValidationException implements Exception {
  final String message;
  final String? roomId;
  final String? gameId;
  final String violatedRule;
  final Map<String, dynamic> currentState;
  final Map<String, dynamic>? expectedState;
  final DateTime timestamp;
  
  GameStateValidationException({
    required this.message,
    required this.violatedRule,
    required this.currentState,
    this.roomId,
    this.gameId,
    this.expectedState,
  }) : timestamp = DateTime.now();
  
  @override
  String toString() => 'GameStateValidationException: $message (rule: $violatedRule)';
  
  Map<String, dynamic> toJson() => {
    'message': message,
    'room_id': roomId,
    'game_id': gameId,
    'violated_rule': violatedRule,
    'current_state': currentState,
    'expected_state': expectedState,
    'timestamp': timestamp.toIso8601String(),
    'type': 'validation_exception',
  };
}

/// Erreur de timeout dans les opérations multijoueur
class MultiplayerTimeoutException implements Exception {
  final String message;
  final String operation;
  final Duration timeout;
  final String? roomId;
  final String? playerId;
  final DateTime timestamp;
  
  MultiplayerTimeoutException({
    required this.message,
    required this.operation,
    required this.timeout,
    this.roomId,
    this.playerId,
  }) : timestamp = DateTime.now();
  
  @override
  String toString() => 'MultiplayerTimeoutException: $message (operation: $operation, timeout: ${timeout.inSeconds}s)';
  
  Map<String, dynamic> toJson() => {
    'message': message,
    'operation': operation,
    'timeout_ms': timeout.inMilliseconds,
    'room_id': roomId,
    'player_id': playerId,
    'timestamp': timestamp.toIso8601String(),
    'type': 'timeout_exception',
  };
}

/// Erreur de capacité dépassée
class RoomCapacityException implements Exception {
  final String message;
  final String roomId;
  final int currentCapacity;
  final int maxCapacity;
  final String? attemptedPlayerId;
  final DateTime timestamp;
  
  RoomCapacityException({
    required this.message,
    required this.roomId,
    required this.currentCapacity,
    required this.maxCapacity,
    this.attemptedPlayerId,
  }) : timestamp = DateTime.now();
  
  @override
  String toString() => 'RoomCapacityException: $message (${currentCapacity}/${maxCapacity})';
  
  Map<String, dynamic> toJson() => {
    'message': message,
    'room_id': roomId,
    'current_capacity': currentCapacity,
    'max_capacity': maxCapacity,
    'attempted_player_id': attemptedPlayerId,
    'timestamp': timestamp.toIso8601String(),
    'type': 'capacity_exception',
  };
}

/// Exception pour les conflits de version optimiste
class OptimisticConflictException implements Exception {
  final String message;
  final String resourceType;
  final String resourceId;
  final int localVersion;
  final int serverVersion;
  final Map<String, dynamic> conflictingData;
  final DateTime timestamp;
  
  OptimisticConflictException({
    required this.message,
    required this.resourceType,
    required this.resourceId,
    required this.localVersion,
    required this.serverVersion,
    required this.conflictingData,
  }) : timestamp = DateTime.now();
  
  @override
  String toString() => 'OptimisticConflictException: $message (v$localVersion vs v$serverVersion)';
  
  Map<String, dynamic> toJson() => {
    'message': message,
    'resource_type': resourceType,
    'resource_id': resourceId,
    'local_version': localVersion,
    'server_version': serverVersion,
    'conflicting_data': conflictingData,
    'version_gap': serverVersion - localVersion,
    'timestamp': timestamp.toIso8601String(),
    'type': 'optimistic_conflict_exception',
  };
  
  bool get isResolvable => (serverVersion - localVersion) <= 5;
}