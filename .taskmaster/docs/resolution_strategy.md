# Stratégie de Résolution des Incompatibilités - Projet Ojyx

**Date**: 26 juillet 2025  
**Branche**: feature/major-dependencies-upgrade  
**Status**: 430 issues analysées, stratégie de résolution définie  

## Résumé Exécutif

La mise à jour majeure des dépendances a introduit des breaking changes critiques nécessitant une migration systématique. Les principaux problèmes concernent les **API dépréciées Sentry v9**, les **changements de types Riverpod v3**, et les **modifications d'API go_router v16**.

## Classification des Incompatibilités

### 🔴 BLOQUANTES (Empêchent la compilation)

| Priorité | Package | Type d'Erreur | Fichiers Affectés | Effort |
|----------|---------|---------------|-------------------|---------|
| **P1** | Riverpod | Type mismatches (ProviderListenable) | connectivity_provider.dart | 2h |
| **P1** | go_router | String → Uri conversions | router tests | 1h |
| **P1** | go_router | Missing properties (refreshListenable) | router_v2_test.dart | 1h |
| **P1** | Riverpod | Undefined methods (BuildContext.read) | router tests | 0.5h |

### 🟡 DÉPRÉCIATIONS (Fonctionnent mais warnings)

| Priorité | Package | API Dépréciée | Remplacement | Fichiers | Effort |
|----------|---------|---------------|--------------|----------|---------|
| **P2** | Sentry | setExtra() | Contexts API | 4 fichiers | 1h |
| **P2** | Riverpod | *Ref types | Ref type | 8 fichiers | 2h |
| **P2** | Supabase | SupabaseClientRef | Ref | 1 fichier | 0.5h |

### 🟢 MINEURES (Qualité du code)

| Type | Description | Quantité | Action |
|------|-------------|----------|--------|
| unused_field | Champs inutilisés | 50+ | Nettoyage |
| unused_import | Imports inutilisés | 20+ | Suppression |
| unnecessary_type_check | Vérifications type redondantes | 10+ | Simplification |

## Plan de Résolution Détaillé

### Phase 1: Blocages Critiques (Obligatoire pour compilation)

#### 1.1 Riverpod Type Mismatches
**Fichier**: `lib/core/providers/connectivity_provider.dart:30`
```diff
// AVANT
- ref.listen<ConnectivityStatus>(connectivityProvider, (prev, next) {
+ ref.listen(connectivityProvider, (prev, next) {
```

**Commande de test**:
```bash
flutter analyze lib/core/providers/connectivity_provider.dart
```

#### 1.2 go_router String → Uri Conversions
**Fichiers**: `test/navigation/router_v2_test.dart` (lignes 93-95)
```diff
// AVANT
- router.go('/game');
+ router.go(Uri.parse('/game'));
```

#### 1.3 go_router Missing Properties
**Fichier**: `test/navigation/router_v2_test.dart:102`
```diff
// AVANT
- expect(router.refreshListenable, isNotNull);
+ // Propriété supprimée en v16 - supprimer le test ou utiliser routerDelegate
```

### Phase 2: Dépréciations API (Recommandé avant production)

#### 2.1 Migration Sentry v9
**Fichiers à mettre à jour**:
- `lib/core/config/sentry_config.dart`
- `lib/core/services/sentry_service.dart`

```diff
// AVANT
- scope.setExtra('gameId', gameId);
+ scope.setContext('game', {'id': gameId});
```

#### 2.2 Migration Riverpod v3 Refs
**Pattern de migration**:
```diff
// AVANT
- @riverpod
- Provider<Type> providerNameRef(ProviderNameRef ref) {}

// APRÈS  
+ @riverpod
+ Type providerName(Ref ref) {}
```

### Phase 3: Code Quality (Optionnel)

#### 3.1 Suppression Champs Inutilisés
```bash
# Script de nettoyage automatique
find lib/ -name "*.dart" -exec dart format {} \;
```

#### 3.2 Suppression Imports Inutilisés
```bash
dart analyze --no-fatal-infos | grep "unused_import" | cut -d• -f2
```

## Commandes de Résolution

### Étape par Étape

```bash
# 1. Corriger les types Riverpod
flutter analyze lib/core/providers/ --no-fatal-infos

# 2. Mettre à jour les tests go_router  
flutter test test/navigation/router_v2_test.dart --no-sound-null-safety

# 3. Migrer l'API Sentry
flutter analyze lib/core/config/sentry_config.dart lib/core/services/sentry_service.dart

# 4. Validation complète
flutter analyze --no-fatal-infos | wc -l  # Devrait descendre sous 50 issues
```

### Tests de Régression

```bash
# Tests unitaires critiques
flutter test test/core/providers/
flutter test test/navigation/
flutter test test/features/auth/

# Build validation
flutter build apk --debug --target-platform android-arm64
```

## Stratégies Alternatives

### Option A: Migration Complète (Recommandé)
- **Effort**: 4-6 heures
- **Risque**: Faible
- **Bénéfice**: Code moderne, pas de warnings

### Option B: Hotfixes Minimaux
- **Effort**: 1-2 heures  
- **Risque**: Moyen
- **Bénéfice**: Compilation rapide, dette technique

### Option C: Downgrade Sélectif
- **Effort**: 0.5 heure
- **Risque**: Élevé
- **Bénéfice**: Évite la migration

## Dependencies Override (Si nécessaire)

```yaml
# pubspec.yaml - Section dependency_overrides
dependency_overrides:
  # Si conflits de versions persistants
  riverpod_analyzer_utils: ^0.5.9
  build_runner: ^2.5.4
```

## Critères de Succès

### ✅ Validation Réussie
- [ ] `flutter analyze --no-fatal-infos` < 50 issues
- [ ] `flutter test` tous verts  
- [ ] `flutter build apk --debug` succès
- [ ] Aucune dépréciation critique

### 📊 Métriques de Performance
- **Issues Before**: 430
- **Issues Target**: < 50
- **Critical Errors**: 0
- **Build Time**: < 2 min

## Contacts & Ressources

### Documentation Migration
- [Riverpod v3 Migration Guide](https://riverpod.dev/docs/migration/0.14.0_to_1.0.0)
- [Sentry v9 Flutter Migration](https://docs.sentry.io/platforms/flutter/migration/)
- [go_router v16 Breaking Changes](https://pub.dev/packages/go_router/changelog#1600)

### Issues GitHub
- [Riverpod Type Issues](https://github.com/rrousselGit/riverpod/issues)
- [go_router API Changes](https://github.com/flutter/packages/tree/main/packages/go_router)

---

## Plan d'Exécution

### Jour 1: Blocages Critiques
- ✅ Analyse terminée
- 🔄 **Correction types Riverpod** (en cours)
- ⏳ Tests go_router
- ⏳ Validation build

### Jour 2: Dépréciations
- ⏳ Migration Sentry
- ⏳ Migration Riverpod refs
- ⏳ Tests de régression

### Jour 3: Validation
- ⏳ Code quality
- ⏳ Performance tests  
- ⏳ Documentation update

**Status**: ✅ Stratégie définie, prêt pour l'implémentation  
**Next**: Commencer Phase 1 - Blocages Critiques