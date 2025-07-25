# Analyse des Breaking Changes - Projet Ojyx
Date: 2025-07-25

## Vue d'Ensemble des Breaking Changes

Cette analyse couvre les changements majeurs pour les mises à jour critiques identifiées dans l'audit des dépendances.

## 1. Freezed 2.5.8 → 3.2.0 & Freezed Annotation 2.4.4 → 3.1.0

### 🚨 Breaking Changes Majeurs

#### Changements de Syntaxe
- **Classes abstraites obligatoires** : Toutes les classes @freezed doivent maintenant être déclarées avec `abstract` ou `sealed`
- **Suppression de when/map** : Remplacés par le pattern matching natif de Dart 3.0
- **Dart 3.0+ requis** : Utilisation des nouvelles fonctionnalités du langage

#### Exemples de Migration

**Déclaration de classe:**
```dart
// ❌ Ancien (2.5.8)
@freezed
class GameState with _$GameState {
  const factory GameState.initial() = _Initial;
  const factory GameState.playing() = _Playing;
}

// ✅ Nouveau (3.1.0)
@freezed
sealed class GameState with _$GameState {
  const factory GameState.initial() = _Initial;
  const factory GameState.playing() = _Playing;
}
```

**Pattern Matching:**
```dart
// ❌ Ancien - when/map
state.when(
  initial: () => showStartScreen(),
  playing: () => showGameBoard(),
);

// ✅ Nouveau - switch expression
final widget = switch (state) {
  GameStateInitial() => showStartScreen(),
  GameStatePlaying() => showGameBoard(),
};
```

### Impact sur Ojyx
- **Tous les modèles de données** devront être revus
- **Génération de code** à refaire complètement
- **Tests unitaires** à adapter pour le nouveau pattern matching

## 2. Go Router 14.8.1 → 16.0.0

### 🚨 Breaking Changes Majeurs

#### Sensibilité à la Casse
- **URLs case-sensitive par défaut** (depuis v15.0.0)
- Peut casser les routes existantes si elles dépendent de l'insensibilité

#### Configuration Requise
```dart
// Pour maintenir l'ancien comportement
final router = GoRouter(
  caseSensitive: false,  // Ajouter cette ligne
  routes: [...],
);
```

### Impact sur Ojyx
- Vérifier toutes les routes pour la sensibilité à la casse
- Mettre à jour la configuration du router
- Tester tous les deep links

## 3. Flutter Lints 5.0.0 → 6.0.0

### 🚨 Breaking Changes Majeurs

#### Nouvelles Règles de Lint
1. **strict_top_level_inference** : Inférence stricte au niveau supérieur
2. **unnecessary_underscores** : Détecte les underscores inutiles

#### SDK Minimum
- Flutter 3.32.0
- Dart 3.8.0

### Impact sur Ojyx
- Potentiellement beaucoup de warnings à corriger
- Amélioration de la qualité du code
- Temps de correction estimé : moyen

## 4. Sentry Flutter 8.14.2 → 9.5.0

### 🚨 Breaking Changes Majeurs

#### Changements d'API
- **Classes mutables** : Plus de `copyWith`, mutation directe
- **Screenshots masqués par défaut**
- **Méthodes supprimées** : enableTracing, autoAppStart

#### Exemples de Migration
```dart
// ❌ Ancien (8.x)
options.beforeSend = (event, hint) {
  event = event.copyWith(release: 'v1.0.0');
  return event;
}

// ✅ Nouveau (9.x)
options.beforeSend = (event, hint) {
  event.release = 'v1.0.0';  // Mutation directe
  return event;
}
```

#### Configuration Android
- API minimum : 21
- Kotlin : 1.5.31+

### Impact sur Ojyx
- Refactorisation de toute la configuration Sentry
- Mise à jour des configurations Android
- Tests d'intégration à revoir

## Matrice de Compatibilité Inter-Dépendances

| Package | Version Cible | Dart Min | Flutter Min | Conflits Potentiels |
|---------|---------------|----------|-------------|-------------------|
| freezed | 3.2.0 | 3.0.0 | - | build_runner, analyzer |
| freezed_annotation | 3.1.0 | 3.0.0 | - | - |
| go_router | 16.0.0 | 3.6.0 | 3.27.0 | - |
| flutter_lints | 6.0.0 | 3.8.0 | 3.32.0 | lints transitive |
| sentry_flutter | 9.5.0 | 3.5.0 | 3.24.0 | - |
| build_runner | 2.6.0 | 2.19.0 | - | analyzer, build |
| json_serializable | 6.10.0 | 3.5.0 | - | source_gen |

### Contraintes Globales Résultantes
- **Dart SDK minimum** : 3.8.0 (imposé par flutter_lints)
- **Flutter SDK minimum** : 3.32.0 (imposé par flutter_lints)
- **Android API minimum** : 21 (imposé par sentry_flutter)
- **Kotlin minimum** : 1.5.31 (imposé par sentry_flutter)

## Dépendances Transitives Critiques

### Analyzer (7.6.0 → 8.0.0)
- Impact sur build_runner et tous les générateurs de code
- Changements dans l'API d'analyse

### Build (2.5.4 → 3.0.0)
- Core pour build_runner
- Peut nécessiter des ajustements dans la configuration

### Source Gen (2.0.0 → 3.0.0)
- Affecte json_serializable et freezed
- Changements dans la génération de code

## Ordre de Migration Recommandé

### Phase 1: Préparation (Risque: Faible)
1. **Mise à jour SDK** : Dart 3.8.0+ et Flutter 3.32.0+
2. **flutter_lints** : Correction des nouveaux warnings

### Phase 2: Génération de Code (Risque: Élevé)
1. **build_runner** : Mise à jour mineure
2. **json_serializable** : Mise à jour mineure
3. **freezed + freezed_annotation** : Migration majeure coordonnée
   - Adapter tous les modèles
   - Régénérer le code
   - Adapter les tests

### Phase 3: Navigation (Risque: Moyen)
1. **go_router** : Vérifier la sensibilité à la casse
   - Tester toutes les routes
   - Adapter la configuration

### Phase 4: Services (Risque: Moyen)
1. **sentry_flutter** : Refactoriser la configuration
   - Adapter les callbacks
   - Mettre à jour Android

## Points d'Attention Spécifiques

### Pour Freezed
- Prévoir du temps pour adapter TOUS les modèles
- Les tests utilisant when/map devront être réécrits
- La génération de code peut échouer initialement

### Pour Go Router
- Tester exhaustivement la navigation
- Vérifier les deep links
- S'assurer que la sensibilité à la casse ne casse rien

### Pour Sentry
- La configuration devra être entièrement revue
- Les tests d'intégration devront être adaptés
- Vérifier la compatibilité Android

## Estimation du Temps

| Package | Complexité | Temps Estimé | Risque |
|---------|------------|--------------|---------|
| flutter_lints | Faible | 2-4h | Faible |
| build_runner | Faible | 1-2h | Faible |
| json_serializable | Faible | 1-2h | Faible |
| freezed | Élevée | 8-16h | Élevé |
| go_router | Moyenne | 4-6h | Moyen |
| sentry_flutter | Moyenne | 4-6h | Moyen |

**Total estimé** : 20-36 heures de travail

## Actions Critiques

1. ✅ Créer des tests de régression AVANT toute migration
2. ✅ Sauvegarder l'état actuel (git branch)
3. ✅ Migrer par petits incréments testables
4. ✅ Valider chaque étape avec la CI/CD
5. ✅ Documenter tous les changements