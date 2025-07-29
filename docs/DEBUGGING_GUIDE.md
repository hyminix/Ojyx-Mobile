# Guide de Debugging Ojyx

## Table des Matières

1. [Problèmes de Synchronisation](#problèmes-de-synchronisation)
2. [Erreurs Sentry Communes](#erreurs-sentry-communes)
3. [Problèmes de Base de Données](#problèmes-de-base-de-données)
4. [Erreurs d'Interface Utilisateur](#erreurs-dinterface-utilisateur)
5. [Problèmes de Performance](#problèmes-de-performance)
6. [Outils de Diagnostic](#outils-de-diagnostic)

---

## Problèmes de Synchronisation

### 🚨 États désynchronisés entre joueurs

**Symptômes observables :**
- Les joueurs voient des états de jeu différents
- Les cartes révélées ne correspondent pas
- Les scores affichés diffèrent entre clients
- Les tours de jeu sont incohérents

**Diagnostic :**

1. **Vérifier les logs Supabase Realtime**
```sql
SELECT * FROM game_actions 
WHERE game_state_id = 'GAME_ID' 
ORDER BY created_at DESC 
LIMIT 50;
```

2. **Inspecter l'ordre des événements**
```sql
SELECT 
    player_id,
    action_type,
    action_data,
    created_at,
    LAG(created_at) OVER (ORDER BY created_at) as previous_action_time
FROM game_actions 
WHERE game_state_id = 'GAME_ID'
ORDER BY created_at;
```

3. **Valider les RLS policies**
```sql
-- Vérifier les violations RLS
SELECT * FROM v_rls_violations_monitor 
WHERE created_at > NOW() - INTERVAL '1 hour';
```

**Causes racines identifiées :**
- **Race conditions** : Actions simultanées mal ordonnées
- **Policies RLS défaillantes** : Autorisation incohérente
- **Cache Realtime** : Messages perdus ou dupliqués
- **État optimiste non rollback** : Action locale non annulée

**Solutions :**

```dart
// ❌ INCORRECT - Pas de vérification d'ordre
Future<void> revealCard(int row, int col) async {
  await supabase.from('game_actions').insert({
    'action_type': 'reveal_card',
    'data': {'row': row, 'col': col}
  });
}

// ✅ CORRECT - Avec vérification d'ordre et rollback
Future<void> revealCard(int row, int col) async {
  final action = RevealCardAction(
    playerId: currentPlayer.id,
    row: row,
    col: col,
  );
  
  // Appliquer optimiste
  final optimisticState = await applyOptimisticAction(action);
  
  try {
    // Synchroniser avec serveur
    await gameSync.sendEvent(action.toGameSyncEvent());
  } catch (e) {
    // Rollback en cas d'erreur
    await rollbackOptimisticAction(action);
    rethrow;
  }
}
```

**Mesures préventives :**
- Implémenter des timestamps monotones
- Utiliser des ID d'événements uniques
- Valider l'état avant chaque action
- Configurer des alertes sur les incohérences

---

### 🚨 Actions non appliquées

**Symptômes observables :**
- L'action est visible localement mais pas pour les autres joueurs
- Erreur "Action failed" dans l'interface
- L'action disparaît après quelques secondes

**Diagnostic :**

1. **Vérifier l'authentification**
```sql
SELECT auth.uid(), auth.role();
```

2. **Tester les policies RLS manuellement**
```sql
-- Se mettre dans le contexte du joueur concerné
SELECT set_config('role', 'authenticated', true);
SELECT set_config('request.jwt.claims', 
  '{"sub":"USER_ID","role":"authenticated"}', true);

-- Tester l'insertion
INSERT INTO game_actions (game_state_id, player_id, action_type, action_data)
VALUES ('GAME_ID', 'USER_ID', 'reveal_card', '{"row":0,"col":1}');
```

3. **Vérifier les types de données**
```sql
-- Identifier les problèmes de cast
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'game_actions';
```

**Causes racines identifiées :**
- **Problème auth.uid()** : Utilisateur non authentifié
- **Cast uuid/text** : Comparaisons échouent
- **Policies trop restrictives** : Action valide mais bloquée
- **Données malformées** : JSON invalide dans action_data

**Solutions :**

```sql
-- ❌ INCORRECT - auth.uid() appelé plusieurs fois
CREATE POLICY "players_can_act" ON game_actions
FOR INSERT WITH CHECK (
    player_id = auth.uid() AND
    EXISTS (
        SELECT 1 FROM game_states gs
        WHERE gs.id = game_state_id
        AND gs.current_player_id = auth.uid()
    )
);

-- ✅ CORRECT - auth.uid() mis en cache
CREATE POLICY "players_can_act" ON game_actions
FOR INSERT WITH CHECK (
    (SELECT auth.uid()) IS NOT NULL AND
    player_id = (SELECT auth.uid()) AND
    EXISTS (
        SELECT 1 FROM game_states gs
        WHERE gs.id = game_state_id
        AND gs.current_player_id = (SELECT auth.uid())
    )
);
```

---

## Erreurs Sentry Communes

### 🔴 Zone Mismatch (OJYX-7)

**Message d'erreur :**
```
Zone mismatch error: Different zone than expected
```

**Cause :** Initialisation de services après `runApp()`.

```dart
// ❌ INCORRECT - Initialisation après runApp
void main() async {
  await dotenv.load();
  runApp(MyApp());
  await AppInitializer.initialize(); // ERREUR : Après runApp
}

// ✅ CORRECT - runZonedGuarded wrapper
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  
  runZonedGuarded(() async {
    await AppInitializer.initialize(); // AVANT runApp
    runApp(MyApp());
  }, (error, stack) {
    Sentry.captureException(error, stackTrace: stack);
  });
}
```

**Fix testé et validé :** ✅ Résolu dans commit `7caf661`

---

### 🟡 Ref après disposal (OJYX-C)

**Message d'erreur :**
```
StateNotifierProvider was disposed before being used
```

**Cause :** Accès à un provider après que le widget ait été unmounted.

```dart
// ❌ INCORRECT - Pas de vérification mounted
class MyNotifier extends StateNotifier<State> {
  void someMethod() async {
    await Future.delayed(Duration(seconds: 1));
    final service = ref.read(provider); // ERREUR : Peut être disposed
  }
}

// ✅ CORRECT - Vérification mounted
class MyNotifier extends StateNotifier<State> {
  void someMethod() async {
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return; // Vérifier avant accès
    
    try {
      final service = ref.read(provider);
    } catch (e) {
      debugPrint('Provider disposed: $e');
      return;
    }
  }
}
```

**Fix testé et validé :** ✅ Pattern appliqué dans tous les notifiers

---

### 🔴 RLS Policies Circulaires (OJYX-D)

**Message d'erreur :**
```sql
infinite recursion detected in rules for relation "players"
```

**Cause :** Policy qui requiert déjà ce qu'elle veut permettre.

```sql
-- ❌ INCORRECT - Référence circulaire
CREATE POLICY "update_room" ON players
FOR UPDATE USING (
    EXISTS (
        SELECT 1 FROM players p2
        WHERE p2.id = auth.uid()
        AND p2.current_room_id = players.current_room_id
    )
);

-- ✅ CORRECT - Cas de base pour éviter la récursion
CREATE POLICY "update_room" ON players
FOR UPDATE USING (auth.uid() IS NOT NULL)
WITH CHECK (
    id = auth.uid() OR
    current_room_id IS NULL OR -- Cas de base
    EXISTS (
        SELECT 1 FROM rooms r
        WHERE r.id = current_room_id
        AND (SELECT auth.uid())::text = ANY(r.player_ids)
    )
);
```

**Fix testé et validé :** ✅ Résolu dans migrations task 53

---

### 🟡 Performance RLS (OJYX-8)

**Message d'erreur :**
```
Query timeout: RLS policy evaluation too slow
```

**Cause :** Appels multiples non mis en cache à `auth.uid()`.

```sql
-- ❌ INCORRECT - Appels multiples non cachés
CREATE POLICY "policy" ON table
USING (
    auth.uid() = user_id OR
    auth.uid() IN (SELECT user_id FROM other_table) OR
    auth.uid() = creator_id
);

-- ✅ CORRECT - Appel unique mis en cache
CREATE POLICY "policy" ON table
USING (
    (SELECT auth.uid()) IS NOT NULL AND (
        user_id = (SELECT auth.uid()) OR
        (SELECT auth.uid()) IN (SELECT user_id FROM other_table) OR
        creator_id = (SELECT auth.uid())
    )
);
```

**Monitoring des performances :**
```sql
SELECT * FROM v_policy_performance_metrics 
WHERE avg_execution_time_ms > 50;
```

**Fix testé et validé :** ✅ Toutes les policies optimisées (task 52)

---

### 🔴 Vérification Auth (OJYX-9)

**Message d'erreur :**
```
User not authenticated for game state creation
```

**Cause :** Création de données critiques sans vérifier l'authentification.

```dart
// ❌ INCORRECT - Pas de vérification auth
Future<void> createGameState() async {
  await supabase.from('game_states').insert({...});
}

// ✅ CORRECT - Vérification auth systématique
Future<void> createGameState() async {
  final user = supabase.auth.currentUser;
  if (user == null) {
    throw MultiplayerSyncException(
      message: 'User not authenticated',
      metadata: {'action': 'create_game_state'},
    );
  }
  
  await supabase.from('game_states').insert({
    'creator_id': user.id,
    ...
  });
}
```

**Fix testé et validé :** ✅ Appliqué à toutes les opérations critiques

---

## Problèmes de Base de Données

### 🚨 Incohérences de données

**Symptômes :**
- `player_count` ne correspond pas à la taille de `player_ids`
- Joueurs dans des rooms inexistantes
- Parties sans joueurs associés

**Diagnostic :**
```sql
-- Détecter les incohérences
SELECT * FROM v_player_room_inconsistencies;
SELECT * FROM v_room_counter_validation;
SELECT * FROM v_business_rule_violations;
```

**Solutions automatisées :**
```sql
-- Corriger automatiquement
SELECT * FROM fix_data_inconsistencies();

-- Validation complète
SELECT * FROM validate_all_data_consistency();
```

### 🚨 Deadlocks

**Message d'erreur :**
```
deadlock detected
```

**Prévention :**
- Toujours acquérir les verrous dans le même ordre
- Utiliser des transactions courtes
- Implémenter retry avec backoff exponentiel

```dart
// Pattern de retry pour deadlocks
Future<T> withRetry<T>(Future<T> Function() operation) async {
  int attempts = 0;
  const maxAttempts = 3;
  
  while (attempts < maxAttempts) {
    try {
      return await operation();
    } catch (e) {
      if (e.toString().contains('deadlock') && attempts < maxAttempts - 1) {
        attempts++;
        await Future.delayed(Duration(milliseconds: 100 * attempts));
        continue;
      }
      rethrow;
    }
  }
  throw Exception('Max retry attempts reached');
}
```

---

## Erreurs d'Interface Utilisateur

### 🚨 Widget disposed

**Symptômes :**
- Erreur "Widget was disposed" lors de navigation
- Actions qui ne répondent plus
- État non mis à jour après navigation

**Solutions :**
```dart
// Vérifier mounted dans les callbacks async
if (!mounted) return;

// Cleanup proper dans dispose
@override
void dispose() {
  _subscription?.cancel();
  _controller?.close();
  super.dispose();
}
```

### 🚨 Memory leaks

**Diagnostic :**
- Utiliser Flutter Inspector
- Surveiller la consommation mémoire
- Checker les StreamSubscriptions non fermées

**Solutions :**
```dart
// Pattern de subscription avec cleanup auto
late final StreamSubscription _subscription;

@override
void initState() {
  super.initState();
  _subscription = stream.listen(onData)
    ..onError(onError)
    ..onDone(onDone);
}

@override
void dispose() {
  _subscription.cancel();
  super.dispose();
}
```

---

## Problèmes de Performance

### 🚨 Latence réseau élevée

**Seuils critiques :**
- Synchronisation > 1000ms
- Requête RLS > 50ms  
- Reconnexion > 5s

**Optimisations :**
```dart
// Batch les opérations
final batch = supabase.rpc('batch_operations', 
  params: {'operations': operations});

// Cache local avec TTL
final cached = await cache.get(key, 
  ttl: Duration(minutes: 5));

// Compression des payloads
final compressed = gzip.encode(utf8.encode(jsonData));
```

### 🚨 Rebuild excessifs

**Diagnostic :**
```dart
// Ajouter logs pour détecter rebuilds
@override
Widget build(BuildContext context) {
  debugPrint('Rebuild: $runtimeType');
  return Widget();
}
```

**Solutions :**
- Utiliser `const` constructors
- Séparer les providers par responsabilité
- Implémenter `select()` pour Riverpod

---

## Outils de Diagnostic

### 🔧 Commandes SQL utiles

```sql
-- Performances générales
SELECT * FROM v_rls_performance_dashboard;

-- Activité temps réel
SELECT 
    COUNT(*) as active_connections,
    MAX(last_seen) as last_activity
FROM pg_stat_activity 
WHERE application_name LIKE '%supabase%';

-- Usage des index
SELECT * FROM v_index_usage_stats 
WHERE usage_category = 'unused';

-- Taille des tables
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### 🔧 Scripts de monitoring

```bash
#!/bin/bash
# check_health.sh

echo "=== Supabase Health Check ==="

# Vérifier la connectivité
curl -f "$SUPABASE_URL/rest/v1/" \
  -H "apikey: $SUPABASE_ANON_KEY" || echo "❌ API unreachable"

# Vérifier les métriques
psql "$DATABASE_URL" -c "SELECT * FROM v_rls_performance_dashboard;"

echo "=== Sentry Check ==="
# Vérifier les erreurs récentes
curl "https://sentry.io/api/0/projects/$ORG/$PROJECT/events/" \
  -H "Authorization: Bearer $SENTRY_TOKEN"
```

### 🔧 Dashboard Flutter

```dart
// Widget de debug en développement
class DebugOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) return SizedBox.shrink();
    
    return Positioned(
      top: 100,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(8),
        color: Colors.black54,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🔧 Debug Info', style: TextStyle(color: Colors.white)),
            Text('Connection: ${_connectionStatus}'),
            Text('Sync Queue: ${_syncQueueSize}'),
            Text('Latency: ${_latency}ms'),
          ],
        ),
      ),
    );
  }
}
```

### 🔧 Logs structurés

```dart
// Utiliser le LogService pour des logs structurés
logService.error(
  'Sync failed',
  category: 'multiplayer',
  data: {
    'room_id': roomId,
    'player_id': playerId,
    'action': action,
    'attempt': attemptCount,
    'error_code': errorCode,
  },
  stackTrace: stackTrace,
);
```

---

## Checklist de Résolution

### ✅ Avant de commencer
- [ ] Reproduire l'erreur de manière consistante
- [ ] Identifier l'environnement (dev/staging/prod)
- [ ] Capturer les logs complets (client + serveur)
- [ ] Noter le timing et la fréquence

### ✅ Pendant le debugging
- [ ] Isoler la cause racine (client vs serveur vs réseau)
- [ ] Tester la solution en environnement isolé
- [ ] Vérifier que la solution ne casse pas d'autres fonctionnalités
- [ ] Ajouter des tests pour éviter la régression

### ✅ Après la correction
- [ ] Mettre à jour cette documentation
- [ ] Configurer une alerte pour détecter le problème à l'avenir
- [ ] Faire une review de code
- [ ] Déployer et surveiller

---

## Contacts et Escalade

### 🚨 Incidents critiques
- **Production down** : Alertes Slack immédiate
- **Données corrompues** : Arrêt du service + investigation
- **Faille sécurité** : Escalade équipe sécurité

### 📊 Monitoring continu
- **Dashboard Sentry** : https://sentry.io/organizations/ojyx/
- **Supabase Dashboard** : https://app.supabase.com/project/[PROJECT_ID]
- **Métriques RLS** : Exécuter hebdomadairement

### 📝 Documentation
- **Issues GitHub** : Référencer OJYX-X dans les commits
- **Runbook** : Maintenir ce document à jour
- **Post-mortems** : Archiver dans `/docs/post-mortems/`