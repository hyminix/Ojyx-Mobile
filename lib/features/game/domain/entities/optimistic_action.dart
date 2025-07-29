import 'package:uuid/uuid.dart';
import 'game_state.dart';

/// Action optimiste abstraite qui peut être appliquée localement et synchronisée
abstract class OptimisticAction {
  /// ID unique de l'action
  final String id;
  
  /// Timestamp de création
  final DateTime timestamp;
  
  /// Type d'action pour la sérialisation
  final String type;
  
  /// Nombre de tentatives de synchronisation
  final int retryCount;
  
  /// ID du joueur qui effectue l'action
  final String playerId;
  
  /// Indique si l'action peut être rejouée après un échec
  final bool isRetryable;
  
  OptimisticAction({
    String? id,
    DateTime? timestamp,
    required this.type,
    required this.playerId,
    this.retryCount = 0,
    this.isRetryable = true,
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();
  
  /// Applique l'action à l'état actuel et retourne le nouvel état
  GameState apply(GameState currentState);
  
  /// Convertit l'action en JSON pour la synchronisation
  Map<String, dynamic> toJson();
  
  /// Crée une nouvelle instance avec le compteur de retry incrémenté
  OptimisticAction withRetry();
  
  /// Valide si l'action peut être appliquée à l'état actuel
  bool canApply(GameState currentState);
  
  /// Priorité de l'action pour l'ordonnancement (1-10, 1 étant le plus prioritaire)
  int get priority => 5;
  
  /// Délai avant le prochain retry en millisecondes
  int get retryDelayMs {
    if (!isRetryable || retryCount >= maxRetries) return 0;
    // Backoff exponentiel : 1s, 2s, 4s, 8s...
    return 1000 * (1 << retryCount);
  }
  
  /// Nombre maximum de tentatives
  static const int maxRetries = 3;
  
  /// Indique si l'action a atteint le nombre maximum de tentatives
  bool get hasReachedMaxRetries => retryCount >= maxRetries;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptimisticAction &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}