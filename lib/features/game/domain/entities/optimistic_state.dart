import 'package:freezed_annotation/freezed_annotation.dart';

part 'optimistic_state.freezed.dart';

/// État générique pour la gestion optimiste avec synchronisation
@freezed
class OptimisticState<T> with _$OptimisticState<T> {
  const OptimisticState._();
  
  const factory OptimisticState({
    /// Valeur locale (optimiste) affichée à l'utilisateur
    required T localValue,
    
    /// Valeur confirmée par le serveur
    T? serverValue,
    
    /// Indique si une synchronisation est en cours
    @Default(false) bool isSyncing,
    
    /// Erreur de synchronisation si présente
    String? syncError,
    
    /// Timestamp de la dernière tentative de synchronisation
    required DateTime lastSyncAttempt,
    
    /// Nombre d'actions en attente de synchronisation
    @Default(0) int pendingActionsCount,
    
    /// ID de la dernière action synchronisée avec succès
    String? lastSyncedActionId,
  }) = _OptimisticState<T>;
  
  /// Indique si l'état local est désynchronisé du serveur
  bool get isOutOfSync => localValue != serverValue && serverValue != null;
  
  /// Indique si l'état est en erreur
  bool get hasError => syncError != null;
  
  /// Indique si l'état est complètement synchronisé
  bool get isSynchronized => !isOutOfSync && !isSyncing && !hasError && pendingActionsCount == 0;
  
  /// Durée depuis la dernière synchronisation
  Duration get timeSinceLastSync => DateTime.now().difference(lastSyncAttempt);
  
  /// Indique si une resynchronisation est nécessaire (après 30 secondes)
  bool get needsResync => timeSinceLastSync > const Duration(seconds: 30);
}