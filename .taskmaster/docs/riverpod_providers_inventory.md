# Inventaire des Providers Riverpod - Projet Ojyx

Date: 2025-07-26
Versions: Riverpod 2.6.1 → 3.0.0

## Résumé

- **Total providers identifiés**: 37+ 
- **StateNotifierProvider à migrer**: 3
- **Providers @riverpod modernes**: 14
- **ChangeNotifierProvider**: 1
- **Autres providers (Provider, FutureProvider, etc.)**: Variable

## 1. StateNotifierProvider à migrer

### 1.1 CardSelectionNotifier
- **Fichier**: `/lib/features/game/presentation/providers/card_selection_provider.dart`
- **Type actuel**: `StateNotifierProvider<CardSelectionNotifier, CardSelectionState>`
- **État géré**: `CardSelectionState` (Freezed)
- **Complexité**: Moyenne - gestion de sélections multiples de cartes
- **Dépendances**: Aucune
- **Méthodes principales**:
  - `startTeleportSelection()`
  - `startSwapSelection()`
  - `startPeekSelection()`
  - `selectCard()`
  - `clearSelection()`

### 1.2 ActionCardStateNotifier
- **Fichier**: `/lib/features/game/presentation/providers/action_card_providers.dart`
- **Type actuel**: `StateNotifierProvider<ActionCardStateNotifier, ActionCardState>`
- **État géré**: `ActionCardState` (Freezed)
- **Complexité**: Simple - compteurs de cartes
- **Dépendances**: Aucune
- **Méthodes principales**:
  - `updateCounts()`
  - `setLoading()`
  - `drawCard()`

### 1.3 GameAnimationNotifier
- **Fichier**: `/lib/features/game/presentation/providers/game_animation_provider.dart`
- **Type actuel**: `StateNotifierProvider<GameAnimationNotifier, GameAnimationState>`
- **État géré**: `GameAnimationState` (Freezed)
- **Complexité**: Moyenne - gestion d'animations
- **Dépendances**: Aucune
- **Méthodes principales**:
  - `showDirectionChange()`
  - `hideDirectionChange()`
  - Autres méthodes d'animation

## 2. Providers @riverpod modernes (déjà migrés)

### 2.1 Core Providers
1. **ConnectivityProvider** (`/lib/core/providers/connectivity_provider.dart`)
   - Utilise déjà `@riverpod`
   - Plusieurs providers: `connectivityService`, `connectivityStatus`, `connectivityStatusStream`

2. **SupabaseProvider** (`/lib/core/providers/supabase_provider_v2.dart`)
   - `@riverpod` SupabaseClient

3. **StorageProvider** (`/lib/core/providers/storage_provider.dart`)
   - `@riverpod` SharedPreferencesAsync

4. **SentryProvider** (`/lib/core/providers/sentry_provider.dart`)
   - `@riverpod` SentryService

5. **FileProvider** (`/lib/core/providers/file_provider.dart`)
   - `@riverpod` FileService et providers associés

### 2.2 Game Providers (déjà modernes)
1. **GameStateNotifier** (`/lib/features/game/presentation/providers/game_state_notifier.dart`)
   - DÉJÀ migré vers `@riverpod class GameStateNotifier extends _$GameStateNotifier`
   - Utilise la syntaxe Notifier moderne avec `build()`

2. **CardSelectionProviderV2** (`/lib/features/game/presentation/providers/card_selection_provider_v2.dart`)
   - `@riverpod class CardSelection extends _$CardSelection`
   - Version moderne déjà créée !

3. **GameAnimationProviderV2** (`/lib/features/game/presentation/providers/game_animation_provider_v2.dart`)
   - `@riverpod class GameAnimation extends _$GameAnimation`
   - Version moderne existe aussi !

### 2.3 Multiplayer Providers
1. **RoomProviders** (`/lib/features/multiplayer/presentation/providers/room_providers.dart`)
   - Multiples providers `@riverpod`
   - Datasources, repositories, use cases

2. **MultiplayerGameNotifier** (`/lib/features/multiplayer/presentation/providers/multiplayer_game_notifier.dart`)
   - `@riverpod class MultiplayerGameNotifier extends _$MultiplayerGameNotifier`

### 2.4 Auth Providers
1. **AuthProvider** (`/lib/features/auth/presentation/providers/auth_provider.dart`)
   - `@riverpod` providers modernes

## 3. ChangeNotifierProvider

### 3.1 RouterRefreshNotifier
- **Fichier**: `/lib/core/config/router_config_v2.dart`
- **Type**: `ChangeNotifier`
- **Usage**: Refresh du router sur changements auth
- **Migration**: À convertir en Notifier simple

## 4. Autres Providers Legacy

Trouvés dans les screens et widgets:
- `Provider()` directs dans certains screens
- Potentiels `FutureProvider` et `StreamProvider` à identifier

## 5. Patterns de migration identifiés

### 5.1 Doublons V1/V2
**IMPORTANT**: Il existe déjà des versions V2 modernes pour:
- `card_selection_provider.dart` → `card_selection_provider_v2.dart`
- `game_animation_provider.dart` → `game_animation_provider_v2.dart`

Stratégie: Remplacer les références aux anciennes versions par les V2.

### 5.2 Ordre de migration recommandé

1. **Phase 1**: Nettoyer les doublons
   - Supprimer les anciens providers qui ont des V2
   - Mettre à jour toutes les références

2. **Phase 2**: Migrer les StateNotifier restants
   - `ActionCardStateNotifier` (simple, sans dépendances)
   - Autres StateNotifier trouvés

3. **Phase 3**: Migrer ChangeNotifier
   - `RouterRefreshNotifier` vers Notifier

4. **Phase 4**: Moderniser les providers legacy
   - Remplacer les `Provider()` directs
   - Migrer les patterns anciens

## 6. Tests à adapter

- Tests unitaires des providers migrés
- Tests d'intégration avec ProviderContainer
- Vérifier les overrides dans les tests widgets

## 7. Risques et points d'attention

1. **Doublons V1/V2**: Attention aux conflits lors du remplacement
2. **Dépendances circulaires**: Vérifier les refs entre providers
3. **Performance**: Mesurer avant/après migration
4. **Compatibilité**: Certains widgets peuvent utiliser les anciens patterns

## 8. Métriques de migration

- **Providers modernes existants**: 14+
- **StateNotifier à migrer**: 3 (mais 2 ont déjà des V2)
- **Effort estimé**: 4-6 heures
- **Complexité globale**: Moyenne (beaucoup déjà fait)