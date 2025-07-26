# Guide de Migration des Dépendances Critiques - Projet Ojyx

## Aperçu

Ce guide documente les changements majeurs (breaking changes) pour les dépendances principales du projet Ojyx lors de la migration vers les versions les plus récentes :

- **Freezed** : 2.5.7 → 3.2.0+ (macros Dart 3)
- **Riverpod** : 2.6.1 → 3.0.0+ (AsyncNotifier API)
- **go_router** : 14.6.2 → 15.0.0+ (StatefulShellRoute)
- **supabase_flutter** : 2.8.0 → 3.0.0+ (nouvelle architecture)

## 🧊 Freezed v3.0+ - Migration vers les Macros Dart 3

### Changements Obligatoires

#### 1. Ajout des mots-clés `abstract` et `sealed`

```dart
// ❌ Avant (v2.x)
@freezed
class Person with _$Person {
  const factory Person({
    required String firstName,
    required String lastName,
    required int age,
  }) = _Person;
}

// ✅ Après (v3.x) - Classe simple
@freezed
abstract class Person with _$Person {
  const factory Person({
    required String firstName,
    required String lastName,
    required int age,
  }) = _Person;
}

// ✅ Après (v3.x) - Union types
@freezed
sealed class Model with _$Model {
  factory Model.first(String a) = First;
  factory Model.second(int b, bool c) = Second;
}
```

#### 2. Migration des Pattern Matching

```dart
// ❌ Avant - .map/.when (générés par Freezed)
final res = model.map(
  first: (String a) => 'first $a',
  second: (int b, bool c) => 'second $b $c',
);

// ✅ Après - switch expression Dart natif
final res = switch (model) {
  First(:final a) => 'first $a',
  Second(:final b, :final c) => 'second $b $c',
};
```

### Patterns Identifiés dans Ojyx

```bash
# Scan des usages à migrer
grep -r "@freezed" lib/ --include="*.dart"
grep -r "\.map(" lib/ --include="*.dart" 
grep -r "\.when(" lib/ --include="*.dart"
```

**Estimation** : ~15-20 modèles à migrer dans `/lib/features/`

## 🏞️ Riverpod v3.0+ - Nouvelle API AsyncNotifier

### Changements Architecturaux Majeurs

#### 1. StateNotifier → AsyncNotifier

```dart
// ❌ Avant - StateNotifierProvider
class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier(this.ref) : super(const GameState.initial());
  
  final Ref ref;
  
  void updateCard(int index, Card card) {
    state = state.copyWith(cards: {...});
  }
}

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier(ref);
});

// ✅ Après - AsyncNotifierProvider
@riverpod
class GameState extends _$GameState {
  @override
  GameStateData build() {
    return const GameStateData.initial();
  }
  
  void updateCard(int index, Card card) {
    state = state.copyWith(cards: {...});
  }
}
```

#### 2. Nouvelle Syntaxe d'Observation

```dart
// ❌ Avant
final gameState = ref.watch(gameStateProvider);
final notifier = ref.read(gameStateProvider.notifier);

// ✅ Après
final gameState = ref.watch(gameStateProvider);
final notifier = ref.read(gameStateProvider.notifier);
// L'API reste identique pour les consumers !
```

#### 3. Migration des Providers Complexes

```dart
// ❌ Avant - FutureProvider
final playerDataProvider = FutureProvider<Player>((ref) async {
  final playerId = ref.watch(currentPlayerIdProvider);
  return await ref.read(databaseProvider).getPlayer(playerId);
});

// ✅ Après - @riverpod avec build async
@riverpod
Future<Player> playerData(PlayerDataRef ref) async {
  final playerId = ref.watch(currentPlayerIdProvider);
  return await ref.read(databaseProvider).getPlayer(playerId);
}
```

### Import Legacy pour Transition

```dart
// Pendant la migration graduelle
import 'package:riverpod/legacy.dart'; // Pour StateNotifierProvider
import 'package:riverpod/riverpod.dart'; // Pour nouveaux providers
```

### Patterns Identifiés dans Ojyx

