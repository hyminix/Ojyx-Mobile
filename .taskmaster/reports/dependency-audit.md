# Rapport d'Audit des Dépendances - Projet Ojyx
Date: 2025-07-25

## Résumé Exécutif

- **SDK Flutter actuel**: 3.32.6 (stable)
- **SDK Dart actuel**: 3.8.1
- **Total de dépendances obsolètes**: 28 packages
- **Dépendances directes obsolètes**: 3
- **Dépendances de développement obsolètes**: 5
- **Dépendances transitives obsolètes**: 20

## État Actuel vs Cible

### 🚨 Dépendances Directes (Production)

| Package | Version Actuelle | Version Résolvable | Version Latest | Écart | Priorité |
|---------|-----------------|-------------------|----------------|-------|----------|
| freezed_annotation | 2.4.4 | 3.1.0 | 3.1.0 | Major | **HAUTE** |
| go_router | 14.8.1 | 16.0.0 | 16.0.0 | Major | **HAUTE** |
| sentry_flutter | 8.14.2 | 9.5.0 | 9.5.0 | Major | **MOYENNE** |
| flutter_riverpod | 2.6.1 | - | - | Current | OK |
| riverpod_annotation | 2.3.5 | - | - | Current | OK |
| json_annotation | 4.9.0 | - | - | Current | OK |
| supabase_flutter | 2.9.1 | - | - | Current | OK |
| dartz | 0.10.1 | - | - | Current | OK |
| fpdart | 1.1.0 | - | - | Current | OK |
| cupertino_icons | 1.0.8 | - | - | Current | OK |

### 🔧 Dépendances de Développement

| Package | Version Actuelle | Version Résolvable | Version Latest | Écart | Priorité |
|---------|-----------------|-------------------|----------------|-------|----------|
| flutter_lints | 5.0.0 | 6.0.0 | 6.0.0 | Major | **HAUTE** |
| build_runner | 2.5.4 | 2.5.4 | 2.6.0 | Minor | MOYENNE |
| freezed | 2.5.8 | 3.1.0 | 3.2.0 | Major | **HAUTE** |
| json_serializable | 6.9.5 | 6.9.5 | 6.10.0 | Minor | BASSE |
| riverpod_generator | 2.6.4 | 2.6.5 | 2.6.5 | Patch | BASSE |
| mocktail | 1.0.4 | - | - | Current | OK |

### 📦 Dépendances Transitives Critiques

| Package | Version Actuelle | Version Latest | Impact |
|---------|-----------------|----------------|---------|
| analyzer | 7.6.0 | 8.0.0 | Affecte build_runner et génération de code |
| build | 2.5.4 | 3.0.0 | Core pour build_runner |
| source_gen | 2.0.0 | 3.0.0 | Affecte json_serializable et freezed |
| lints | 5.1.1 | 6.0.0 | Lié à flutter_lints |

## Classification par Catégorie

### 1. Core Flutter/Dart
- **SDK Dart**: Mise à jour nécessaire dans pubspec.yaml (^3.8.1 → ^3.32.0)
- **flutter_lints**: 5.0.0 → 6.0.0 (changements de règles de linting)

### 2. Génération de Code
- **freezed_annotation**: 2.4.4 → 3.1.0 (breaking changes majeurs)
- **freezed**: 2.5.8 → 3.2.0 (nouvelle syntaxe)
- **json_serializable**: 6.9.5 → 6.10.0 (mise à jour mineure)
- **build_runner**: 2.5.4 → 2.6.0 (mise à jour mineure)

### 3. State Management & Navigation
- **go_router**: 14.8.1 → 16.0.0 (breaking changes dans l'API)
- **riverpod_generator**: 2.6.4 → 2.6.5 (patch)

### 4. Backend & Services
- **sentry_flutter**: 8.14.2 → 9.5.0 (nouvelles fonctionnalités de monitoring)

## Analyse des Breaking Changes Majeurs

### 1. Freezed 2.x → 3.x
- Nouvelle syntaxe pour les unions
- Changements dans la génération des copyWith
- Support amélioré pour les generics
- **Impact**: Tous les modèles devront être revérifiés

### 2. Go Router 14.x → 16.x
- Refactorisation de l'API de configuration
- Nouveaux hooks de navigation
- Changements dans les guards
- **Impact**: Configuration de routing à adapter

### 3. Flutter Lints 5.x → 6.x
- Nouvelles règles de linting plus strictes
- Certaines règles renommées ou supprimées
- **Impact**: Potentiellement beaucoup de warnings à corriger

### 4. Sentry Flutter 8.x → 9.x
- Nouvelle API pour le performance monitoring
- Changements dans la configuration
- **Impact**: Configuration à mettre à jour

## Contraintes et Conflits Identifiés

1. **Freezed et build_runner**: La mise à jour de freezed nécessite des versions compatibles de build_runner et analyzer
2. **Flutter SDK**: La contrainte Dart SDK dans pubspec.yaml est obsolète et doit être mise à jour
3. **Dépendances transitives**: Plusieurs packages transitifs (build, source_gen) ont des versions majeures disponibles mais sont contraints par les dépendances directes

## Recommandations d'Ordre de Mise à Jour

### Phase 1: Préparation et SDK
1. Mettre à jour la contrainte Dart SDK dans pubspec.yaml
2. Mettre à jour flutter_lints et corriger les warnings

### Phase 2: Génération de Code
1. build_runner (mise à jour mineure)
2. json_serializable (mise à jour mineure)
3. freezed + freezed_annotation (mise à jour majeure coordonnée)

### Phase 3: State Management et Navigation
1. riverpod_generator (patch)
2. go_router (mise à jour majeure)

### Phase 4: Services
1. sentry_flutter (mise à jour majeure)

## Métriques

- **Packages avec breaking changes majeurs**: 4
- **Packages avec mises à jour mineures**: 3
- **Packages avec patches**: 1
- **Risque global**: **ÉLEVÉ** (dû aux changements majeurs dans freezed et go_router)

## Actions Requises

1. ✅ Créer une branche dédiée pour les mises à jour
2. ✅ Sauvegarder l'état actuel du projet
3. ✅ Préparer les tests de régression
4. ⏳ Analyser les changelogs détaillés (prochaine étape)
5. ⏳ Créer la matrice de compatibilité
6. ⏳ Développer le plan de migration détaillé