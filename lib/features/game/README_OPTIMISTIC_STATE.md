# Système d'État Optimiste - Documentation

## Vue d'ensemble

Le système d'état optimiste permet à l'application Ojyx de fournir une expérience utilisateur fluide et réactive, même en cas de latence réseau ou de perte de connexion temporaire. Les actions des joueurs sont appliquées immédiatement localement, puis synchronisées avec le serveur en arrière-plan.

## Architecture

### 1. OptimisticState<T>
Structure générique pour gérer n'importe quel état avec synchronisation :
- `localValue` : État affiché à l'utilisateur (optimiste)
- `serverValue` : État confirmé par le serveur
- `isSyncing` : Indique si une synchronisation est en cours
- `syncError` : Erreur de synchronisation éventuelle
- `pendingActionsCount` : Nombre d'actions en attente

### 2. OptimisticAction
Classe abstraite pour toutes les actions optimistes :
- Application locale immédiate via `apply()`
- Validation avec `canApply()`
- Retry automatique avec backoff exponentiel
- Priorité pour l'ordonnancement
- Sérialisation JSON pour la persistance

### 3. OptimisticGameStateNotifier
Gestionnaire principal de l'état optimiste :
- Queue de synchronisation avec debouncing
- Gestion des erreurs et rollback automatique
- Intégration avec GameSyncService
- Persistance locale des actions

### 4. OptimisticActionStorage
Stockage local des actions en attente :
- Sauvegarde dans SharedPreferences
- Récupération au démarrage
- Nettoyage des actions expirées (>24h)
- Métadonnées pour monitoring

### 5. ConnectionMonitor
Surveillance de la connexion réseau :
- Détection automatique de perte/retour de connexion
- Déclenchement de resynchronisation
- Compteur de tentatives de reconnexion
- État de stabilité de connexion

## Flux de données

### Action optimiste réussie :
1. Utilisateur effectue une action (ex: révéler une carte)
2. Action appliquée immédiatement à `localValue`
3. Action sauvegardée localement
4. Action ajoutée à la queue de synchronisation
5. Synchronisation avec le serveur (debounce 300ms)
6. Confirmation du serveur
7. Mise à jour de `serverValue`
8. Suppression de l'action locale

### Gestion d'erreur :
1. Échec de synchronisation détecté
2. Retry automatique avec backoff (1s, 2s, 4s...)
3. Après 3 échecs : rollback à `serverValue`
4. Notification utilisateur
5. Actions perdues supprimées

### Reconnexion :
1. Perte de connexion détectée
2. Actions continuent localement
3. Sauvegarde persistante
4. Retour de connexion
5. Chargement des actions en attente
6. Resynchronisation automatique

## Composants UI

### OptimisticCardWidget
- Affichage des cartes avec indicateur de sync
- Animation de révélation optimiste
- Gestion du tap avec création d'action

### SyncStatusIndicator
- Badge global de statut de synchronisation
- Compteur d'actions en attente
- Animation de synchronisation
- Messages d'erreur

### OptimisticActionButton
- Boutons pour cartes action
- État de traitement visuel
- Gestion d'erreur intégrée

### OptimisticGameBoard
- Intégration complète du plateau
- Overlay de déconnexion
- Banner d'erreur avec retry
- Indicateurs de connexion joueurs

## Configuration

### Paramètres de retry :
- Max tentatives : 3
- Délai initial : 1 seconde
- Backoff : Exponentiel (x2)
- Timeout action : 24 heures

### Debouncing :
- Synchronisation : 300ms
- Vérification connexion : 5s

## Utilisation

### Créer une nouvelle action :
```dart
class MyAction extends OptimisticAction {
  @override
  GameState apply(GameState state) {
    // Appliquer les changements
  }
  
  @override
  bool canApply(GameState state) {
    // Valider l'action
  }
}
```

### Appliquer une action :
```dart
final action = RevealCardAction(
  playerId: currentPlayer.id,
  row: 0,
  col: 1,
);

await ref.read(optimisticGameStateNotifierProvider.notifier)
    .applyOptimisticAction(action);
```

### Écouter l'état :
```dart
// État local (optimiste)
final gameState = ref.watch(optimisticGameStateProvider);

// Statut de synchronisation
final isSyncing = ref.watch(isGameStateSyncingProvider);

// Erreurs
final error = ref.watch(gameSyncErrorProvider);
```

## Points d'attention

1. **Validation côté serveur** : Toujours valider les actions côté serveur
2. **Idempotence** : Les actions doivent être idempotentes pour les retry
3. **Conflits** : Gérer les conflits entre actions locales et serveur
4. **Performance** : Limiter le nombre d'actions en attente
5. **Sécurité** : Ne pas stocker d'informations sensibles localement

## Monitoring

- Logs détaillés avec `debugPrint`
- Métriques de synchronisation
- Tracking des erreurs via Sentry
- État de connexion visible

## Tests recommandés

1. Mode avion pendant une partie
2. Connexion lente (throttling)
3. Déconnexion/reconnexion rapide
4. Actions simultanées multijoueurs
5. Rollback après erreurs