```bash
# Providers à migrer
grep -r "StateNotifierProvider" lib/ --include="*.dart"
grep -r "FutureProvider" lib/ --include="*.dart"
grep -r "StreamProvider" lib/ --include="*.dart"
```

**Estimation** : ~8-12 providers dans `/lib/features/game/` et `/lib/features/auth/`

## 🧭 go_router v15.0+ - StatefulShellRoute

### Nouveaux Concepts

#### 1. StatefulShellRoute pour Navigation Persistante

```dart
// ❌ Avant - ShellRoute simple
ShellRoute(
  builder: (context, state, child) => ScaffoldWithNavBar(child: child),
  routes: [...],
)

// ✅ Après - StatefulShellRoute.indexedStack
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return ScaffoldWithNavBar(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      navigatorKey: _sectionANavigatorKey,
      routes: [
        GoRoute(path: '/game', builder: (context, state) => GameScreen()),
      ],
    ),
    StatefulShellBranch(
      navigatorKey: _sectionBNavigatorKey, 
      routes: [
        GoRoute(path: '/stats', builder: (context, state) => StatsScreen()),
      ],
    ),
  ],
)
```

#### 2. Navigation entre Branches

```dart
// Nouveau widget pour navigation stateful
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Jeu'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Stats'),
        ],
      ),
    );
  }
}
```

### Patterns Identifiés dans Ojyx

```bash
# Routes à migrer
grep -r "ShellRoute" lib/ --include="*.dart"
grep -r "GoRoute" lib/ --include="*.dart"
```

**Estimation** : Configuration principale dans `/lib/core/config/router_config.dart`

## 🚀 Supabase Flutter v3.0+ - Nouvelle Architecture

### Changements d'Authentification

#### 1. Méthodes de Connexion Spécialisées

```dart
// ❌ Avant - signIn générique
await supabase.auth.signIn(email: 'user@example.com', password: 'password');
await supabase.auth.signIn(email: 'user@example.com'); // magic link

// ✅ Après - méthodes spécialisées
await supabase.auth.signInWithPassword(email: 'user@example.com', password: 'password');
await supabase.auth.signInWithOtp(email: 'user@example.com');
```

#### 2. Gestion des États d'Auth via Stream

```dart
// ❌ Avant - callback
supabase.auth.onAuthStateChange((event, session) {
  // Gestion des changements d'état
});

// ✅ Après - Stream
final subscription = supabase.auth.onAuthStateChange.listen((data) {
  final AuthChangeEvent event = data.event;
  final Session? session = data.session;
  // Gestion des changements d'état
});

// Important : annuler la subscription
@override
void dispose() {
  subscription.cancel();
  super.dispose();
}
```

#### 3. Mise à jour des Utilisateurs

```dart
// ❌ Avant
await supabase.auth.update(UserAttributes(email: 'new@email.com'));

// ✅ Après  
await supabase.auth.updateUser(UserAttributes(email: 'new@email.com'));
```

### Changements Realtime

#### 1. Nouvelle API Realtime

```dart
// ❌ Avant - ancienne syntaxe
supabase.from('games').stream(['id'])
  .eq('status', 'active')
  .listen((data) => print(data));

// ✅ Après - syntaxe channel
final channel = supabase.channel('game_updates');

channel.onPostgresChanges(
  event: PostgresChangeEvent.all,
  schema: 'public', 
  table: 'games',
  callback: (payload) {
    // Traitement des changements
  },
).subscribe();
```

#### 2. Gestion des Channels

```dart
// Nouveau pattern pour les channels
final gameChannel = supabase.channel('game_${gameId}');

// Écoute des changements PostgreSQL
gameChannel.onPostgresChanges(
  event: PostgresChangeEvent.update,
  schema: 'public',
  table: 'game_states', 
  filter: PostgresChangeFilter(column: 'game_id', value: gameId),
  callback: (payload) {
    // Synchronisation en temps réel
  },
);

// Broadcast entre joueurs
gameChannel.onBroadcast(
  event: 'player_action',
  callback: (payload) {
    // Action d'un autre joueur
  },
);

// S'abonner au channel
gameChannel.subscribe();
```

