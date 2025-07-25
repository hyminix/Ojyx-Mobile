# Stratégie de Migration des Dépendances - Projet Ojyx
Date: 2025-07-25

## Résumé Exécutif

Cette stratégie organise la migration des dépendances en phases logiques minimisant les risques et garantissant la stabilité du projet à chaque étape. L'approche suit rigoureusement la méthodologie TDD comme défini dans le PRD.

## Principes Directeurs

1. **Migration Incrémentale** : Une phase à la fois, avec validation complète
2. **TDD Strict** : Tests écrits AVANT toute modification de code
3. **Points de Rollback** : Possibilité de revenir en arrière à chaque phase
4. **Validation Continue** : CI/CD doit passer après chaque phase
5. **Zero Régression** : Aucune fonctionnalité ne doit être cassée

## Phases de Migration

### 🔧 Phase 0: Préparation (1-2 heures)
**Objectif** : Préparer l'environnement et sauvegarder l'état actuel

**Actions** :
1. Créer une branche dédiée : `git checkout -b feat/dependency-upgrade`
2. Sauvegarder l'état actuel :
   ```bash
   flutter pub get
   flutter pub deps --style=tree > .taskmaster/reports/deps-before-migration.txt
   flutter test --coverage
   cp coverage/lcov.info .taskmaster/reports/coverage-before-migration.info
   ```
3. Créer un snapshot des tests actuels
4. Documenter les métriques de base (temps de build, taille APK)

**Critères de Succès** :
- ✅ Branche créée
- ✅ État actuel documenté
- ✅ Tests de base passent à 100%
- ✅ Coverage baseline établi

### 📦 Phase 1: Mise à Jour SDK et Environnement (2-3 heures)
**Objectif** : Mettre à jour les contraintes SDK pour supporter les nouvelles versions

**Dépendances** :
- SDK Dart : 3.8.1 → 3.8.0+ (minimum requis)
- SDK Flutter : Vérifier compatibilité avec 3.32.0+

**Actions TDD** :
1. Écrire un test vérifiant les contraintes SDK
2. Mettre à jour pubspec.yaml :
   ```yaml
   environment:
     sdk: ^3.8.0
     flutter: ^3.32.0
   ```
3. Exécuter `flutter pub get`
4. Vérifier que tous les tests passent

**Risques** : Faible
**Rollback** : Simple (revert pubspec.yaml)

### 🔍 Phase 2: Linting et Qualité de Code (3-4 heures)
**Objectif** : Mettre à jour flutter_lints et corriger les nouveaux warnings

**Dépendances** :
- flutter_lints : 5.0.0 → 6.0.0

**Actions TDD** :
1. Créer des tests pour les règles critiques de linting
2. Mettre à jour dans pubspec.yaml
3. Exécuter `flutter analyze`
4. Pour chaque warning :
   - Écrire un test validant le comportement actuel
   - Corriger le code
   - Vérifier que le test passe toujours
5. Commit atomique par catégorie de corrections

**Nouveaux Warnings Attendus** :
- `strict_top_level_inference`
- `unnecessary_underscores`

**Risques** : Faible (warnings seulement)
**Rollback** : Par commit si nécessaire

### 🏗️ Phase 3: Outils de Build (2-3 heures)
**Objectif** : Mettre à jour les outils de génération de code

**Dépendances** :
- build_runner : 2.5.4 → 2.6.0
- json_serializable : 6.9.5 → 6.10.0
- riverpod_generator : 2.6.4 → 2.6.5

**Actions TDD** :
1. Tests de génération de code existants
2. Mettre à jour dans l'ordre :
   ```yaml
   dev_dependencies:
     build_runner: ^2.6.0
     json_serializable: ^6.10.0
     riverpod_generator: ^2.6.5
   ```
3. Nettoyer et régénérer :
   ```bash
   flutter clean
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Vérifier tous les fichiers générés
5. Exécuter les tests

**Risques** : Moyen (génération peut échouer)
**Rollback** : Revert et clean

### 🎯 Phase 4: Freezed Migration (8-12 heures) - CRITIQUE
**Objectif** : Migrer Freezed avec tous les breaking changes

**Dépendances** :
- freezed_annotation : 2.4.4 → 3.1.0
- freezed : 2.5.8 → 3.2.0

**Prérequis** :
```yaml
# Si conflit analyzer
dependency_overrides:
  analyzer: ^8.0.0
  _fe_analyzer_shared: ^86.0.0
