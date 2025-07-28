# Audit - Utilisation de ref après disposal

## Date: 2025-07-28

### Fichiers à risque identifiés

#### 1. **CRITIQUE** - admin_dashboard_screen.dart
- **Ligne 25**: `ref.read(cleanupMonitoringProvider.notifier).stopAutoRefresh()` dans `dispose()`
- **Risque**: Utilisation de ref après disposal du widget
- **Solution**: Déplacer la logique de cleanup dans un callback ou utiliser un flag _isDisposed

#### 2. **CRITIQUE** - game_screen.dart  
- **Ligne 53**: `ref.read(heartbeatServiceManagerProvider.notifier).stopHeartbeat()` dans `dispose()`
- **Risque**: Utilisation de ref après disposal du widget
- **Solution**: Stocker la référence du notifier dans initState ou utiliser SafeRefMixin

### Widgets utilisant ConsumerStatefulWidget/ConsumerState

1. `room_lobby_screen.dart` - À vérifier
2. `join_room_screen.dart` - OK (pas de ref dans dispose)
3. `admin_dashboard_screen.dart` - **PROBLÈME DÉTECTÉ**
4. `game_screen.dart` - **PROBLÈME DÉTECTÉ**
5. `home_screen.dart` - OK (pas de ref dans dispose)
6. `game_selection_overlay.dart` - À vérifier
7. `enhanced_player_grid.dart` - À vérifier
8. `performance_monitored_widget.dart` - OK (pas de ConsumerState)
9. `action_card_hand_widget.dart` - À vérifier
10. `create_room_screen.dart` - À vérifier

### Services avec Timers/Subscriptions à vérifier

1. `heartbeat_service.dart` - Timer périodique
2. `cleanup_monitoring_provider.dart` - Timer auto-refresh
3. `available_rooms_provider.dart` - Potentiel streaming
4. `console_logger.dart` - Timer de flush
5. `resilient_supabase_service.dart` - Retry avec Timer
6. `connectivity_service.dart` - StreamSubscription
7. `multiplayer_game_notifier.dart` - Realtime subscriptions

### Recommandations

1. Implémenter SafeRefMixin pour tous les ConsumerStatefulWidget
2. Migrer les providers critiques vers keepAlive
3. Ajouter des guards _isDisposed dans tous les widgets à risque
4. Créer des tests de régression pour la navigation rapide