### Patterns Identifiés dans Ojyx

```bash
# Auth patterns à migrer
grep -r "\.signIn(" lib/ --include="*.dart"
grep -r "onAuthStateChange" lib/ --include="*.dart"
grep -r "\.update(" lib/ --include="*.dart"

# Realtime patterns
grep -r "\.stream(" lib/ --include="*.dart" 
grep -r "realtime" lib/ --include="*.dart"
```

**Estimation** : 
- Auth : ~5-8 usages dans `/lib/features/auth/`
- Realtime : ~3-5 usages dans `/lib/features/game/`

## 📋 Plan de Migration Recommandé

### Phase 1: Préparation (1-2 jours)
1. **Backup complet** du projet
2. **Création branche** `feat/dependencies-migration`
3. **Tests de régression** complets
4. **Documentation** des patterns actuels

### Phase 2: Migration Freezed (1 jour)
1. Mise à jour vers Dart 3 (déjà fait)
2. Ajout des mots-clés `abstract`/`sealed`
3. Migration des `.map`/`.when` vers `switch`
4. Génération de code avec `build_runner`

### Phase 3: Migration Riverpod (2-3 jours)
1. Import legacy pour transition
2. Migration graduelle des providers
3. Tests de régression après chaque provider
4. Suppression imports legacy

### Phase 4: Migration go_router (1 jour)
1. Refactoring configuration routes
2. Implémentation StatefulShellRoute
3. Tests navigation

### Phase 5: Migration Supabase (2 jours)
1. Migration méthodes auth
2. Refactoring Realtime vers channels
3. Tests d'intégration auth + realtime

### Phase 6: Validation (1 jour)
1. Tests end-to-end complets
2. Vérification performance
3. Documentation mise à jour

## 🧪 Stratégies de Test

### Tests de Migration
```dart
// Test de compatibilité Freezed
testWidgets('Freezed models serialization compatibility', (tester) async {
  final oldModel = OldGameState.fromJson(json);
  final newModel = GameState.fromJson(json);
  expect(newModel.toJson(), equals(oldModel.toJson()));
});

// Test de migration Riverpod
testWidgets('Riverpod provider behavior consistency', (tester) async {
  final container = ProviderContainer();
  final gameState = container.read(gameStateProvider);
  // Vérifier que l'état est identique
});
```

### Tests d'Intégration
```dart
// Test Supabase Realtime
testWidgets('Real-time game sync works correctly', (tester) async {
  // Simuler deux clients
  // Vérifier synchronisation
});
```

## ⚠️ Points d'Attention

### Freezed
- **Breaking** : Les `.map`/`.when` ne sont plus générés
- **Action** : Migrer vers `switch` expressions natifs
- **Impact** : Moyen - principalement syntaxique

### Riverpod  
- **Breaking** : StateNotifierProvider déprécié
- **Action** : Migrer vers `@riverpod` et AsyncNotifier
- **Impact** : Élevé - architecture globale

### go_router
- **Breaking** : ShellRoute API changée
- **Action** : Utiliser StatefulShellRoute pour navigation persistante
- **Impact** : Moyen - configuration centralisée

### Supabase
- **Breaking** : APIs auth et realtime refactorisées
- **Action** : Méthodes spécialisées + channels
- **Impact** : Élevé - fonctionnalités temps réel critiques

## 🔍 Outils de Validation

### Scripts de Détection
```bash
# Script de validation post-migration
./scripts/validate_migration.sh

# Vérifications automatiques
flutter analyze --no-fatal-infos
flutter test --coverage
flutter pub run build_runner build --delete-conflicting-outputs
```

### Métriques de Succès
- ✅ Compilation sans erreurs
- ✅ Tests unitaires 100% passants  
- ✅ Tests d'intégration fonctionnels
- ✅ Performance ≥ baseline actuelle
- ✅ Fonctionnalités temps réel opérationnelles

---

**Date de création** : 2025-07-26  
**Auteur** : Claude Code Assistant  
**Version** : 1.0  
**Statut** : Draft pour validation équipe