```

**Actions TDD Par Modèle** :
1. Pour chaque modèle Freezed :
   a. Écrire des tests capturant le comportement actuel
   b. Sauvegarder le modèle actuel
   c. Adapter la syntaxe :
      ```dart
      // Avant
      @freezed
      class Model with _$Model { ... }
      
      // Après
      @freezed
      sealed class Model with _$Model { ... }
      ```
   d. Remplacer when/map par switch
   e. Régénérer le code
   f. Faire passer les tests
   g. Commit atomique

**Ordre de Migration des Modèles** :
1. Modèles simples sans union types
2. Modèles avec union types
3. Modèles utilisés dans les providers
4. Modèles critiques (GameState, Player, etc.)

**Script de Migration** :
```bash
#!/bin/bash
# Pour chaque modèle
echo "Migrating $MODEL..."
flutter test test/models/${MODEL}_test.dart
# Si succès, continuer avec le suivant
```

**Risques** : Élevé (breaking changes majeurs)
**Rollback** : Par modèle si nécessaire

### 🧭 Phase 5: Navigation (4-6 heures)
**Objectif** : Mettre à jour go_router avec gestion de la case sensitivity

**Dépendances** :
- go_router : 14.8.1 → 16.0.0

**Actions TDD** :
1. Écrire des tests E2E pour toutes les routes
2. Tests spécifiques pour la sensibilité à la casse
3. Mettre à jour go_router
4. Adapter la configuration :
   ```dart
   final router = GoRouter(
     caseSensitive: false, // Maintenir l'ancien comportement
     routes: [...],
   );
   ```
5. Exécuter tous les tests de navigation
6. Tester manuellement les deep links

**Points de Vérification** :
- Routes avec paramètres
- Guards et redirections
- Deep links
- Navigation stack

**Risques** : Moyen (comportement de navigation)
**Rollback** : Simple si tests complets

### 📡 Phase 6: Services Backend (4-6 heures)
**Objectif** : Mettre à jour Sentry avec la nouvelle API

**Dépendances** :
- sentry_flutter : 8.14.2 → 9.5.0

**Actions TDD** :
1. Tests d'intégration Sentry mockés
2. Sauvegarder la configuration actuelle
3. Mettre à jour sentry_flutter
4. Adapter la configuration :
   ```dart
   // Avant
   options.beforeSend = (event, hint) {
     event = event.copyWith(release: version);
     return event;
   };
   
   // Après
   options.beforeSend = (event, hint) {
     event.release = version;
     return event;
   };
   ```
5. Vérifier Android Kotlin 1.5.31+
6. Tester le monitoring en conditions réelles

**Risques** : Moyen (monitoring production)
**Rollback** : Configuration sauvegardée

## Calendrier Estimé

| Phase | Durée | Jour | Dépendances | Risque |
|-------|-------|------|-------------|--------|
| Phase 0 | 1-2h | Jour 1 AM | - | Faible |
| Phase 1 | 2-3h | Jour 1 PM | Phase 0 | Faible |
| Phase 2 | 3-4h | Jour 2 AM | Phase 1 | Faible |
| Phase 3 | 2-3h | Jour 2 PM | Phase 2 | Moyen |
| Phase 4 | 8-12h | Jours 3-4 | Phase 3 | Élevé |
| Phase 5 | 4-6h | Jour 5 AM | Phase 4 | Moyen |
| Phase 6 | 4-6h | Jour 5 PM | Phase 5 | Moyen |
| Validation | 2-3h | Jour 6 | Toutes | - |

**Total Estimé** : 5-6 jours de travail

## Scripts de Validation

### Validation Post-Phase
```bash
#!/bin/bash
# validate-phase.sh
echo "🔍 Validating Phase $1..."

# 1. Tests unitaires
flutter test

# 2. Analyse statique
flutter analyze

# 3. Génération de code
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Build Android
flutter build apk --debug

# 5. Coverage
flutter test --coverage
lcov --list coverage/lcov.info

echo "✅ Phase $1 validated"
```

### Validation Globale
```bash
#!/bin/bash
# validate-all.sh

# Métriques avant/après
echo "📊 Comparing metrics..."
diff .taskmaster/reports/deps-before-migration.txt <(flutter pub deps --style=tree)

# Tests de régression
flutter test test/regression/

# Performance
flutter build apk --release --analyze-size
```

## Critères de Go/No-Go par Phase

### Phase 1-2 (SDK & Linting)
- ✅ GO si : Tous les tests passent, pas de nouveaux warnings critiques
- ❌ NO-GO si : Tests échouent ou regression détectée

### Phase 3 (Build Tools)
- ✅ GO si : Génération de code réussie, tous les fichiers .g.dart valides
- ❌ NO-GO si : Erreurs de génération ou fichiers corrompus

### Phase 4 (Freezed)
- ✅ GO si : Tous les modèles migrés, tests passent, pas de regression
- ❌ NO-GO si : Modèles critiques cassés ou tests échouent

### Phase 5 (Navigation)
- ✅ GO si : Toutes les routes fonctionnent, deep links OK
- ❌ NO-GO si : Navigation cassée ou routes inaccessibles

### Phase 6 (Services)
- ✅ GO si : Monitoring opérationnel, pas d'erreurs Android
- ❌ NO-GO si : Sentry ne capture pas les erreurs

## Plan de Communication

1. **Avant Migration** : Informer l'équipe du planning
2. **Pendant** : Updates quotidiens sur Slack/Discord
3. **Par Phase** : PR dédiée avec description détaillée
4. **Après** : Documentation des changements dans CHANGELOG.md

## Risques et Mitigations

| Risque | Impact | Probabilité | Mitigation |
|--------|---------|-------------|------------|
| Conflit analyzer | Build cassé | Haute | dependency_overrides prêt |
| Freezed regression | App cassée | Moyenne | Migration par étapes |
| Navigation cassée | UX dégradée | Faible | Tests E2E complets |
| Sentry offline | Pas de monitoring | Faible | Config de fallback |
| Rollback nécessaire | Retard projet | Moyenne | Commits atomiques |

## Checklist Finale

- [ ] Toutes les phases complétées
- [ ] Aucune régression détectée
- [ ] Coverage maintenu ou amélioré
- [ ] CI/CD passe sur tous les environnements
- [ ] Build Android fonctionnel
- [ ] Performance acceptable
- [ ] Documentation mise à jour
- [ ] CHANGELOG.md complété
- [ ] Équipe informée des changements

## Commandes Utiles

```bash
# Vérifier l'état à tout moment
flutter pub deps --style=tree
flutter analyze
flutter test

# En cas de problème
git stash
flutter clean
flutter pub get

# Rollback d'urgence
git checkout main
git branch -D feat/dependency-upgrade
```

## Conclusion

Cette stratégie minimise les risques en procédant par étapes validées. La clé du succès réside dans :
1. Le respect strict du TDD
2. Les commits atomiques
3. La validation continue
4. La possibilité de rollback à chaque étape

Temps total estimé : **30-40 heures** de travail sur 5-6 jours.