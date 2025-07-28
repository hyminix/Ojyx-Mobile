# Migration vers KeepAlive Providers - Stratégie

## Date: 2025-07-28

### Providers Critiques Identifiés

#### 1. Providers qui DOIVENT utiliser keepAlive

**HeartbeatServiceManager**
- **Raison**: Le heartbeat doit continuer même lors de la navigation entre écrans
- **Migration**: Créé `CriticalHeartbeatServiceManager` avec `@Riverpod(keepAlive: true)`
- **Utilisation**: Remplacer `heartbeatServiceManagerProvider` par `criticalHeartbeatServiceManagerProvider`

**GameStateManager** 
- **Raison**: L'état du jeu ne doit pas être perdu lors de la navigation (ex: aller voir les règles)
- **Migration**: Créé `CriticalGameStateManager` avec `@Riverpod(keepAlive: true)`
- **Utilisation**: Pour les jeux actifs uniquement, utiliser la version keepAlive

**ActiveGamesTracker**
- **Raison**: Tracker centralisé pour gérer le cycle de vie des jeux actifs
- **Migration**: Nouveau provider pour gérer quels jeux doivent rester en mémoire

#### 2. Providers qui PEUVENT rester autoDispose

**authNotifierProvider**
- **Raison**: L'authentification est gérée par Supabase qui persiste la session
- **Décision**: Garder autoDispose, pas de problème de perte d'état

**currentUserIdProvider**
- **Raison**: Dérivé de authNotifierProvider, recalculé facilement
- **Décision**: Garder autoDispose

**roomStateProvider** (si existe)
- **Raison**: Les rooms sont temporaires et peuvent être rechargées
- **Décision**: Garder autoDispose sauf si utilisé dans un jeu actif

#### 3. Providers de UI/Présentation

Tous les providers de UI doivent rester autoDispose :
- `cardSelectionProvider`
- `directionObserverProvider` 
- `gameAnimationProvider`
- Etc.

### Stratégie de Migration

#### Phase 1: Infrastructure (Complété)
1. ✅ Créer les versions keepAlive des providers critiques
2. ✅ Implémenter ActiveGamesTracker pour gérer le lifecycle

#### Phase 2: Migration Progressive
1. Identifier les écrans qui utilisent les providers critiques
2. Remplacer progressivement les références
3. Tester la navigation pour vérifier la persistance

#### Phase 3: Cleanup Manuel
1. Implémenter la logique de cleanup quand un jeu se termine
2. Utiliser ActiveGamesTracker pour invalider les providers

### Pattern Recommandé

```dart
// Dans GameScreen
@override
void initState() {
  super.initState();
  
  // Marquer le jeu comme actif
  ref.read(activeGamesTrackerProvider.notifier).addGame(widget.gameId);
  
  // Utiliser la version keepAlive
  ref.read(criticalHeartbeatServiceManagerProvider.notifier)
    .startHeartbeat(playerId);
}

// Quand le jeu se termine
void _onGameEnd() {
  // Nettoyer manuellement
  ref.read(activeGamesTrackerProvider.notifier).removeGame(widget.gameId);
}
```

### Considérations de Performance

1. **Mémoire**: Les providers keepAlive consomment plus de mémoire
2. **Limite**: Ne garder que les jeux actifs (max 1-2 simultanément)
3. **Cleanup**: Toujours nettoyer manuellement quand un jeu se termine

### Tests à Effectuer

1. Navigation pendant une partie active
2. Rotation d'écran pendant le jeu
3. App en arrière-plan puis retour
4. Déconnexion/reconnexion réseau
5. Multiple jeux simultanés (edge case)