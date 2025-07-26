# Inventaire des Modèles Freezed - Projet Ojyx

**Date**: 26 juillet 2025  
**Branche**: feature/major-dependencies-upgrade  
**Version Freezed**: 3.1.0 (après upgrade)  

## Résumé Exécutif

**26 modèles Freezed** identifiés dans le projet, répartis principalement dans les entités de domaine et les modèles de données. La majorité utilise déjà la syntaxe moderne avec `@Default()`, mais tous nécessitent la migration vers la syntaxe `@Freezed()` pour la v3.1.0.

## Classification des Modèles

### 🎯 Entités de Domaine (Priorité HAUTE)
| Fichier | Type | Complexité | JSON | Unions | @Default |
|---------|------|------------|------|--------|----------|
| `core/errors/failures.dart` | **Union** | Élevée | ❌ | ✅ (7 types) | ❌ |
| `game/domain/entities/game_state.dart` | Simple | Moyenne | ❌ | ❌ | ❌ |
| `game/domain/entities/action_card.dart` | Simple | Faible | ✅ | ❌ | ✅ (3) |
| `game/domain/entities/card.dart` | Simple | Faible | ✅ | ❌ | ✅ (1) |
| `game/domain/entities/game_player.dart` | Simple | Moyenne | ✅ | ❌ | ✅ (5) |
| `game/domain/entities/player_grid.dart` | Simple | Faible | ✅ | ❌ | ❌ |
| `game/domain/entities/player_state.dart` | Simple | Moyenne | ✅ | ❌ | ❌ |
| `game/domain/entities/deck_state.dart` | Simple | Faible | ✅ | ❌ | ❌ |
| `game/domain/entities/card_position.dart` | Simple | Faible | ❌ | ❌ | ❌ |

### 📊 Modèles de Données (Priorité MOYENNE)
| Fichier | Type | Complexité | JSON | @Default |
|---------|------|------------|------|----------|
| `game/data/models/game_state_model.dart` | Simple | Moyenne | ✅ | ❌ |
| `game/data/models/player_grid_model.dart` | Simple | Faible | ✅ | ❌ |
| `game/data/models/db_player_grid_model.dart` | Simple | Faible | ✅ | ❌ |
| `multiplayer/data/models/room_model.dart` | Simple | Moyenne | ✅ | ❌ |
| `multiplayer/data/models/player_model.dart` | Simple | Faible | ✅ | ❌ |
| `global_scores/data/models/global_score_model.dart` | Simple | Faible | ✅ | ❌ |

### 🎮 États Multiplayer (Priorité HAUTE)
| Fichier | Type | Complexité | JSON | Unions |
|---------|------|------------|------|--------|
| `multiplayer/domain/entities/room_event.dart` | **Union** | Élevée | ✅ | ✅ (5 types) |
| `multiplayer/domain/entities/room.dart` | Simple | Moyenne | ✅ | ❌ |
| `multiplayer/domain/entities/lobby_player.dart` | Simple | Faible | ✅ | ❌ |
| `end_game/domain/entities/end_game_state.dart` | Simple | Faible | ❌ | ❌ |

### 🔄 Providers Riverpod (Priorité MOYENNE)
| Fichier | Type | Usage |
|---------|------|-------|
| `game/presentation/providers/action_card_providers.dart` | États | Actions cartes |
| `game/presentation/providers/action_card_state_provider.dart` | État | Gestion état cartes |
| `game/presentation/providers/card_selection_provider.dart` | État | Sélection cartes |
| `game/presentation/providers/card_selection_provider_v2.dart` | État | Sélection v2 |
| `game/presentation/providers/game_animation_provider.dart` | État | Animations |
| `game/presentation/providers/game_animation_provider_v2.dart` | État | Animations v2 |

## Patterns de Code Identifiés

### ✅ Syntaxe Moderne (Déjà Conforme)
```dart
@freezed
class ActionCard with _$ActionCard {
  const factory ActionCard({
    required String id,
    @Default(ActionTiming.optional) ActionTiming timing,
    @Default(ActionTarget.none) ActionTarget target,
    @Default({}) Map<String, dynamic> parameters,
  }) = _ActionCard;
}
```

### ⚠️ Syntaxe à Migrer (Legacy)
```dart
@freezed  // ❌ Doit devenir @Freezed()
class GameState with _$GameState {
  const factory GameState({
    required String roomId,
    // Pas de @Default() utilisé
  }) = _GameState;
}
```

### 🔄 Unions Complexes
```dart
@freezed  // ❌ Doit devenir @Freezed()
class Failure with _$Failure {
  const factory Failure.server({required String message}) = ServerFailure;
  const factory Failure.network({required String message}) = NetworkFailure;
  // ... 7 types d'union au total
}
```

## Analyse des Dépendances

### JSON Serialization
- **31 fichiers** avec `part '*.g.dart'`
- **26 fichiers** utilisent fromJson/toJson
- **5 fichiers** sans sérialisation JSON

### Converters Personnalisés
- `GameStateConverter` dans room_event.dart
- Converters pour types énumérés complexes

### Imports Patterns
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'filename.freezed.dart';
part 'filename.g.dart';  // Si JSON
```

## Plan de Migration par Priorité

### 🔴 Phase 1: Unions Critiques (2h)
1. **`core/errors/failures.dart`** - 7 types d'union, aucun JSON
2. **`multiplayer/domain/entities/room_event.dart`** - 5 types, JSON + Converter

### 🟡 Phase 2: Entités Core (3h)
1. **`game/domain/entities/game_state.dart`** - Central au jeu
2. **`game/domain/entities/game_player.dart`** - 5 @Default()
3. **`game/domain/entities/action_card.dart`** - Déjà moderne, test migration

### 🟢 Phase 3: Modèles & Providers (2h)
1. Modèles de données (6 fichiers)
2. Providers Riverpod (6 fichiers)
3. Autres entités (3 fichiers)

## Estimation d'Effort

| Phase | Fichiers | Complexité | Effort | Risque |
|-------|----------|------------|--------|--------|
| **Phase 1** | 2 | Élevée | 2h | Élevé |
| **Phase 2** | 7 | Moyenne | 3h | Moyen |
| **Phase 3** | 17 | Faible | 2h | Faible |
| **Total** | **26** | **Mixte** | **7h** | **Moyen** |

## Points d'Attention

### 🚨 Risques Identifiés
1. **Unions complexes** - Changements dans .map()/.when()
2. **Converters JSON** - Compatibilité json_serializable 6.8.0
3. **Providers Riverpod** - Double migration nécessaire
4. **GameState** - Impact sur toute la logique de jeu

### 🔧 Commandes de Migration
```bash
# Nettoyer les fichiers générés
flutter packages pub run build_runner clean

# Régénérer avec nouvelle syntaxe
flutter packages pub run build_runner build --delete-conflicting-outputs

# Validation par fichier
flutter analyze lib/path/to/file.dart
```

### 📝 Pattern de Migration Standard
```diff
// AVANT
- @freezed
+ @Freezed()
class MyClass with _$MyClass {
  const factory MyClass({
    required String id,
+   @Default('defaultValue') String name,
  }) = _MyClass;
}
```

## Fichiers de Test Correspondants

Chaque modèle migré doit avoir des tests validant:
- Création d'instance avec/sans valeurs par défaut
- Sérialisation/désérialisation JSON
- copyWith() avec null et valeurs
- Égalité et hashCode
- toString() lisible

---

**Status**: ✅ Inventaire complet terminé  
**Prochaine étape**: Démarrer Phase 1 - Migration unions critiques  
**Estimation totale**: 7 heures sur 3 phases