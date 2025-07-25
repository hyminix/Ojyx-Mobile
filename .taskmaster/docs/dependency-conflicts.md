# Analyse des Conflits de Dépendances Transitives - Projet Ojyx
Date: 2025-07-25

## Vue d'Ensemble des Conflits Identifiés

L'analyse de l'arbre de dépendances révèle plusieurs conflits potentiels lors de la migration. Ces conflits nécessitent des stratégies de résolution spécifiques.

## 🚨 Conflits Critiques

### 1. Conflit Analyzer (MAJEUR)

**Situation actuelle** :
- `build_runner 2.5.4` → utilise `analyzer 7.6.0`
- `freezed 2.5.8` → utilise `analyzer 7.6.0`
- **Migration cible** : `freezed 3.2.0` → requiert `analyzer ^8.0.0`

**Impact** :
- Blocage complet de la génération de code si non résolu
- Affecte tous les packages de génération de code

**Résolution** :
```yaml
# Dans pubspec.yaml après mise à jour de freezed
dependency_overrides:
  analyzer: ^8.0.0
  _fe_analyzer_shared: ^86.0.0
```

### 2. Conflit Source Gen

**Situation actuelle** :
- `freezed 2.5.8` → utilise `source_gen 2.0.0`
- `json_serializable 6.9.5` → utilise `source_gen 2.0.0`
- `riverpod_generator 2.6.4` → utilise `source_gen 2.0.0`

**Migration** :
- Toutes les dépendances sont alignées sur `source_gen 2.0.0`
- Pas de conflit immédiat, mais attention aux futures mises à jour

### 3. Conflit Build

**Situation actuelle** :
- `build_runner 2.5.4` → utilise `build 2.5.4`
- Dépendances transitives alignées

**Migration** :
- `build_runner 2.6.0` pourrait utiliser une version différente de `build`
- Surveiller les incompatibilités lors de la mise à jour

## ⚠️ Conflits Potentiels

### 1. Lints et Flutter Lints

**Situation actuelle** :
- `flutter_lints 5.0.0` → utilise `lints 5.1.1`

**Migration cible** :
- `flutter_lints 6.0.0` → utilisera `lints 6.0.0`

**Impact** :
- Changement des règles de linting
- Potentiellement beaucoup de nouveaux warnings

**Résolution** :
- Migration directe, pas de conflit technique
- Prévoir du temps pour corriger les warnings

### 2. Custom Lint Core

**Situation actuelle** :
- `riverpod_analyzer_utils 0.5.9` → utilise `custom_lint_core 0.7.5`

**Impact potentiel** :
- Peut affecter l'analyse Riverpod lors des mises à jour
- Surveiller lors de la mise à jour de `riverpod_generator`

## 📊 Matrice des Dépendances Transitives Critiques

| Package Direct | Version Actuelle | Dépendance Transitive | Version Transitive | Conflit Potentiel |
|---------------|------------------|----------------------|-------------------|-------------------|
| build_runner | 2.5.4 | analyzer | 7.6.0 | ❌ Avec freezed 3.x |
| build_runner | 2.5.4 | build | 2.5.4 | ✅ OK |
| build_runner | 2.5.4 | source_gen | 2.0.0 | ✅ OK |
| freezed | 2.5.8 | analyzer | 7.6.0 | ❌ Besoin 8.0.0 |
| freezed | 2.5.8 | source_gen | 2.0.0 | ✅ OK |
| json_serializable | 6.9.5 | source_gen | 2.0.0 | ✅ OK |
| riverpod_generator | 2.6.4 | analyzer | 7.6.0 | ⚠️ Via analyzer_utils |
| flutter_lints | 5.0.0 | lints | 5.1.1 | ⚠️ Changera en 6.0.0 |

## 🔧 Scripts de Vérification des Conflits

### Script 1: Vérifier les Versions Actuelles
```bash
#!/bin/bash
# check-transitive-versions.sh

echo "🔍 Analyzing transitive dependencies..."

# Vérifier analyzer
echo -e "\n📦 Analyzer versions:"
flutter pub deps | grep -E "analyzer\s+[0-9]" | sort | uniq

# Vérifier source_gen
echo -e "\n📦 Source_gen versions:"
flutter pub deps | grep -E "source_gen\s+[0-9]" | sort | uniq

# Vérifier build
echo -e "\n📦 Build versions:"
flutter pub deps | grep -E "build\s+[0-9]" | sort | uniq

# Vérifier lints
echo -e "\n📦 Lints versions:"
flutter pub deps | grep -E "lints\s+[0-9]" | sort | uniq
```

