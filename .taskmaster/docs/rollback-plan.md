# Plan de Rollback - Migration des Dépendances Ojyx
Date: 2025-07-25

## Vue d'Ensemble

Ce document définit les procédures de rollback pour chaque phase de migration. Chaque procédure est conçue pour être exécutée rapidement en cas de problème.

## Procédures de Rollback par Phase

### 🔄 Rollback Phase 1 (SDK et Environnement)

**Déclencheurs** :
- Flutter/Dart SDK incompatible avec l'environnement de dev
- Erreurs de compilation au niveau SDK

**Procédure** :
```bash
# 1. Restaurer pubspec.yaml
git checkout HEAD -- pubspec.yaml

# 2. Nettoyer et restaurer
flutter clean
flutter pub get

# 3. Vérifier
flutter doctor
flutter test
```

**Temps de rollback** : 5 minutes

### 🔄 Rollback Phase 2 (Flutter Lints)

**Déclencheurs** :
- Trop de warnings bloquants
- Règles incompatibles avec le code existant

**Procédure** :
```bash
# 1. Revert des commits de correction
git log --oneline | grep "fix: linting"
git revert <commit-hash> --no-edit

# 2. Restaurer flutter_lints
git checkout HEAD -- pubspec.yaml
flutter pub get

# 3. Vérifier l'état
flutter analyze
```

**Temps de rollback** : 10 minutes

### 🔄 Rollback Phase 3 (Build Tools)

**Déclencheurs** :
- Échec de génération de code
- Fichiers .g.dart corrompus
- Incompatibilité avec les modèles existants

**Procédure** :
```bash
# 1. Supprimer tous les fichiers générés
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete

# 2. Restaurer les versions
git checkout HEAD -- pubspec.yaml

# 3. Restaurer les fichiers générés originaux
git checkout HEAD -- "*.g.dart"
git checkout HEAD -- "*.freezed.dart"

# 4. Rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Temps de rollback** : 15 minutes

### 🔄 Rollback Phase 4 (Freezed) - CRITIQUE

**Déclencheurs** :
- Modèles cassés après migration
- Tests échouent massivement
- Génération de code impossible

**Procédure par Modèle** :
```bash
# Pour un modèle spécifique
MODEL_NAME="game_state"

# 1. Restaurer le modèle
git checkout HEAD -- lib/features/game/domain/entities/${MODEL_NAME}.dart
git checkout HEAD -- lib/features/game/domain/entities/${MODEL_NAME}.freezed.dart
git checkout HEAD -- lib/features/game/domain/entities/${MODEL_NAME}.g.dart

# 2. Restaurer les tests
git checkout HEAD -- test/features/game/domain/entities/${MODEL_NAME}_test.dart

# 3. Régénérer uniquement ce modèle
flutter pub run build_runner build --delete-conflicting-outputs
```

**Procédure Complète** :
```bash
# 1. Identifier le point de rollback
git log --oneline | grep "feat: migrate freezed"
ROLLBACK_COMMIT=$(git log --oneline | grep "Before freezed migration" | cut -d' ' -f1)

# 2. Rollback complet
git reset --hard $ROLLBACK_COMMIT

# 3. Supprimer dependency_overrides si ajouté
sed -i '/dependency_overrides:/,/^$/d' pubspec.yaml

# 4. Restaurer l'environnement
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Temps de rollback** : 30-45 minutes

### 🔄 Rollback Phase 5 (Go Router)

**Déclencheurs** :
- Navigation cassée
- Routes inaccessibles
- Deep links non fonctionnels

**Procédure** :
```bash
# 1. Restaurer la configuration du router
git checkout HEAD -- lib/core/config/router_config.dart

# 2. Restaurer go_router dans pubspec
git checkout HEAD -- pubspec.yaml

# 3. Restaurer et tester
flutter pub get
flutter test test/navigation/
```

**Points de Vérification Post-Rollback** :
- [ ] Toutes les routes accessibles
- [ ] Paramètres de route fonctionnels
- [ ] Guards opérationnels
- [ ] Deep links testés

**Temps de rollback** : 20 minutes

### 🔄 Rollback Phase 6 (Sentry)

**Déclencheurs** :
- Monitoring non fonctionnel
- Erreurs de configuration Android
- Crash au démarrage

**Procédure** :
```bash
# 1. Restaurer la configuration Sentry
git checkout HEAD -- lib/core/config/sentry_config.dart
git checkout HEAD -- lib/main.dart

# 2. Restaurer les dépendances
git checkout HEAD -- pubspec.yaml

# 3. Restaurer Android si modifié
git checkout HEAD -- android/app/build.gradle
git checkout HEAD -- android/build.gradle

# 4. Clean rebuild
flutter clean
cd android && ./gradlew clean
cd ..
flutter pub get
```

