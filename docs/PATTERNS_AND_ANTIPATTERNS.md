# Patterns et Anti-Patterns - Ojyx

## Table des Matières

1. [Patterns Architecture](#patterns-architecture)
2. [Patterns Riverpod & State Management](#patterns-riverpod--state-management)
3. [Patterns Supabase & Base de Données](#patterns-supabase--base-de-données)
4. [Patterns Multijoueur & Synchronisation](#patterns-multijoueur--synchronisation)
5. [Patterns Monitoring & Error Handling](#patterns-monitoring--error-handling)
6. [Anti-Patterns à Éviter Absolument](#anti-patterns-à-éviter-absolument)
7. [Patterns de Test](#patterns-de-test)
8. [Patterns de Performance](#patterns-de-performance)

---

## Patterns Architecture

### ✅ Clean Architecture avec Features

**Concept :** Organisation par fonctionnalités avec séparation claire des couches.

```dart
// ✅ CORRECT - Structure claire par feature
lib/
├── features/
│   ├── game/
│   │   ├── presentation/   # UI, providers, widgets
│   │   ├── domain/         # Entités, use cases
│   │   └── data/          # Repositories, datasources
│   └── multiplayer/
│       ├── presentation/
│       ├── domain/
│       └── data/
├── core/                  # Partagé entre features
└── main.dart

// ❌ INCORRECT - Tout dans lib/
lib/
├── screens/              # Mélange toutes les features
├── widgets/              # Pas de séparation logique
├── services/             # Couplage fort
└── models/               # Pas de couches claires
```

**Pourquoi ça marche :**
- Scalabilité : Facile d'ajouter de nouvelles features
- Maintenance : Modifications isolées par feature
- Tests : Testabilité par couche et feature
- Collaboration : Équipes peuvent travailler en parallèle

### ✅ Dependency Injection avec Riverpod

**Pattern :** Injecter les dépendances via des providers.

```dart
// ✅ CORRECT - DI avec providers
@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@riverpod
GameRepository gameRepository(GameRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return GameRepositoryImpl(client);
}

@riverpod
class GameStateNotifier extends _$GameStateNotifier {
  @override
  GameState build() {
    // DI automatique via ref
    final repo = ref.watch(gameRepositoryProvider);
    return GameState.initial();
  }
}

// ❌ INCORRECT - Dépendances en dur
class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(GameState.initial()) {
    // Couplage fort - difficile à tester
    _repository = GameRepositoryImpl(Supabase.instance.client);
  }
  
  late final GameRepository _repository;
}
```

**Avantages :**
- Testabilité : Mock facile des dépendances
- Flexibilité : Changement d'implémentation transparent
- Lifecycle : Gestion automatique par Riverpod

### ✅ Feature-First File Organization

**Pattern :** Organiser les fichiers par valeur business, pas par type technique.

```dart
// ✅ CORRECT - Par feature business
lib/features/game/
├── presentation/
│   ├── screens/
│   │   ├── game_screen.dart
│   │   └── game_lobby_screen.dart
│   ├── widgets/
│   │   ├── player_grid_widget.dart
│   │   └── action_card_widget.dart
│   └── providers/
│       ├── game_state_provider.dart
│       └── card_selection_provider.dart

// ❌ INCORRECT - Par type technique
lib/
├── screens/
│   ├── game_screen.dart          # Éparpillé
│   ├── lobby_screen.dart         # Difficile à naviguer
│   └── settings_screen.dart
├── widgets/
│   ├── player_grid.dart          # Pas de contexte
│   └── card_widget.dart
└── providers/
    ├── game_provider.dart        # Couplage implicite
    └── settings_provider.dart
```

---

## Patterns Riverpod & State Management

### ✅ Optimistic State Pattern

**Concept :** Appliquer les changements localement puis synchroniser avec le serveur.

```dart
// ✅ CORRECT - État optimiste avec rollback
@riverpod
class OptimisticGameState extends _$OptimisticGameState {
  @override
  GameState build() => GameState.initial();
  
  Future<void> revealCard(int row, int col) async {
    final action = RevealCardAction(row: row, col: col);
    
    // 1. Appliquer optimiste
    final optimisticState = state.applyAction(action);
    state = optimisticState.copyWith(syncing: true);
    
    try {
      // 2. Synchroniser serveur
      await ref.read(gameSyncServiceProvider).sendAction(action);
      
      // 3. Confirmer l'état
      state = optimisticState.copyWith(syncing: false, confirmed: true);
    } catch (e) {
      // 4. Rollback en cas d'erreur
      state = state.rollbackAction(action);
      rethrow;
    }
  }
}

// ❌ INCORRECT - Synchrone uniquement
@riverpod
class GameState extends _$GameState {
  Future<void> revealCard(int row, int col) async {
    // Aucun feedback utilisateur immédiat
    final result = await api.revealCard(row, col);
    
    // L'utilisateur attend sans feedback
    state = state.copyWith(grid: result.grid);
  }
}
```

**Bénéfices :**
- UX : Feedback immédiat pour l'utilisateur
- Performance : Pas d'attente réseau
- Résilience : Gestion d'erreur avec rollback

### ✅ Provider Lifecycle Management

**Pattern :** Gérer proprement le cycle de vie des providers.

```dart
// ✅ CORRECT - Cleanup automatique
@riverpod
class RoomRealtimeService extends _$RoomRealtimeService {
  StreamSubscription? _subscription;
  
  @override
  RealtimeState build() {
    // Cleanup automatique quand provider est disposed
    ref.onDispose(() {
      _subscription?.cancel();
      _cleanup();
    });
    
    return RealtimeState.disconnected();
  }
  
  void _cleanup() {
    // Libérer ressources
  }
}

// ❌ INCORRECT - Memory leaks
@riverpod
class RoomService extends _$RoomService {
  StreamSubscription? _subscription;
  
  @override
  RoomState build() {
    _subscription = stream.listen(handleEvent);
    return RoomState.initial();
    // Pas de cleanup - memory leak garanti
  }
}
```

### ✅ Granular State Updates

**Pattern :** Séparer les états pour éviter les rebuilds inutiles.

```dart
// ✅ CORRECT - États séparés
@riverpod
class GameGridNotifier extends _$GameGridNotifier {
  @override
  PlayerGrid build() => PlayerGrid.initial();
  
  void revealCard(int row, int col) {
    // Seuls les widgets de grille rebuild
    state = state.revealCard(row, col);
  }
}

@riverpod
class GameScoreNotifier extends _$GameScoreNotifier {
  @override
  GameScore build() => GameScore.initial();
  
  void updateScore(int newScore) {
    // Seuls les widgets de score rebuild
    state = state.copyWith(total: newScore);
  }
}

// ❌ INCORRECT - État monolithique
@riverpod
class GameNotifier extends _$GameNotifier {
  @override
  GameState build() => GameState.initial();
  
  void revealCard(int row, int col) {
    // TOUT l'écran rebuild pour un changement de carte
    state = state.copyWith(
      grid: state.grid.revealCard(row, col),
      // scores, players, ui state, etc. - tout rebuild
    );
  }
}
```

### ✅ Select Pattern pour Performance

**Pattern :** Utiliser `select` pour éviter les rebuilds inutiles.

```dart
// ✅ CORRECT - Select spécifique
class ScoreWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild uniquement si le score change
    final score = ref.watch(
      gameStateProvider.select((state) => state.score)
    );
    
    return Text('Score: $score');
  }
}

// ✅ CORRECT - Select avec condition
class ErrorWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild uniquement s'il y a une erreur
    final hasError = ref.watch(
      gameStateProvider.select((state) => state.error != null)
    );
    
    if (!hasError) return SizedBox.shrink();
    
    final error = ref.watch(
      gameStateProvider.select((state) => state.error!)
    );
    
    return ErrorBanner(error: error);
  }
}

// ❌ INCORRECT - Tout écouter
class ScoreWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    
    // Rebuild à chaque changement de gameState
    // même si seul le score nous intéresse
    return Text('Score: ${gameState.score}');
  }
}
```

---

## Patterns Supabase & Base de Données

### ✅ RLS Policies Optimisées

**Pattern :** Mettre en cache `auth.uid()` pour optimiser les performances.

```sql
-- ✅ CORRECT - auth.uid() mis en cache
CREATE POLICY "players_can_update_own_data" ON players
FOR UPDATE USING (
    (SELECT auth.uid()) IS NOT NULL AND 
    id = (SELECT auth.uid())
);

-- ✅ CORRECT - Complexe mais optimisé
CREATE POLICY "room_members_can_act" ON game_actions
FOR INSERT WITH CHECK (
    (SELECT auth.uid()) IS NOT NULL AND 
    player_id = (SELECT auth.uid()) AND
    EXISTS (
        SELECT 1 FROM rooms r 
        WHERE r.id = room_id 
        AND (SELECT auth.uid())::text = ANY(r.player_ids)
    )
);

-- ❌ INCORRECT - Appels multiples non cachés
CREATE POLICY "bad_policy" ON players
FOR UPDATE USING (
    auth.uid() = id OR  -- Premier appel
    auth.uid() IN (     -- Deuxième appel
        SELECT owner_id FROM rooms WHERE id = current_room_id
    ) OR
    auth.uid() = creator_id  -- Troisième appel
);
```

**Impact :** Les policies optimisées sont 5-10x plus rapides.

### ✅ Transactions pour Cohérence

**Pattern :** Grouper les opérations liées dans des transactions.

```dart
// ✅ CORRECT - Transaction atomique
Future<void> joinRoom(String roomId, String playerId) async {
  await supabase.rpc('join_room_transaction', params: {
    'room_id': roomId,
    'player_id': playerId,
  });
}

// SQL correspondant
CREATE OR REPLACE FUNCTION join_room_transaction(
  room_id uuid,
  player_id uuid
) RETURNS void AS $$
BEGIN
  -- Tout ou rien
  UPDATE rooms 
  SET player_ids = array_append(player_ids, player_id::text),
      player_count = player_count + 1
  WHERE id = room_id;
  
  UPDATE players 
  SET current_room_id = room_id 
  WHERE id = player_id;
  
  INSERT INTO room_events (room_id, event_type, data)
  VALUES (room_id, 'player_joined', jsonb_build_object('player_id', player_id));
END;
$$ LANGUAGE plpgsql;

// ❌ INCORRECT - Opérations séparées
Future<void> joinRoom(String roomId, String playerId) async {
  // Race condition possible entre ces opérations
  await supabase.from('rooms').update({
    'player_count': 'player_count + 1',
  }).eq('id', roomId);
  
  await supabase.from('players').update({
    'current_room_id': roomId,
  }).eq('id', playerId);
  
  // Si cette étape échoue, les données sont incohérentes
  await supabase.from('room_events').insert({
    'room_id': roomId,
    'event_type': 'player_joined',
  });
}
```

### ✅ Validation de Données avec Triggers

**Pattern :** Valider automatiquement la cohérence en base.

```sql
-- ✅ CORRECT - Trigger de validation
CREATE OR REPLACE FUNCTION validate_room_capacity()
RETURNS trigger AS $$
BEGIN
  -- Vérifier que le nombre de joueurs ne dépasse pas la capacité
  IF array_length(NEW.player_ids, 1) > NEW.max_players THEN
    RAISE EXCEPTION 'Room capacity exceeded: % > %', 
      array_length(NEW.player_ids, 1), NEW.max_players;
  END IF;
  
  -- Synchroniser player_count avec player_ids
  NEW.player_count := COALESCE(array_length(NEW.player_ids, 1), 0);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_room_capacity_trigger
  BEFORE INSERT OR UPDATE ON rooms
  FOR EACH ROW
  EXECUTE FUNCTION validate_room_capacity();

-- ❌ INCORRECT - Validation uniquement côté client
```

---

## Patterns Multijoueur & Synchronisation

### ✅ Event-Driven Synchronization

**Pattern :** Utiliser un système d'événements pour la synchronisation.

```dart
// ✅ CORRECT - Events typés et sérialisables
abstract class GameSyncEvent {
  String get eventType;
  Map<String, dynamic> toJson();
  
  factory GameSyncEvent.fromJson(Map<String, dynamic> json) {
    switch (json['event_type']) {
      case 'reveal_card':
        return RevealCardEvent.fromJson(json);
      case 'play_action_card':
        return PlayActionCardEvent.fromJson(json);
      default:
        throw UnknownEventException(json['event_type']);
    }
  }
}

@freezed
class RevealCardEvent extends GameSyncEvent with _$RevealCardEvent {
  const factory RevealCardEvent({
    required String playerId,
    required int row,
    required int col,
    required DateTime timestamp,
  }) = _RevealCardEvent;
  
  @override
  String get eventType => 'reveal_card';
  
  factory RevealCardEvent.fromJson(Map<String, dynamic> json) =>
      _$RevealCardEventFromJson(json);
}

// ❌ INCORRECT - Maps non typés
class GameSync {
  void sendAction(Map<String, dynamic> action) {
    // Pas de validation de type
    // Erreurs détectées seulement à l'exécution
    supabase.channel('game').send({
      'type': 'broadcast',
      'event': 'game_action',
      'payload': action, // Peut contenir n'importe quoi
    });
  }
}
```

### ✅ Conflict Resolution Strategy

**Pattern :** Stratégie claire pour résoudre les conflits.

```dart
// ✅ CORRECT - Résolution de conflits explicite
class ConflictResolver {
  GameState resolveConflict(
    GameState localState,
    GameState serverState,
    DateTime localTimestamp,
    DateTime serverTimestamp,
  ) {
    // Stratégie : "Server wins" avec exceptions
    if (serverTimestamp.isAfter(localTimestamp)) {
      return serverState;
    }
    
    // Si local plus récent, garder certains changements
    return serverState.copyWith(
      // Préserver les changements UI locaux
      selectedCard: localState.selectedCard,
      // Mais prendre l'état de jeu du serveur
      grid: serverState.grid,
      scores: serverState.scores,
    );
  }
}

// ❌ INCORRECT - Pas de stratégie claire
class GameSync {
  void handleServerUpdate(Map<String, dynamic> update) {
    // Écrase aveuglément l'état local
    state = GameState.fromJson(update);
    // Perte des actions utilisateur en cours
  }
}
```

### ✅ Connection State Management

**Pattern :** Gérer explicitement les états de connexion.

```dart
// ✅ CORRECT - États de connexion explicites
enum ConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  failed,
}

@riverpod
class ConnectionNotifier extends _$ConnectionNotifier {
  Timer? _heartbeatTimer;
  int _reconnectAttempts = 0;
  
  @override
  ConnectionState build() {
    _startHeartbeat();
    return ConnectionState.connecting;
  }
  
  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(
      Duration(seconds: 30),
      (_) => _checkConnection(),
    );
  }
  
  void _checkConnection() async {
    try {
      await supabase.rpc('ping');
      if (state != ConnectionState.connected) {
        state = ConnectionState.connected;
        _reconnectAttempts = 0;
      }
    } catch (e) {
      _handleConnectionLoss();
    }
  }
  
  void _handleConnectionLoss() {
    if (state == ConnectionState.connected) {
      state = ConnectionState.reconnecting;
      _attemptReconnect();
    }
  }
  
  void _attemptReconnect() async {
    const maxAttempts = 5;
    const baseDelay = Duration(seconds: 2);
    
    while (_reconnectAttempts < maxAttempts) {
      await Future.delayed(baseDelay * (_reconnectAttempts + 1));
      
      try {
        await supabase.realtime.connect();
        state = ConnectionState.connected;
        return;
      } catch (e) {
        _reconnectAttempts++;
      }
    }
    
    state = ConnectionState.failed;
  }
}

// ❌ INCORRECT - Pas de gestion d'état
class SimpleConnection {
  bool isConnected = false;
  
  void connect() {
    isConnected = true; // Trop simpliste
  }
  
  void disconnect() {
    isConnected = false; // Pas de retry logic
  }
}
```

---

## Patterns Monitoring & Error Handling

### ✅ Structured Error Handling

**Pattern :** Hiérarchie d'erreurs avec contexte riche.

```dart
// ✅ CORRECT - Erreurs structurées
abstract class OjyxException implements Exception {
  const OjyxException({
    required this.message,
    required this.code,
    this.context = const {},
    this.cause,
  });
  
  final String message;
  final String code;
  final Map<String, dynamic> context;
  final dynamic cause;
  
  @override
  String toString() => '$code: $message';
}

class MultiplayerSyncException extends OjyxException {
  const MultiplayerSyncException({
    required super.message,
    super.context,
    super.cause,
  }) : super(code: 'MULTIPLAYER_SYNC_ERROR');
  
  // Factory methods pour différents cas
  factory MultiplayerSyncException.actionFailed({
    required String action,
    required String roomId,
  }) {
    return MultiplayerSyncException(
      message: 'Failed to sync action: $action',
      context: {
        'action': action,
        'room_id': roomId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}

// Usage avec monitoring automatique
void handleSyncError(dynamic error, StackTrace stackTrace) {
  if (error is MultiplayerSyncException) {
    MultiplayerErrorMonitor.captureSyncError(
      error,
      roomId: error.context['room_id'],
      action: error.context['action'],
      stackTrace: stackTrace,
    );
  }
  
  throw error;
}

// ❌ INCORRECT - Erreurs génériques
class BadErrorHandling {
  void syncAction() async {
    try {
      await api.doSomething();
    } catch (e) {
      print('Error: $e'); // Pas de contexte
      throw Exception('Something went wrong'); // Perte d'information
    }
  }
}
```

### ✅ Monitoring with Context

**Pattern :** Capturer le contexte riche pour le debugging.

```dart
// ✅ CORRECT - Contexte riche pour monitoring
class MultiplayerErrorMonitor {
  static void captureSyncError(
    dynamic error, {
    required String roomId,
    required String playerId,
    String? action,
    Map<String, dynamic>? gameState,
    int? attemptNumber,
    StackTrace? stackTrace,
  }) {
    Sentry.withScope((scope) {
      // Tags pour filtrage
      scope.setTag('error_category', 'multiplayer_sync');
      scope.setTag('room_id', roomId);
      scope.setTag('action_type', action ?? 'unknown');
      
      // Contexte pour debugging
      scope.setContext('multiplayer', {
        'room_id': roomId,
        'player_id': playerId,
        'action': action,
        'attempt_number': attemptNumber,
        'game_state_summary': _summarizeGameState(gameState),
      });
      
      // Breadcrumbs pour traçabilité
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Multiplayer sync error',
        level: SentryLevel.error,
        data: {
          'room_id': roomId,
          'action': action,
        },
      ));
      
      Sentry.captureException(error, stackTrace: stackTrace);
    });
  }
  
  static Map<String, dynamic> _summarizeGameState(Map<String, dynamic>? state) {
    if (state == null) return {};
    
    return {
      'current_turn': state['current_turn'],
      'phase': state['phase'],
      'player_count': state['players']?.length ?? 0,
      // Ne pas logguer les données sensibles
    };
  }
}

// ❌ INCORRECT - Monitoring basique
class BasicMonitoring {
  static void logError(dynamic error) {
    Sentry.captureException(error);
    // Pas de contexte - debugging impossible
  }
}
```

### ✅ Performance Monitoring

**Pattern :** Mesurer automatiquement les performances critiques.

```dart
// ✅ CORRECT - Monitoring de performance automatique
class PerformanceMonitor {
  static Future<T> measureOperation<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, dynamic>? context,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await operation();
      stopwatch.stop();
      
      _recordSuccess(operationName, stopwatch.elapsedMilliseconds, context);
      return result;
    } catch (error, stackTrace) {
      stopwatch.stop();
      
      _recordFailure(operationName, stopwatch.elapsedMilliseconds, error, context);
      rethrow;
    }
  }
  
  static void _recordSuccess(String operation, int durationMs, Map<String, dynamic>? context) {
    // Sentry performance tracking
    final transaction = Sentry.startTransaction(
      operation,
      'multiplayer_operation',
    );
    
    transaction.setData('duration_ms', durationMs);
    transaction.setData('context', context ?? {});
    transaction.finish(const SpanStatus.ok());
    
    // Log si trop lent
    if (durationMs > 1000) {
      MultiplayerErrorMonitor.capturePerformanceMetric(
        operation: operation,
        durationMs: durationMs,
        context: context,
        isSlow: true,
      );
    }
  }
}

// Usage
Future<void> syncGameAction(GameSyncEvent event) async {
  return PerformanceMonitor.measureOperation(
    'sync_game_action',
    () => _doSync(event),
    context: {
      'event_type': event.eventType,
      'room_id': event.roomId,
    },
  );
}

// ❌ INCORRECT - Pas de monitoring
Future<void> syncGameAction(GameSyncEvent event) async {
  await _doSync(event);
  // Aucune visibilité sur les performances
}
```

---

## Anti-Patterns à Éviter Absolument

### ❌ Zone Mismatch (OJYX-7)

**Anti-Pattern :** Initialiser des services après `runApp()`.

```dart
// ❌ DANGEREUX - Zone mismatch
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

**Conséquences :** Crashes aléatoires, erreurs de zone, instabilité générale.

### ❌ Ref après Disposal (OJYX-C)

**Anti-Pattern :** Accéder à `ref` après disposal du provider.

```dart
// ❌ DANGEREUX - Ref après disposal
class BadNotifier extends StateNotifier<State> {
  void someAsyncMethod() async {
    await Future.delayed(Duration(seconds: 1));
    
    // Provider peut être disposed ici
    final service = ref.read(serviceProvider); // CRASH
  }
}

// ✅ CORRECT - Vérification mounted
class GoodNotifier extends StateNotifier<State> {
  void someAsyncMethod() async {
    await Future.delayed(Duration(seconds: 1));
    
    // Vérifier avant chaque accès
    if (!mounted) return;
    
    try {
      final service = ref.read(serviceProvider);
      // Utiliser service...
    } catch (e) {
      if (!mounted) return; // Provider disposed pendant l'opération
      rethrow;
    }
  }
}
```

### ❌ RLS Policies Circulaires (OJYX-D)

**Anti-Pattern :** Policies qui se référencent elles-mêmes.

```sql
-- ❌ DANGEREUX - Récursion infinie
CREATE POLICY "circular_policy" ON players
FOR UPDATE USING (
    EXISTS (
        SELECT 1 FROM players p2
        WHERE p2.id = auth.uid()
        AND p2.current_room_id = players.current_room_id
    )
);

-- ✅ CORRECT - Cas de base pour éviter récursion
CREATE POLICY "safe_policy" ON players
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

### ❌ Performance RLS (OJYX-8)

**Anti-Pattern :** Appels multiples à `auth.uid()` dans les policies.

```sql
-- ❌ LENT - Appels multiples non cachés
CREATE POLICY "slow_policy" ON table
USING (
    auth.uid() = user_id OR
    auth.uid() IN (SELECT user_id FROM other_table) OR
    auth.uid() = creator_id
);

-- ✅ RAPIDE - Un seul appel mis en cache
CREATE POLICY "fast_policy" ON table
USING (
    (SELECT auth.uid()) IS NOT NULL AND (
        user_id = (SELECT auth.uid()) OR
        (SELECT auth.uid()) IN (SELECT user_id FROM other_table) OR
        creator_id = (SELECT auth.uid())
    )
);
```

### ❌ Vérification Auth Manquante (OJYX-9)

**Anti-Pattern :** Opérations critiques sans vérifier l'authentification.

```dart
// ❌ DANGEREUX - Pas de vérification auth
Future<void> createGameState(String roomId) async {
  await supabase.from('game_states').insert({
    'room_id': roomId,
    // Pas de vérification si l'utilisateur est authentifié
  });
}

// ✅ CORRECT - Vérification auth systématique
Future<void> createGameState(String roomId) async {
  final user = supabase.auth.currentUser;
  if (user == null) {
    throw MultiplayerSyncException(
      message: 'User not authenticated for game state creation',
      context: {'room_id': roomId},
    );
  }
  
  await supabase.from('game_states').insert({
    'room_id': roomId,
    'creator_id': user.id, // Toujours inclure creator
  });
}
```

### ❌ Memory Leaks avec StreamSubscriptions

**Anti-Pattern :** Oublier de cancel les subscriptions.

```dart
// ❌ DANGEREUX - Memory leak garanti
class BadWidget extends StatefulWidget {
  @override
  _BadWidgetState createState() => _BadWidgetState();
}

class _BadWidgetState extends State<BadWidget> {
  late StreamSubscription subscription;
  
  @override
  void initState() {
    super.initState();
    subscription = stream.listen(handleEvent);
    // Pas de cancel dans dispose - memory leak
  }
}

// ✅ CORRECT - Cleanup proper
class GoodWidget extends StatefulWidget {
  @override
  _GoodWidgetState createState() => _GoodWidgetState();
}

class _GoodWidgetState extends State<GoodWidget> {
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = stream.listen(handleEvent);
  }
  
  @override
  void dispose() {
    _subscription?.cancel(); // Cleanup obligatoire
    super.dispose();
  }
}
```

### ❌ Mutation d'État Direct

**Anti-Pattern :** Modifier directement les objets Freezed.

```dart
// ❌ INCORRECT - Tentative de mutation
@freezed
class GameState with _$GameState {
  const factory GameState({
    required List<Player> players,
    required GameGrid grid,
  }) = _GameState;
}

void badUpdate() {
  final state = GameState(players: [], grid: GameGrid.empty());
  
  // ERREUR : Freezed objects sont immutables
  state.players.add(newPlayer); // Compile pas
  
  // ERREUR : Même avec cast
  (state.players as List<Player>).add(newPlayer); // Runtime error
}

// ✅ CORRECT - copyWith pattern
void goodUpdate() {
  final state = GameState(players: [], grid: GameGrid.empty());
  
  // Créer nouvelle instance
  final newState = state.copyWith(
    players: [...state.players, newPlayer],
  );
}
```

---

## Patterns de Test

### ✅ Provider Testing avec Overrides

**Pattern :** Tester les providers en isolant les dépendances.

```dart
// ✅ CORRECT - Test avec mocks
void main() {
  group('GameStateNotifier', () {
    late MockGameRepository mockRepo;
    late ProviderContainer container;
    
    setUp(() {
      mockRepo = MockGameRepository();
      container = ProviderContainer(
        overrides: [
          gameRepositoryProvider.overrideWith((ref) => mockRepo),
        ],
      );
    });
    
    tearDown(() {
      container.dispose();
    });
    
    test('should reveal card successfully', () async {
      // Arrange
      when(() => mockRepo.revealCard(any(), any(), any()))
          .thenAnswer((_) async => GameState.withCardRevealed());
      
      final notifier = container.read(gameStateNotifierProvider.notifier);
      
      // Act
      await notifier.revealCard(0, 1);
      
      // Assert
      final state = container.read(gameStateNotifierProvider);
      expect(state.grid.isCardRevealed(0, 1), isTrue);
      verify(() => mockRepo.revealCard(any(), 0, 1)).called(1);
    });
  });
}

// ❌ INCORRECT - Test sans mocks
void main() {
  test('should reveal card', () {
    // Utilise les vraies dépendances - fragile et lent
    final notifier = GameStateNotifier();
    notifier.revealCard(0, 1); // Appelle vraie API
  });
}
```

### ✅ Integration Testing Pattern

**Pattern :** Tests d'intégration pour les flows multijoueur.

```dart
// ✅ CORRECT - Test d'intégration complet
void main() {
  group('Multiplayer Integration Tests', () {
    late TestMultiplayerSetup setup;
    
    setUp(() async {
      setup = await TestMultiplayerSetup.create();
    });
    
    tearDown(() async {
      await setup.cleanup();
    });
    
    testWidgets('should sync card reveal between players', (tester) async {
      // Arrange - 2 joueurs dans la même room
      final player1 = await setup.createPlayer('player1');
      final player2 = await setup.createPlayer('player2');
      await setup.joinRoom(player1, player2);
      
      // Act - Player 1 révèle une carte
      await player1.revealCard(0, 1);
      
      // Assert - Player 2 voit le changement
      await tester.pumpAndSettle();
      expect(player2.getCardAt(0, 1).isRevealed, isTrue);
      
      // Vérifier en base de données
      final dbState = await setup.getGameStateFromDb();
      expect(dbState.grid.isCardRevealed(0, 1), isTrue);
    });
  });
}

class TestMultiplayerSetup {
  static Future<TestMultiplayerSetup> create() async {
    // Configuration test avec vraie base de données de test
    await Supabase.initialize(
      url: testSupabaseUrl,
      anonKey: testAnonKey,
    );
    
    return TestMultiplayerSetup._();
  }
  
  Future<TestPlayer> createPlayer(String id) async {
    // Créer utilisateur de test authentifié
    final auth = await supabase.auth.signInAnonymously();
    return TestPlayer(id: id, auth: auth);
  }
}
```

---

## Patterns de Performance

### ✅ Lazy Loading avec Providers

**Pattern :** Charger les données uniquement quand nécessaire.

```dart
// ✅ CORRECT - Lazy loading avec cache
@riverpod
Future<GameState> gameState(GameStateRef ref, String gameId) async {
  // Cache automatique par gameId
  final repo = ref.watch(gameRepositoryProvider);
  return repo.getGameState(gameId);
}

@riverpod
class GameListNotifier extends _$GameListNotifier {
  @override
  AsyncValue<List<Game>> build() {
    // Pas de chargement initial - attend premier watch
    return const AsyncValue.loading();
  }
  
  Future<void> loadGames() async {
    state = const AsyncValue.loading();
    
    try {
      final games = await ref.read(gameRepositoryProvider).getGames();
      state = AsyncValue.data(games);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Usage - chargement déclenché par UI
class GameListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gameListNotifierProvider);
    
    return gamesAsync.when(
      loading: () {
        // Déclencher chargement seulement maintenant
        Future.microtask(() => 
          ref.read(gameListNotifierProvider.notifier).loadGames()
        );
        return CircularProgressIndicator();
      },
      data: (games) => ListView.builder(...),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}

// ❌ INCORRECT - Chargement immédiat
@riverpod
class EagerGameList extends _$EagerGameList {
  @override
  AsyncValue<List<Game>> build() {
    // Charge immédiatement même si pas affiché
    _loadGames();
    return const AsyncValue.loading();
  }
  
  void _loadGames() async {
    // Chargement même si l'utilisateur n'ira jamais sur cet écran
    final games = await ref.read(gameRepositoryProvider).getGames();
    state = AsyncValue.data(games);
  }
}
```

### ✅ Batch Operations

**Pattern :** Grouper les opérations pour réduire les roundtrips réseau.

```dart
// ✅ CORRECT - Batch des actions
class GameSyncService {
  final List<GameAction> _pendingActions = [];
  Timer? _batchTimer;
  
  void scheduleAction(GameAction action) {
    _pendingActions.add(action);
    
    // Batch toutes les actions en 100ms
    _batchTimer?.cancel();
    _batchTimer = Timer(Duration(milliseconds: 100), _flushBatch);
  }
  
  Future<void> _flushBatch() async {
    if (_pendingActions.isEmpty) return;
    
    final actions = List<GameAction>.from(_pendingActions);
    _pendingActions.clear();
    
    try {
      // Une seule requête pour toutes les actions
      await supabase.rpc('batch_game_actions', params: {
        'actions': actions.map((a) => a.toJson()).toList(),
      });
    } catch (e) {
      // Re-ajouter en cas d'erreur pour retry
      _pendingActions.addAll(actions);
      rethrow;
    }
  }
}

// ❌ INCORRECT - Action par action
class InefficientSync {
  void syncAction(GameAction action) async {
    // Une requête par action - très lent
    await supabase.from('game_actions').insert(action.toJson());
  }
}
```

### ✅ Widget Rebuilding Optimization

**Pattern :** Optimiser les rebuilds avec const et keys.

```dart
// ✅ CORRECT - Widgets optimisés
class OptimizedGameGrid extends StatelessWidget {
  const OptimizedGameGrid({
    Key? key,
    required this.grid,
    required this.onCardTap,
  }) : super(key: key);
  
  final GameGrid grid;
  final void Function(int row, int col) onCardTap;
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 12,
      itemBuilder: (context, index) {
        final row = index ~/ 4;
        final col = index % 4;
        final card = grid.getCard(row, col);
        
        // Key stable pour éviter rebuilds inutiles
        return GameCardWidget(
          key: ValueKey('card_${row}_${col}'),
          card: card,
          onTap: () => onCardTap(row, col),
        );
      },
    );
  }
}

class GameCardWidget extends StatelessWidget {
  const GameCardWidget({
    Key? key,
    required this.card,
    required this.onTap,
  }) : super(key: key);
  
  final GameCard card;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    // Widget const quand possible
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration( // const decoration
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: card.isRevealed 
            ? Text('${card.value}') 
            : const Icon(Icons.help_outline), // const icon
      ),
    );
  }
}

// ❌ INCORRECT - Rebuilds inutiles
class BadGameGrid extends StatelessWidget {
  final GameGrid grid;
  final Function onCardTap;
  
  BadGameGrid({required this.grid, required this.onCardTap});
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) {
        // Pas de key - rebuilds inutiles
        // Decoration créée à chaque build
        return GestureDetector(
          onTap: () => onCardTap(index ~/ 4, index % 4),
          child: Container(
            decoration: BoxDecoration( // Nouvelle instance à chaque build
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: buildCardContent(index), // Method call - pas const
          ),
        );
      },
    );
  }
}
```

---

## Résumé des Règles d'Or

### 🎯 Architecture
1. **Feature-first** : Organiser par valeur business
2. **Clean Architecture** : Séparer presentation/domain/data
3. **Dependency Injection** : Utiliser Riverpod pour tout
4. **Immutabilité** : Freezed pour tous les modèles

### 🎯 État et Synchronisation
1. **Optimistic UI** : Feedback immédiat + rollback
2. **Event-driven** : Communication par événements typés
3. **Conflict resolution** : Stratégie claire "server wins"
4. **Connection management** : États explicites + retry logic

### 🎯 Base de Données
1. **RLS optimisé** : Cache `auth.uid()` systématiquement
2. **Transactions** : Grouper opérations cohérentes
3. **Validation** : Triggers pour intégrité automatique
4. **Monitoring** : Vues pour performance et violations

### 🎯 Erreurs et Monitoring
1. **Structured errors** : Hiérarchie avec contexte riche
2. **Sentry integration** : Tags, contexte, breadcrumbs
3. **Performance tracking** : Mesurer opérations critiques
4. **Alerting** : Seuils et escalation automatique

### 🎯 Performance
1. **Lazy loading** : Charger à la demande
2. **Batch operations** : Grouper requêtes réseau
3. **Widget optimization** : const, keys, select
4. **Resource cleanup** : Cancel subscriptions, dispose

### 🚫 À Éviter Absolument
1. **Zone mismatch** : Initialiser avant runApp
2. **Ref après disposal** : Vérifier mounted
3. **RLS circulaires** : Cas de base obligatoire
4. **Auth non vérifiée** : Contrôler avant opérations
5. **Memory leaks** : Cancel toutes les subscriptions

Ces patterns sont le fruit de l'expérience acquise sur le projet Ojyx et représentent les meilleures pratiques validées en production. Ils doivent être suivis scrupuleusement pour maintenir la qualité et la stabilité du système.