### Script 2: Test de Résolution avec Overrides
```bash
#!/bin/bash
# test-resolution.sh

echo "🧪 Testing dependency resolution with overrides..."

# Créer un backup
cp pubspec.yaml pubspec.yaml.backup

# Ajouter les overrides
cat >> pubspec.yaml << EOF

dependency_overrides:
  analyzer: ^8.0.0
  _fe_analyzer_shared: ^86.0.0
EOF

# Tester la résolution
flutter pub get --dry-run

# Restaurer
mv pubspec.yaml.backup pubspec.yaml
```

### Script 3: Validation Post-Migration
```bash
#!/bin/bash
# validate-no-conflicts.sh

echo "✅ Validating no conflicts after migration..."

# Obtenir toutes les versions
DEPS=$(flutter pub deps --json)

# Vérifier les doublons
echo "$DEPS" | jq '.packages | group_by(.name) | map(select(length > 1))'

# Si vide, pas de conflits
```

## 🎯 Stratégies de Résolution par Package

### Pour Freezed (Phase 4)
1. **Avant la mise à jour** :
   - Sauvegarder tous les fichiers générés
   - Créer des tests de régression
   
2. **Pendant la mise à jour** :
   ```yaml
   dependencies:
     freezed_annotation: ^3.1.0
   
   dev_dependencies:
     freezed: ^3.2.0
   
   dependency_overrides:
     analyzer: ^8.0.0
     _fe_analyzer_shared: ^86.0.0
   ```

3. **Après la mise à jour** :
   - Supprimer tous les fichiers .freezed.dart
   - Régénérer avec build_runner
   - Valider que tous les modèles compilent

### Pour Build Runner
1. **Mise à jour simple** :
   ```yaml
   dev_dependencies:
     build_runner: ^2.6.0
   ```
   
2. **Si conflits** :
   - Vérifier la compatibilité avec analyzer override
   - Possiblement ajouter `build: ^3.0.0` aux overrides

### Pour Flutter Lints
1. **Mise à jour directe** :
   ```yaml
   dev_dependencies:
     flutter_lints: ^6.0.0
   ```
   
2. **Pas de conflits transitifs attendus**

## 📋 Checklist de Résolution

### Avant Migration
- [ ] Exécuter `check-transitive-versions.sh`
- [ ] Documenter les versions actuelles
- [ ] Préparer les dependency_overrides

### Pendant Migration
- [ ] Appliquer les overrides nécessaires
- [ ] Vérifier avec `flutter pub get --dry-run`
- [ ] Tester la génération de code

### Après Migration
- [ ] Valider avec `validate-no-conflicts.sh`
- [ ] Vérifier que tous les packages utilisent les bonnes versions
- [ ] Supprimer les overrides non nécessaires

## 🚀 Commandes Utiles

```bash
# Voir les dépendances d'un package spécifique
flutter pub deps --style=tree | grep -A 10 "├── freezed"

# Vérifier les contraintes de version
flutter pub deps --json | jq '.packages[] | select(.name == "analyzer")'

# Forcer la résolution
flutter pub get --enforce-lockfile

# Nettoyer et reconstruire
flutter clean && flutter pub get
```

## 📊 Métriques de Succès

1. **Aucune erreur lors de** : `flutter pub get`
2. **Génération de code réussie** : `flutter pub run build_runner build`
3. **Pas de doublons de versions** dans l'arbre de dépendances
4. **Tous les tests passent** après migration

## 🔄 Plan B : Si Blocage Total

Si les conflits sont insolubles :

1. **Option 1** : Reporter la mise à jour de freezed
   - Garder freezed 2.x temporairement
   - Mettre à jour les autres dépendances d'abord
   
2. **Option 2** : Migration partielle
   - Créer un nouveau projet avec les nouvelles versions
   - Migrer progressivement les modèles
   
3. **Option 3** : Attendre les mises à jour
   - build_runner 3.0.0 pourrait résoudre les conflits
   - Surveiller les releases

## Conclusion

Les conflits identifiés sont gérables avec les bonnes stratégies :
1. **Conflit analyzer** : Résolu avec dependency_overrides
2. **Alignement source_gen** : Pas de conflit actuel
3. **Migration flutter_lints** : Simple et directe

La clé est d'appliquer les overrides au bon moment et de valider chaque étape.