**Temps de rollback** : 25 minutes

## Rollback d'Urgence Global

### 🚨 Procédure d'Urgence Complète

Si plusieurs phases sont compromises ou si l'état est incertain :

```bash
#!/bin/bash
# emergency-rollback.sh

echo "🚨 EMERGENCY ROLLBACK INITIATED"

# 1. Sauvegarder l'état actuel pour analyse
git stash save "emergency-rollback-$(date +%Y%m%d-%H%M%S)"

# 2. Retourner au dernier état stable connu
STABLE_COMMIT=$(git log --oneline | grep "chore: backup before migration" | cut -d' ' -f1)
git reset --hard $STABLE_COMMIT

# 3. Nettoyer complètement
flutter clean
rm -rf .dart_tool/
rm -rf build/
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete

# 4. Restaurer l'environnement
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# 5. Valider
flutter test
flutter build apk --debug

echo "✅ Emergency rollback completed"
```

**Temps de rollback** : 45-60 minutes

## Stratégies de Prévention

### Avant Chaque Phase
1. **Commit de sauvegarde** : `git commit -m "chore: backup before [phase name]"`
2. **Tag de version** : `git tag -a pre-migration-phase-X -m "Before phase X"`
3. **Branch de secours** : `git branch backup/phase-X`

### Points de Contrôle
```bash
# Créer un point de contrôle
create_checkpoint() {
  PHASE=$1
  git add -A
  git commit -m "checkpoint: before phase $PHASE migration"
  git tag -a "checkpoint-phase-$PHASE" -m "Checkpoint before phase $PHASE"
}

# Restaurer depuis un point de contrôle
restore_checkpoint() {
  PHASE=$1
  git reset --hard "checkpoint-phase-$PHASE"
  flutter clean && flutter pub get
}
```

## Métriques de Décision

### Critères de Rollback Automatique

| Métrique | Seuil | Action |
|----------|--------|---------|
| Tests échoués | > 10% | Rollback immédiat |
| Coverage | < -5% | Évaluer le rollback |
| Build time | > +50% | Investiguer |
| Warnings | > 100 nouveaux | Évaluer le rollback |
| Crash au démarrage | 1 | Rollback immédiat |

### Dashboard de Santé
```bash
#!/bin/bash
# health-check.sh

echo "🏥 Health Check Dashboard"
echo "========================"

# Tests
TESTS=$(flutter test --machine | grep -c '"success":true')
TOTAL=$(flutter test --machine | grep -c '"test"')
echo "Tests: $TESTS/$TOTAL"

# Coverage
COV=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines......" | cut -d' ' -f4)
echo "Coverage: $COV"

# Warnings
WARNINGS=$(flutter analyze | grep -c "warning")
echo "Warnings: $WARNINGS"

# Build
if flutter build apk --debug --no-pub >/dev/null 2>&1; then
  echo "Build: ✅ SUCCESS"
else
  echo "Build: ❌ FAILED"
fi
```

## Communication en Cas de Rollback

### Template de Communication
```
🚨 ROLLBACK ALERT - Phase [X]: [Nom de la Phase]

**Raison**: [Description du problème]
**Impact**: [Ce qui est affecté]
**Action**: Rollback initié à [heure]
**ETA**: Retour à la normale dans ~[X] minutes
**Status**: [En cours/Complété]

Détails techniques: [Lien vers les logs]
```

### Canaux de Communication
1. **Immédiat** : Slack #dev-alerts
2. **Suivi** : Ticket GitHub Issues
3. **Post-mortem** : Document dans `.taskmaster/reports/`

## Lessons Learned - Template

Après chaque rollback, documenter :

```markdown
## Rollback Post-Mortem - [Date]

### Phase Affectée
[Phase X: Nom]

### Cause du Rollback
[Description détaillée]

### Durée
- Détection: [X] minutes
- Décision: [X] minutes  
- Exécution: [X] minutes
- Total: [X] minutes

### Impact
- Tests affectés: [Liste]
- Fonctionnalités impactées: [Liste]
- Temps de développement perdu: [X] heures

### Actions Correctives
1. [Action 1]
2. [Action 2]

### Prévention Future
[Recommandations]
```

## Conclusion

Ce plan de rollback garantit une récupération rapide en cas de problème. Les points clés :

1. **Rollback granulaire** : Par phase ou par modèle
2. **Temps de récupération** : 5-60 minutes selon la phase
3. **Automatisation** : Scripts prêts à l'emploi
4. **Communication** : Templates et procédures claires

La préparation est la clé : avec les bons checkpoints et scripts, tout rollback devient une opération routine plutôt qu'une urgence.